//
//  Magic Variables.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/18/24.
//

import Foundation

// Static magic variables
struct M {
    
    // Game
    static let ROWS: Int = 8
    static let COLS: Int = 8
    /*
     --------------------------------------------------------
     ---------------------- ROWS ARE X ----------------------
     ---------------------- COLS ARE Y ----------------------
     --------------------------------------------------------
     */
    
    // Team
    static let WHITE: Int = 1
    static let BLACK: Int = -1
    
    static let WHITE_S: String = "White"
    static let BLACK_S: String = "Black"
    
    static func getTeamInitial(_ teamID: Int, isUppercase uppercase: Bool = true) -> String {
        
        var newInitial: String
        
        switch teamID {
        case WHITE:
            newInitial = String(WHITE_S.first!).uppercased()
        case BLACK:
            newInitial = String(BLACK_S.first!).uppercased()
        default:
            newInitial = "?"
            print("Invalid request for pieceInitial with piece number \(teamID)")
        }
        
        return uppercase ? newInitial : newInitial.lowercased()
    }
    
    // Piece Type ID
    static let KING: Int = 6
    static let QUEEN: Int = 5
    static let BISHOP: Int = 4
    static let KNIGHT: Int = 3
    static let ROOK: Int = 2
    static let PAWN: Int = 1
    
    static let KING_S: String = "King"
    static let QUEEN_S: String = "Queen"
    static let BISHOP_S: String = "Bishop"
    static let KNIGHT_S: String = "Knight"
    static let ROOK_S: String = "Rook"
    static let PAWN_S: String = "Pawn"
    
    static let KNIGHT_S_I: String = "N"
    
    static func getPieceInitial(_ pieceID: Int, isUppercase uppercase: Bool = true) -> String {
        
        var newInitial: String
        
        switch pieceID {
        case KING:
            newInitial = String(KING_S.first!).uppercased()
        case QUEEN:
            newInitial = String(QUEEN_S.first!).uppercased()
        case BISHOP:
            newInitial = String(BISHOP_S.first!).uppercased()
        case KNIGHT:
            newInitial = String(KNIGHT_S_I.first!).uppercased()
        case ROOK:
            newInitial = String(ROOK_S.first!).uppercased()
        case PAWN:
            newInitial = String(PAWN_S.first!).uppercased()
        default:
            newInitial = "?"
            print("Invalid request for pieceInitial with piece number \(pieceID)")
        }
        
        return uppercase ? newInitial : newInitial.lowercased()
    }
    
    // Voided elements
    static let NULL: Int = 0
    static let NULL_S: String = ""
    
    // In cases where a 0 value implies a random calculation should occur
    static let RANDOM: Int = 0
    
    static let HASMOVED: String = "hasMoved"
}
