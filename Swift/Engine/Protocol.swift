//
//  Protocol.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/10/24.
//

import Foundation


enum IsValidFlag {
    
    case valid
    case invalid
    
    init(_ bool: Bool) {
        if bool {
            self = .valid
        } else {
            self = .invalid
        }
    }
}

enum DebugOptions_enum {
    
    case on
    case off
    case unknown
    
    init(_ rawValue: String) {
        
        switch rawValue {
        case "on":
            self = .on
        case "off":
            self = .off
        default:
            self = .unknown
        }
    }
}



/*
 Here's an alternative method for parsing input in Swift without relying on enums:

 ## **String-based Parsing with Dictionaries**

 1. **Define input command structures:**
    - Create a dictionary to map command keywords to their corresponding parsing logic:
      ```swift
      let commandParsers: [String: (String) -> Void] = [
          "uci": parseUciCommand,
          "debug": parseDebugCommand,
          // ... add parsers for other commands
      ]
      ```
    - Each parsing function (`parseUciCommand`, `parseDebugCommand`, etc.) will take the raw input string and extract necessary information.

 2. **Receive and split input:**
    - Get the raw input string from the interface.
    - Split it into an array of words using spaces as delimiters:
      ```swift
      let inputWords = inputString.split(separator: " ")
      ```

 3. **Identify command and parse:**
    - Check if the first word (command) exists in `commandParsers`:
      ```swift
      if let parser = commandParsers[inputWords[0]] {
          // Remove the command itself from the input
          let remainingInput = inputWords.dropFirst().joined(separator: " ")
          parser(remainingInput)
      } else {
          // Handle unknown command
          print("Error: Unknown command: \(inputWords[0])")
      }
      ```

 4. **Implement parsing functions:**
    - For each command, write a parsing function that extracts arguments and performs actions:
      ```swift
      func parseUciCommand(input: String) {
          // ... parse "uci" command details
      }

      func parseDebugCommand(input: String) {
          if input == "on" {
              enableDebugMode()
          } else if input == "off" {
              disableDebugMode()
          } else {
              // Handle invalid debug argument
          }
      }

      // ... similar functions for other commands
      ```

 ## **Example (`parseDebugCommand`)**

 ```swift
 func parseDebugCommand(input: String) {
     if input == "on" {
         enableDebugMode()
     } else if input == "off" {
         disableDebugMode()
     } else {
         print("Error: Invalid argument for debug command. Use 'on' or 'off'.")
     }
 }
 ```

 ## **Advantages**

 - **Flexibility:** You can easily add or modify command parsing logic without changing an enum definition.
 - **No fixed option range:** This approach doesn't limit the number of potential commands or arguments.
 - **Error handling:** You can include specific error handling within each parsing function.

 ## **Considerations**

 - **Potential typos:** String-based matching can be prone to typos in command names. Consider error handling or input validation.
 - **Complexity:** For many commands with complex arguments, using enums might become more readable and maintainable.
 - **Performance:** String parsing might be slightly slower than enum-based approaches, but the difference is usually negligible for typical command-line input scenarios.

 Choose the method that best suits your specific use case, balancing flexibility, readability, and performance requirements.
 */
