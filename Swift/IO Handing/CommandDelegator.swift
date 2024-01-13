//
//  InputParser.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/8/24.
//

import Foundation

// Receives sanitized input, delegates commands to their respective classes
class CommandDelegator {
    
    private var quitSwitch: Bool
    
    init() {
        quitSwitch = sharedData.masterQuitSwitch
    }
    
    func delegateCommand(_ command: TopLevelCommand) {
        
        log.send(.verbose, array: ["delegateCommand(_ command: TopLevelCommand)", "command: \(command)"])
        
        
        switch command {
        case .quit:
            sharedData.safeKillAll()
        case .uci, .isready, .ucinewgame, .stop, .ponderhit:
            engine.commandNoArgs(command)
        case .debug:
            break
        case .setoption:
            break
        case .register:
            break
        case .go:
            break
        default:
            break
        }
    }
}
