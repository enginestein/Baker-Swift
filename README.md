# Baker-Swift

*Bot-Maker* Baker! Is a framework to create chatbots with Swift in the easiest and simplest route, train your chatbot by texting or adding data in XML, JSON or YAML files. 

# Usage

## Initial Tasks

Using Baker is very easy, all you have to do is to create a YAML, JSON or XML file first. However, files should have been defined in a specific format:

**For XML files**

```xml
<responses>
  <Hello>
    <response>Hello!</response>
    <response>Hi there!</response>
  </Hello>
</responses>
```

The `Hello` tag is defining that if the user will write `Hello` to the chatbot the chatbot will return one of the responses in the `response` tag.

**For JSON files**

```json
{
    "Hello": [
        "Hi",
        "Heyy",
        "Hello"
    ]

}
```

Same goes with JSON files. Even if the response is only one, it must be in a list []. Here, if user inputs `Hello` then the response must be random in the list. 

**For YAML files**

```yaml
Hello:
- Hello!
- Hi there!
How are you:
- I am fine
- I am doing good, thanks for asking
```

Same process is with the YAML files with a bit different syntax and nothing else.

The files can also be empty for example a JSON file can be like this:

```json
{

}
```

## Training

To train the chatbot, use the `Trainer` class. Here is an example of basic training:

```swift
let bot = Trainer(responseFileName: "database.yaml")

print("You: ", terminator: "")
if let user_input = readLine() {
    let response = bot.getResponse(userInput: user_input)
    print("Bot:", response)

    // Train the bot with a new response
    print("New response: ", terminator: "")
    if let new_response = readLine() {
        bot.trainResponse(userInput: user_input, newResponse: new_response)
        print("Bot has been trained with the new response!")
    }
}
```

from this route the keyword (user's question) must be already created in the file or else the trainer will not be able to train because the trainer will not find the keyword in the file. For example if you want to train the chatbot for responses of `Hello` then `Hello` should be created in the data file.

But with this way to train you can train the chatbot as long you want to with custom keywords (no need to define them in the data file) and their infinite responses:

```swift
let trainer = Trainer(responseFileName: "responses.json")
trainer.loop_training()
```

The data file can either be empty or it can have keywords, pre-defined keyowrds can be trained too.

# Parsing

To parse the chatbot to run and test it use the `Parser` class:

```swift
import Foundation

func testChatbot(bot: Parser) {
    print("Testing session started. Type 'exit' to end the session.")
    while true {
        print("You: ", terminator: "")
        if let user_input = readLine()?.lowercased(), user_input != "exit" {
            let response = bot.getResponse(userInput: user_input)
            print("Bot:", response)
        } else {
            print("Testing session ended.")
            break
        }
    }
}

let bot = Parser(responseFileName: "database.json")
testChatbot(bot: bot)
```

The above code will run the chatbot, but there is anther simpler way to run the chatbot with it's specified name which is to use the `Chatbot` class:

```swift
let parser = Parser(responseFileName: "responses.json")
let trainer = Trainer(responseFileName: "responses.json")
let chatbot = Chatbot(name: "MyChatbot")
chatbot.session(trainer: trainer, parser: parser)
```

`Parser` class has more functions regarding the data file:


## Other Functions

- **Export responses** using `exportResponses`
- **Reset responses** using `resetResponses`
- **Remove responses** using `removeResponse`
- **List questions** using `listKeyQuestions`
- **Count responses** using `countResponses`

Keep training your chatbot by texting or adding words in the database and then run it!
