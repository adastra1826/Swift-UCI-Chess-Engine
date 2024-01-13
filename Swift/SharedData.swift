//
//  GlobalData.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/10/24.
//

import Foundation

class SharedData {
   
    let quitSwitchQueue: DispatchQueue
    //let masterQuitCondition: NSCondition
    var masterQuitSwitch: Bool
    
    init() {
        quitSwitchQueue = DispatchQueue(label: "com.PeerlessApps.Chess.quitSwitchQueue")
        //masterQuitCondition = NSCondition()
        masterQuitSwitch = false
    }
    
    public func safeMirrorMasterQuit() -> Bool {
        quitSwitchQueue.sync {
            return sharedData.masterQuitSwitch
        }
    }
    
    public func safeKillAll() {
        quitSwitchQueue.sync {
            masterQuitSwitch = true
        }
    }
}
