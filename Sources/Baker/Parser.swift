import Foundation

class Parser {
    let fileURL: URL
    var responses: [String: [String]] = [:]

    init(responseFileName: String) {
        self.fileURL = URL(fileURLWithPath: responseFileName)
        self.responses = self.loadResponses(from: self.fileURL)
    }
    
    private func loadResponses(from fileURL: URL) -> [String: [String]] {
        let fileExtension = fileURL.pathExtension
        do {
            let fileContent = try String(contentsOf: fileURL, encoding: .utf8)
            if fileExtension == "json" {
                if let jsonData = fileContent.data(using: .utf8),
                   let jsonResponses = try JSONSerialization.jsonObject(with: jsonData) as? [String: [String]] {
                    return jsonResponses
                }
            } else if fileExtension == "yaml" || fileExtension == "yml" {
                if let yamlResponses = try Yams.load(yaml: fileContent) as? [String: [String]] {
                    return yamlResponses
                }
            } else if fileExtension == "xml" {
                let xml = try SWXMLParser.parse(fileContent)
                var xmlResponses: [String: [String]] = [:]
                for elem in xml["responses"]["response"] {
                    let key = elem.element?.name
                    let value = elem.element?.text
                    if let key = key, let value = value {
                        if xmlResponses[key] != nil {
                            xmlResponses[key]?.append(value)
                        } else {
                            xmlResponses[key] = [value]
                        }
                    }
                }
                return xmlResponses
            }
        } catch {
            print("Error loading responses: \(error)")
        }
        return [:]
    }
    
    func saveResponses() {
        let fileExtension = fileURL.pathExtension
        do {
            if fileExtension == "json" {
                let jsonData = try JSONSerialization.data(withJSONObject: responses, options: .prettyPrinted)
                try jsonData.write(to: fileURL)
            } else if fileExtension == "yaml" || fileExtension == "yml" {
                let yamlData = try Yams.dump(object: responses)
                try yamlData.write(to: fileURL, atomically: true, encoding: .utf8)
            } else if fileExtension == "xml" {
                let xmlResponses = ResponseXML(fromDictionary: responses)
                let xmlData = try XMLEncoder().encode(xmlResponses)
                try xmlData.write(to: fileURL, options: .atomic)
            }
        } catch {
            print("Error saving responses: \(error)")
        }
    }
    
    func trainResponse(userInput: String, newResponse: String) {
        if var existingResponses = responses[userInput] {
            existingResponses.append(newResponse)
            responses[userInput] = existingResponses
        } else {
            responses[userInput] = [newResponse]
        }
        saveResponses()
    }
    
    func getResponse(userInput: String) -> String {
        if let availableResponses = responses[userInput] {
            return availableResponses.randomElement() ?? "I'm not sure how to respond to that."
        } else {
            return "I'm not sure how to respond to that."
        }
    }
    
    func removeResponse(userInput: String, response: String) {
        if var existingResponses = responses[userInput] {
            existingResponses.removeAll { $0 == response }
            responses[userInput] = existingResponses
            saveResponses()
        }
    }
    
    func listKeyQuestions() -> [String] {
        return Array(responses.keys)
    }
    
    func countResponses(userInput: String) -> Int {
        return responses[userInput]?.count ?? 0
    }
    
    func resetResponses(userInput: String) {
        responses[userInput] = []
        saveResponses()
    }
    
    func exportResponses(exportFileName: String) {
        let exportExtension = URL(fileURLWithPath: exportFileName).pathExtension

        do {
            let exportData: Data
            if exportExtension == "json" {
                exportData = try JSONSerialization.data(withJSONObject: responses, options: .prettyPrinted)
            } else if exportExtension == "yaml" || exportExtension == "yml" {
                exportData = try Yams.dump(object: responses)
            } else if exportExtension == "xml" {
                let xmlResponses = ResponseXML(fromDictionary: responses)
                exportData = try XMLEncoder().encode(xmlResponses)
            } else {
                throw NSError(domain: "Unsupported export file format", code: 0, userInfo: nil)
            }
            
            try exportData.write(to: URL(fileURLWithPath: exportFileName))
        } catch {
            print("Error exporting responses: \(error)")
        }
    }
}

struct ResponseXML: Codable {
    let responses: [String: [String]]

    enum CodingKeys: String, CodingKey {
        case responses = "responses"
    }
    
    init(fromDictionary dictionary: [String: [String]]) {
        self.responses = dictionary
    }
    
    func toDictionary() -> [String: [String]] {
        return responses
    }
}

//let parser = Parser(responseFileName: "responses.json")