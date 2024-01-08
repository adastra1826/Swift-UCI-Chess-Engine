//
//  Engine.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/8/24.
//

import Foundation

class Engine {
    
    func start() {
        
        // Temporary test code to simulate work
        var count = 1
        shouldQuitCondition.lock() // Acquire lock before checking shouldQuit
        
        while !shouldQuit {
            
            print(count)
            count += 1
            
            shouldQuitCondition.unlock()
            Thread.sleep(forTimeInterval: 1.0) // Simulate background work with a delay
            shouldQuitCondition.lock()
            
            if shouldQuit { break }
            
            // Periodically check shouldQuit while holding the lock
            if count % 10 == 0 {
                shouldQuitCondition.wait() // Release lock, wait if shouldQuit is false
            }
        }
        shouldQuitCondition.unlock() // Release lock on exit
        print("Counting thread stopped.")
        threadGroup.leave()
    }
    
}
