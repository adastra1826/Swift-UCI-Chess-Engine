//
//  Settings.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/8/24.
//

import Foundation

class Settings {
    
    let lock: NSLock
    let engine: _Engine
    
    init() {
        lock = NSLock()
        engine = _Engine()
    }
    
    class _Engine {
        
        //let options: MasterOptionsValidation
        
        private let queue: DispatchQueue
        private var maxNumberSearchThreads: Int
        
        init() {
            //options = MasterOptionsValidation()
            queue = DispatchQueue(label: "com.peerlessApps.chess.settings_EngineQueue")
            maxNumberSearchThreads = DefaultEngineSettings.maxNumberSearchThreads
        }
        
        struct DefaultEngineSettings {
            static let maxNumberSearchThreads = 3
        }
        
        func getMaxThreads() -> Int {
            queue.sync {
                return maxNumberSearchThreads
            }
        }
        
    }
}
