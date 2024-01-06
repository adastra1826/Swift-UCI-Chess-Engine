//
//  main.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/6/24.
//

import Foundation

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
        get_input(buffer, Int32(bufferSize))
        let result = String(cString: buffer)
        return result
    }
}

class IOHandler {
    
    let cInputWrapper: CInputWrapper
    let inputParser: InputParser
    var finalInput: String
    
    init() {
        cInputWrapper = CInputWrapper(50)
        inputParser = InputParser()
        finalInput = ""
    }
    
    func start() {
        while inputParser.continueLooping {
            finalInput = cInputWrapper.getString()
            inputParser.parseInput(finalInput)
        }
    }

}

class InputParser {
    
    var continueLooping: Bool
    
    init() {
        continueLooping = true
    }
    
    func parseInput(_ input: String) {
        
        var output: [String] = []
        
        switch input {
        case "uci":
            output.append("id name AstralProjection")
            output.append("id author Nicholas Doherty")
            output.append("uciok")
        case "isready":
            // Check if the engine is ready
            output.append("readyok")
        case "go":
            // Example: parsing the "go" command
            // In a real engine, you would start searching for the best move here
            output.append("bestmove e2e4")
        case "quit":
            continueLooping = false
            break
        default:
            output.append("Unknown command: \(input)")
            break
        }
        
        outputStrings(output)
    }
    
    func outputStrings(_ output: [String]) {
        for string in output {
            output_string(string)
        }
    }
}

let ioHandler = IOHandler()
ioHandler.start()
