
nasm -f bin src\boot.asm -o output\tmp\boot.bin

nasm -f elf src\kernel_entry.asm -o output\tmp\kernel_entry.o

i686-elf-g++ -m32 -ffreestanding -c src\kernel.cpp -o output\tmp\kernel.o
i686-elf-ld -m elf_i386 -T tools\linker.ld -o output\tmp\kernel.elf output\tmp\kernel_entry.o output\tmp\kernel.o
i686-elf-objcopy -O binary output\tmp\kernel.elf output\tmp\kernel.bin


copy /b output\tmp\boot.bin+output\tmp\kernel.bin+output\tmp\blank2048.bin output\os.img

qemu-system-i386 -drive format=raw,file=output\os.img