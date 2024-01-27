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
    
    // Bitboard gameboard edge masks
    // 0s on the leftmost column
    private static let fileAMask: UInt64 = 0x7f7f7f7f7f7f7f7f
    // 0s on the rightmost column
    private static let fileHMask: UInt64 = 0xfefefefefefefefe
    // 0s on the top row
    private static let rank8Mask: UInt64 = 0xFFFFFFFFFFFFFF
    // 0s on the bottom row
    private static let rank1Mask: UInt64 = 0xFFFFFFFFFFFFFF00
    //Full edge mask
    static let EDGEMASK = ~fileAMask | ~fileHMask | ~rank1Mask | ~rank8Mask
    // Used to isolate the last 4 bits of the BITSHIFT enum values by ANDing, resulting in the correct integer value of the bit shift
    static let UINT8LAST4BMASK: UInt8 = 0b00001111
    
    enum BITSHIFT {
        
        // Left << bit shift
        case NW
        case N
        case NE
        case E
        // Right >> bit shift
        case SE
        case S
        case SW
        case W
        
        // Using 8 bit unsigned integers to encode relevant bit shift data
        //          1   2 3
        // Binary: |000|1|1001|
        // Section 1: not used
        // Section 2: bit shift right = 1, left = 0
        // Section 3: bit shift amount ranging from 1-9
        
        // Left 9
        static let NWShift: UInt8 = 0b00001001
        // Left 8
        static let NShift: UInt8 = 0b00001000
        // Left 7
        static let NEShift: UInt8 = 0b00000111
        // Left 1
        static let EShift: UInt8 = 0b00000001
        // Right 9
        static let SEShift: UInt8 = 0b00011001
        // Right 8
        static let SShift: UInt8 = 0b00011000
        // Right 7
        static let SWShift: UInt8 = 0b00010111
        // Right 1
        static let WShift: UInt8 = 0b00010001
        
        var SHIFT: UInt8 {
            switch self {
            case .NW:
                return BITSHIFT.NWShift
            case .N:
                return BITSHIFT.NShift
            case .NE:
                return BITSHIFT.NEShift
            case .E:
                return BITSHIFT.EShift
            case .SE:
                return BITSHIFT.SEShift
            case .S:
                return BITSHIFT.SShift
            case .SW:
                return BITSHIFT.SWShift
            case .W:
                return BITSHIFT.WShift
            }
        }
    }
}
