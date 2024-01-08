//
//  IOHandler.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/8/24.
//

import Foundation

// Buffer allocator for passing text from C++ to Swift
// C++ writes output to the buffer provided by Swift
// Swift casts the resulting text to a String
class CInputWrapper {
    
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

class IOHandler {
    
    let cInputWrapper: CInputWrapper
    let inputParser: InputParser
    var finalInput: String
    //var enumeratedInput: Input
    
    init() {
        cInputWrapper = CInputWrapper(50)
        inputParser = InputParser()
        //enumeratedInput = Input()
        finalInput = ""
    }
    
    func start() {
        while inputParser.continueLooping {
            finalInput = cInputWrapper.getString()
            let enumeratedInput = Input(finalInput)
            inputParser.parseEnumeratedInput(enumeratedInput)
            //inputParser.parseRawInput(finalInput)
        }
    }
}
