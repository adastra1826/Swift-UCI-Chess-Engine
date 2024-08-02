//
//  InputWrapper.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/8/24.
//

import Foundation

// Buffer allocator for passing text from C++ to Swift
// C++ writes output to the buffer provided by Swift
// Swift casts the resulting text to a String
class CppstdinInputWrapper {
    
    private var _bufferSize: Int
    private var _buffer: UnsafeMutablePointer<CChar>

    init(_ bufferSize: Int) {
        self._bufferSize = bufferSize
        self._buffer = UnsafeMutablePointer<CChar>.allocate(capacity: bufferSize)
    }

    deinit {
        self._buffer.deallocate()
    }

    func getString() -> String {
        
        // Call C++ input listening function
        get_input(_buffer, Int32(_bufferSize))
        
        // Copy input result from allocated memory into a String
        let result = String(cString: _buffer)
        
        return result
    }
}

class SwiftInputWrapper {
    
    let cInputWrapper: CppstdinInputWrapper
    let inputParser: InputParser
    
    init() {
        cInputWrapper = CppstdinInputWrapper(50)
        inputParser = InputParser()
    }
    
    func start() {
        
        log.info("Start SwiftInputWrapper")
        
        while true {
            // Collect raw input from C++ std::in
            let rawInput = cInputWrapper.getString()
            
            inputParser.parse(rawInput)
            
            if sharedData.masterQuit() {
                log.info("End SwiftInputWrapper: master quit")
                break
            }
        }
    }
}
