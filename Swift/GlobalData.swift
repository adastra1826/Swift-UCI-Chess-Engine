//
//  GlobalData.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/10/24.
//

import Foundation

class GlobalData {
   
    let masterQuitCondition: NSCondition = NSCondition()
    var masterQuitSwitch: Bool = false
    
    public func safeMirrorMasterQuit() -> Bool {
        masterQuitCondition.lock()
        let quitSwitch = global.masterQuitSwitch
        masterQuitCondition.unlock()
        return quitSwitch
    }
    
    public func safeKillAll() {
        masterQuitCondition.lock()
        masterQuitSwitch = true
        masterQuitCondition.unlock()
    }
}
