//
//  main.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/6/24.
//

import Foundation
import XCGLogger

let settings = Settings()
let log = XCGLogger.default

log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: "/Users/nicholasdoherty/Desktop/log.txt", fileLevel: .verbose)

log.logAppDetails()

let sharedData = SharedData()
let ioHandler = SwiftInputWrapper()
let engine = Engine()

let masterSync = MasterSynchronizer(ioHandler, engine)

log.info("Starting main threads")

masterSync.startAll()
