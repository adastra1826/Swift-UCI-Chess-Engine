//
//  Log.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/11/24.
//

import Foundation

class Log {
    
    // Settings variables
    let logSettings: LogSettings
    
    init() {
        logSettings = LogSettings()
    }
    
    func send(_ logs: [String], _ level: LogLevel) {
        if logSettings.validateLogPush(level) {
            log(logs)
        }
    }
    
    private func log(_ logs: [String]) {
        for log in logs {
            output_string(log)
        }
    }
    
    
}

public enum LogLevel {
    case warning
    case error
    case critical
    case info
    case trace
    case verbose
}

class LogSettings {
    
    // Log settings
    private let lock: NSLock
    
    private var cacheData: CacheData
    
    // General debug flag
    private var debug: Bool
    // Override individual settings, log everything
    private var debugAll: Bool
    // Log everything below the highest set level, regardless of lower level individual settings
    private var debugDescending: Bool
    
    init() {
        lock = NSLock()
        
        debug = true
        debugAll = false
        debugDescending = true
        
        cacheData = CacheData()
        
        updateHighest()
    }
    
    var debugLevelSettings: [(LogLevel, Bool)] = [
        // The following cannot be changed
        (LogLevel.warning, true),
        (LogLevel.error, true),
        (LogLevel.critical, true),
        // Lowest level, overview of thread calls and terminations
        (LogLevel.info, true),
        // Function calls
        (LogLevel.trace, true),
        // Log everything the engine does
        (LogLevel.verbose, false)
    ]
    
    // Precalculated data
    struct CacheData {
        var highestLogLevel = 0
    }
    
    // Precalculate highest log level
    // Must call any time log settings are changed
    func updateHighest() {
        cacheData.highestLogLevel = debugLevelSettings.lastIndex(where: { $0.1 == true }) ?? 0
    }
    
    func validateLogPush(_ level: LogLevel) -> Bool {
        
        if !debug { return false }
        if debugAll { return true }
        
        // Lower level than highest set level with descending turned on
        if debugDescending {
            // Coalesce to range such that the next Bool() statement cannot be true if all settings are set to false
            let currentLevel = debugLevelSettings.firstIndex(where: { $0.0 == level }) ?? 9
            return Bool(currentLevel <= cacheData.highestLogLevel)
        }
        
        // Individual level validation
        return debugLevelSettings.first(where: { $0.0 == level })?.1 ?? false
    }
    
    func turnDebugOff() {
        lock.lock()
        debug = false
        lock.unlock()
    }
    
    func turnDebugOn() {
        lock.lock()
        debug = true
        lock.unlock()
    }
}

/*
 Okay, here's my assessment of the provided Log implementation and how it could potentially be improved:

 Functionality:

 Core Logging: Basic logging mechanism is provided, outputting a list of logs to an unspecified target (output_string).
 Log Levels: Uses a LogLevel enum for filtering logs by severity.
 Validation: The validateLogPush function in the LogSettings class handles complex validation logic:
 Considers individual log level settings.
 Implements "debugDescending" to log levels lower than the highest active level.
 Has a "debugAll" override.

 Efficiency:

 Locking: The validateLogPush uses NSLock for thread safety, which could introduce potential overhead if locking and unlocking happens too frequently.
 Looping: The log function iterates through all the logs using a for loop. This might not be the most efficient way for large numbers of logs.
 Output: The output_string function is undefined, so it's hard to assess how the logs are actually written. However, this is a potential area for efficiency concerns.

 Areas for Improvement:

 Performance Optimization:
 Log Buffering: Instead of logging immediately in the log function, consider accumulating logs in a buffer and then outputting them in batches. This could reduce I/O operations and locking overhead.
 Asynchronous Logging: Explore moving the logging process to a background thread to avoid blocking the main thread. This is especially important if the output_string function is a slow operation.
 Conditional Logging: If possible, introduce conditional checks within the log function to avoid creating the log message string if the log level is not active.
 Readability and Maintainability:
 Code Style: Consider using a more consistent code formatting style to improve readability.
 Comments: Add comments to explain the purpose of the different classes, functions, and validation logic in validateLogPush.
 Centralized Output: Define the output_string function to clarify how the log strings are actually being output (to console, file, etc.).
 Flexibility and Configuration:
 External Configuration: Explore using a configuration file or environment variables to change log settings without modifying code.
 Dynamic Log Levels: Consider making the log levels configurable at runtime for easier debugging.
 Customizable Loggers: Allow for the creation of separate logger instances with different configurations (e.g., different log levels for different parts of the application).
 Error Handling:
 Validation Error: The validateLogPush function returns false if validation fails. However, it might be better to raise an exception or use a more explicit error-handling mechanism to indicate what went wrong.
 Output Failure: What happens if the output_string function fails? Consider adding error handling and reporting.

 Additional Thoughts:

 Log Formatting: A good logging implementation should allow for log message formatting (adding timestamps, thread information, etc.). Consider how you might add this functionality.
 Third-Party Logging Libraries: For larger, more complex applications, it might make sense to use an existing logging library like Log4j (Java) or similar, which provides more features and performance benefits.

 Example Improvements (Pseudocode):

 class Log {
     // Buffer for logs
     private var logBuffer: [String] = []

     func send(_ logs: [String], _ level: LogLevel) {
         // ... validation ...
         // Conditional logging to avoid string creation overhead
         if settings.logSettings.validateLogPush(level) {
             logBuffer.append(logs)
             flushBufferIfNeeded() // Check if buffer is full or on a timer
         }

     // ... (rest of the code)
 }

Strengths:

Granular Logging Levels: Offers multiple levels (warning, error, critical, info, trace, verbose) for tailored logging.
Flexible Configuration: Allows control over logging behavior through debug, debugAll, and debugDescending settings.
Thread-Safety: Employs NSLock to ensure thread-safe access to configuration settings.

Potential Areas for Improvement:

Process Intensity:
Excessive Locking: Synchronization using NSLock within validateLogPush for every log message might introduce overhead, especially in high-frequency logging scenarios. Consider:
Using a lock-free approach for basic level checks if thread conflicts are infrequent.
Lazy-initializing the lock if logging is not immediately active.
Redundant lastIndex Calls: The debugDescending check calls lastIndex twice, potentially iterating through the array multiple times. Caching or pre-computing the highest enabled level could reduce iterations.
Code Organization and Readability:
Nesting: The LogSettings class is nested within Settings, making it less discoverable and tightly coupling logging configuration with other settings. Refactoring it as a standalone class could enhance organization.
Naming Conventions: Using more descriptive names for variables and functions (e.g., shouldLogMessage instead of validateLogPush) would improve readability.
Logging Destination and Format:
Customizability: The implementation lacks options for redirecting logs to different destinations (files, network streams, etc.) or customizing log formatting (timestamps, metadata). Consider incorporating these features.

Additional Suggestions:

Logging Framework: For comprehensive logging features and configuration options, evaluate adopting a well-established logging framework tailored to the programming language and platform.
Performance Benchmarking: Conduct testing to measure the logging overhead in various scenarios and pinpoint potential bottlenecks for optimization.
Error Handling: Implement error-handling mechanisms within logging functions to prevent unexpected failures and ensure log integrity.

By addressing these areas, you can create a more efficient, versatile, and robust logging system.
 */
