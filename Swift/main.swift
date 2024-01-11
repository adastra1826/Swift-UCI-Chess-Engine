//
//  main.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/6/24.
//

import Foundation

let global = GlobalData()
let ioHandler = IOHandler()
let engine = Engine()

let masterSync = MasterSynchronizer(ioHandler, engine)

masterSync.startAll()
