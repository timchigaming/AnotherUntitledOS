nasm -f bin src/%1 -o output/boot.img
qemu-system-i386 -drive format=raw,file=output/boot.img