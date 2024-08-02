//
//  OutputWrapper.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/16/24.
//

import Foundation

// Receive Strings, queue them to a buffer for Engine output. The buffer is checked 10x/second
class SwiftOutputWrapper {
    
    private let _queue: DispatchQueue
    private var _buffer: [String]
    
    private let _outputCondition = NSCondition()
    
    init() {
        _queue = DispatchQueue(label: "com.PeerlessApps.Chess-Engine-UCI.outputBuffer")
        _buffer = []
    }
    
    /*
    func start() {
        
        log.info("Start SwiftOutputWrapper")
        
        while true {
            
            //Busy waiting: The `start()` method contains an infinite loop that continuously checks the buffer and sleeps for a short interval. This approach is known as busy waiting and can be inefficient, especially if the buffer is empty most of the time. It would be better to use a more efficient synchronization mechanism, such as a semaphore or a condition variable, to wait for new items in the buffer instead of constantly polling.
            
            _queue.sync {
                while !_buffer.isEmpty {
                    _outputString(_buffer.removeFirst())
                }
            }
            
            if sharedData.masterQuit() {
                log.info("End SwiftOutputWrapper: master quit")
                break
            }
            
            Thread.sleep(forTimeInterval: 0.1)
        }
    }
    
    func queue(_ output: String) {
        _queue.sync {
            _buffer.append(output)
        }
    }
    */
    
    
    // Model B
    
    // /*
    func start() {
        log.info("Start SwiftOutputWrapper")
        
        _queue.async { // Move the processing logic to a background queue
            while true {
                self._outputCondition.lock()
                
                // Wait on the condition variable until there's data
                while self._buffer.isEmpty && !sharedData.masterQuit() {
                    self._outputCondition.wait()
                }
                
                // If it's a quit signal, end the loop
                if sharedData.masterQuit() {
                    self._outputCondition.unlock()
                    log.info("End SwiftOutputWrapper: master quit")
                    break
                }
                
                // Process data
                while !self._buffer.isEmpty {
                    self._outputString(self._buffer.removeFirst())
                }
                
                self._outputCondition.unlock()
            }
        }
    }
    
    func queue(_ output: String) {
        print("appending output")
        _buffer.append(output)
        print("signalling")
        _outputCondition.signal() // Signal the waiting thread
        print("signalled")
    }
    // */

     
    private func _outputString(_ output: String) {
        let nsOutput = NSString(string: output)
        let cOutput = nsOutput.utf8String
        output_string(cOutput)
        log.info("\(output)")
    }
}
