//
//  GlobalData.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/10/24.
//

import Foundation

class SharedData {
   
    private let quitSwitchQueue: DispatchQueue
    
    private var masterQuitSwitch: Bool
    
    struct Info {
        static let author = "Nicholas Doherty"
        static let engine = "Peerless Chess Engine"
    }
    
    init() {
        quitSwitchQueue = DispatchQueue(label: "com.PeerlessApps.Chess.quitSwitchQueue")
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
