//
//  MasterSync.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/10/24.
//

import Foundation

class MasterSynchronizer {
    
    private let ioHandler: SwiftInputWrapper
    private let engine: Engine
    
    private let masterThreadGroup: DispatchGroup
    
    private var quitSwitch: Bool
    
    init(_ ioHandler: SwiftInputWrapper, _ engine: Engine) {
        
        self.ioHandler = ioHandler
        self.engine = engine
        
        masterThreadGroup = DispatchGroup()
        
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
            log.verbose(".")
            
            if sharedData.safeMirrorMasterQuit() {
                log.info("Break from MasterSynchronizer")
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
        log.info("Breaking things down...")
    }
}
