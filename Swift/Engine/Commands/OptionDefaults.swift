//
//  OptionDefaults.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 4/4/24.
//

import Foundation

struct AllOptions {
    
    private var options: [any Option]
    
    init() {
        options = []
    }
    
    private mutating func initOptions() {
        options = [
            OptionDefaults.CheckOption(
                name: "Ponder",
                defaultValue: true
            ),
            OptionDefaults.CheckOption(
                name: "OwnBook",
                defaultValue: false
            ),
            OptionDefaults.CheckOption(
                name: "UCIShowCurrLine",
                defaultValue: false
            ),
            OptionDefaults.CheckOption(
                name: "UCIShowRefutations",
                defaultValue: false
            ),
            OptionDefaults.CheckOption(
                name: "UCILimitStrength",
                defaultValue: false
            ),
            OptionDefaults.CheckOption(
                name: "UCIAnalyzeMode",
                defaultValue: false
            ),
            OptionDefaults.SpinOption(
                name: "Hash",
                defaultValue: 100,
                minValue: 100,
                maxValue: 1000
            ),
            OptionDefaults.SpinOption(
                name: "NalimovCache",
                defaultValue: 100,
                minValue: 1,
                maxValue: 1024
            ),
            OptionDefaults.SpinOption(
                name: "MultiPV",
                defaultValue: 1,
                minValue: 1,
                maxValue: 100
            ),
            OptionDefaults.SpinOption(
                name: "UCIElo",
                defaultValue: 1500,
                minValue: 1,
                maxValue: 3000
            ),
            OptionDefaults.ComboOption(
                name: "Aggressiveness",
                defaultValue: "Neutral",
                possibleValues: [
                    "Conservative",
                    "Neutral",
                    "Aggresive"
                ]
            ),
            OptionDefaults.StringOption(
                name: "UCIOpponent",
                defaultValue: "None"
            )
        ]
    }
    
    func getAllOptions() -> [any Option] {
        return options
    }
}

struct OptionDefaults {
    
    struct CheckOption: CheckOptionProtocol, Option {
        
        typealias ValueType = Bool
        
        let type: OptionType = .check
        
        let name: String
        let defaultValue: Bool
        var value: Bool?
        
        // CheckOptionProtocol
        //
        
        func isValid(_ newValue: Bool) -> Bool {
            return true
        }
        
        mutating func setValue(_ newValue: Bool?) -> Bool {
            if let newValue = newValue {
                if isValid(newValue) {
                    value = newValue
                    return true
                }
                return false
            } else {
                value = defaultValue
                return true
            }
        }
    }

    struct SpinOption: SpinOptionProtocol, Option {
        
        typealias ValueType = Int
        
        let type: OptionType = .spin
        
        let name: String
        let defaultValue: Int
        var value: Int?
        
        // SpinOptionProtocol
        let minValue: Int
        let maxValue: Int
        //
        
        func isValid(_ newValue: Int) -> Bool {
            return newValue >= minValue && newValue <= maxValue
        }
        
        mutating func setValue(_ newValue: Int?) -> Bool {
            if let newValue = newValue {
                if isValid(newValue) {
                    value = newValue
                    return true
                }
                return false
            } else {
                value = defaultValue
                return true
            }
        }
    }

    struct ComboOption: ComboOptionProtocol, Option {
        
        typealias ValueType = String
        
        let type: OptionType = .combo
        
        let name: String
        let defaultValue: String
        var value: String?
        
        // ComboOptionProtocol
        let possibleValues: [String]
        //
        
        func isValid(_ newValue: String) -> Bool {
            return possibleValues.contains(newValue)
        }
        
        mutating func setValue(_ newValue: String?) -> Bool {
            if let newValue = newValue {
                if isValid(newValue) {
                    value = newValue
                    return true
                }
                return false
            } else {
                value = defaultValue
                return true
            }
        }
    }

    struct ButtonOption: ButtonOptionProtocol, Option {
        
        typealias ValueType = Void
        
        let type: OptionType = .button
        
        let name: String
        let defaultValue: Void
        var value: Void?
        
        // ButtonOptionProtocol
        //
        
        func isValid(_ newValue: Void) -> Bool {
            return true
        }
        
        //fix
        mutating func setValue(_ newValue: Void?) -> Bool {
            if let newValue = newValue {
                if isValid(newValue) {
                    value = newValue
                    return true
                }
                return false
            } else {
                value = defaultValue
                return true
            }
        }
    }

    struct StringOption: StringOptionProtocol, Option {
        
        typealias ValueType = String
        
        let type: OptionType = .string
        
        let name: String
        let defaultValue: String
        var value: String?
        
        // StringOptionProtocol
        //
        
        func isValid(_ newValue: String) -> Bool {
            return true
        }
        
        //fix
        mutating func setValue(_ newValue: String?) -> Bool {
            if let newValue = newValue {
                if isValid(newValue) {
                    value = newValue
                    return true
                }
                return false
            } else {
                value = defaultValue
                return true
            }
        }
    }
}
