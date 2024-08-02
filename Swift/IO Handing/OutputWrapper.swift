//
//  OutputWrapper.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/16/24.
//

import Foundation

// Receive Strings, queue them to a buffer for Engine output
class SwiftOutputWrapper {
    
    private let outputQueue: DispatchQueue
    private let inputQueue: DispatchQueue
    private var buffer: [String]
    
    private let outputCondition = NSCondition()
    
    init() {
        outputQueue = DispatchQueue(label: "com.PeerlessApps.Chess-Engine-UCI.outputBuffer")
        inputQueue = DispatchQueue(label: "com.PeerlessApps.Chess-Engine-UCI.inputBuffer")
        buffer = []
    }
    
    public func start() {
        log.info("Start SwiftOutputWrapper")
        
        outputQueue.async {
            while true {
                self.outputCondition.lock()
                
                while self.buffer.isEmpty {
                    self.outputCondition.wait()
                }
                
                // Process data
                while !self.buffer.isEmpty {
                    self.outputString(self.buffer.removeFirst())
                }
                
                self.outputCondition.unlock()
            }
        }
    }
    
    public func queue(_ output: String) {
        inputQueue.sync {
            buffer.append(output)
            outputCondition.signal()
        }
    }
     
    private func outputString(_ output: String) {
        
        // Convert Swift swting to C compatible string
        let nsOutput = NSString(string: output)
        let cOutput = nsOutput.utf8String
        
        // Call C function to output to the console
        output_string(cOutput)
        
        log.info("\(output)")
    }
}
