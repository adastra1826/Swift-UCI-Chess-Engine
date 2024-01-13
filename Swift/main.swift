//
//  main.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/6/24.
//

import Foundation

let settings = Settings()
let log = Log()

log.send(.info, "Initializing")

let sharedData = SharedData()
let ioHandler = IOHandler()
let engine = Engine()

let masterSync = MasterSynchronizer(ioHandler, engine)

log.send(.info, "Starting main threads")

masterSync.startAll()
