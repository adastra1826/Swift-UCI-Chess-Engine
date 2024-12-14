//
//  Engine.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/8/24.
//

import Foundation

class Engine {
    
    // Temporary variable to be moved later to a method where it can be changed by the user
    private let maxThreads = 3
    
    // Dependency injections
    private let sharedData: SharedData
    
    // Privately initialized variables
    private let outputWrapper: SwiftOutputWrapper
    private var engineOptions: EngineOptions
    private var threadOptions: [ThreadOptions]
    private let phaseControl: PhaseControl
    private let commandDispatch: CommandDispatch
    
    // Max number of concurrent searching threads
    private let searchThreadPermits: DispatchSemaphore
    
    private let updateThreadOptionsQueue: DispatchQueue
    
    // Stop calculating ASAP
    private let stopCondition: NSCondition
    
    init(_ sharedData: SharedData, _ outputWrapper: SwiftOutputWrapper) {
        
        self.sharedData = sharedData
        self.outputWrapper = outputWrapper
        
        self.engineOptions = EngineOptions()
        self.phaseControl = PhaseControl()
        self.commandDispatch = CommandDispatch(outputWrapper)
        
        searchThreadPermits = DispatchSemaphore(value: maxThreads)
        
        updateThreadOptionsQueue = DispatchQueue(label: "com.PeerlessApps.chess.updateThreadOptionsQueue")
        
        stopCondition = NSCondition()
        
        threadOptions = []
    }
    
    func start() {
        
        log.info("Start engine")
        
    }
    
    func command(_ command: TopLevelCommand, _ arguments: [String]) {
        commandDispatch.command(command, arguments)
    }
    
    
    private func generateNewSearchThread() {
        
    }
    
    private func updateThreadOptions() {
        
    }
    
    
}
