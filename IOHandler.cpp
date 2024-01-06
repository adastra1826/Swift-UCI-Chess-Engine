//
//  IOHandler.cpp
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/6/24.
//

#include "IOHandler.hpp"
#include <iostream>

extern "C" {

// Get input and store it in the provided buffer
// Reads input using std::getline, ensures null-termination
void get_input(char* buffer, int bufferSize) {
    
    std::string c_input;
    
    while (true) {
        std::getline(std::cin, c_input);
        break;
    }
    
    strncpy(buffer, c_input.c_str(), bufferSize - 1);
    buffer[bufferSize - 1] = '\0';
}

// Function to output a string to the standard output
void output_string(const char* output) {
    std::cout << output << std::endl;
}

} /* extern "C" */
