//
//  InputParser.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/13/24.
//

import Foundation

class InputParser {
    
    let commandDelegator: CommandDelegator
    
    init() {
        commandDelegator = CommandDelegator()
    }
    
    func parse(_ rawInput: String) {
        // Sanitize input, ensure non-empty
        if let sanitizedInput = sanitizeInput(rawInput) {
            let topLevelCommand = TopLevelCommand(sanitizedInput)
            commandDelegator.delegateCommand(topLevelCommand)
        }
    }
    
    // Lowercase and split input by spaces
    func sanitizeInput(_ rawInput: String) -> [String]? {
        
        //log.send(.verbose, array: ["sanitizeInput(_ rawInput: String) -> [String]?", "rawInput: \(rawInput)"])
        
        let lowercased = rawInput.lowercased()
        let components = lowercased.components(separatedBy: " ")
        guard components.first != nil else { return nil }
        return components
    }
}
