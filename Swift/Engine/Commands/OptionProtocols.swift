//
//  OptionProtocols.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 4/4/24.
//

import Foundation

enum OptionType {
    case check(Bool.Type)
    case spin(Int.Type)
    case combo(String.Type)
    case button(Void.Type)
    case string(String.Type)
    case unknown
}

protocol Option {
    
    associatedtype ValueType
    associatedtype P: OptionDefaultValueProtocol
    
    var type: OptionType { get }
    var name: String { get }
    var defaults: P { get }
    
    var value: ValueType? { get }
    
    func isValid(_ newValue: ValueType) -> Bool
    
    mutating func setValue(_ newValue: ValueType?) -> Bool
}

protocol OptionDefaultValueProtocol {
    associatedtype ValueType
    var defaultValue: ValueType { get }
}

protocol CheckOptionProtocol {
    
}

protocol SpinOptionProtocol {
    var minValue: Int { get }
    var maxValue: Int { get }
}

protocol ComboOptionProtocol {
    var possibleValues: [String] { get }
}

protocol ButtonOptionProtocol {
    
}

protocol StringOptionProtocol {
    
}
