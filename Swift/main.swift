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

log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: "/Users/nicholasdoherty/Desktop/log.txt", fileLevel: .debug)

log.logAppDetails()

let sharedData = SharedData()
let masterSync = MasterSynchronizer()

log.info("Starting main threads")

masterSync.startAll()
