This is currently a work in progress. It is not currently useable in any way except for responding to basic UCI prompts:


    
    isready ->    readyok
    uci ->        id name Peerless Chess Engine
                  id author Nicholas Doherty
                  readyok

Current package dependencies for logging: 
XCGLogger: https://github.com/DaveWoodCom/XCGLogger

Codebase Visualization: 
https://mango-dune-07a8b7110.1.azurestaticapps.net/?repo=adastra1826%2FSwift-UCI-Chess-Engine

It seems like the GUI I'm mainly testing with (SCID: https://scid.sourceforge.net) is unable to read Swift getline(), but it can see Swift print() statements. Therefore, it can see log statments directed to the terminal. A good GUI will ignore output it does not understand, and I have not yet discovered an issue with this. 
That said, input from the engine and output directed to the engine are specifically handled with C++ std::cin and std::cout. Additionally, log specific output can be directed to a .txt file. 
Engine specific output is easily distinguishable from log output, as logs have additional metadata besides the actual log statement.
