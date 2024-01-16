//
//  OutputWrapper.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/16/24.
//

import Foundation

// Buffer allocator for passing text from C++ to Swift
// C++ writes output to the buffer provided by Swift
// Swift casts the resulting text to a String
class C__stdout_OutputWrapper {
    
    /*
    private var bufferSize: Int
    private var buffer: UnsafeMutablePointer<CChar>

    init(_ bufferSize: Int) {
        self.bufferSize = bufferSize
        self.buffer = UnsafeMutablePointer<CChar>.allocate(capacity: bufferSize)
    }

    deinit {
        self.buffer.deallocate()
    }

    func outputString() -> String {
        
        // Call C++ input listening function
        get_input(buffer, Int32(bufferSize))
        
        // Copy input result from allocated memory into a String
        let result = String(cString: buffer)
        
        return result
    }
     */
    
    
}

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
