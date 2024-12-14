//
//  main.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/6/24.
//

import Foundation
import XCGLogger

let log = XCGLogger.default

log.setup(level: .info, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: "/Users/nicholasdoherty/Desktop/log.txt", fileLevel: .debug)

log.logAppDetails()

private let sharedData = SharedData()

let master = EngineMaster(sharedData)

master.start()
