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
        
        quitCondition = sharedData.masterQuitCondition
        quitSwitch = sharedData.masterQuitSwitch
    }
    
    func parseEnumeratedInput2(_ input: TopLevelEngineCommandValidation) {
        
        var output: [String] = []
        
        switch input {
        case .uci:
            output.append("id name AstralProjection")
            output.append("id author Nicholas Doherty")
            output.append("uciok")
        case .debug:
            output.append("debug")
        case .isready:
            output.append("readyok")
        case .setoption:
            output.append("setoption")
        case .register:
            output.append("register")
        case .ucinewgame:
            output.append("ucinewgame")
        case .position:
            output.append("position")
        case .go:
            quitCondition.lock()
            quitCondition.signal()
            quitCondition.unlock()
            output.append("go")
        case .stop:
            output.append("stop")
        case .ponderhit:
            output.append("ponderhit")
        case .quit:
            sharedData.safeKillAll()
            output.append("quit")
        default:
            output.append("Unknown command")
        }
        
        log.send(output, LogLevel.info)
    }
}
