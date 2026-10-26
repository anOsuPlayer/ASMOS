.code16

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

.global strrev
strrev:
    pushw %bp
    movw %sp, %bp
    subw $4, %sp

    movw %si, -2(%bp)
    movw %di, -4(%bp)

    call strlen
    addw %ax, %di
    movb $0, (%di)

    strrev_loop:
        cmpw -4(%bp), %di
        jb strrev_end
            decw %di 
            lodsb
            movb %al, (%di)
            jmp strrev_loop

    strrev_end:

    movw -2(%bp), %si
    movw -4(%bp), %di

    addw $4, %sp
    popw %bp
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
    pushw %bp
    movw %sp, %bp
    subw $14, %sp

    movw %di, -2(%bp)
    leaw -14(%bp), %di
    movw %ax, -6(%bp)

    cmpw $0, %ax
    jg itoa_pos0
        negw %ax
    itoa_pos0:

    movw %ax, -4(%bp)

    test %ax, %ax
    jnz itoa0
        movb $48, %al
        stosb
        movb $0, %al
        stosb
        jmp itoa_end1

    itoa0:

    itoa_loop:
        movw -4(%bp), %ax
        xorw %dx, %dx
        movw $10, %cx
        idivw %cx

        movw %ax, -4(%bp)
        testw %dx, %dx
        jnz itoa1
            testw %ax, %ax
            jz itoa_end0

        itoa1:
        movb %dl, %al
        addb $48, %al
        stosb

        jmp itoa_loop

    itoa_end0:
    movw -6(%bp), %ax
    cmpw $0, %ax
    jg itoa_pos1
        movb $45, %al
        stosb
    itoa_pos1:

    itoa_end1:
    movb $0, (%di)

    leaw -14(%bp), %si
    movw -2(%bp), %di
    call strrev

    addw $14, %sp
    popw %bp
    ret

invalid_hex:            .asciz  "Invalid Hexadecimal."

.global htoi
htoi:
    pushw %si
    movw $0, %cx

    lodsb
    cmpb $48, %al
    jnz htoi0
        cmpb $88, (%si)
        je htoi_0x
        cmpb $120, (%si)
        je htoi_0x
        
        jmp htoi0

        htoi_0x:
        lodsb
        lodsb
    htoi0:

    htoi_loop:
        testb %al, %al
        jz htoi_success
            cmpb $48, %al
            jb htoi_nfe
            cmpb $57, %al
            jbe htoi_num
            cmpb $65, %al
            jb htoi_nfe
            cmpb $70, %al
            jbe htoi_upper
            cmpb $97, %al
            jb htoi_nfe
            cmpb $102, %al
            jbe htoi_lower

            jmp htoi_nfe

            htoi_num:
            subb $48, %al
            movzxb %al, %bx
            jmp htoi1

            htoi_upper:
            subb $55, %al
            movzxb %al, %bx
            jmp htoi1

            htoi_lower:
            subb $87, %al
            movzxb %al, %bx
            jmp htoi1
            
            htoi1:
            movw %cx, %ax
            shlw $4, %ax
            addw %bx, %ax
            movw %ax, %cx

            lodsb
            jmp htoi_loop

    htoi_nfe:
    movw $invalid_hex, %si
    call println

    popw %ax
    xorw %ax, %ax
    test %al, %al
    jmp htoi_end

    htoi_success:
    movw %cx, %ax

    movb $1, %cl
    testb %cl, %cl

    htoi_end:
    popw %si
    ret

.global itoh
itoh:
    pushw %bp
    movw %sp, %bp
    subw $12, %sp

    movw %di, -2(%bp)
    movw %ax, -4(%bp)

    leaw -12(%bp), %di

    itoh_loop:
        testw %ax, %ax
        jz itoh_end

        movw %ax, %cx
        movw %ax, %dx
        andw $0x000F, %cx
        shrw $4, %dx

        cmpb $10, %cl
        jge itoh_alpha
            addb $48, %cl
            movb %cl, %al
            stosb
            jmp itoh_num
        itoh_alpha:
            addb $55, %cl
            movb %cl, %al
            stosb
        itoh_num:

        movw %dx, %ax
        jmp itoh_loop

    itoh_end:
    
    movb $120, %al
    stosb
    movb $48, %al
    stosb
    movb $0, %al
    stosb

    movw -2(%bp), %di
    leaw -12(%bp), %si
    call strrev

    movw -4(%bp), %ax

    add $12, %sp
    popw %bp
    ret
