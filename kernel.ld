ENTRY(_kernel_main)
SECTIONS
{
    . = 0x7E00;

    .text : {
        *(.text)
        *(.data)
        *(.rodata)
        *(.bss)
        *(COMMON)
        
        . = 3072 - 1;
        BYTE(0x00)
    }

    /DISCARD/ : {
        *(.eh_frame)
        *(.comment)
        *(.note*)
    }
}