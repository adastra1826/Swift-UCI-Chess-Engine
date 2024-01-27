//
//  InitialBoardConditions.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/18/24.
//

import Foundation

struct InitialBoardConditions {
    
    // ----------------------------------------------------------------------------------------------------------------
    private static let bbTileID: [[String]] = [
        ["a8", "b8", "c8", "d8", "e8", "f8", "g8", "h8"],
        ["a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7"],
        ["a6", "b6", "c6", "d6", "e6", "f6", "g6", "h6"],
        ["a5", "b5", "c5", "d5", "e5", "f5", "g5", "h5"],
        ["a4", "b4", "c4", "d4", "e4", "f4", "g4", "h4"],
        ["a3", "b3", "c3", "d3", "e3", "f3", "g3", "h3"],
        ["a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2"],
        ["a1", "b1", "c1", "d1", "e1", "f1", "g1", "h1"]
    ]
    
    // Return entire TileID board
    static func getbbTileID() -> [[String]] {
        return bbTileID
    }
    
    // Return specific TileID
    static func getTileID(_ x: Int, _ y: Int) -> String {
        guard x >= 0 && x < M.ROWS && y >= 0 && y < M.COLS else { return "" }
        return bbTileID[x][y]
    }
    
    // Batch of specfic TileIDs
    static func getTileIDs(_ coords: [[Int]]) -> [String] {
        var IDs: [String] = []
        guard !coords.isEmpty else { return [] }
        for coord in coords {
            IDs.append(getTileID(coord[0], coord[1]))
        }
        return IDs
    }
    
    // ----------------------------------------------------------------------------------------------------------------
    
    private static let bbPieceType: [[Int]] = [
        [M.ROOK, M.KNIGHT, M.BISHOP, M.QUEEN, M.KING, M.BISHOP, M.KNIGHT, M.ROOK],
        [M.PAWN, M.PAWN, M.PAWN, M.PAWN, M.PAWN, M.PAWN, M.PAWN, M.PAWN],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [M.PAWN, M.PAWN, M.PAWN, M.PAWN, M.PAWN, M.PAWN, M.PAWN, M.PAWN],
        [M.ROOK, M.KNIGHT, M.BISHOP, M.QUEEN, M.KING, M.BISHOP, M.KNIGHT, M.ROOK]
    ]
    
    // 1: white, 2: black
    private static let bbTeamType: [[Int]] = [
        [M.BLACK, M.BLACK, M.BLACK, M.BLACK, M.BLACK, M.BLACK, M.BLACK, M.BLACK],
        [M.BLACK, M.BLACK, M.BLACK, M.BLACK, M.BLACK, M.BLACK, M.BLACK, M.BLACK],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [M.WHITE, M.WHITE, M.WHITE, M.WHITE, M.WHITE, M.WHITE, M.WHITE, M.WHITE],
        [M.WHITE, M.WHITE, M.WHITE, M.WHITE, M.WHITE, M.WHITE, M.WHITE, M.WHITE]
    ]
    
    // Returns normal or inverted arrays of InititalGame state depending on player color
    private static func getbbPieceType(_ playerTeam: Int) -> [[Int]] {
        if playerTeam == M.WHITE { return bbPieceType }
        return invert2DArray(bbPieceType)
    }
    
    private static func getbbTeamType(_ playerTeam: Int) -> [[Int]] {
        if playerTeam == M.WHITE { return bbTeamType }
        return invert2DArray(bbTeamType)
    }
    
    static func getbbPieceAndTeam(_ playerTeam: Int) -> [[Int]] {
        
        let bbTeamType = getbbTeamType(playerTeam)
        let bbPieceType = getbbPieceType(playerTeam)
        var bbPieceAndTeam: [[Int]] = []
        
        for (teamRow, pieceRow) in zip(bbTeamType, bbPieceType) {
            let newRow = zip(teamRow, pieceRow).map( { $0 * $1 })
            bbPieceAndTeam.append(newRow)
        }
        
        return bbPieceAndTeam
    }
    
    // Return initial bitboard for a specific team piece, as filtered by piece type and team
    static func getPieceBBbyTeam(_ piece: Int, _ team: Int) -> UInt64? {
        
        let filteredArray = zip(bbPieceType, bbTeamType).map { (pieceRow, teamRow) in
            return zip(pieceRow, teamRow).map { (pieceElement, teamElement) in
                if pieceElement == piece && teamElement == team {
                    return "1"
                } else {
                    return "0"
                }
            }
        }
        
        let binaryString = (filteredArray.joined()).joined()
        
        if let bitBoard = binaryStringToUInt64(binaryString) {
            return bitBoard
        }
        
        return nil
    }
    
    // ----------------------------------------------------------------------------------------------------------------
}
