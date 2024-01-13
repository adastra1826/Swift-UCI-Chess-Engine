//
//  MasterSync.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/10/24.
//

import Foundation

class MasterSynchronizer {
    
    private let ioHandler: IOHandler
    private let engine: Engine
    
    private let masterThreadGroup: DispatchGroup
    
    private let quitCondition: NSCondition
    private var quitSwitch: Bool
    
    init(_ ioHandler: IOHandler, _ engine: Engine) {
        
        self.ioHandler = ioHandler
        self.engine = engine
        
        masterThreadGroup = DispatchGroup()
        
        quitCondition = sharedData.masterQuitCondition
        quitSwitch = sharedData.masterQuitSwitch
    }
    
    public func startAll() {
        
        let ioThread = Thread { [weak self] in
            self?.startIO()
        }
        
        let engineThread = Thread { [weak self] in
            self?.startEngine()
        }
        
        ioThread.start()
        engineThread.start()
        
        // Artificial wait
        while true {
            
            Thread.sleep(forTimeInterval: 0.5)
            log.send(.trace,  ".")
            
            if sharedData.safeMirrorMasterQuit() {
                log.send(.info, "Break from MasterSynchronizer")
                break
            }
        }
        
        
        breakdown()
        
    }
    
    func stopAll() {
        
    }
    
    func startIO() {
        self.ioHandler.start()
    }
    
    func stopIO() {
        
    }
    
    func startEngine() {
        self.engine.start()
    }
    
    func commandEngine() {
        
    }
    
    private func stopEngine() {
    }
    
    func breakdown() {
        log.send(.info, "Breaking things down...")
    }
}
