//
//  InputParser.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/8/24.
//

import Foundation

// Receives sanitized input
class CommandDelegator {
    
    public var continueLooping: Bool
    
    private let quitCondition: NSCondition
    private var quitSwitch: Bool
    
    init() {
        
        continueLooping = true
        
        quitCondition = global.masterQuitCondition
        quitSwitch = global.masterQuitSwitch
    }
    /*
    func parseRawInput(_ input: String) {
        
        var output: [String] = []
        
        switch input {
        case "uci":
            output.append("id name AstralProjection")
            output.append("id author Nicholas Doherty")
            output.append("uciok")
        case "isready":
            // Check if the engine is ready
            output.append("readyok")
        case "go":
            // Example: parsing the "go" command
            // In a real engine, you would start searching for the best move here
            output.append("bestmove e2e4")
        case "quit":
            continueLooping = false
            break
        case "q":
            shouldQuitCondition.lock()
            shouldQuit = true
            shouldQuitCondition.signal() // Signal the counting thread to stop
            shouldQuitCondition.unlock()
        case "c":
            shouldQuitCondition.signal()
        default:
            output.append("Unknown command: \(input)")
            break
        }
        
        outputStrings(output)
        
        if shouldQuit { threadGroup.leave() }
    }
    
    func parseEnumeratedInput(_ input: Input) {
        
        var output: [String] = []
        
        switch input {
        case .uci:
            output.append("id name AstralProjection")
            output.append("id author Nicholas Doherty")
            output.append("uciok")
        case .debug(.on):
            output.append("debugging on")
        case .debug(.off):
            output.append("debugging off")
        case .isready:
            // Check if the engine is ready
            output.append("readyok")
        case .go:
            // Example: parsing the "go" command
            // In a real engine, you would start searching for the best move here
            output.append("bestmove e2e4")
        case .quit:
            shouldQuitCondition.lock()
            shouldQuit = true
            shouldQuitCondition.signal() // Signal the counting thread to stop
            shouldQuitCondition.unlock()
        default:
            output.append("Unknown command")
            break
        }
        
        outputStrings(output)
        
        if shouldQuit { threadGroup.leave() }
    }
     */
    
    func parseEnumeratedInput2(_ input: Input_enum) {
        
        var output: [String] = []
        
        switch input {
        case .uci:
            output.append("id name AstralProjection")
            output.append("id author Nicholas Doherty")
            output.append("uciok")
        case .debug(.on):
            output.append("debugging on")
        case .debug(.off):
            output.append("debugging off")
        case .isready:
            // Check if the engine is ready
            output.append("readyok")
        case .setoption_name(.hash(.invalid)):
            output.append("Unknown bool")
            break
        case .go:
            quitCondition.lock()
            quitCondition.signal()
            quitCondition.unlock()
            // Example: parsing the "go" command
            // In a real engine, you would start searching for the best move here
            output.append("bestmove e2e4")
        case .quit:
            global.safeKillAll()
            print("Set quitSwitch to true. Value from global:")
            print(global.masterQuitSwitch)
        default:
            output.append("Unknown command")
            break
        }
        
        outputStrings(output)
    }
    
    func outputStrings(_ output: [String]) {
        for string in output {
            output_string(string)
        }
    }
}
