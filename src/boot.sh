nasm -f bin boot.asm -o boot.o
qemu-system-x86_64 boot.o