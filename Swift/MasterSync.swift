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
        
        quitCondition = global.masterQuitCondition
        quitSwitch = global.masterQuitSwitch
    }
    
    public func startAll() {
        
        let ioThread = Thread { [weak self] in
            self?.startIO()
        }
        
        let engineThread = Thread { [weak self] in
            self?.startEngine()
        }
        
        //masterThreadGroup.enter()
        
        ioThread.start()
        engineThread.start()
        
        //masterThreadGroup.wait()
        
        while true {
            
            Thread.sleep(forTimeInterval: 0.5)
            //print(".")
            
            if global.safeMirrorMasterQuit() {
                print("Break from MasterSynchronizer")
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
        print("Breaking things down...")
    }
}
