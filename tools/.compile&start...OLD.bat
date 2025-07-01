
nasm -f bin src\boot.asm -o output\tmp\boot.bin

nasm -f elf src\kernel_entry.asm -o output\tmp\kernel_entry.o

g++ -m32 -ffreestanding -c src\kernel.cpp -o output\tmp\kernel.o

g++ -m32 -ffreestanding -nostdlib -Ttext 0x8000 -o output\tmp\kernel.elf output\tmp\kernel_entry.o output\tmp\kernel.o
objcopy -O binary output\tmp\kernel.elf output\tmp\kernel.bin

copy /b output\tmp\boot.bin+output\tmp\kernel.bin output\os.img

qemu-system-i386 -drive format=raw,file=output\os.img