//
//  Generic Functions.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/18/24.
//

import Foundation

// Custom operator for checking if two integers are both positive or both negative, but not both equal to 0
infix operator +==+: ComparisonPrecedence
func +==+(lhs: Int, rhs: Int) -> Bool {
    return (lhs > 0 && rhs > 0) || (lhs < 0 && rhs < 0)
}

// Completely inverts any 2D array
/*
 Example input:
    Int:
    [[1, 2, 3],
     [2, 3, 4]]
    Output:
    [[4, 3, 2],
     [3, 2, 1]]
 */
func invert2DArray<T>(_ array: [[T]]) -> [[T]] {
    
    guard !array.isEmpty else {
        return []
    }
    
    var invertedArray: [[T]] = []
    
    for row in array.reversed() {
        invertedArray.append(row.reversed())
    }
    
    return invertedArray
}

func print2DArray<T>(_ title: String, _ array: [[T]]) {
    
    guard !array.isEmpty else {
        return
    }
    
    print("Name: \(title): [")
    for foo in array {
        print("\(foo),")
    }
    print("]")
}

// Takes a 2D array of type T, and maps every instance of each element to a dictionary such that the keys are all the unique elements, and the values are 2D arrays containing the coordinate(s) in the original array where the element(s) were found
/*
 Example input:
    Int:
    [[1, 2, 3],
     [2, 3, 4]]
    Output:
    Dictionary:
    1: [[0, 0]]
    2: [[0, 1],
        [1, 0]]
    3: [[0, 2],
        [1, 1]]
    4: [[1, 2]]
 */
func indexUniqueIDsByCoords<T>(_ array: [[T]]) -> Dictionary<T, [[Int]]> {
    
    guard !array.isEmpty else {
        return [:]
    }
    
    var uniqueIDIndexDictionary: Dictionary<T, [[Int]]> = [:]
    
    var allUniqueElements: [T] = []
    
    // Generate array containing one of each unique element
    for row in 0..<array.count {
        let rowUniqueElements = Array(Set(array[row]))
        allUniqueElements.append(contentsOf: rowUniqueElements)
        allUniqueElements = Array(Set(allUniqueElements))
    }
    
    // Fill dictionary with unique key values for each unique element
    for element in allUniqueElements {
        uniqueIDIndexDictionary[element] = []
    }
    
    // Iterate through entire original array to add each element's position as a value on its respective dictionary entry
    for row in 0..<array.count {
        for col in 0..<array[row].count {
            let element = array[row][col]
            uniqueIDIndexDictionary[element]?.append([row, col])
        }
    }
        
    return uniqueIDIndexDictionary
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
