//
//  MasterOptionsValidation.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/25/24.
//

import Foundation

class MasterOptionsValidation {
    
    private let changeOptionsQueue: DispatchQueue
    
    init() {
        changeOptionsQueue = DispatchQueue(label: "com.peerlessApps.chess.changeOptionsQueue")
    }
    
    let allCheckOptions: [any CheckOption] = [
        Ponder(),
        OwnBook(),
        UCIShowCurrLine(),
        UCIShowRefutations(),
        UCILimitStrength(),
        UCIAnalyzeMode()
    ]
    
    let allSpinOptions: [any SpinOption] = [
        Hash(),
        NalimovCache(),
        MultiPV(),
        UCIElo()
    ]
    
    let allComboOptions: [any ComboOption] = [
        Aggressiveness()
    ]
    
    let allButtonOptions: [any ButtonOption] = [
    ]
    
    let allStringOptions: [any StringOption] = [
        UCIOpponent()
    ]

    ///
    /// Default Options
    ///
    
    // Value in MB for memory for hash tables
    private struct Hash: SpinOption {
        
        let name = "Hash"
        
        private struct Defaults: SpinDefaults {
            let minVal = 100
            let maxVal = 1000
            let defaultVal = 100
        }
        
        let defaults: SpinDefaults
        let type = OptionTypes.spin
        typealias ValueType = Int
        var currentVal: ValueType? = nil
        
        init(as value: ValueType? = nil) {
            defaults = Defaults()
            if let value = value {
                currentVal = validate(value) ? value : defaults.defaultVal
            } else {
                currentVal = defaults.defaultVal
            }
        }
        
        func validate(_ newVal: ValueType) -> Bool {
            return newVal >= defaults.minVal && newVal <= defaults.maxVal
        }
        
        func printOption() -> String {
            return "option name \(name) type \(type) default \(defaults.defaultVal) min \(defaults.minVal) max \(defaults.maxVal)"
        }
        
        mutating func setOption(_ newVal: ValueType) -> Bool {
            if validate(newVal) {
                currentVal = newVal
                return true
            }
            return false
        }
    }

    // Path on the hard disk to the Nalimov compressed format
    // Multiple directories can be concatenated with ";"
    private struct NalimovPath {
        let type = OptionTypes.string
        let defaultValue = ""
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            //fix later
            return IsValidFlag(true)
        }
    }

    // Size in MB for the cache for the nalimov table bases
    private struct NalimovCache: SpinOption {
        
        let name = "Nalimov Cache"
        
        private struct Defaults: SpinDefaults {
            let minVal = 1
            let maxVal = 1024
            let defaultVal = 100
        }
        
        let defaults: SpinDefaults
        let type = OptionTypes.spin
        typealias ValueType = Int
        var currentVal: ValueType? = nil
        
        init(as value: ValueType? = nil) {
            defaults = Defaults()
            if let value = value {
                currentVal = validate(value) ? value : defaults.defaultVal
            } else {
                currentVal = defaults.defaultVal
            }
        }
        
        func validate(_ newVal: ValueType) -> Bool {
            return newVal >= defaults.minVal && newVal <= defaults.maxVal
        }
        
        func printOption() -> String {
            return "option name \(name) type \(type) default \(defaults.defaultVal) min \(defaults.minVal) max \(defaults.maxVal)"
        }
        
        mutating func setOption(_ newVal: ValueType) -> Bool {
            if validate(newVal) {
                currentVal = newVal
                return true
            }
            return false
        }
    }

    // The engine may/may not ponder
    // The engine should not start pondering on its own if this is enabled, this option is only needed because the engine might change its time management algorithm when pondering is allowed
    private struct Ponder: CheckOption {
        
        let name = "Ponder"
        
        private struct Defaults: CheckDefaults {
            let defaultVal = true
        }
        
        let defaults: CheckDefaults
        let type = OptionTypes.check
        typealias ValueType = Bool
        var currentVal: ValueType? = nil
        
        init(as value: ValueType? = nil) {
            defaults = Defaults()
            if let value = value {
                currentVal = validate(value)
            } else {
                currentVal = defaults.defaultVal
            }
        }
        
        func validate(_ newVal: ValueType) -> Bool {
            return true // fix potentially. this just returns true
        }
        
        func printOption() -> String {
            return "option name \(name) type \(type) default \(defaults.defaultVal)"
        }
        
        mutating func setOption(_ newVal: ValueType) -> Bool {
            if validate(newVal) {
                currentVal = newVal
                return true
            }
            return false
        }
    }

    // The engine has its own book which is accessed by the engine itself.
    // If this is set, the engine takes care of the opening book and the GUI will never  execute a move out of its book for the engine.
    // If this is set to false by the GUI, the engine should not access its own book.
    private struct OwnBook: CheckOption {
        
        let name = "Own Book"
        
        private struct Defaults: CheckDefaults {
            let defaultVal = false
        }
        
        let defaults: CheckDefaults
        let type = OptionTypes.check
        typealias ValueType = Bool
        var currentVal: ValueType? = nil
        
        init(as value: ValueType? = nil) {
            defaults = Defaults()
            if let value = value {
                currentVal = validate(value)
            } else {
                currentVal = defaults.defaultVal
            }
        }
        
        func validate(_ newVal: ValueType) -> Bool {
            return true // fix potentially. this just returns true
        }
        
        func printOption() -> String {
            return "option name \(name) type \(type) default \(defaults.defaultVal)"
        }
        
        mutating func setOption(_ newVal: ValueType) -> Bool {
            if validate(newVal) {
                currentVal = newVal
                return true
            }
            return false
        }
    }

    // The engine supports multi best line or k-best mode
    private struct MultiPV: SpinOption {
        
        let name = "Multi PV"
        
        private struct Defaults: SpinDefaults {
            let minVal = 1
            let maxVal = 100
            let defaultVal = 1
        }
        
        let defaults: SpinDefaults
        let type = OptionTypes.spin
        typealias ValueType = Int
        var currentVal: ValueType? = nil
        
        
        init(as value: ValueType? = nil) {
            defaults = Defaults()
            if let value = value {
                currentVal = validate(value) ? value : defaults.defaultVal
            } else {
                currentVal = defaults.defaultVal
            }
        }
        
        func validate(_ newVal: ValueType) -> Bool {
            return newVal >= defaults.minVal && newVal <= defaults.maxVal
        }
        
        func printOption() -> String {
            return "option name \(name) type \(type) default \(defaults.defaultVal) min \(defaults.minVal) max \(defaults.maxVal)"
        }
        
        mutating func setOption(_ newVal: ValueType) -> Bool {
            if validate(newVal) {
                currentVal = newVal
                return true
            }
            return false
        }
    }

    // The engine can show the current line it is calculating
    private struct UCIShowCurrLine: CheckOption {
        
        let name = "UCI Show Current Line"
        
        private struct Defaults: CheckDefaults {
            let defaultVal = false
        }
        
        let defaults: CheckDefaults
        let type = OptionTypes.check
        typealias ValueType = Bool
        var currentVal: ValueType? = nil
        
        init(as value: ValueType? = nil) {
            defaults = Defaults()
            if let value = value {
                currentVal = validate(value)
            } else {
                currentVal = defaults.defaultVal
            }
        }
        
        func validate(_ newVal: ValueType) -> Bool {
            return true // fix potentially. this just returns true
        }
        
        func printOption() -> String {
            return "option name \(name) type \(type) default \(defaults.defaultVal)"
        }
        
        mutating func setOption(_ newVal: ValueType) -> Bool {
            if validate(newVal) {
                currentVal = newVal
                return true
            }
            return false
        }
    }

    // The engine can show a move and its refutation in a line
    private struct UCIShowRefutations: CheckOption {
        
        let name = "UCI Show Refutations"
        
        private struct Defaults: CheckDefaults {
            let defaultVal = false
        }
        
        let defaults: CheckDefaults
        let type = OptionTypes.check
        typealias ValueType = Bool
        var currentVal: ValueType? = nil
        
        init(as value: ValueType? = nil) {
            defaults = Defaults()
            if let value = value {
                currentVal = validate(value)
            } else {
                currentVal = defaults.defaultVal
            }
        }
        
        func validate(_ newVal: ValueType) -> Bool {
            return true // fix potentially. this just returns true
        }
        
        func printOption() -> String {
            return "option name \(name) type \(type) default \(defaults.defaultVal)"
        }
        
        mutating func setOption(_ newVal: ValueType) -> Bool {
            if validate(newVal) {
                currentVal = newVal
                return true
            }
            return false
        }
    }

    // The engine is able to limit its strength to a specific Elo number
    // This should always be implemented together with "UCI_Elo"
    private struct UCILimitStrength: CheckOption {
        
        let name = "UCI Limit Strength"
        
        private struct Defaults: CheckDefaults {
            let defaultVal = false
        }
        
        let defaults: CheckDefaults
        let type = OptionTypes.check
        typealias ValueType = Bool
        var currentVal: ValueType? = nil
        
        init(as value: ValueType? = nil) {
            defaults = Defaults()
            if let value = value {
                currentVal = validate(value)
            } else {
                currentVal = defaults.defaultVal
            }
        }
        
        func validate(_ newVal: ValueType) -> Bool {
            return true // fix potentially. this just returns true
        }
        
        func printOption() -> String {
            return "option name \(name) type \(type) default \(defaults.defaultVal)"
        }
        
        mutating func setOption(_ newVal: ValueType) -> Bool {
            if validate(newVal) {
                currentVal = newVal
                return true
            }
            return false
        }
    }

    // The engine can limit its strength in Elo within this interval
    // If UCI_LimitStrength is set to false, this value should be ignored
    private struct UCIElo: SpinOption {
        
        let name = "UCI Elo"
        
        private struct Defaults: SpinDefaults {
            let minVal = 1
            let maxVal = 3000
            let defaultVal = 2600
        }
        
        let defaults: SpinDefaults
        let type = OptionTypes.spin
        typealias ValueType = Int
        var currentVal: ValueType? = nil
        
        init(as value: ValueType? = nil) {
            defaults = Defaults()
            if let value = value {
                currentVal = validate(value) ? value : defaults.defaultVal
            } else {
                currentVal = defaults.defaultVal
            }
        }
        
        func validate(_ newVal: ValueType) -> Bool {
            return newVal >= defaults.minVal && newVal <= defaults.maxVal
        }
        
        func printOption() -> String {
            return "option name \(name) type \(type) default \(defaults.defaultVal) min \(defaults.minVal) max \(defaults.maxVal)"
        }
        
        mutating func setOption(_ newVal: ValueType) -> Bool {
            if validate(newVal) {
                currentVal = newVal
                return true
            }
            return false
        }
    }

    // The engine wants to behave differently when analysing or playing a game
    // For example when playing, it can use some kind of learning
    // This is set to false if the engine is playing a game, otherwise it is true
    private struct UCIAnalyzeMode: CheckOption {
        
        let name = "UCI Analyze Mode"
        
        private struct Defaults: CheckDefaults {
            let defaultVal = false
        }
        
        let defaults: CheckDefaults
        let type = OptionTypes.check
        typealias ValueType = Bool
        var currentVal: ValueType? = nil
        
        init(as value: ValueType? = nil) {
            defaults = Defaults()
            if let value = value {
                currentVal = validate(value)
            } else {
                currentVal = defaults.defaultVal
            }
        }
        
        func validate(_ newVal: ValueType) -> Bool {
            return true // fix potentially. this just returns true
        }
        
        func printOption() -> String {
            return "option name \(name) type \(type) default \(defaults.defaultVal)"
        }
        
        mutating func setOption(_ newVal: ValueType) -> Bool {
            if validate(newVal) {
                currentVal = newVal
                return true
            }
            return false
        }
    }

    // With this command the GUI can send the name, title, elo and if the engine is playing a human or computer to the engine
    private struct UCIOpponent: StringOption {
        
        let name = "UCI Opponent"
        
        private struct Defaults: StringDefaults {
            let defaultVal = ""
        }
        
        let defaults: StringDefaults
        let type = OptionTypes.string
        typealias ValueType = String
        var currentVal: ValueType? = nil
        
        init(as value: ValueType? = nil) {
            defaults = Defaults()
            if let value = value, validate(value) {
                currentVal = value
            } else {
                currentVal = defaults.defaultVal
            }
        }
        
        func validate(_ newVal: ValueType) -> Bool {
            return true // fix potentially. this just returns true
        }
        
        func printOption() -> String {
            return "option name \(name) type \(type) default \(defaults.defaultVal)"
        }
        
        mutating func setOption(_ newVal: ValueType) -> Bool {
            if validate(newVal) {
                currentVal = newVal
                return true
            }
            return false
        }
    }

    // Likely will delete
    private struct Unknown: CheckOption {
        
        let name = "Unknown"
        
        private struct Defaults: CheckDefaults {
            let defaultVal = false
        }
        
        let defaults: CheckDefaults
        let type = OptionTypes.check
        typealias ValueType = Bool
        var currentVal: ValueType? = nil
        
        init(as value: ValueType? = nil) {
            defaults = Defaults()
            if let value = value {
                currentVal = validate(value)
            } else {
                currentVal = defaults.defaultVal
            }
        }
        
        func validate(_ newVal: ValueType) -> Bool {
            return true // fix potentially. this just returns true
        }
        
        func printOption() -> String {
            return "option name \(name) type \(type) default \(defaults.defaultVal)"
        }
        
        mutating func setOption(_ newVal: ValueType) -> Bool {
            if validate(newVal) {
                currentVal = newVal
                return true
            }
            return false
        }
    }
    
    // Custom values
    private struct Aggressiveness: ComboOption {
        
        let name = "Aggressiveness"
        
        private struct Defaults: ComboDefaults {
            let possibleVals: [String] = [
                "Conservative",
                "Neutral",
                "Aggressive"
            ]
            let defaultVal = "Neutral"
        }
        
        let defaults: ComboDefaults
        let type = OptionTypes.combo
        typealias ValueType = String
        var currentVal: ValueType? = nil
        
        init(as value: ValueType? = nil) {
            defaults = Defaults()
            if let value = value, validate(value) {
                currentVal = value
            } else {
                currentVal = defaults.defaultVal
            }
        }
        
        func validate(_ newVal: ValueType) -> Bool {
            return defaults.possibleVals.contains(where: { $0.lowercased() == newVal.lowercased() })
        }
        
        func printOption() -> String {
            return "option name \(name) type \(type) default \(defaults.defaultVal) var \(defaults.possibleVals.joined(separator: " var "))"
        }
        
        mutating func setOption(_ newVal: ValueType) -> Bool {
            if validate(newVal) {
                currentVal = newVal
                return true
            }
            return false
        }
    }
    
    ///
    /// Change/Validate settings
    ///
    
    func changeCheckOption(_ optionName: String, _ newValue: Bool) {
        changeOptionsQueue.sync {
            if let option = allCheckOptions.first(where: { $0.name == optionName }) {
                if option.setOption(newValue) {
                    
                }
            }
        }
    }
}

enum OptionTypes {
    case check
    case spin
    case combo
    case button
    case string
    case unknown
}

protocol Option {
    var name: String { get }
    var type: OptionTypes { get }
    associatedtype ValueType
    func validate(_ value: ValueType) -> Bool
    func printOption() -> String
    mutating func setOption(_ newOption: ValueType) -> Bool
}

protocol SpinOption: Option {
    var defaults: SpinDefaults { get }
}

protocol SpinDefaults {
    var minVal: Int { get }
    var maxVal: Int { get }
    var defaultVal: Int { get }
}

protocol CheckOption: Option {
    var defaults: CheckDefaults { get }
}

protocol CheckDefaults {
    var defaultVal: Bool { get }
}

protocol ComboOption: Option {
    var defaults: ComboDefaults { get }
}

protocol ComboDefaults {
    var possibleVals: [String] { get }
    var defaultVal: String { get }// or int of index in possibleVals?
}

protocol ButtonOption: Option {
    var defaults: ButtonDefaults { get }
}

protocol ButtonDefaults {
}

protocol StringOption: Option {
    var defaults: StringDefaults { get }
}

protocol StringDefaults {
    var defaultVal: String { get }
}

/*
 Here are a few suggestions to improve the options system:

- Use enums instead of structs for the option types (CheckOption, SpinOption, etc). This removes a lot of boilerplate.

- Use a protocol-oriented approach. Define protocols for the common option behaviors instead of concrete types.

- Use enums with raw values instead of strings for combo box options. This adds type safety.

- Use a single Options struct instead of _Options. No need for the underscore.

- Consider using Record instead of defining separate defaults structs.

- Validation could be improved by returning more info like an Error instead of just Bool.

- Naming should follow Swift conventions - lowerCamelCase instead of UpperCamelCase for most things.

Here is one way it could be refactored:

```swift
enum OptionType {
  case check, spin, combo, button, string
}

protocol Option {
  var type: OptionType { get }
  
  func validate(_ value: OptionValue) -> Result<OptionValue, Error>
  
  func print() -> String
}

// Usage:

enum Aggressiveness: String, OptionValue {
  case conservative = "Conservative"
  //...
}

struct Options {

  enum AggressivenessOption: Option {
    typealias ValueType = Aggressiveness
    
    let type = .combo
    let defaultValue = .neutral
    
    //...
  }
  
}
```

The key changes:

- Use enums for reusable, common types like OptionType.

- Protocols define shared behavior.

- Enums provide type safety.

- Single Options struct for clean usage.

- Record can remove boilerplate defaults.

- Validation returns a Result instead of just Bool.
 
 
 Here are a few suggestions to improve the options system:

1. Use enums rather than structs for the option types (CheckOption, SpinOption, etc.). This avoids having to define separate protocols and makes the code more concise.

2. Use a single Option protocol that has a type property instead of separate protocols for each type. This avoids needing to conform to multiple protocols.

3. Use a Result type instead of a separate validate method. This encapsulates the success/failure more cleanly.

4. Use generics and associatedtypes to avoid needing as many typealiases.

5. Consider consolidating the various Defaults structs into a single Defaults protocol for less duplication.

Here is an example of how it could be refactored:

```swift
enum OptionType {
    case check, spin, combo, button, string
}

protocol Defaults {
    var name: String { get }
}

struct SpinDefaults: Defaults {
    let minVal: Int
    let maxVal: Int
    let defaultVal: Int
}

enum Option<T> {
    case check(CheckOption)
    case spin(SpinOption)
    // other cases
    
    var type: OptionType { /* return correct type */ }
    
    struct CheckOption {
        let defaults: Defaults
    }
    
    struct SpinOption {
        let defaults: SpinDefaults
    }
}

struct OptionResult<Value> {
    let value: Value
    let isValid: Bool
}

extension Option {
    func validate(value: T) -> OptionResult<T> {
        // implement validation
    }
}
```
 
 protocol Defaults {
     var name: String { get }
 }

 struct CheckDefaults: Defaults {
     let defaultValue: Bool
 }

 struct SpinDefaults: Defaults {
     let minValue: Int
     let maxValue: Int
     let defaultValue: Int
 }

 struct ComboDefaults: Defaults {
     let options: [String]
     let defaultValue: String
 }

 enum OptionType {
     case check, spin, combo, string
 }

 enum OptionResult<Value> {
     case valid(Value)
     case invalid
 }

 enum Option<Value> {
     case check(CheckOption<Value>)
     case spin(SpinOption<Value>)
     case combo(ComboOption<Value>)
     case string(StringOption<Value>)
     
     var type: OptionType {
         switch self {
         case .check: return .check
         // ...
         }
     }

     struct CheckOption<Value> {
         let defaults: CheckDefaults
     }
     
     struct SpinOption<Value> {
         let defaults: SpinDefaults
     }
     
     struct ComboOption<Value> {
         let defaults: ComboDefaults
     }
     
     struct StringOption<Value> {
         let defaults: Defaults
     }
 }

 extension Option {
     func validate(_ value: Value) -> OptionResult<Value> {
         switch self {
         case .check(let option):
             return .valid(value)
             // check value
         case .spin(let option):
             return .valid(value)
             // validate spin
         // ...
         }
     }
 }
 
 enum OptionType {
     case check, spin, combo, button, string
 }

 protocol Defaults {
     var name: String { get }
 }

 struct CheckDefaults: Defaults {
     let defaultValue: Bool
 }

 struct SpinDefaults: Defaults {
     let minValue: Int
     let maxValue: Int
     let defaultValue: Int
 }

 struct ComboDefaults: Defaults {
     let options: [String]
     let defaultIndex: Int
 }

 enum OptionResult<Value> {
     case valid(Value)
     case invalid
 }

 enum Option<Value> {
     case check(CheckOption<Value>)
     case spin(SpinOption<Value>)
     // other cases
     
     var type: OptionType {
         switch self {
         case .check: return .check
         case .spin: return .spin
         // etc
         }
     }

     struct CheckOption<Value> {
         let defaults: CheckDefaults
     }
     
     struct SpinOption<Value> {
         let defaults: SpinDefaults
     }
     
     func validate(value: Value) -> OptionResult<Value> {
         switch self {
         case .check(let opt):
             return .valid(value) // add validation
         case .spin(let opt):
             return .valid(value) // add validation
         }
     }
 }

 let hashOption = Option.spin(
     SpinOption(defaults: SpinDefaults(
         name: "Hash",
         minValue: 100,
         maxValue: 1000,
         defaultValue: 100))
 )

 let result = hashOption.validate(value: 500)

 switch result {
 case .valid(let value):
     print("New valid value is \(value)")
 case .invalid:
     print("Invalid value")
 }
 */







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
