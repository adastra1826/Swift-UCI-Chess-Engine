//
//  Protocol.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/10/24.
//

import Foundation


enum IsValidFlag {
    
    case valid
    case invalid
    
    init(_ bool: Bool) {
        if bool {
            self = .valid
        } else {
            self = .invalid
        }
    }
}

enum DebugOptions_enum {
    
    case on
    case off
    case unknown
    
    init(_ rawValue: String) {
        
        switch rawValue {
        case "on":
            self = .on
        case "off":
            self = .off
        default:
            self = .unknown
        }
    }
}
