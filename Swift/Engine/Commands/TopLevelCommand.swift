//
//  TopLevelCommand.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/25/24.
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
    case help
    case quit
    case unknown
    
    init(_ input: [String]) {
        
        log.info("\(input)")
        
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
        case "help":
            self = .help
        case "quit", "q":
            self = .quit
        default:
            self = .unknown
        }
    }
}
