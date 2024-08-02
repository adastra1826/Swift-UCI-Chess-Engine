//
//  EngineOptions.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 4/4/24.
//

import Foundation

class EngineOptions {
    
    private let _changeOptionQueue: DispatchQueue
    private let _mergeOptionQueue: DispatchQueue
    
    var currentOptions: [any Option]
    var tempOptions: [any Option]
    
    init() {
        
        _changeOptionQueue = DispatchQueue(label: "com.peerlessApps.chess._changeOptionQueue")
        _mergeOptionQueue = DispatchQueue(label: "com.peerlessApps.chess._mergeOptionQueue")
        
        let allOptions = AllOptions()
        currentOptions = allOptions.getAllOptions()
        tempOptions = allOptions.getAllOptions()
    }
    
    func changeOption(_ option: String, _ argument: Any) throws {
        
        try _changeOptionQueue.sync {
            
            if let currentOption = tempOptions.first(where: { $0.name == option }) {
                
                var throwAlert = false
                
                switch currentOption {
                case var checkOption as OptionDefaults.CheckOption:
                    if !checkOption.isValid(argument as! Bool) {
                        throwAlert = true
                    }
                case var spinOption as OptionDefaults.SpinOption:
                    if !spinOption.isValid(argument as! Int) {
                        throwAlert = true
                    }
                case var stringOption as OptionDefaults.StringOption:
                    if !stringOption.isValid(argument as! String) {
                        throwAlert = true
                    }
                case var comboOption as OptionDefaults.ComboOption:
                    if !comboOption.isValid(argument as! String) {
                        throwAlert = true
                    }
                case var buttonOption as OptionDefaults.ButtonOption:
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
            _mergeOptionQueue.sync {
                currentOptions = tempOptions
            }
        }
    }
    
    func dispatchOptions() -> [any Option] {
        _mergeOptionQueue.sync {
            return currentOptions
        }
    }
    
}
