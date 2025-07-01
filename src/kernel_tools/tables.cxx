#pragma once
#include "defines.cxx"

unsigned char ascii_table[] = {
    0, 0, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 0,
    0, 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',
    0, 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`',
    0, '\\', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0,
    0, 0, ' '
};

/*
 * \brief Переводит scanCode в ascii по табличке 

 * \param[in] scancode сканкод;
 * \param[out] ascii ASCII-символ клавиши
 */
unsigned char scancode_to_ascii(unsigned char scancode) {
    if (scancode < sizeof(ascii_table)) {
        return ascii_table[scancode];
    }
    return 0;
}

/*
 * \brief Базовый адрес видеопамяти.
 * Указатель(адрес) константный.
 *  
 * Для текстовых(и некоторых графических) запись такова:
 * \param vga[y*ROWS+x] (цвет << 8) | символ;
 */
const volatile unsigned short* vga = (unsigned short*)VIDEO_MEMORY;