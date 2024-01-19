//
//  BitBoard Manipulation.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/19/24.
//

import Foundation

func combineBitBoards(_ boards: [UInt64]) -> UInt64 {
    var result: UInt64 = 0
    for board in boards {
        result = result | board
    }
    return result
}
