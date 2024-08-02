//
//  ThreadOptions.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 4/4/24.
//

import Foundation

struct ThreadOptions {
    
    let version: Int
    let options: [any Option]
    
    init(version: Int, options: [any Option]) {
        self.version = version
        self.options = options
    }
    
}
