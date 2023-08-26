import Foundation

class Chatbot {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func session(trainer: Trainer, parser: Parser) {
        print("Welcome to \(self.name) Chatbot! Type 'exit' to end the session.")
        while true {
            print("You: ", terminator: "")
            if let user_input = readLine()?.lowercased() {
                if user_input == "exit" {
                    print("Session ended.")
                    break
                }
                let response = parser.getResponse(userInput: user_input)
                print("Bot:", response)
            }
        }
    }
}

//let parser = Parser(responseFileName: "responses.json")
//let trainer = Trainer(responseFileName: "responses.json")
//let chatbot = Chatbot(name: "MyChatbot")

//chatbot.session(trainer: trainer, parser: parser)
