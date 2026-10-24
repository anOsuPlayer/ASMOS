.code16

.global _stl16main
_stl16main:

.global print
print:
    mov $0x0E, %ah
    print_loop:
    lodsb
    test %al, %al
    jz print_end
        int $0x10
        jmp print_loop
    print_end:
    ret

.global println
println:
    mov $0x0E, %ah

    testw %si, %si
    jz println_end

    println_loop:
    lodsb
    test %al, %al
    jz println_end
        int $0x10
        jmp println_loop
    println_end:

    movb $'\n', %al
    int $0x10
    movb $'\r', %al
    int $0x10

    ret

.global strlen
strlen:
    pushw %si
    movw $0, %cx
    strlen_loop:
        lodsb
        testb %al, %al
        jz strlen_end
            incw %cx
            jmp strlen_loop
    strlen_end:
    movw %cx, %ax 
    popw %si
    ret

.global strcmp
strcmp:
    pushw %si
    pushw %bx
    strcmp_loop:
        lodsb
        movb (%bx), %cl
        cmpb %al, %cl
        jne strcmp_end

        test %al, %al
        jz strcmp_end

        incw %bx
        jmp strcmp_loop
    strcmp_end:
    popw %bx
    popw %si
    ret

.global strtok
strtok:
    pushw %si
    strtok_loop:
        lodsb
        test %al, %al
        jz strtok_end
            cmpb $32, %al
            jne strtok0
                movb $0, -1(%si)
        strtok0:
        jmp strtok_loop

    strtok_end:
    movb $0, (%si)
    popw %si
    ret

.global tokeat
tokeat:
    lodsb
    test %al, %al
    jnz tokeat

    ret

invalid_number:         .asciz "Invalid Number."

.global atoi
atoi:
    pushw %si
    movw $0, %cx

    lodsb
    cmpb $45, %al
    jne atoi_pos
        pushw $-1
        lodsb
        jmp atoi_neg
    atoi_pos:
        pushw $1
    atoi_neg:

    atoi_loop:
        testb %al, %al
        jz atoi_success
            cmpb $48, %al
            jb atoi_nfe
            cmpb $57, %al
            jg atoi_nfe

            subb $48, %al
            movzxb %al, %bx

            movw $10, %dx
            movw %cx, %ax
            mulw %dx
            addw %bx, %ax
            movw %ax, %cx

            lodsb
            jmp atoi_loop

    atoi_nfe:
        movw $invalid_number, %si
        call println

        popw %ax
        xorw %ax, %ax
        test %al, %al
        jmp atoi_end

    atoi_success:
    popw %ax
    imulw %cx

    movb $1, %cl
    testb %cl, %cl

    atoi_end:
    popw %si
    ret

.global itoa
itoa:
    pushw %di
    pushw %ax
    

    popw %ax
    popw %di
    ret

.global htoi
htoi:
    ret
