//
//  Options.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/25/24.
//

import Foundation

class _Options {
    
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
        
        private struct Defaults: SpinDefaults {
            let name = "Hash"
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
            return "option name \(defaults.name) type \(type) default \(defaults.defaultVal) min \(defaults.minVal) max \(defaults.maxVal)"
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
        
        private struct Defaults: SpinDefaults {
            let name = "Nalimov Cache"
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
            return "option name \(defaults.name) type \(type) default \(defaults.defaultVal) min \(defaults.minVal) max \(defaults.maxVal)"
        }
    }

    // The engine may/may not ponder
    // The engine should not start pondering on its own if this is enabled, this option is only needed because the engine might change its time management algorithm when pondering is allowed
    private struct Ponder: CheckOption {
        
        private struct Defaults: CheckDefaults {
            let name = "Ponder"
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
            return "option name \(defaults.name) type \(type) default \(defaults.defaultVal)"
        }
    }

    // The engine has its own book which is accessed by the engine itself.
    // If this is set, the engine takes care of the opening book and the GUI will never  execute a move out of its book for the engine.
    // If this is set to false by the GUI, the engine should not access its own book.
    private struct OwnBook: CheckOption {
        
        private struct Defaults: CheckDefaults {
            let name = "Own Book"
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
            return "option name \(defaults.name) type \(type) default \(defaults.defaultVal)"
        }
    }

    // The engine supports multi best line or k-best mode
    private struct MultiPV: SpinOption {
        
        private struct Defaults: SpinDefaults {
            let name = "Multi PV"
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
            return "option name \(defaults.name) type \(type) default \(defaults.defaultVal) min \(defaults.minVal) max \(defaults.maxVal)"
        }
    }

    // The engine can show the current line it is calculating
    private struct UCIShowCurrLine: CheckOption {
        
        private struct Defaults: CheckDefaults {
            let name = "UCI Show Current Line"
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
            return "option name \(defaults.name) type \(type) default \(defaults.defaultVal)"
        }
    }

    // The engine can show a move and its refutation in a line
    private struct UCIShowRefutations: CheckOption {
        
        private struct Defaults: CheckDefaults {
            let name = "UCI Show Refutations"
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
            return "option name \(defaults.name) type \(type) default \(defaults.defaultVal)"
        }
    }

    // The engine is able to limit its strength to a specific Elo number
    // This should always be implemented together with "UCI_Elo"
    private struct UCILimitStrength: CheckOption {
        
        private struct Defaults: CheckDefaults {
            let name = "UCI Limit Strength"
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
            return "option name \(defaults.name) type \(type) default \(defaults.defaultVal)"
        }
    }

    // The engine can limit its strength in Elo within this interval
    // If UCI_LimitStrength is set to false, this value should be ignored
    private struct UCIElo: SpinOption {
        
        private struct Defaults: SpinDefaults {
            let name = "UCI Elo"
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
            return "option name \(defaults.name) type \(type) default \(defaults.defaultVal) min \(defaults.minVal) max \(defaults.maxVal)"
        }
    }

    // The engine wants to behave differently when analysing or playing a game
    // For example when playing, it can use some kind of learning
    // This is set to false if the engine is playing a game, otherwise it is true
    private struct UCIAnalyzeMode: CheckOption {
        
        private struct Defaults: CheckDefaults {
            let name = "UCI Analyze Mode"
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
            return "option name \(defaults.name) type \(type) default \(defaults.defaultVal)"
        }
    }

    // With this command the GUI can send the name, title, elo and if the engine is playing a human or computer to the engine
    private struct UCIOpponent: StringOption {
        
        private struct Defaults: StringDefaults {
            let name = "UCI Opponent"
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
            return "option name \(defaults.name) type \(type) default \(defaults.defaultVal)"
        }
    }

    // Likely will delete
    private struct Unknown: CheckOption {
        
        private struct Defaults: CheckDefaults {
            let name = "Unknown"
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
            return "option name \(defaults.name) type \(type) default \(defaults.defaultVal)"
        }
    }
    
    // Custom values
    private struct Aggressiveness: ComboOption {
        
        private struct Defaults: ComboDefaults {
            let name = "Aggressiveness"
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
            return "option name \(defaults.name) type \(type) default \(defaults.defaultVal) var \(defaults.possibleVals.joined(separator: " var "))"
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
    var type: OptionTypes { get }
    associatedtype ValueType
    func validate(_ value: ValueType) -> Bool
    func printOption() -> String
}

protocol SpinOption: Option {
    var defaults: SpinDefaults { get }
}

protocol SpinDefaults {
    var name: String { get }
    var minVal: Int { get }
    var maxVal: Int { get }
    var defaultVal: Int { get }
}

protocol CheckOption: Option {
    var defaults: CheckDefaults { get }
}

protocol CheckDefaults {
    var name: String { get }
    var defaultVal: Bool { get }
}

protocol ComboOption: Option {
    var defaults: ComboDefaults { get }
}

protocol ComboDefaults {
    var name: String { get }
    var possibleVals: [String] { get }
    var defaultVal: String { get }// or int of index in possibleVals?
}

protocol ButtonOption: Option {
    var defaults: ButtonDefaults { get }
}

protocol ButtonDefaults {
    var name: String { get }
}

protocol StringOption: Option {
    var defaults: StringDefaults { get }
}

protocol StringDefaults {
    var name: String { get }
    var defaultVal: String { get }
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
