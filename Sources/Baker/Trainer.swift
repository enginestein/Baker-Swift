import Foundation
import Yams
import SWXMLHash

class Trainer {
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
                if let yamlResponses = try YAMLEncoder.decode([String: [String]].self, from: fileContent) {
                    return yamlResponses
                }
            } else if fileExtension == "xml" {
                if let xmlData = fileContent.data(using: .utf8),
                   let xmlResponses = try? XMLDecoder().decode(ResponseXML.self, from: xmlData) {
                    return xmlResponses.toDictionary()
                }
            }
        } catch {
            print("Error loading responses: \(error)")
        }
        return [:]
    }
    
    func saveResponses() {
        let fileExtension = fileURL.pathExtension
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            if fileExtension == "json" {
                let jsonData = try encoder.encode(responses)
                try jsonData.write(to: fileURL)
            } else if fileExtension == "yaml" || fileExtension == "yml" {
                let yamlData = try YAMLEncoder.encode(responses)
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
    
    func loopTraining() {
        do {
            while true {
                print("Enter a key question (or press Ctrl+C to exit): ", terminator: "")
                if let keyQuestion = readLine(), !keyQuestion.isEmpty {
                    print("Enter a response: ", terminator: "")
                    if let response = readLine() {
                        trainResponse(userInput: keyQuestion, newResponse: response)
                    }
                }
            }
        } catch {
            print("Training aborted.")
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

//let trainer = Trainer(responseFileName: "responses.json")
//trainer.loopTraining()
