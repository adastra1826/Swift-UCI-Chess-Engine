//
//  OptionDefaults.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 4/4/24.
//

import Foundation

struct AllOptions {
    
    private let allOptions: [any Option] = [
        AllOptionDefaultSettings.Ponder(),
        AllOptionDefaultSettings.OwnBook(),
        AllOptionDefaultSettings.UCIShowCurrLine(),
        AllOptionDefaultSettings.UCIShowRefutations(),
        AllOptionDefaultSettings.UCILimitStrength(),
        AllOptionDefaultSettings.UCIAnalyzeMode(),
        AllOptionDefaultSettings.Hash(),
        AllOptionDefaultSettings.NalimovCache(),
        AllOptionDefaultSettings.MultiPV(),
        AllOptionDefaultSettings.UCIElo(),
        AllOptionDefaultSettings.Aggressiveness(),
        AllOptionDefaultSettings.UCIOpponent()
    ]
    
    func initializeAllOptions() -> [any Option] {
        return allOptions
    }
}

struct AllOptionDefaultSettings {
    
    //
    // Check options
    //
    fileprivate struct Ponder: Option {
        
        
        struct Defaults: CheckOptionProtocol, OptionDefaultValueProtocol {
            let defaultValue = true
        }
        
        // Protocol required values
        typealias ValueType = Bool
        
        let type = OptionType.check(ValueType.self)
        let name = "Ponder"
        let defaults = Defaults()
        
        var value: ValueType? = nil
        
        internal func isValid(_ newValue: ValueType) -> Bool {
            return true
        }
        
        mutating func setValue(_ newValue: ValueType?) -> Bool {
            if let newValue = newValue {
                if isValid(newValue) {
                    value = newValue
                    return true
                }
                return false
            } else {
                value = defaults.defaultValue
                return true
            }
        }
        //
    }
    
    fileprivate struct OwnBook: Option {
        
        struct Defaults: CheckOptionProtocol, OptionDefaultValueProtocol {
            let defaultValue = false
        }
        
        // Protocol required values
        typealias ValueType = Bool
        
        let type = OptionType.check(ValueType.self)
        let name = "OwnBook"
        let defaults = Defaults()
        
        var value: ValueType? = nil
        
        internal func isValid(_ newValue: ValueType) -> Bool {
            return true
        }
        
        mutating func setValue(_ newValue: ValueType?) -> Bool {
            if let newValue = newValue {
                if isValid(newValue) {
                    value = newValue
                    return true
                }
                return false
            } else {
                value = defaults.defaultValue
                return true
            }
        }
        //
    }
    
    fileprivate struct UCIShowCurrLine: Option {
        
        struct Defaults: CheckOptionProtocol, OptionDefaultValueProtocol {
            let defaultValue = false
        }
        
        // Protocol required values
        typealias ValueType = Bool
        
        let type = OptionType.check(ValueType.self)
        let name = "UCIShowCurrLine"
        let defaults = Defaults()
        
        var value: ValueType? = nil
        
        internal func isValid(_ newValue: ValueType) -> Bool {
            return true
        }
        
        mutating func setValue(_ newValue: ValueType?) -> Bool {
            if let newValue = newValue {
                if isValid(newValue) {
                    value = newValue
                    return true
                }
                return false
            } else {
                value = defaults.defaultValue
                return true
            }
        }
        //
    }
    
    fileprivate struct UCIShowRefutations: Option {
        
        struct Defaults: CheckOptionProtocol, OptionDefaultValueProtocol {
            let defaultValue = false
        }
        
        // Protocol required values
        typealias ValueType = Bool
        
        let type = OptionType.check(ValueType.self)
        let name = "UCIShowRefutations"
        let defaults = Defaults()
        
        var value: ValueType? = nil
        
        internal func isValid(_ newValue: ValueType) -> Bool {
            return true
        }
        
        mutating func setValue(_ newValue: ValueType?) -> Bool {
            if let newValue = newValue {
                if isValid(newValue) {
                    value = newValue
                    return true
                }
                return false
            } else {
                value = defaults.defaultValue
                return true
            }
        }
        //
    }
    
    fileprivate struct UCILimitStrength: Option {
        
        struct Defaults: CheckOptionProtocol, OptionDefaultValueProtocol {
            let defaultValue = false
        }
        
        // Protocol required values
        typealias ValueType = Bool
        
        let type = OptionType.check(ValueType.self)
        let name = "UCILimitStrength"
        let defaults = Defaults()
        
        var value: ValueType? = nil
        
        internal func isValid(_ newValue: ValueType) -> Bool {
            return true
        }
        
        mutating func setValue(_ newValue: ValueType?) -> Bool {
            if let newValue = newValue {
                if isValid(newValue) {
                    value = newValue
                    return true
                }
                return false
            } else {
                value = defaults.defaultValue
                return true
            }
        }
        //
    }
    
    fileprivate struct UCIAnalyzeMode: Option {
        
        struct Defaults: CheckOptionProtocol, OptionDefaultValueProtocol {
            let defaultValue = false
        }
        
        // Protocol required values
        typealias ValueType = Bool
        
        let type = OptionType.check(ValueType.self)
        let name = "UCIAnalyzeMode"
        let defaults = Defaults()
        
        var value: ValueType? = nil
        
        internal func isValid(_ newValue: ValueType) -> Bool {
            return true
        }
        
        mutating func setValue(_ newValue: ValueType?) -> Bool {
            if let newValue = newValue {
                if isValid(newValue) {
                    value = newValue
                    return true
                }
                return false
            } else {
                value = defaults.defaultValue
                return true
            }
        }
        //
    }
    
    //
    // Spin options
    //
    fileprivate struct Hash: Option {
        
        // Values specific to the option type are contained here
        struct Defaults: SpinOptionProtocol, OptionDefaultValueProtocol {
            let minValue = 100
            let maxValue = 1000
            let defaultValue = 100
        }
        
        // Protocol required values
        typealias ValueType = Int
        
        let type = OptionType.spin(ValueType.self)
        let name = "Hash"
        let defaults = Defaults()
        
        var value: ValueType? = nil
        
        internal func isValid(_ newValue: ValueType) -> Bool {
            return newValue <= defaults.maxValue && newValue >= defaults.maxValue
        }
        
        mutating func setValue(_ newValue: ValueType?) -> Bool {
            if let newValue = newValue {
                if isValid(newValue) {
                    value = newValue
                    return true
                }
                return false
            } else {
                value = defaults.defaultValue
                return true
            }
        }
        //
    }
    
    fileprivate struct NalimovCache: Option {
        
        // Values specific to the option type are contained here
        struct Defaults: SpinOptionProtocol, OptionDefaultValueProtocol {
            let minValue = 1
            let maxValue = 1024
            let defaultValue = 100
        }
        
        // Protocol required values
        typealias ValueType = Int
        
        let type = OptionType.spin(ValueType.self)
        let name = "NalimovCache"
        let defaults = Defaults()
        
        var value: ValueType? = nil
        
        internal func isValid(_ newValue: ValueType) -> Bool {
            return newValue <= defaults.maxValue && newValue >= defaults.maxValue
        }
        
        mutating func setValue(_ newValue: ValueType?) -> Bool {
            if let newValue = newValue {
                if isValid(newValue) {
                    value = newValue
                    return true
                }
                return false
            } else {
                value = defaults.defaultValue
                return true
            }
        }
        //
    }
    
    fileprivate struct MultiPV: Option {
        
        // Values specific to the option type are contained here
        struct Defaults: SpinOptionProtocol, OptionDefaultValueProtocol {
            let minValue = 1
            let maxValue = 100
            let defaultValue = 1
        }
        
        // Protocol required values
        typealias ValueType = Int
        
        let type = OptionType.spin(ValueType.self)
        let name = "MultiPV"
        let defaults = Defaults()
        
        var value: ValueType? = nil
        
        internal func isValid(_ newValue: ValueType) -> Bool {
            return newValue <= defaults.maxValue && newValue >= defaults.maxValue
        }
        
        mutating func setValue(_ newValue: ValueType?) -> Bool {
            if let newValue = newValue {
                if isValid(newValue) {
                    value = newValue
                    return true
                }
                return false
            } else {
                value = defaults.defaultValue
                return true
            }
        }
        //
    }
    
    fileprivate struct UCIElo: Option {
        
        // Values specific to the option type are contained here
        struct Defaults: SpinOptionProtocol, OptionDefaultValueProtocol {
            let minValue = 1
            let maxValue = 3000
            let defaultValue = 1500
        }
        
        // Protocol required values
        typealias ValueType = Int
        
        let type = OptionType.spin(ValueType.self)
        let name = "MultiPV"
        let defaults = Defaults()
        
        var value: ValueType? = nil
        
        internal func isValid(_ newValue: ValueType) -> Bool {
            return newValue <= defaults.maxValue && newValue >= defaults.maxValue
        }
        
        mutating func setValue(_ newValue: ValueType?) -> Bool {
            if let newValue = newValue {
                if isValid(newValue) {
                    value = newValue
                    return true
                }
                return false
            } else {
                value = defaults.defaultValue
                return true
            }
        }
        //
    }
    
    //
    // Combo options
    //
    fileprivate struct Aggressiveness: Option {
        
        // Values specific to the option type are contained here
        struct Defaults: ComboOptionProtocol, OptionDefaultValueProtocol {
            let possibleValues: [String] = [
                "Conservative",
                "Neutral",
                "Aggresive"
            ]
            let defaultValue = "Neutral"
        }
        
        // Protocol required values
        typealias ValueType = String
        
        let type = OptionType.combo(ValueType.self)
        let name = "Aggressiveness"
        let defaults = Defaults()
        
        var value: ValueType? = nil
        
        internal func isValid(_ newValue: ValueType) -> Bool {
            return defaults.possibleValues.contains(where: { $0.lowercased() == newValue.lowercased() })
        }
        
        mutating func setValue(_ newValue: ValueType?) -> Bool {
            if let newValue = newValue {
                if isValid(newValue) {
                    value = newValue
                    return true
                }
                return false
            } else {
                value = defaults.defaultValue
                return true
            }
        }
        //
    }
    
    //
    // Button options
    //
    
    
    //
    // String options
    //
    fileprivate struct UCIOpponent: Option {
        
        // Values specific to the option type are contained here
        struct Defaults: ComboOptionProtocol, OptionDefaultValueProtocol {
            let possibleValues: [String] = [
            ]
            let defaultValue = "None"
        }
        
        // Protocol required values
        typealias ValueType = String
        
        let type = OptionType.string(ValueType.self)
        let name = "UCIOpponent"
        let defaults = Defaults()
        
        var value: ValueType? = nil
        
        internal func isValid(_ newValue: ValueType) -> Bool {
            return defaults.possibleValues.contains(where: { $0.lowercased() == newValue.lowercased() })
        }
        
        mutating func setValue(_ newValue: ValueType?) -> Bool {
            if let newValue = newValue {
                if isValid(newValue) {
                    value = newValue
                    return true
                }
                return false
            } else {
                value = defaults.defaultValue
                return true
            }
        }
        //
    }
}
