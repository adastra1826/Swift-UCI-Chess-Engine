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
class C__stdin_InputWrapper {
    
    private var bufferSize: Int
    private var buffer: UnsafeMutablePointer<CChar>

    init(_ bufferSize: Int) {
        self.bufferSize = bufferSize
        self.buffer = UnsafeMutablePointer<CChar>.allocate(capacity: bufferSize)
    }

    deinit {
        self.buffer.deallocate()
    }

    func getString() -> String {
        
        // Call C++ input listening function
        get_input(buffer, Int32(bufferSize))
        
        // Copy input result from allocated memory into a String
        let result = String(cString: buffer)
        
        return result
    }
}

class SwiftInputWrapper {
    
    let cInputWrapper: C__stdin_InputWrapper
    let inputParser: InputParser
    
    init() {
        cInputWrapper = C__stdin_InputWrapper(50)
        inputParser = InputParser()
    }
    
    func start() {
        
        log.info("Start SwiftInputWrapper")
        
        while true {
            // Collect raw input from C++ std::in
            let rawInput = cInputWrapper.getString()
            
            inputParser.parse(rawInput)
            
            if sharedData.safeMirrorMasterQuit() {
                log.info("End SwiftInputWrapper: master quit")
                break
            }
        }
    }
}
