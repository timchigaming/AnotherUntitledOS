[org 0x7C00]
[bits 16]

global _start

section .text

_start:
    mov bp, 0x7C00
    mov sp, bp

    push 0x03
    call SetVideoMode@2

    push 0x1E
    push 0x08
    call SetCursorPos@4

    push hello_str
    call PutStr@2

    push 0x1C
    push 0x09
    call SetCursorPos@4

    push what_do_str
    call PutStr@2

    push 0x20
    push 0x0B
    call SetCursorPos@4

    push answer1_str
    call PutStr@2

    push 0x20
    push 0x0C
    call SetCursorPos@4

    push answer2_str
    call PutStr@2

    push 0x25
    push 0x0E
    call SetCursorPos@4

    push buffer_str
    call PutStr@2

.getInput:
    push 0x27
    push 0x0E
    call SetCursorPos@4

    call GetCh

    cmp al, VK_1
    je .goToSystem ; go to load another section

    cmp al, VK_2
    je ShutDown

    push 0x19
    push 0x10
    call SetCursorPos@4

    push err_str
    call PutStr@2

    jmp .getInput

.goToSystem:
    push 0x06
    push 0x02
    push 0x7E00
    call LoadSection@6

    jmp bx


; in: @2 - pointer to string
PutStr@2:
    push bp
    mov bp, sp
    mov si, [bp+4]
    mov ah, 0x0E
    xor bx, bx

.putCh:
    mov al, [si]
    cmp al, 0
    jz .done

    int 0x10
    inc si
    jmp .putCh

.done:
    pop bp
    ret 2

; in: @2 - clmn
; in: @4 - str
SetCursorPos@4:
    push bp
    mov bp, sp

    mov ah, 0x02
    mov bx, 0x0000
    mov dh, byte [bp+4]
    mov dl, byte [bp+6]
    int 0x10

    pop bp
    ret 4

; out: ah - keyCode
; out: al - ascii code
GetCh:
    mov ah, 0x00
    int 16h
    ret

ShutDown:
    ; ACPI shutdown
    mov ax, 0x5307
    mov bx, 0x0001
    mov cx, 0x0003
    int 0x15

; in: @2 - amount of sectors to load
; in: @4 - start from ? sector (1, 2, 3. Not from 0)
; in: @6 - Buffer/Section addr
; out: bx - Buffer/Section addr
LoadSection@6:
    push bp
    mov bp, sp

    mov ah, 0x02        ; функция чтения с диска
    mov al, byte [bp+8] ; читаем секторов
    mov ch, 0           ; цилиндр 0
    mov cl, byte [bp+6] ; сектор ?
    mov dh, 0           ; головка 0
    mov dl, 0x80        ; первый жесткий диск
    mov bx, word [bp+4] ; адрес загрузки второго сектора (0x0000:0x0600)
    int 0x13

    jc crash_RSOD

    pop bp
    ret 6

crash_RSOD:
    push 0x03
    call SetVideoMode@2

    push 0x04
    call SetBGColor@2

    push 0x25
    push 0x0C
    call SetCursorPos@4

    mov ah, 0x0E
    mov al, ":"
    int 0x10
    mov al, "("
    int 0x10

    push 0x1D
    push 0x18
    call SetCursorPos@4

    push rsod1_str
    call PutStr@2

    push 0x1D
    push 0x18
    call SetCursorPos@4

    push rsod2_str
    call PutStr@2

    call GetCh

    push 0x00
    call SetBGColor@2

    push 0x03
    call SetVideoMode@2

    int 0x18
    hlt

; in: @2 - mode index
SetVideoMode@2:
    push bp
    mov bp, sp

    mov ah, 0x00
    mov al, byte [bp+4]
    int 0x10

    pop bp
    ret 2

; in: @2 - color index
SetBGColor@2:
    push bp
    mov bp, sp

    mov ah, 0x0b
    mov bh, 0x00
    mov bl, byte [bp+4]
    int 0x10

    pop bp
    ret 2

;   DATA

    hello_str   db " Hello from TimChi", 0
    what_do_str db "What can i do for you?", 0
    answer1_str db "1. Load system", 0
    answer2_str db "2. Shutdown", 0
    buffer_str  db ">", 0
    err_str     db "^ Invalid choice, try again ^",0
    rsod1_str   db "Something went wrong.",13,10,0
    rsod2_str   db "Checkout github repo.",0

;   CONSTANTS

    VK_1        equ "1"
    VK_2        equ "2"
    NULL        equ 0

;   Boot sector signature
    times 510 - ($ - $$) db 0
    dw 0xAA55 
    
;------------------------SECTION 2: 0x7E00------------------------

_start2:
    push 0x03
    call SetVideoMode@2

    cli
    lgdt [GDT_Descriptor]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp CODE_SEG:start_protected_mode

;   GDT

GDT_Start:
    null_descriptor:
        dd NULL
        dd NULL
    code_descriptor:
        dw 0xFFFF
        dw NULL
        db NULL
        db 0b10011010
        db 0b11001111
        db NULL
    data_descriptor:
        dw 0xFFFF
        dw NULL
        db NULL
        db 0b10010010
        db 0b11001111
        db NULL
GDT_End:

GDT_Descriptor:
    dw GDT_End - GDT_Start - 1
    dd GDT_Start

CODE_SEG equ code_descriptor - GDT_Start
DATA_SEG equ data_descriptor - GDT_Start

;------------------------PROTECTED MODE------------------------
[bits 32]

start_protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x90000
    mov esp, ebp

    jmp 0x8000

times 1024 - ($ - $$) db 0

;------------------------SECTION 3: 0x8000------------------------