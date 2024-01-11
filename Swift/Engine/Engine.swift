//
//  Engine.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/8/24.
//

import Foundation

class Engine {
    
    private let quitCondition: NSCondition
    
    init() {
        quitCondition = sharedData.masterQuitCondition
    }
    
    func start() {
        
        log.send(["Start engine"], .info)
        
        var count = 0
        
        while !sharedData.safeMirrorMasterQuit() {
            
            /*
            if global.safeMirrorMasterQuit() {
                print("Break from Engine")
                break
            }
             */
            
            count += 1
            print(count)
            
            Thread.sleep(forTimeInterval: 1.0)
            
            if count % 5 == 0 {
                quitCondition.lock()
                quitCondition.wait()
                quitCondition.unlock()
            }
        }
        
        log.send(["Stop engine"], .info)
    }
    
}
