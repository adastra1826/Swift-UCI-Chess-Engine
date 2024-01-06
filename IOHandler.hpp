//
//  IOHandler.hpp
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/6/24.
//

#ifndef IOHandler_hpp
#define IOHandler_hpp

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

// C++ functions exposed to Swift
void get_input(char* buffer, int bufferSize);
void output_string(const char* output);

#ifdef __cplusplus
}
#endif

#endif /* IOHandler_hpp */
