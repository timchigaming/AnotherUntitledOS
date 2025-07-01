#pragma once

/*
 * \brief Video Memory Print - напечатать str на экране, начиная с x и y, используя цвета color
 */
void vm_print(const char* str, unsigned char x, unsigned char y, unsigned char color)
{
    volatile unsigned short* vga = (unsigned short*)0xB8000;
    int offset = y * 80 + x;

    while (*str) {
        vga[offset++] = (color << 8) | *str++;
    }
}

/*
 *  \return byte значение из порта по адрессу в port.
 */
inline unsigned char inb(unsigned short port) {
    unsigned char result;
    asm volatile ("inb %1, %0" : "=a"(result) : "Nd"(port));
    return result;
}

/*
 *  \brief Ждёт, когда нажмут любую клавишу на клавиатуре. Пока ждёт - ожидает.
 *  \return scanCode нажатой клавиши.
 *
 *  Можно вызвать kb_read() прямо в параметрах scancode_to_ascii().
 *  А-ля scancode_to_ascii(kb_read()) - сразу вернёт Ascii символ нажатой клавиши.
 */
unsigned char kb_read()
{
    while (!(inb(0x64) & 0x01)) {/*wait*/}

    return inb(0x60);
}