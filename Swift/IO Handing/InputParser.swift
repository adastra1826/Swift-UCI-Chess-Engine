//
//  InputParser.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/13/24.
//

import Foundation

class InputParser {
    
    init() {
    }
    
    func parse(_ rawInput: String) {
        
        log.info("\(rawInput)")
        
        // Sanitize input, ensure non-empty
        if let sanitizedInput = sanitizeInput(rawInput) {
            let topLevelCommand = TopLevelCommand(sanitizedInput)
            let arguments = Array(sanitizedInput.suffix(from: 1))
            master.commandEngine(topLevelCommand, arguments)
        } else {
            log.debug("Empty command")
        }
    }
    
    // Lowercase and split input by spaces
    func sanitizeInput(_ rawInput: String) -> [String]? {
        let lowercased = rawInput.lowercased()
        let components = lowercased.components(separatedBy: " ")
        guard components.first != "" else { return nil }
        return components
    }
}
