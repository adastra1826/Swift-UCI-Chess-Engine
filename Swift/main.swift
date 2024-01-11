//
//  main.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/6/24.
//

import Foundation

let settings = Settings()
let log = Log()

log.send(["Initializing"], .info)

let sharedData = SharedData()
let ioHandler = IOHandler()
let engine = Engine()

let masterSync = MasterSynchronizer(ioHandler, engine)

log.send(["Starting main threads"], .info)

masterSync.startAll()
