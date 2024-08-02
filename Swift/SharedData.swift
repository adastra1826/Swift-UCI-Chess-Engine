//
//  GlobalData.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/10/24.
//

import Foundation

class SharedData {
   
    let quitSwitchSemaphore: DispatchSemaphore
    
    private let _quitSwitchQueue: DispatchQueue
    private let _UUIDQueue: DispatchQueue
    
    private var _masterQuitSwitch: Bool
    
    var activeThreadUUIDs: [UUID] = []
    var terminatedThreadUUIDs: [UUID] = []
    
    init() {
        quitSwitchSemaphore = DispatchSemaphore(value: 0)
        _quitSwitchQueue = DispatchQueue(label: "com.PeerlessApps.Chess.quitSwitchQueue")
        _UUIDQueue = DispatchQueue(label: "com.PeerlessApps.Chess.UUIDQueue")
        _masterQuitSwitch = false
    }
    
    struct Info {
        static let author = "Nicholas Doherty"
        static let engine = "Peerless Chess Engine"
    }
    
    enum ErrorTypes: Error {
        case alert(message: String)
        case warning(message: String)
        case fatal(message: String)
    }
    
    public func masterQuit() -> Bool {
        _quitSwitchQueue.sync {
            return _masterQuitSwitch
        }
    }
    
    public func safeKillAll() {
        _quitSwitchQueue.sync {
            _masterQuitSwitch = true
        }
        quitSwitchSemaphore.signal()
    }
    
    public func generateNewUUID() -> UUID {
        let newUUID = UUID()
        _UUIDQueue.sync {
            activeThreadUUIDs.append(newUUID)
        }
        return newUUID
    }
    
    public func terminateUUID(_ oldUUID: UUID) {
        _UUIDQueue.sync {
            activeThreadUUIDs.removeAll(where: { $0 == oldUUID} )
            terminatedThreadUUIDs.append(oldUUID)
        }
    }
}
