//
//  GlobalData.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/10/24.
//

import Foundation

class SharedData {
   
    private let quitSwitchQueue: DispatchQueue
    private let UUIDQueue: DispatchQueue
    
    private var masterQuitSwitch: Bool
    
    var activeThreadUUIDs: [UUID] = []
    var terminatedThreadUUIDs: [UUID] = []
    
    struct Info {
        static let author = "Nicholas Doherty"
        static let engine = "Peerless Chess Engine"
    }
    
    enum ErrorTypes: Error {
        case alert(message: String)
        case warning(message: String)
        case fatal(message: String)
    }
    
    init() {
        quitSwitchQueue = DispatchQueue(label: "com.PeerlessApps.Chess.quitSwitchQueue")
        UUIDQueue = DispatchQueue(label: "com.PeerlessApps.Chess.UUIDQueue")
        masterQuitSwitch = false
    }
    
    public func masterQuit() -> Bool {
        quitSwitchQueue.sync {
            return sharedData.masterQuitSwitch
        }
    }
    
    public func safeKillAll() {
        quitSwitchQueue.sync {
            masterQuitSwitch = true
        }
    }
    
    public func generateNewUUID() -> UUID {
        let newUUID = UUID()
        UUIDQueue.sync {
            activeThreadUUIDs.append(newUUID)
        }
        return newUUID
    }
    
    public func terminateUUID(_ oldUUID: UUID) {
        UUIDQueue.sync {
            activeThreadUUIDs.removeAll(where: { $0 == oldUUID} )
            terminatedThreadUUIDs.append(oldUUID)
        }
    }
}
