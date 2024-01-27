//
//  Move Validation.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/19/24.
//

import Foundation

// Create a bitboard representing valid moves in one specified direction
func slidingPieceSingleLineMoveCheckBBoard(bitShift: M.BITSHIFT, piece: UInt64, teamPieces: UInt64, enemyPieces: UInt64) -> UInt64 {
    
    //log.verbose("Sliding piece single line valid move check in \(bitShift) direction")
    let shiftDistance = bitShift.SHIFT & M.UINT8LAST4BMASK
    
    // Running mask used to isolate test bit
    var lineMask = piece
    
    var iterationCount = 1
    
    var finalSquare = false
    while !finalSquare {
        
        //log.verbose("Iteration \(iterationCount)")
        
        var testBit = lineMask
        
        // Shift to new test position from previous position
        var tempLineMask = bitShift.SHIFT >= 16 ? lineMask >> shiftDistance : lineMask << shiftDistance
        
        tempLineMask |= lineMask
        
        // Isolate bit
        testBit ^= tempLineMask
        
        // Mask does not cover same team
        if testBit & teamPieces != 0 {
            //log.verbose("Same team collision, further search stopped")
            break
        }
        
        lineMask = tempLineMask
        
        if testBit & (M.EDGEMASK | enemyPieces) != 0 {
            finalSquare = true
        }
        
        iterationCount += 1
        guard iterationCount <= 7 else {
            log.warning("Potential infinite search stopped.")
            break
        }
    }
    
    // Remove piece from movement mask
    lineMask ^= piece
    
    //tmp
    return lineMask
}

func slidingPieceSingleLineMaskBBoard() {
    
}
