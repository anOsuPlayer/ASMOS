.code16

.global _kernel_main
_kernel_main:
    cli

    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss

    movw $0x9000, %sp
    movw %sp, %bp

    sti

    movw $success, %si
    call println

    call keyboard_handle

    hang:
        hlt
        jmp hang

success:                .asciz  "Kernel Successfully Loaded!"

cmdbuf:                 .fill   256, 1, 0
prompt:                 .asciz  ">> "

.global keyboard_handle
keyboard_handle:
    kh_reset:
        movw $prompt, %si
        call print
        movw $cmdbuf, %di

    kh_listen:
        movb $0x00, %ah
        int $0x16

        cmpb $0x0D, %al
        je kh_enter
        cmpb $0x08, %al
        je kh_backspace

        movw %di, %bx
        subw $cmdbuf, %bx
        cmpw $255, %bx
        jge kh_listen

        cmpb $32, %al
        jb kh_listen
        cmpb $126, %al
        jg kh_listen

        stosb

        movb $0x0E, %ah
        int $0x10

        jmp kh_listen

    kh_enter:
        movb $0x00, %al
        stosb

        movw $0, %si
        call println

        movw $cmdbuf, %si
        call strtok

        call execute
    
        jmp kh_reset

    kh_backspace:
        cmpw $cmdbuf, %di
        je kh_listen

        decw %di

        movb $0x0E, %ah
        
        movb $0x08, %al
        int $0x10
        movb $0x20, %al
        int $0x10
        movb $0x08, %al
        int $0x10

        jmp kh_listen

.global execute
execute:
    movw $exit_cmd, %si
    movw $cmdbuf, %bx
    call strcmp
    jnz execute1

        call exit
    
    execute1:
    movw $reboot_cmd, %si
    movw $cmdbuf, %bx
    call strcmp
    jnz execute2

        call reboot

    execute2:
    movw $echo_cmd, %si
    movw $cmdbuf, %bx
    call strcmp
    jnz execute3

        call echo

    execute3:
    movw $peek_cmd, %si
    movw $cmdbuf, %bx
    call strcmp
    jnz execute4

        call peek

    execute4:
    movw $rdump_cmd, %si
    movw $cmdbuf, %bx
    call strcmp
    jnz execute5

        call rdump

    execute5:
    movw $clear_cmd, %si
    movw $cmdbuf, %bx
    call strcmp
    jnz execute6

        call clear

    execute6:
    movw $ftest_cmd, %si
    movw $cmdbuf, %bx
    call strcmp
    jnz execute0

        call feature_test

    execute0:
    ret

exit_cmd:           .asciz  "exit"
exit_no_apm:        .asciz  "Impossible to shutdown; restart manually."

.global exit
exit:
    movw $0x5301, %ax
    xorw %bx, %bx
    int $0x15

    movw $0x5308, %ax
    movw $0x0001, %bx
    movw $0x0001, %cx
    int $0x15

    movw $0x5307, %ax
    movw $0x0001, %bx
    movw $0x0003, %cx
    int $0x15

    movw $exit_no_apm, %si
    call print

    e_hang:
        cli
        hlt
        jmp e_hang


reboot_cmd:             .asciz  "reboot"

.global reboot
reboot:
    ljmp $0xFFFF, $0x0000

clear_cmd:              .asciz  "clear"

.global clear
clear:
    movb $0x06, %ah
    movb $0x00, %al
    movb $0x07, %bh
    movw $0x0000, %cx
    movw $0x184F, %dx
    int $0x10

    movb $0x02, %ah
    movb $0x00, %bh
    movb $0x00, %dh
    movb $0x00, %dl
    int $0x10

    ret

echo_cmd:               .asciz  "echo"

.global echo
echo:
    movw $cmdbuf, %si
    echo_loop:
    call tokeat

    movb (%si), %al
    testb %al, %al
    jz echo_end
        pushw %si
        call print

        movb $0x0E, %ah
        movb $32, %al
        int $0x10

        popw %si
        jmp echo_loop

    echo_end:
    call println
    ret

peek_cmd:               .asciz  "peek"

peek_rbegin:            .asciz  " : "
peek_rbetween:          .asciz  " "

peek_wrong_mem:         .asciz  "Invalid Memory Address."
peek_wrong_count:       .asciz  "Invalid Bytes Count."

peek_buf:               .fill   10, 1, 0

.global peek
peek:
    pushw %bp
    movw %sp, %bp
    subw $12, %sp

    movw $cmdbuf, %si
    call tokeat

    call htoi
    jz peek_fault0
    movw %ax, -2(%bp)

    call tokeat

    call atoi
    jz peek_fault1
    cmpw $0, %ax
    jbe peek_fault1
    movw %ax, -4(%bp)

    movw -2(%bp), %si
    peek_loop:
        movw %si, -6(%bp)

        movw %si, %ax
        movw $peek_buf, %di
        call itoh

        movw $peek_buf, %si
        call print

        movw $peek_rbegin, %si
        call print

        movw -6(%bp), %si
        
        movw $4, %cx
        cmpw -4(%bp), %cx
        jg peek0
            movw %cx, -8(%bp)
            jmp peek1
        peek0:
            movw -4(%bp), %cx
            movw %cx, -8(%bp)
        peek1:

        peek_loop0:
            lodsb
            xorb %ah, %ah

            movw %si, -6(%bp)
            movw $peek_buf, %di
            call itoh

            movw $peek_buf, %si
            call print
            movw $peek_rbetween, %si
            call print

            movw -6(%bp), %si

            decw -8(%bp)
            decw -4(%bp)

            cmpw $0, -8(%bp)
            jg peek_loop0
            cmpw $0, -4(%bp)
            jbe peek_success
        
        movw %si, -6(%bp)
        xorw %si, %si
        call println
        movw -6(%bp), %si

        jmp peek_loop

    peek_fault0:
        movw $peek_wrong_mem, %si
        call println

        jmp peek_end
    
    peek_fault1:
        movw $peek_wrong_count, %si
        call println

        jmp peek_end

    peek_success:
    xorw %si, %si
    call println

    peek_end:
    addw $12, %sp
    popw %bp
    ret

ftest_cmd:              .asciz  "ftest"
buf:                    .fill   32, 1, 0

.global feature_test
feature_test:
    ret
