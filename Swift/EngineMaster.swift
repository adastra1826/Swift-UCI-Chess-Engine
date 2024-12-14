//
//  EngineMaster.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/10/24.
//

import Foundation

class EngineMaster {
    
    // Dependency injections
    private let sharedData: SharedData
    
    // Privately initialized
    private let inputWrapper: SwiftInputWrapper
    private let outputWrapper: SwiftOutputWrapper
    private let engine: Engine
    
    private let masterThreadGroup: DispatchGroup
    
    init(_ sharedData: SharedData) {
        
        self.sharedData = sharedData
        
        self.inputWrapper = SwiftInputWrapper()
        self.outputWrapper = SwiftOutputWrapper()
        self.engine = Engine(sharedData, outputWrapper)
        
        masterThreadGroup = DispatchGroup()
    }
    
    public func start() {
        
        // Initialize default settings
        initDefaultSettings()
        
        // Initialize primary threads
        let inputQueue = DispatchQueue(label: "com.PeerlessApps.EngineMaster.input")
        let outputQueue = DispatchQueue(label: "com.PeerlessApps.EngineMaster.output")
        let engineQueue = DispatchQueue(label: "com.PeerlessApps.EngineMaster.engine")
        
        // Start primary threads
        inputQueue.async(group: masterThreadGroup) { [weak self] in
            self?.inputWrapper.start()
        }
        
        outputQueue.async(group: masterThreadGroup) { [weak self] in
            self?.outputWrapper.start()
        }
        
        engineQueue.async(group: masterThreadGroup) { [weak self] in
            self?.engine.start()
        }
        
        // Wait for the signal to quit the application
        waitForQuit()
        
        // Clean up resources
        breakdown()
    }
    
    private func initDefaultSettings() {
        
    }
    
    // Wait for the master quit switch to be set to true before terminating the main thread, which immediately terminates the program
    private func waitForQuit() {
        while true {
            let result = sharedData.quitSwitchSemaphore.wait(timeout: .now() + 1)
            if result == .success {
                log.info("Master quit set to true, terminating main thread")
                break
            } else {
                log.verbose("Timed out")
            }
        }
    }
    
    func commandEngine(_ command: TopLevelCommand, _ arguments: [String]) {
        
        log.info("\(command): \(arguments)")
        
        switch command {
        case .quit:
            sharedData.safeKillAll()
        case .unknown:
            log.info("Unknown command")
        default:
            engine.command(command, arguments)
        }
    }
    
    private func stopEngine() {
    }
    
    func breakdown() {
        log.info("Breaking things down...")
    }
}
