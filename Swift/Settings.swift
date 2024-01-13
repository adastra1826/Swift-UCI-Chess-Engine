//
//  Settings.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/8/24.
//

import Foundation

class Settings {
    
    let lock: NSLock
    let log: _Log
    let engine: _Engine
    
    init() {
        lock = NSLock()
        log = _Log()
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
    
    class _Log {
        
        // Log settings
        private let queue: DispatchQueue
        
        private var cacheData: CacheData
        
        // General debug flag
        private var debug: Bool
        // Override individual settings, log everything
        private var debugAll: Bool
        // Log everything below the highest set level, regardless of lower level individual settings
        private var debugDescending: Bool
        
        init() {
            queue = DispatchQueue(label: "com.peerlessApps.chess.settings_LogQueue")
            
            debug = true
            debugAll = false
            debugDescending = true
            
            cacheData = CacheData()
            cacheData.updateHighest(debugLevelSettings)
        }
        
        struct DefaultLogSettings {
            
        }
        
        var debugLevelSettings: [(LogLevel, Bool)] = [
            // The first 3 should not be changed
            (LogLevel.warning, true),
            (LogLevel.error, true),
            (LogLevel.critical, true),
            // Lowest level, overview of thread calls and terminations
            (LogLevel.info, true),
            // Function calls
            (LogLevel.verbose, true),
            // Log everything the engine does
            (LogLevel.trace, false)
        ]
        
        // Precalculated data
        struct CacheData {
            
            var highestLogLevel = 0
            
            // Precalculate highest log level
            // Must call any time log settings are changed
            mutating func updateHighest(_ levels: [(LogLevel, Bool)]) {
                highestLogLevel = levels.lastIndex(where: { $0.1 == true }) ?? 0
            }
            
            var derivedDebugLevelSettings: [(LogLevel, Bool)] = [
                /*
                // The first 3 should not be changed
                (LogLevel.warning, false),
                (LogLevel.error, false),
                (LogLevel.critical, false),
                // Lowest level, overview of thread calls and terminations
                (LogLevel.info, false),
                // Function calls
                (LogLevel.trace, false),
                // Log everything the engine does
                (LogLevel.verbose, false)
                 */
            ]
            
            mutating func updateDerived(_ debug: Bool, _ debugAll: Bool, _ debugDescending: Bool, _ levels: [(LogLevel, Bool)]) {
                derivedDebugLevelSettings = levels
            }
        }
        
        
        func validateLogPush(_ level: LogLevel) -> Bool {
            queue.sync {
                if !debug { return false }
                if debugAll { return true }
                
                // Lower level than highest set level with descending turned on
                if debugDescending {
                    // Coalesce to range such that the next Bool() statement cannot be true if all settings are set to false
                    let currentLevel = debugLevelSettings.firstIndex(where: { $0.0 == level }) ?? 9
                    return Bool(currentLevel <= cacheData.highestLogLevel)
                }
                
                // Individual level validation
                return debugLevelSettings.first(where: { $0.0 == level })?.1 ?? false
            }
        }
        
        func turnDebugOff() {
            queue.sync {
                debug = false
            }
        }
        
        func turnDebugOn() {
            queue.sync {
                debug = true
            }
        }
    }
}
