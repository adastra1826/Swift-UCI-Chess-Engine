//
//  IO_Header.hpp
//  Chess-Engine-UCI
//
//  Created by Nicholas Doherty on 1/6/24.
//

#ifndef IO_Header_hpp
#define IO_Header_hpp

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

#endif /* IO_Header_hpp */
