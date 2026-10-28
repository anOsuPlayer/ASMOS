.code16

.global rdump_cmd
rdump_cmd:              .asciz  "rdump"

rdump_text0:            .asciz  "General Purpose Registers:"
rdump_text1:            .asciz  "Segment Registers:"
rdump_text2:            .asciz  "FLAG Register:"

rdump_AX:               .asciz  "AX : "
rdump_BX:               .asciz  "BX : "
rdump_CX:               .asciz  "CX : "
rdump_DX:               .asciz  "DX : "
rdump_SI:               .asciz  "SI : "
rdump_DI:               .asciz  "DI : "
rdump_SP:               .asciz  "SP : "
rdump_BP:               .asciz  "BP : "

rdump_CS:               .asciz  "CS : "
rdump_DS:               .asciz  "DS : "
rdump_ES:               .asciz  "ES : "
rdump_SS:               .asciz  "SS : "

rdump_FLAGS:            .asciz  "FLAGS : "
rdump_buf:              .fill   32, 1, 0

.global rdump
rdump:
    pushfw
    pushw %cs
    pushw %ds
    pushw %es
    pushw %ss
    pusha

    movw %sp, %bp

    movw $rdump_text0, %si
    call println

    movw $rdump_AX, %si
    call print
    movw 14(%bp), %ax
    movw $rdump_buf, %di
    call itoa
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 14(%bp), %ax
    movw $rdump_buf, %di
    call itoh
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 14(%bp), %ax
    movw $rdump_buf, %di
    call itob
    movw %di, %si
    call println

    movw $rdump_BX, %si
    call print
    movw 8(%bp), %ax
    movw $rdump_buf, %di
    call itoa
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 8(%bp), %ax
    movw $rdump_buf, %di
    call itoh
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 8(%bp), %ax
    movw $rdump_buf, %di
    call itob
    movw %di, %si
    call println

    movw $rdump_CX, %si
    call print
    movw 12(%bp), %ax
    movw $rdump_buf, %di
    call itoa
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 12(%bp), %ax
    movw $rdump_buf, %di
    call itoh
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 12(%bp), %ax
    movw $rdump_buf, %di
    call itob
    movw %di, %si
    call println

    movw $rdump_DX, %si
    call print
    movw 10(%bp), %ax
    movw $rdump_buf, %di
    call itoa
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 10(%bp), %ax
    movw $rdump_buf, %di
    call itoh
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 10(%bp), %ax
    movw $rdump_buf, %di
    call itob
    movw %di, %si
    call println

    movw $rdump_SI, %si
    call print
    movw 2(%bp), %ax
    movw $rdump_buf, %di
    call itoa
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 2(%bp), %ax
    movw $rdump_buf, %di
    call itoh
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 2(%bp), %ax
    movw $rdump_buf, %di
    call itob
    movw %di, %si
    call println

    movw $rdump_DI, %si
    call print
    movw (%bp), %ax
    movw $rdump_buf, %di
    call itoa
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw (%bp), %ax
    movw $rdump_buf, %di
    call itoh
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw (%bp), %ax
    movw $rdump_buf, %di
    call itob
    movw %di, %si
    call println

    movw $rdump_SP, %si
    call print
    movw 6(%bp), %ax
    movw $rdump_buf, %di
    call itoa
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 6(%bp), %ax
    movw $rdump_buf, %di
    call itoh
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 6(%bp), %ax
    movw $rdump_buf, %di
    call itob
    movw %di, %si
    call println

    movw $rdump_BP, %si
    call print
    movw 4(%bp), %ax
    movw $rdump_buf, %di
    call itoa
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 4(%bp), %ax
    movw $rdump_buf, %di
    call itoh
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 4(%bp), %ax
    movw $rdump_buf, %di
    call itob
    movw %di, %si
    call println

    xorw %si, %si
    call println
    movw $rdump_text1, %si
    call println

    movw $rdump_CS, %si
    call print
    movw 22(%bp), %ax
    movw $rdump_buf, %di
    call itoa
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 22(%bp), %ax
    movw $rdump_buf, %di
    call itoh
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 22(%bp), %ax
    movw $rdump_buf, %di
    call itob
    movw %di, %si
    call println

    movw $rdump_DS, %si
    call print
    movw 20(%bp), %ax
    movw $rdump_buf, %di
    call itoa
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 20(%bp), %ax
    movw $rdump_buf, %di
    call itoh
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 20(%bp), %ax
    movw $rdump_buf, %di
    call itob
    movw %di, %si
    call println

    movw $rdump_ES, %si
    call print
    movw 18(%bp), %ax
    movw $rdump_buf, %di
    call itoa
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 18(%bp), %ax
    movw $rdump_buf, %di
    call itoh
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 18(%bp), %ax
    movw $rdump_buf, %di
    call itob
    movw %di, %si
    call println

    movw $rdump_SS, %si
    call print
    movw 16(%bp), %ax
    movw $rdump_buf, %di
    call itoa
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 16(%bp), %ax
    movw $rdump_buf, %di
    call itoh
    movw %di, %si
    call print
    movb $32, %al
    movb $0x0E, %ah
    int $0x10
    movw 16(%bp), %ax
    movw $rdump_buf, %di
    call itob
    movw %di, %si
    call println

    xorw %si, %si
    call println
    movw $rdump_text2, %si
    call println

    movw $rdump_FLAGS, %si
    call print
    movw 24(%bp), %ax
    movw $rdump_buf, %di
    call itob
    movw %di, %si
    call println

    popa
    addw $8, %sp
    popfw
    ret
