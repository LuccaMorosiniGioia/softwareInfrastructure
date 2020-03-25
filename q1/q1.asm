org 0x7c00
jmp 0x0000:start


start:
    push 1
    mov ax, 13h
    int 10h

loop:
    xor ah, ah
    int 16h
    
    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h

    push ax

    cmp al, 13
    jne loop

printa:
    pop ax

    cmp ax, 1
    je $

    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h
 
    jmp printa
    
times 510 - ($-$$) db 0
dw 0xaa55