//
//  SearchThread.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 4/4/24.
//

import Foundation

class SearchThread {
    
    let threadUUID: UUID
    let options: ThreadOptions
    
    init(options: ThreadOptions) {
        self.threadUUID = sharedData.generateNewUUID()
        self.options = options
    }
}
