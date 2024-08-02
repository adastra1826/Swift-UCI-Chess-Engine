//
//  PhaseControl.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 8/2/24.
//

import Foundation

// Manage the phase of engine operation, as not all commands can be accepted at all times
class PhaseControl {
    
    init() {
        
    }
}

enum PhaseEnum {
    case startup
    case idle
    case search
    case pause
    case stop
    case error
}
