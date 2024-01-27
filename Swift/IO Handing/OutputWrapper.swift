//
//  OutputWrapper.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/16/24.
//

import Foundation

// Receive Strings, queue them to a buffer for Engine output. The buffer is checked 10x/second
class SwiftOutputWrapper {
    
    private let queue: DispatchQueue
    private var buffer: [String]
    
    init() {
        queue = DispatchQueue(label: "com.PeerlessApps.Chess-Engine-UCI.outputBuffer")
        buffer = []
    }
    
    func start() {
        
        log.info("Start SwiftOutputWrapper")
        
        while true {
            
            queue.sync {
                while !buffer.isEmpty {
                    outputString(buffer.removeFirst())
                }
            }
            
            if sharedData.safeMirrorMasterQuit() {
                log.info("End SwiftOutputWrapper: master quit")
                break
            }
            
            Thread.sleep(forTimeInterval: 0.1)
        }
    }
    
    func queue(_ output: String) {
        log.info("\(output)")
        queue.sync {
            buffer.append(output)
        }
    }
    
    private func outputString(_ output: String) {
        let nsOutput = NSString(string: output)
        let cOutput = nsOutput.utf8String
        output_string(cOutput)
    }
}
