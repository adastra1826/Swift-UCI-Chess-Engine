//
//  Engine.swift
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/8/24.
//

import Foundation

class Engine {
    
    // Max number of concurrent searching threads
    private let _searchThreadPermits: DispatchSemaphore
    
    private let _updateThreadOptionsQueue: DispatchQueue
    
    // Stop calculating ASAP
    private let _stopCondition: NSCondition
    
    private let _outputWrapper: SwiftOutputWrapper
    
    private var _threadOptions: [ThreadOptions]
    
    
    private lazy var _allCommandsDispatchMap: [TopLevelCommand: ([String]) -> Void] = [
        .uci: uciCommand,
        .isready: isreadyCommand,
        .ucinewgame: ucinewgameCommand,
        .stop: stopCommand,
        .ponderhit: ponderhitCommand,
        .help: helpCommand,
        .debug: debugCommand,
        .setoption: setoptionCommand,
        .register: registerCommand,
        .position: positionCommand,
        .go: goCommand
    ]
    
    init(_ outputWrapper: SwiftOutputWrapper) {
        
        self._outputWrapper = outputWrapper
        
        _searchThreadPermits = DispatchSemaphore(value: settings.engine.getMaxThreads())
        
        _updateThreadOptionsQueue = DispatchQueue(label: "com.peerlessApps.chess._updateThreadOptionsQueue")
        
        _stopCondition = NSCondition()
        
        _threadOptions = []
    }
    
    func start() {
        
        log.info("Start engine")
        
        _fakeStart()
        
        log.info("Stop engine")
    }
    
    private func _fakeStart() {
        
        var count = 0
        
        while !sharedData.masterQuit() {
            
            count += 1
            //print(count)
            
            Thread.sleep(forTimeInterval: 1.0)
        }
    }
    
    private func _generateNewSearchThread() {
        
    }
    
    private func _updateThreadOptions() {
        
    }
    
    func command(_ command: TopLevelCommand, _ arguments: [String]) {
        if let commandFunc = _allCommandsDispatchMap[command] {
            commandFunc(arguments)
        } else {
            log.alert("Unable to map \(command) to function in engine")
        }
    }
    
    ///
    /// ----------------------
    /// Begin no argument commands
    /// ----------------------
    ///
    
    /* uci
     Tell engine to use UCI (universal chess interface).
     This will be sent once as a first command after program boot to tell the engine to switch to uci mode.
     After receiving the uci command the engine must identify itself with the "id" command and send the "option" commands to tell the GUI which engine settings the engine supports, if any.
     After that, the engine should sent "uciok" to acknowledge UCI mode.
     If no uciok is sent within a certain time period, the engine task will be killed by the GUI.
     */
    private func uciCommand(_ nilArgument: [String]? = nil) {
        idOut()
        optionOut()
        uciokOut()
    }
    
    /* isready
     This is used to synchronize the engine with the GUI.
     When the GUI has sent a command or multiple commands that can take some time to complete, this command can be used to wait for the engine to be ready again or to ping the engine to find out if it is still alive.
     E.g. this should be sent after setting the path to the tablebases as this can take some time.
     This command is also required once before the engine is asked to do any search to wait for the engine to finish initializing.
     This command must always be answered with "readyok" and can be sent also when the engine is calculating in which case the engine should also immediately answer with "readyok" without stopping the search.
     */
    private func isreadyCommand(_ nilArgument: [String]? = nil) {
        readyokOut()
    }
    
    /* ucinewgame
     This is sent to the engine when the next search (started with "position" and "go") will be from a different game. This can be a new game the engine should play or a new game it should analyse but also the next position from a testsuite with positions only.
     If the GUI hasn't sent a "ucinewgame" before the first "position" command, the engine shouldn't expect any further ucinewgame commands as the GUI is probably not supporting the ucinewgame command.
     The engine should not rely on this command even though all new GUIs should support it.
     As the engine's reaction to "ucinewgame" can take some time the GUI should always send "isready" after "ucinewgame" to wait for the engine to finish its operation.
     */
    private func ucinewgameCommand(_ nilArgument: [String]? = nil) {
        return
    }
    
    /* stop
     Stop calculating as soon as possible, don't forget the "bestmove" and possibly the "ponder" token when finishing the search.
     */
    private func stopCommand(_ nilArgument: [String]? = nil) {
        bestmoveOut()
    }
    
    /* ponderhit
     The user has played the expected move. This will be sent if the engine was told to ponder on the same move the user has played. The engine should continue searching but switch from pondering to normal search.
     */
    private func ponderhitCommand(_ nilArgument: [String]? = nil) {
        return
    }
    
    
    private func helpCommand(_ nilArgument: [String]? = nil) {
        log.info("Help stuff")
        _outputWrapper.queue("Help stuff")
    }
    
    ///
    /// ----------------------
    /// End no argument commands
    /// ----------------------
    ///
    /// ----------------------
    /// Begin argument commands
    /// ----------------------
    ///
    
    /* debug
     Switch the debug mode of the engine on and off.
     In debug mode the engine should sent additional infos to the GUI, e.g. with the "info string" command, to help debugging, e.g. the commands that the engine has received etc.
     This mode should be switched off by default and this command can be sent
     any time, also when the engine is thinking.
     */
    private func debugCommand(_ arguments: [String]) {
        return
    }
    
    /* setoption
     This is sent to the engine when the user wants to change the internal parameters of the engine.
     For the "button" type no value is needed.
     One string will be sent for each parameter and this will only be sent when the engine is waiting.
     The name of the option in  should not be case sensitive and can inludes spaces like also the value.
     The substrings "value" and "name" should be avoided in  and  to allow unambiguous parsing, for example do not use  = "draw value".
     Here are some strings for the example below:
         "setoption name Nullmove value true\n"
         "setoption name Selectivity value 3\n"
         "setoption name Style value Risky\n"
         "setoption name Clear Hash\n"
         "setoption name NalimovPath value c:\chess\tb\4;c:\chess\tb\5\n"
     */
    private func setoptionCommand(_ arguments: [String]) {
        return
    }
    
    /* register
     This is the command to try to register an engine or to tell the engine that registration will be done later. This command should always be sent if the engine has sent "registration error" at program startup.
     The following tokens are allowed:
     * later
        the user doesn't want to register the engine now.
     * name
        the engine should be registered with the name
     * code
        the engine should be registered with the code
     Example:
        "register later"
        "register name Stefan MK code 4359874324"
     */
    private func registerCommand(_ arguments: [String]) {
        log.error("Registration not supported")
        _outputWrapper.queue("Registration not supported")
    }
    
    /* position
     [fen  | startpos ]  moves  ....
     Set up the position described in fenstring on the internal board and play the moves on the internal chess board.
     If the game was played  from the start position the string "startpos" will be sent.
     Note: no "new" command is needed. However, if this position is from a different game than the last position sent to the engine, the GUI should have sent a "ucinewgame" inbetween.
     */
    private func positionCommand(_ arguments: [String]) {
        
    }
    
    /* go
     Start calculating on the current position set up with the "position" command.
     There are a number of commands that can follow this command, all will be sent in the same string.
     If one command is not send its value should be interpreted as it would not influence the search.
     * searchmoves  ....
         Restrict search to this moves only
         Example: After "position startpos" and "go infinite searchmoves e2e4 d2d4" the engine should only search the two moves e2e4 and d2d4 in the initial position.
     * ponder
         Start searching in pondering mode.
         Do not exit the search in ponder mode, even if it's mate!
         This means that the last move sent in in the position string is the ponder move.
         The engine can do what it wants to do, but after a "ponderhit" command it should execute the suggested move to ponder on. This means that the ponder move sent by the GUI can be interpreted as a recommendation about which move to ponder. However, if the engine decides to ponder on a different move, it should not display any mainlines as they are likely to be misinterpreted by the GUI because the GUI expects the engine to ponder on the suggested move.
     * wtime
         white has x msec left on the clock
     * btime
         black has x msec left on the clock
     * winc
         white increment per move in mseconds if x > 0
     * binc
         black increment per move in mseconds if x > 0
     * movestogo
       there are x moves to the next time control,
         this will only be sent if x > 0,
         if you don't get this and get the wtime and btime it's sudden death
     * depth
         search x plies only.
     * nodes
        search x nodes only,
     * mate
         search for a mate in x moves
     * movetime
         search exactly x mseconds
     * infinite
         search until the "stop" command. Do not exit the search without being told so in this mode!
     */
    private func goCommand(_ arguments: [String]) {
        return
    }
    
    ///
    /// ----------------------
    /// End argument commands
    /// ----------------------
    ///
    /// ----------------------
    /// Begin output functions
    ///

    /* id
     * name
         This must be sent after receiving the "uci" command to identify the engine,
         e.g. "id name Shredder X.Y\n"
     * author
         This must be sent after receiving the "uci" command to identify the engine,
         e.g. "id author Stefan MK\n
     */
    private func idOut() {
        _outputWrapper.queue("id name \(SharedData.Info.engine)")
        _outputWrapper.queue("id author \(SharedData.Info.author)")
    }
    
    /*
     Must be sent after the id and optional options to tell the GUI that the engine has sent all infos and is ready in uci mode.
     */
    private func uciokOut() {
        _outputWrapper.queue("uciok")
    }
    
    /* readyok
     This must be sent when the engine has received an "isready" command and has processed all input and is ready to accept new commands now.
     It is usually sent after a command that can take some time to be able to wait for the engine, but it can be used anytime, even when the engine is searching.
     */
    private func readyokOut() {
        _outputWrapper.queue("readyok")
    }
    
    /* option
     This command tells the GUI which parameters can be changed in the engine.
     This should be sent once at engine startup after the "uci" and the "id" commands if any parameter can be changed in the engine.
     The GUI should parse this and build a dialog for the user to change the settings.
     Note that not every option needs to appear in this dialog as some options like "Ponder", "UCI_AnalyseMode", etc. are better handled elsewhere or are set automatically.
     If the user wants to change some settings, the GUI will send a "setoption" command to the engine.
     Note that the GUI need not send the setoption command when starting the engine for every option if it doesn't want to change the default value.
     For all allowed combinations see the example below, as some combinations of this tokens don't make sense.
     One string will be sent for each parameter.
     * name
     
         The option has the name id.
         Certain options have a fixed value, which means that the semantics of these option is fixed.
         Usually those options should not be displayed in the normal engine options window of the GUI but get a special treatment. "Pondering" for example should be set automatically when pondering is enabled or disabled in the GUI options. The same for "UCI_AnalyseMode" which should also be set automatically by the GUI. All those certain options have the prefix "UCI_" except for the first 6 options below. If the GUI get an unknown Option with the prefix "UCI_", it should just ignore it and not display it in the engine's options dialog.
         *  = Hash, type is spin
             the value in MB for memory for hash tables can be changed.
             This should be answered with the first "setoptions" command at program boot if the engine has sent the appropriate "option name Hash" command, which should be supported by all engines!
             So the engine should use a very small hash first as default.
         *  = NalimovPath, type string
             this is the path on the hard disk to the Nalimov compressed format.
             Multiple directories can be concatenated with ";"
         *  = NalimovCache, type spin
             this is the size in MB for the cache for the nalimov table bases
             These last two options should also be present in the initial options exchange dialog
             when the engine is booted if the engine supports it
         *  = Ponder, type check
             this means that the engine is able to ponder.
             The GUI will send this whenever pondering is possible or not.
             Note: The engine should not start pondering on its own if this is enabled, this option is only
             needed because the engine might change its time management algorithm when pondering is allowed.
         *  = OwnBook, type check
             this means that the engine has its own book which is accessed by the engine itself.
             if this is set, the engine takes care of the opening book and the GUI will never
             execute a move out of its book for the engine. If this is set to false by the GUI,
             the engine should not access its own book.
         *  = MultiPV, type spin
             the engine supports multi best line or k-best mode. the default value is 1
         *  = UCI_ShowCurrLine, type check, should be false by default,
             the engine can show the current line it is calculating. see "info currline" above.
         *  = UCI_ShowRefutations, type check, should be false by default,
             the engine can show a move and its refutation in a line. see "info refutations" above.
         *  = UCI_LimitStrength, type check, should be false by default,
             The engine is able to limit its strength to a specific Elo number,
            This should always be implemented together with "UCI_Elo".
         *  = UCI_Elo, type spin
             The engine can limit its strength in Elo within this interval.
             If UCI_LimitStrength is set to false, this value should be ignored.
             If UCI_LimitStrength is set to true, the engine should play with this specific strength.
            This should always be implemented together with "UCI_LimitStrength".
         *  = UCI_AnalyseMode, type check
            The engine wants to behave differently when analysing or playing a game.
            For example when playing it can use some kind of learning.
            This is set to false if the engine is playing a game, otherwise it is true.
          *  = UCI_Opponent, type string
            With this command the GUI can send the name, title, elo and if the engine is playing a human
            or computer to the engine.
            The format of the string has to be [GM|IM|FM|WGM|WIM|none] [|none] [computer|human]
            Example:
            "setoption name UCI_Opponent value GM 2800 human Gary Kasparow"
            "setoption name UCI_Opponent value none none computer Shredder"
                       
         
     * type
         The option has type t.
         There are 5 different types of options the engine can send
         * check
             a checkbox that can either be true or false
         * spin
             a spin wheel that can be an integer in a certain range
         * combo
             a combo box that can have different predefined strings as a value
         * button
             a button that can be pressed to send a command to the engine
         * string
             a text field that has a string as a value,
             an empty string has the value ""
     * default
         the default value of this parameter is x
     * min
         the minimum value of this parameter is x
     * max
         the maximum value of this parameter is x
     * var
         a predefined value of this parameter is x
     Example:
     Here are 5 strings for each of the 5 possible types of options
        "option name Nullmove type check default true\n"
       "option name Selectivity type spin default 2 min 0 max 4\n"
        "option name Style type combo default Normal var Solid var Normal var Risky\n"
        "option name NalimovPath type string default c:\\n"
        "option name Clear Hash type button\n"
     */
    private func optionOut() {
        return
    }
    
    /* info
     The engine wants to send infos to the GUI. This should be done whenever one of the info has changed.
     The engine can send only selected infos and multiple infos can be send with one info command:
     e.g. "info currmove e2e4 currmovenumber 1" or
          "info depth 12 nodes 123456 nps 100000".
     All infos belonging to the pv should be sent together
     e.g. "info depth 2 score cp 214 time 1242 nodes 2124 nps 34928 pv e2e4 e7e5 g1f3"
     I suggest to start sending "currmove", "currmovenumber", "currline" and "refutation" only after one second to avoid too much traffic.
     Additional info:
        * depth
            Search depth in plies
        * seldepth
            Selective search depth in plies.
            If the engine sends seldepth there must also a "depth" be present in the same string.
        * time
            The time searched in ms, this should be sent together with the pv.
        * nodes
            x nodes searched, the engine should send this info regularly
        * pv  ...
            The best line found
        * multipv
            This for the multi pv mode.
            For the best move/pv add "multipv 1" in the string when you send the pv.
            In k-best mode always send all k variants in k strings together.
        * score
            * cp
                The score from the engine's point of view in centipawns.
            * mate
                Mate in y moves, not plies.
                If the engine is getting mated use negativ values for y.
            * lowerbound
                The score is just a lower bound.
            * upperbound
                The score is just an upper bound.
        * currmove
            Currently searching this move
        * currmovenumber
            Currently searching move number x, for the first move x should be 1 not 0.
        * hashfull
            The hash is x permill full, the engine should send this info regularly
        * nps
            x nodes per second searched, the engine should send this info regularly
        * tbhits
            x positions where found in the endgame table bases
        * cpuload
            The cpu usage of the engine is x permill.
        * string
            Any string str which will be displayed by the engine,
            If there is a string command the rest of the line will be interpreted as .
        * refutation   ...
            Move  is refuted by the line  ... , i can be any number >= 1.
            Example: after move d1h5 is searched, the engine can send
            "info refutation d1h5 g6h5" if g6h5 is the best answer after d1h5 or if g6h5 refutes the move d1h5.
            If there is no refutation for d1h5 found, the engine should just send "info refutation d1h5"
            The engine should only send this if the option "UCI_ShowRefutations" is set to true.
        * currline   ...
            This is the current line the engine is calculating.
        It is the number of the cpu if the engine is running on more than one cpu.  = 1,2,3....
        If the engine is just using one cpu,  can be omitted.
        If it is greater than 1, always send all k lines in k strings together.
        The engine should only send this if the option "UCI_ShowCurrLine" is set to true.
     */
    private func infoOut() {
        return
    }
    
    /* bestmove [ponder]
     The engine has stopped searching and found the move  best in this position.
     The engine can send the move it likes to ponder on. The engine must not start pondering automatically.
     This command must always be sent if the engine stops searching, also in pondering mode if there is a "stop" command, so for every "go" command a "bestmove" command is needed!
     Directly before that the engine should send a final "info" command with the final search information so that the the GUI has the complete statistics about the last search.
     */
    private func bestmoveOut() {
        return
    }
    
    /*
     This is needed for engines that need a username and/or a code to function with all features.
     Analog to the "copyprotection" command the engine can send "registration checking" after the uciok command followed by either "registration ok" or "registration error".
     Also after every attempt to register the engine it should answer with "registration checking" and then either "registration ok" or "registration error".
     In contrast to the "copyprotection" command, the GUI can use the engine after the engine has reported an error, but should inform the user that the engine is not properly registered and might not use all its features.
     In addition the GUI should offer to open a dialog to enable registration of the engine. To try to register an engine the GUI can send the "register" command.
     The GUI has to always answer with the "register" command if the engine sends "registration error" at engine startup (this can also be done with "register later") and tell the user somehow that the engine is not registered.
     This way the engine knows that the GUI can deal with the registration procedure and the user will be informed that the engine is not properly registered.
     */
    private func registrationOut() {
        return
    }
    
    /* copyprotection
     This is needed for copyprotected engines. After the uciok command the engine can tell the GUI that it will check the copy protection now.
     This is done by "copyprotection checking".
     If the check is ok the engine should send "copyprotection ok", otherwise "copyprotection error".
     If there is an error the engine should not function properly but should not quit alone.
     If the engine reports "copyprotection error" the GUI should not use this engine and display an error message instead!
     The code in the engine can look like this
        Tell GUI("copyprotection checking\n");
        // ... check the copy protection here ...
        if(ok)
            TellGUI("copyprotection ok\n");
        else
            TellGUI("copyprotection error\n");
     */
    private func copyprotectionOut() {
        log.error("Engine not copy protected")
        _outputWrapper.queue("Engine not copy protected")
    }
}
