//
//  Protocol.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/10/24.
//

import Foundation

// Validate top level commands
enum TopLevelCommand {
    
    case uci
    case debug
    case isready
    case setoption
    case register
    case ucinewgame
    case position
    case go
    case stop
    case ponderhit
    case quit
    case unknown
    
    init(_ input: [String]) {
        
        let components = input
        let command = components.first!
        
        switch command {
        case "uci":
            self = .uci
        case "debug":
            self = .debug
        case "isready":
            self = .isready
        case "setoption":
            self = .setoption
        case "register":
            self = .register
        case "ucinewgame":
            self = .ucinewgame
        case "position":
            self = .position
        case "go":
            self = .go
        case "stop":
            self = .stop
        case "ponderhit":
            self = .ponderhit
        case "quit", "q":
            self = .quit
        default:
            self = .unknown
        }
    }
}

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

struct SetOptionCommand_struct {
    
    let name: OptionNames_enum
    let value: String?
    
    init(_ rawValue: String) {
        
        let components = rawValue.components(separatedBy: " ")
        var fullOptionName: String
        var fullSettingName: String? = nil
        
        // There is an option name and value provided
        if let valueIndex = components.firstIndex(where: { $0.lowercased() == "value" } ) {
            
            fullOptionName = String(components.prefix(valueIndex - 1).joined(separator: " "))
            
            // Account for index by 0
            if components.count >= valueIndex {
                fullSettingName = String(components.suffix(from: valueIndex + 1).joined(separator: " "))
            }
            
        } else {
            // Only option name is provided
            fullOptionName = String(components.joined(separator: " "))
        }
        
        name = OptionNames_enum(fullOptionName)
        
        
        value = fullSettingName
        
        
    }
}

enum OptionNames_enum {
    
    // Default
    case hash(IsValidFlag?)
    case nalimovPath(IsValidFlag?)
    case nalimovCache(IsValidFlag?)
    case ponder(IsValidFlag?)
    case ownbook(IsValidFlag?)
    case multiPV(IsValidFlag?)
    case uci_showCurrLine(IsValidFlag?)
    case uci_showRefutations(IsValidFlag?)
    case uci_limitStrength(IsValidFlag?)
    case uci_elo(IsValidFlag?)
    case uci_analyseMode(IsValidFlag?)
    case uci_opponent(IsValidFlag?)
    
    // Custom
    case aggressiveness(IsValidFlag?)
    
    // Default
    case unknown(IsValidFlag?)
    
    init(_ rawValue: String, _ optionSetting: String? = nil) {
        
        var isValidSetting: IsValidFlag? = nil

        switch rawValue {
            
        // Default
        case "hash":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings_enum.Hash().isValidSetting(optionSetting)
            }
            self = .hash(isValidSetting)
            
        case "nalimovPath":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings_enum.NalimovPath().isValidSetting(optionSetting)
            }
            self = .nalimovPath(isValidSetting)
            
        case "nalimovCache":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings_enum.NalimovCache().isValidSetting(optionSetting)
            }
            self = .nalimovCache(isValidSetting)
            
        case "ponder":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings_enum.Ponder().isValidSetting(optionSetting)
            }
            self = .ponder(isValidSetting)
            
        case "ownbook":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings_enum.OwnBook().isValidSetting(optionSetting)
            }
            self = .ownbook(isValidSetting)
            
        case "multiPV":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings_enum.MultiPV().isValidSetting(optionSetting)
            }
            self = .multiPV(isValidSetting)
            
        case "uci_showCurrLine":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings_enum.UCIShowCurrLine().isValidSetting(optionSetting)
            }
            self = .uci_showCurrLine(isValidSetting)
            
        case "uci_showRefutations":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings_enum.UCIShowRefutations().isValidSetting(optionSetting)
            }
            self = .uci_showRefutations(isValidSetting)
            
        case "uci_limitStrength":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings_enum.UCILimitStrength().isValidSetting(optionSetting)
            }
            self = .uci_limitStrength(isValidSetting)
            
        case "uci_elo":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings_enum.UCIElo().isValidSetting(optionSetting)
            }
            self = .uci_elo(isValidSetting)
            
        case "uci_analyseMode":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings_enum.UCIAnalyseMode().isValidSetting(optionSetting)
            }
            self = .uci_analyseMode(isValidSetting)
            
        case "uci_opponent":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings_enum.UCIOpponent().isValidSetting(optionSetting)
            }
            self = .uci_opponent(isValidSetting)
        
        // Custom
        case "aggressiveness":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings_enum.Hash().isValidSetting(optionSetting)
            }
            self = .aggressiveness(isValidSetting)
        
        // Unknown
        default:
            self = .unknown(isValidSetting)
        }
    }
}

struct OptionSettings_enum {

    // Default options
    struct Hash: SpinOption_enum {
        let name = "hash"
        let type = OptionTypes_enum.spin
        let defaultValue = 1000
        let min = 100
        let max = 10000
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            if let int = Int(input), int >= min, int <= max {
                return IsValidFlag(true)
            }
            return IsValidFlag(false)
        }
    }

    struct NalimovPath: StringOption_enum {
        let type = OptionTypes_enum.string
        let defaultValue = ""
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            //fix later
            return IsValidFlag(true)
        }
    }

    struct NalimovCache: SpinOption_enum {
        let type = OptionTypes_enum.spin
        let defaultValue = 64
        let min = 1
        let max = 1024
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            if let int = Int(input), int >= min, int <= max {
                return IsValidFlag(true)
            }
            return IsValidFlag(false)
        }
    }

    struct Ponder: CheckOption_enum {
        let type = OptionTypes_enum.check
        let defaultValue = true
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            if Bool(input) != nil {
                return IsValidFlag(true)
            }
            return IsValidFlag(false)
        }
    }

    struct OwnBook: CheckOption_enum {
        let type = OptionTypes_enum.check
        let defaultValue = false
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            if Bool(input) != nil {
                return IsValidFlag(true)
            }
            return IsValidFlag(false)
        }
    }

    struct MultiPV: SpinOption_enum {
        let type = OptionTypes_enum.spin
        let defaultValue = 1
        let min = 1
        let max = 100
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            if let int = Int(input), int >= min, int <= max {
                return IsValidFlag(true)
            }
            return IsValidFlag(false)
        }
    }

    struct UCIShowCurrLine: CheckOption_enum {
        let type = OptionTypes_enum.check
        let defaultValue = false
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            if Bool(input) != nil {
                return IsValidFlag(true)
            }
            return IsValidFlag(false)
        }
    }

    struct UCIShowRefutations: CheckOption_enum {
        let type = OptionTypes_enum.check
        let defaultValue = false
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            if Bool(input) != nil {
                return IsValidFlag(true)
            }
            return IsValidFlag(false)
        }
    }

    struct UCILimitStrength: CheckOption_enum {
        let type = OptionTypes_enum.check
        let defaultValue = false
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            if Bool(input) != nil {
                return IsValidFlag(true)
            }
            return IsValidFlag(false)
        }
    }

    struct UCIElo: SpinOption_enum {
        let type = OptionTypes_enum.spin
        let defaultValue = 2600
        let min = 1
        let max = 3000
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            if let int = Int(input), int >= min, int <= max {
                return IsValidFlag(true)
            }
            return IsValidFlag(false)
        }
    }

    struct UCIAnalyseMode: CheckOption_enum {
        let type = OptionTypes_enum.check
        let defaultValue = false
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            if Bool(input) != nil {
                return IsValidFlag(true)
            }
            return IsValidFlag(false)
        }
    }

    struct UCIOpponent: StringOption_enum {
        let type = OptionTypes_enum.string
        let defaultValue = ""
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            //fix later
            return IsValidFlag(true)
        }
    }

    struct Unknown: CheckOption_enum {
        let type = OptionTypes_enum.check
        let defaultValue = false
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            if Bool(input) != nil {
                return IsValidFlag(true)
            }
            return IsValidFlag(false)
        }
    }
    
    // Custom values
    struct Aggressiveness: ComboOption_enum {
        
        let type = OptionTypes_enum.combo
        let options = [
            "conservative",
            "neutral",
            "aggressive"
        ]
        let defaultValue = "neutral"
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            if options.contains(where: {$0 == input }) {
                return IsValidFlag(true)
            }
            return IsValidFlag(false)
        }
    }
}


enum OptionTypes_enum {
    
    case check
    case spin
    case combo
    case button
    case string
    case unknown
    
    init(_ rawValue: String) {
        
        switch rawValue.lowercased() {
        default:
            self = .unknown
        }
        
    }
}

protocol Option_enum {
    var name: String { get }
}

protocol CheckOption_enum {
    var type: OptionTypes_enum { get }
    //var value: Bool { get }
    var defaultValue: Bool { get }
    func isValidSetting(_ input: String) -> IsValidFlag
}

protocol SpinOption_enum {
    var type: OptionTypes_enum { get }
    //var value: Int { get }
    var defaultValue: Int { get }
    var min: Int { get }
    var max: Int { get }
    func isValidSetting(_ input: String) -> IsValidFlag
}

protocol ComboOption_enum {
    var type: OptionTypes_enum { get }
    var defaultValue: String { get }
    // options denoted by "var" when printing
    var options: [String] { get }
    func isValidSetting(_ input: String) -> IsValidFlag
}

protocol ButtonOption_enum {
    var type: OptionTypes_enum { get }
    //func isValidSetting(_ value: String) -> Bool
    //closure?
}

protocol StringOption_enum {
    var type: OptionTypes_enum { get }
    var defaultValue: String { get }
    func isValidSetting(_ input: String) -> IsValidFlag
}

enum GoOptions_enum {
    
    case searchmoves
    case ponder
    case wtime
    case btime
    case winc
    case binc
    case movestogo
    case depth
    case nodes
    case mate
    case movetime
    case infinite
    
    
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
