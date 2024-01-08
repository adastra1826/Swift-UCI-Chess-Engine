//
//  main.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/6/24.
//

import Foundation

// Temporary sync code
let threadGroup = DispatchGroup()
let shouldQuitCondition = NSCondition()
var shouldQuit = false
// temp code

let ioHandler = IOHandler()
let engine = Engine()

print("Entering threads")

threadGroup.enter()

Thread { ioHandler.start() }.start()
Thread { engine.start() }.start()

threadGroup.wait()

print("Exiting threads")
