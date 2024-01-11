//
//  Protocol.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/10/24.
//

import Foundation

// Validate top level commands
enum TopLevelEngineCommandValidation {
    
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
            if let bool = Bool(input) {
                return IsValidFlag(true)
            }
            return IsValidFlag(false)
        }
    }

    struct OwnBook: CheckOption_enum {
        let type = OptionTypes_enum.check
        let defaultValue = false
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            if let bool = Bool(input) {
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
            if let bool = Bool(input) {
                return IsValidFlag(true)
            }
            return IsValidFlag(false)
        }
    }

    struct UCIShowRefutations: CheckOption_enum {
        let type = OptionTypes_enum.check
        let defaultValue = false
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            if let bool = Bool(input) {
                return IsValidFlag(true)
            }
            return IsValidFlag(false)
        }
    }

    struct UCILimitStrength: CheckOption_enum {
        let type = OptionTypes_enum.check
        let defaultValue = false
        
        func isValidSetting(_ input: String) -> IsValidFlag {
            if let bool = Bool(input) {
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
            if let bool = Bool(input) {
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
            if let bool = Bool(input) {
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
