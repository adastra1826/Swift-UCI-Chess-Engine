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
class C__stdinInputWrapper {
    
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
    
    let cInputWrapper: C__stdinInputWrapper
    let commandDelegator: CommandDelegator
    
    private let quitCondition: NSCondition
    private var quitSwitch: Bool
    
    init() {
        cInputWrapper = C__stdinInputWrapper(50)
        commandDelegator = CommandDelegator()
        
        quitCondition = sharedData.masterQuitCondition
        quitSwitch = sharedData.masterQuitSwitch
    }
    
    func start() {
        
        log.send(.info, "Start IO Handler")
        
        while true {
            // Collect raw input from C++ std::in
            let rawInput = cInputWrapper.getString()
            
            // Sanitize input, ensure non-empty
            if let sanitizedInput = sanitizeInput(rawInput) {
                
                let topLevelCommand = TopLevelEngineCommandValidation(sanitizedInput)
                
                if topLevelCommand != .unknown {
                    
                    commandDelegator.parseEnumeratedInput2(topLevelCommand)
                    
                } else {
                    // Ignore command
                }
            }
            
            if sharedData.safeMirrorMasterQuit() {
                log.send(.info, "Break from IO Handler")
                break
            }
            
        }
    }
    
    // Lowercase and split input by spaces
    func sanitizeInput(_ rawInput: String) -> [String]? {
        
        log.send(.verbose, array: ["sanitizeInput", "rawInput: \(rawInput)"])
        
        let lowercased = rawInput.lowercased()
        let components = lowercased.components(separatedBy: " ")
        guard components.first != nil else { return nil }
        return components
    }
}
