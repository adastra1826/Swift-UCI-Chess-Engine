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
        
        private let queue: DispatchQueue
        private var maxNumberSearchThreads: Int
        
        init() {
            queue = DispatchQueue(label: "com.peerlessApps.chess.settings_EngineQueue")
            maxNumberSearchThreads = DefaultEngineSettings.maxNumberSearchThreads
        }
        
        struct DefaultEngineSettings {
            static let maxNumberSearchThreads = 10
        }
        
        func getMaxThreads() -> Int {
            queue.sync {
                return maxNumberSearchThreads
            }
        }
        
    }
}
