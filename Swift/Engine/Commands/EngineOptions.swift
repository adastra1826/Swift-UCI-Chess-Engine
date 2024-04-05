//
//  EngineOptions.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 4/4/24.
//

import Foundation

class EngineOptions {
    
    private let changeOptionQueue: DispatchQueue
    private let updateOptionQueue: DispatchQueue
    
    var currentOptions: [any Option]
    var tempOptions: [any Option]
    
    init() {
        
        changeOptionQueue = DispatchQueue(label: "com.peerlessApps.chess.changeOptionQueue")
        updateOptionQueue = DispatchQueue(label: "com.peerlessApps.chess.updateOptionQueue")
        
        let optionsDefaults = AllOptions()
        currentOptions = optionsDefaults.initializeAllOptions()
        tempOptions = optionsDefaults.initializeAllOptions()
    }
    
    func changeOption(_ option: String, _ argument: Any) {
        changeOptionQueue.sync {
            if let currentOption = tempOptions.first(where: { $0.name == option }) {
                switch currentOption.type {
                case .check(let bool):
                    if let boolArgument = argument as? Bool {
                        
                    }
                case .spin(let int):
                    <#code#>
                case .combo(let string):
                    <#code#>
                case .button(let void):
                    <#code#>
                case .string(let string):
                    <#code#>
                case .unknown:
                    <#code#>
                //default:
                //break
                }
            }
            updateOptionQueue.sync {
                currentOptions = tempOptions
            }
        }
    }
    
    func dispitchOptions() -> [any Option] {
        updateOptionQueue.sync {
            return currentOptions
        }
    }
    
}
