//
//  EngineOptions.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 4/4/24.
//

import Foundation

class EngineOptions {
    
    private let changeOptionQueue: DispatchQueue
    private let mergeOptionQueue: DispatchQueue
    
    var currentOptions: [any Option]
    private var tempOptions: [any Option]
    
    init() {
        
        changeOptionQueue = DispatchQueue(label: "com.PeerlessApps.chess.changeOptionQueue")
        mergeOptionQueue = DispatchQueue(label: "com.PeerlessApps.chess.mergeOptionQueue")
        
        currentOptions = DefaultOptionsValues.options
        tempOptions = DefaultOptionsValues.options
    }
    
    func changeOption(_ option: String, _ argument: Any) throws {
        
        try changeOptionQueue.sync {
            
            if let currentOption = tempOptions.first(where: { $0.name == option }) {
                
                var throwAlert = false
                
                switch currentOption {
                case var checkOption as OptionParameters.CheckOption:
                    if !checkOption.isValid(argument as! Bool) {
                        throwAlert = true
                    }
                case var spinOption as OptionParameters.SpinOption:
                    if !spinOption.isValid(argument as! Int) {
                        throwAlert = true
                    }
                case var stringOption as OptionParameters.StringOption:
                    if !stringOption.isValid(argument as! String) {
                        throwAlert = true
                    }
                case var comboOption as OptionParameters.ComboOption:
                    if !comboOption.isValid(argument as! String) {
                        throwAlert = true
                    }
                case var buttonOption as OptionParameters.ButtonOption:
                    if !buttonOption.isValid(argument as! Void) {
                        throwAlert = true
                    }
                default:
                    break
                }
                
                if throwAlert {
                    throw SharedData.ErrorTypes.alert(message: "Unable to set option \(option) to \(argument)")
                }
            }
            mergeOptionQueue.sync {
                currentOptions = tempOptions
            }
        }
    }
    
    func dispatchOptions() -> [any Option] {
        mergeOptionQueue.sync {
            return currentOptions
        }
    }
    
}
