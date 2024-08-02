//
//  Engine.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/8/24.
//

import Foundation

class Engine {
    
    // Dependency injections
    private let engineParameters: Parameters.Engine
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
    
    init(_ engineParameters: Parameters.Engine, _ sharedData: SharedData, _ outputWrapper: SwiftOutputWrapper) {
        
        self.engineParameters = engineParameters
        self.sharedData = sharedData
        self.outputWrapper = outputWrapper
        
        self.engineOptions = EngineOptions()
        self.phaseControl = PhaseControl()
        self.commandDispatch = CommandDispatch()
        
        searchThreadPermits = DispatchSemaphore(value: engineParameters.getMaxThreads())
        
        updateThreadOptionsQueue = DispatchQueue(label: "com.PeerlessApps.chess.updateThreadOptionsQueue")
        
        stopCondition = NSCondition()
        
        threadOptions = []
    }
    
    func start() {
        
        log.info("Start engine")
        
    }
    
    
    private func generateNewSearchThread() {
        
    }
    
    private func updateThreadOptions() {
        
    }
    
    
}
