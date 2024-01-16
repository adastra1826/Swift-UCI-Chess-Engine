//
//  MasterSync.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/10/24.
//

import Foundation

class MasterSynchronizer {
    
    private let inputWrapper: SwiftInputWrapper
    private let outputWrapper: SwiftOutputWrapper
    private let engine: Engine
    
    private let masterThreadGroup: DispatchGroup
    
    private var quitSwitch: Bool
    
    init() {
        
        self.inputWrapper = SwiftInputWrapper()
        self.outputWrapper = SwiftOutputWrapper()
        self.engine = Engine(outputWrapper)
        
        masterThreadGroup = DispatchGroup()
        
        quitSwitch = sharedData.safeMirrorMasterQuit()
    }
    
    public func startAll() {
        
        let inputThread = Thread { [weak self] in
            self?.startInput()
        }
        
        let outputThread = Thread { [weak self] in
            self?.startOutput()
        }
        
        let engineThread = Thread { [weak self] in
            self?.startEngine()
        }
        
        inputThread.start()
        outputThread.start()
        engineThread.start()
        
        // Artificial wait
        while true {
            
            Thread.sleep(forTimeInterval: 0.5)
            //log.verbose(".")
            
            if sharedData.safeMirrorMasterQuit() {
                log.info("Break from MasterSynchronizer")
                break
            }
        }
        
        
        breakdown()
        
    }
    
    func stopAll() {
        
    }
    
    func startInput() {
        inputWrapper.start()
    }
    
    func startOutput() {
        outputWrapper.start()
    }
    
    func startEngine() {
        engine.start()
    }
    
    func commandEngine(_ command: TopLevelCommand, _ arguments: [String]) {
        
        log.info("\(command): \(arguments)")
        
        switch command {
        case .quit:
            sharedData.safeKillAll()
        case .uci, .isready, .ucinewgame, .stop, .ponderhit:
            engine.commandNoArgs(command)
        case .debug, .setoption, .register, .go:
            engine.commandWithArgs(command, arguments)
        case .unknown:
            log.info("Unknown command")
        default:
            log.warning("Unknown command. You should never see this log.")
        }
    }
    
    private func stopEngine() {
    }
    
    func breakdown() {
        log.info("Breaking things down...")
    }
}
