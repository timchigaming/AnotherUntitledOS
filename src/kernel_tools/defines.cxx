#pragma once

#ifndef VIDEO_MODE
    #define VIDEO_MODE                  0x03
    #ifndef VIDEO_MEMORY
        #define VIDEO_MEMORY            0xB8000
    #endif
    #ifndef VIDEO_MODE_ROWS
        #define VIDEO_MODE_ROWS         25
    #endif
    #ifndef VIDEO_MODE_COLLUMNS
        #define VIDEO_MODE_COLLUMNS     80
    #endif
#endif