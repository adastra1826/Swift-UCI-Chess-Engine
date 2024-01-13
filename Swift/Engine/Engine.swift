//
//  Engine.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/8/24.
//

import Foundation

class Engine {
    
    // Max number of concurrent searching threads
    private let searchThreadPermits: DispatchSemaphore
    
    // Stop calculating ASAP
    private let stopCondition: NSCondition
    
    lazy var commandDispatchMap: [TopLevelCommand: () -> Void] = [
        .uci: uciCommand,
        .isready: isReadyCommand,
        .ucinewgame: uciNewGameCommand,
        .stop: stopCommand,
        .ponderhit: ponderHitCommand
    ]
    
    init() {
        
        searchThreadPermits = DispatchSemaphore(value: settings.engine.getMaxThreads())
        
        stopCondition = NSCondition()
    }
    
    func start() {
        fakeStart()
    }
    
    func fakeStart() {
        
        log.send(.info, "Start engine")
        
        var count = 0
        
        while !sharedData.safeMirrorMasterQuit() {
            
            /*
            if global.safeMirrorMasterQuit() {
                print("Break from Engine")
                break
            }
             */
            
            count += 1
            print(count)
            
            Thread.sleep(forTimeInterval: 1.0)
            
            if count % 5 == 0 {
            }
        }
        
        log.send(.info, "Stop engine")
    }
    
    func commandNoArgs(_ command: TopLevelCommand) {
        log.send(.verbose, array: ["commandNoArgs(_ command: TopLevelCommand)", "command: \(command)"])
        if let commandFunc = commandDispatchMap[command] {
            commandFunc()
        }
    }
    
    func uciCommand() {
        log.send(.verbose, "uciCommand()")
    }
    
    func isReadyCommand() {
        log.send(.verbose, "isReadyCommand()")
    }
    
    func uciNewGameCommand() {
        log.send(.verbose, "uciNewGameCommand()")
    }
    
    func stopCommand() {
        log.send(.verbose, "stopCommand()")
    }
    
    func ponderHitCommand() {
        log.send(.verbose, "ponderHitCommand()")
    }
    
}
