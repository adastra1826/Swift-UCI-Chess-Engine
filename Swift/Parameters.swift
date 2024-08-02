//
//  Parameters.swift
//  Chess-Engine-UCI
//
//  Consider modiifying this to reflect static variables that cannot be changed
//
//  Created by Nicholas Doherty on 1/8/24.
//

import Foundation

class Parameters {
    
    let engine: Engine
    
    init() {
        engine = Engine()
        
        log.debug("Settings initialized")
    }
    
    class Engine {
        
        private let engineSettingsQueue: DispatchQueue
        //let threads: Threads
        
        private var maxNumberSearchThreads: Int
        
        init() {
            engineSettingsQueue = DispatchQueue(label: "com.PeerlessApps.chess.engineSettingsQueue")
            //threads = Threads()
            
            maxNumberSearchThreads = DefaultEngineSettings.maxNumberSearchThreads
        }
        
        //class Threads { }
        
        struct DefaultEngineSettings {
            static let maxNumberSearchThreads = 3
        }
        
        func getMaxThreads() -> Int {
            engineSettingsQueue.sync {
                return maxNumberSearchThreads
            }
        }
        
    }
}
