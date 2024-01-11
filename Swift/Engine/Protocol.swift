//
//  Protocol.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/8/24.
//

/*
import Foundation

enum Input {
    
    case uci
    case debug(DebugCommand)
    case isready
    case setoption_name(SetOptionCommand)
    case register
    case ucinewgame
    case position//
    case go//
    case stop
    case ponderhit
    case quit
    case unknown
    case known //testing purposes
    
    init(_ rawValue: String) {
        
        // Process input into lowercase and split by spaces
        let rawValue = rawValue.lowercased()
        let components = rawValue.components(separatedBy: " ")
        let terms = components.count
        let multipleTerms = Bool(terms > 1)
        
        // Empty input
        guard let command = components.first else {
            self = .unknown
            return
        }
        
        switch command {
        case "uci":
            self = .uci
        case "debug":
            if terms == 2 {
                let debugAction = DebugCommand(components[1])
                if debugAction != .unknown {
                    self = .debug(debugAction)
                } else {
                    self = .unknown
                }
            } else {
                self = .unknown
            }
        case "isready":
            self = .isready
        case "setoption":
            let optionAction = SetOptionCommand(command)
            print(optionAction)
            // SetOptionCommand(name: Chess_Engine_UCI.OptionNames.unknown(nil), value: nil)
            if multipleTerms {
                let optionAction = SetOptionCommand(command)
                self = .known
            } else {
                self = .unknown
            }
        case "register":
            self = .register
        case "ucinewgame":
            self = .ucinewgame
        case "position":
            if multipleTerms {
                //do stuff
                self = .unknown
            } else {
                self = .unknown
            }
        case "go":
            if multipleTerms {
                //do stuff
                self = .unknown
            } else {
                //do stuff
                self = .unknown
            }
        case "stop":
            self = .stop
        case "ponderhit":
            self = .ponderhit
        case "quit":
            self = .quit
        default:
            self = .unknown
        }
    }
}

enum ValidatedSettings {
    
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

enum DebugCommand {
    
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
extension Input {
    init(_ setOptionCommand: SetOptionCommand) {
        self = .setoption_name(setOptionCommand)
    }
}
 */

struct SetOptionCommands {
    
    let name: SetOptionCommand
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
        
        name = SetOptionCommand(fullOptionName)
        
        
        value = fullSettingName
        
        
    }
}

enum SetOptionCommand {
    
    // Default
    case hash
    case nalimovPath
    case nalimovCache
    case ponder
    case ownbook
    case multiPV
    case uci_showCurrLine
    case uci_showRefutations
    case uci_limitStrength
    case uci_elo
    case uci_analyseMode
    case uci_opponent
    
    // Custom
    case aggressiveness
    
    // Default
    case unknown
    
    init(_ rawValue: String, _ optionSetting: String? = nil) {
        
        var isValidSetting: ValidatedSettings? = nil

        switch rawValue {
            
        // Default
        case "hash":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings.Hash().isValidSetting(optionSetting)
            }
            self = .hash
            
        case "nalimovPath":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings.NalimovPath().isValidSetting(optionSetting)
            }
            self = .nalimovPath(isValidSetting)
            
        case "nalimovCache":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings.NalimovCache().isValidSetting(optionSetting)
            }
            self = .nalimovCache(isValidSetting)
            
        case "ponder":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings.Ponder().isValidSetting(optionSetting)
            }
            self = .ponder(isValidSetting)
            
        case "ownbook":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings.OwnBook().isValidSetting(optionSetting)
            }
            self = .ownbook(isValidSetting)
            
        case "multiPV":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings.MultiPV().isValidSetting(optionSetting)
            }
            self = .multiPV(isValidSetting)
            
        case "uci_showCurrLine":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings.UCIShowCurrLine().isValidSetting(optionSetting)
            }
            self = .uci_showCurrLine(isValidSetting)
            
        case "uci_showRefutations":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings.UCIShowRefutations().isValidSetting(optionSetting)
            }
            self = .uci_showRefutations(isValidSetting)
            
        case "uci_limitStrength":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings.UCILimitStrength().isValidSetting(optionSetting)
            }
            self = .uci_limitStrength(isValidSetting)
            
        case "uci_elo":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings.UCIElo().isValidSetting(optionSetting)
            }
            self = .uci_elo(isValidSetting)
            
        case "uci_analyseMode":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings.UCIAnalyseMode().isValidSetting(optionSetting)
            }
            self = .uci_analyseMode(isValidSetting)
            
        case "uci_opponent":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings.UCIOpponent().isValidSetting(optionSetting)
            }
            self = .uci_opponent(isValidSetting)
        
        // Custom
        case "aggressiveness":
            if let optionSetting = optionSetting {
                isValidSetting = OptionSettings.Hash().isValidSetting(optionSetting)
            }
            self = .aggressiveness(isValidSetting)
        
        // Unknown
        default:
            self = .unknown(isValidSetting)
        }
    }
}

enum SetOptionCommandParameter {
    
}

struct OptionSettings {

    // Default options
    struct Hash: Option, SpinOption {
        let name = "hash"
        let type = OptionTypes.spin
        let defaultValue = 1000
        let min = 100
        let max = 10000
        
        func isValidSetting(_ input: String) -> ValidatedSettings {
            if let int = Int(input), int >= min, int <= max {
                return ValidatedSettings(true)
            }
            return ValidatedSettings(false)
        }
    }

    struct NalimovPath: StringOption {
        let type = OptionTypes.string
        let defaultValue = ""
        
        func isValidSetting(_ input: String) -> ValidatedSettings {
            //fix later
            return ValidatedSettings(true)
        }
    }

    struct NalimovCache: SpinOption {
        let type = OptionTypes.spin
        let defaultValue = 64
        let min = 1
        let max = 1024
        
        func isValidSetting(_ input: String) -> ValidatedSettings {
            if let int = Int(input), int >= min, int <= max {
                return ValidatedSettings(true)
            }
            return ValidatedSettings(false)
        }
    }

    struct Ponder: CheckOption {
        let type = OptionTypes.check
        let defaultValue = true
        
        func isValidSetting(_ input: String) -> ValidatedSettings {
            if Bool(input) != nil {
                return ValidatedSettings(true)
            }
            return ValidatedSettings(false)
        }
    }

    struct OwnBook: CheckOption {
        let type = OptionTypes.check
        let defaultValue = false
        
        func isValidSetting(_ input: String) -> ValidatedSettings {
            if Bool(input) != nil {
                return ValidatedSettings(true)
            }
            return ValidatedSettings(false)
        }
    }

    struct MultiPV: SpinOption {
        let type = OptionTypes.spin
        let defaultValue = 1
        let min = 1
        let max = 100
        
        func isValidSetting(_ input: String) -> ValidatedSettings {
            if let int = Int(input), int >= min, int <= max {
                return ValidatedSettings(true)
            }
            return ValidatedSettings(false)
        }
    }

    struct UCIShowCurrLine: CheckOption {
        let type = OptionTypes.check
        let defaultValue = false
        
        func isValidSetting(_ input: String) -> ValidatedSettings {
            if Bool(input) != nil {
                return ValidatedSettings(true)
            }
            return ValidatedSettings(false)
        }
    }

    struct UCIShowRefutations: CheckOption {
        let type = OptionTypes.check
        let defaultValue = false
        
        func isValidSetting(_ input: String) -> ValidatedSettings {
            if Bool(input) != nil {
                return ValidatedSettings(true)
            }
            return ValidatedSettings(false)
        }
    }

    struct UCILimitStrength: CheckOption {
        let type = OptionTypes.check
        let defaultValue = false
        
        func isValidSetting(_ input: String) -> ValidatedSettings {
            if Bool(input) != nil {
                return ValidatedSettings(true)
            }
            return ValidatedSettings(false)
        }
    }

    struct UCIElo: SpinOption {
        let type = OptionTypes.spin
        let defaultValue = 2600
        let min = 1
        let max = 3000
        
        func isValidSetting(_ input: String) -> ValidatedSettings {
            if let int = Int(input), int >= min, int <= max {
                return ValidatedSettings(true)
            }
            return ValidatedSettings(false)
        }
    }

    struct UCIAnalyseMode: CheckOption {
        let type = OptionTypes.check
        let defaultValue = false
        
        func isValidSetting(_ input: String) -> ValidatedSettings {
            if Bool(input) != nil {
                return ValidatedSettings(true)
            }
            return ValidatedSettings(false)
        }
    }

    struct UCIOpponent: StringOption {
        let type = OptionTypes.string
        let defaultValue = ""
        
        func isValidSetting(_ input: String) -> ValidatedSettings {
            //fix later
            return ValidatedSettings(true)
        }
    }

    struct Unknown: CheckOption {
        let type = OptionTypes.check
        let defaultValue = false
        
        func isValidSetting(_ input: String) -> ValidatedSettings {
            if Bool(input) != nil {
                return ValidatedSettings(true)
            }
            return ValidatedSettings(false)
        }
    }
    
    // Custom values
    struct Aggressiveness: ComboOption {
        
        let type = OptionTypes.combo
        let options = [
            "conservative",
            "neutral",
            "aggressive"
        ]
        let defaultValue = "neutral"
        
        func isValidSetting(_ input: String) -> ValidatedSettings {
            if options.contains(where: {$0 == input }) {
                return ValidatedSettings(true)
            }
            return ValidatedSettings(false)
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
    
    init(_ rawValue: String) {
        
        switch rawValue.lowercased() {
        default:
            self = .unknown
        }
        
    }
}

protocol Option {
    var name: String { get }
}

protocol CheckOption {
    var type: OptionTypes { get }
    //var value: Bool { get }
    var defaultValue: Bool { get }
    func isValidSetting(_ input: String) -> ValidatedSettings
}

protocol SpinOption {
    var type: OptionTypes { get }
    //var value: Int { get }
    var defaultValue: Int { get }
    var min: Int { get }
    var max: Int { get }
    func isValidSetting(_ input: String) -> ValidatedSettings
}

protocol ComboOption {
    var type: OptionTypes { get }
    var defaultValue: String { get }
    // options denoted by "var" when printing
    var options: [String] { get }
    func isValidSetting(_ input: String) -> ValidatedSettings
}

protocol ButtonOption {
    var type: OptionTypes { get }
    //func isValidSetting(_ value: String) -> Bool
    //closure?
}

protocol StringOption {
    var type: OptionTypes { get }
    var defaultValue: String { get }
    func isValidSetting(_ input: String) -> ValidatedSettings
}

enum GoOptions {
    
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
*/
