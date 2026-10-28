#!/bin/bash

gcc -c boot.S -o boot.o
ld -Ttext 0x7c00 -e _start boot.o -o boot.tmp
objcopy -O binary -j .text boot.tmp boot.bin

gcc -c kernel.S -o kernel.o
gcc -c stl16.S -o stl16.o
gcc -c rdump.S -o rdump.o
ld -T kernel.ld kernel.o stl16.o rdump.o -o kernel.tmp
objcopy -O binary kernel.tmp kernel.bin

cat boot.bin kernel.bin > asmos.img

rm -f *.o *.tmp *.bin