.code16

.global _start
_start:
    cli

    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss

    movw $0x7C00, %sp
    movw %sp, %bp

    sti

    movb %dl, boot_drive

    movw $device_load, %si
    call bios_out

    movb $0x02, %ah
    movb $0x06, %al
    movb $0x00, %ch
    movb $0x02, %cl
    movb $0x00, %dh
    movb boot_drive, %dl

    movw $0x7E00, %bx

    int $0x13
    jc kernel_fail

        ljmp $0x0000, $0x7E00 

    kernel_fail:
    movw $device_fail, %si
    call bios_out

    hang:
        hlt
    jmp hang

.global bios_out
bios_out:
    mov $0x0e, %ah
    bios_out_loop:
    lodsb
    test %al, %al
    jz bios_out_end
        int $0x10
        jmp bios_out_loop
    bios_out_end:
    ret

boot_drive:     .byte 0
device_load:    .asciz "Loading Kernel...\n\r"
device_fail:    .asciz "Failed to load Kernel."

.org 510, 0
.word 0xAA55