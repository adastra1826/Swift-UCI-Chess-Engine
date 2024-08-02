//
//  OptionProtocols.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 4/4/24.
//

import Foundation

enum OptionType {
    case check
    case spin
    case combo
    case button
    case string
    case unknown
}

protocol Option {
    
    associatedtype ValueType
    
    var type: OptionType { get }
    var name: String { get }
    var defaultValue: ValueType { get }
    var value: ValueType? { get set }
    
    func isValid(_ newValue: ValueType) -> Bool
    
    mutating func setValue(_ newValue: ValueType?) -> Bool
}

protocol CheckOptionProtocol {
    
}

protocol SpinOptionProtocol {
    associatedtype ValueType: Comparable
    var minValue: ValueType { get }
    var maxValue: ValueType { get }
}

protocol ComboOptionProtocol {
    associatedtype ValueType: Equatable
    var possibleValues: [ValueType] { get }
}

protocol ButtonOptionProtocol {
    
}

protocol StringOptionProtocol {
    
}
