//
//  BitBoardsUtilities.swift
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

func hexStringToUInt64(_ hex: String) -> UInt64? {
    if let decimalValue = UInt64(hex, radix: 16) {
        return decimalValue
    }
    return nil
}

func binaryStringToUInt64(_ binary: String) -> UInt64? {
    if let decimalValue = UInt64(binary, radix: 2) {
        return decimalValue
    }
    return nil
}

// Print a UInt64 value in 8x8 chunks
func printBBoard(_ value: UInt64) {
    print(getStrInterpolatedBBoard(value))
    print()
}

func getStrInterpolatedBBoard(_ value: UInt64) -> String {
    let uInt64String = strConvertFromUInt64(value)
    let splitString = splitStringIntoChunks(ofLength: 8, from: uInt64String)
    let interpolatedString = splitString.joined(separator: "\n")
    return interpolatedString
}

func strConvertFromUInt64(_ value: UInt64) -> String {
    let leadingZeroes = Array(repeating: "0", count: value.leadingZeroBitCount).joined()
    let binaryString = String(value, radix: 2)
    let fullString = leadingZeroes + binaryString
    let uInt64String = String(fullString.suffix(64))
    return uInt64String
}

// For use specifically with 64 bit integers, split the string binary value into 8 bit chunks for printing
fileprivate func splitStringIntoChunks(ofLength chunkLength: Int, from inputString: String) -> [String] {
    var result: [String] = []
    for i in stride(from: 0, to: inputString.count, by: chunkLength) {
        let startIndex = inputString.index(inputString.startIndex, offsetBy: i)
        let endIndex = inputString.index(startIndex, offsetBy: chunkLength, limitedBy: inputString.endIndex) ?? inputString.endIndex
        let chunk = String(inputString[startIndex..<endIndex])
        result.append(chunk)
    }
    return result
}
