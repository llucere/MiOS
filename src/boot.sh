rm -rf build
mkdir build
nasm -f bin boot.asm -o build/boot.o
qemu-system-x86_64 build/boot.o
rm -rf build