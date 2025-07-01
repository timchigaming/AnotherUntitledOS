@echo off
nasm -f bin src/%1 -o output/boot.img
start "" qemu-system-i386 -drive format=raw,file=output/boot.img -s -S
gdb
@echo on

:: i dont use it btw its useless