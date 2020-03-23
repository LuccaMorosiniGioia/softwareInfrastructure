org 0x7c00
jmp 0x0000:start

str1 db 'Digite o tamanho da base: ', 13, 10, 0
str2 db 'Digite o tamanho da altura: ', 13, 10, 0

width db 0
height db 0
aux db 0

x db 1
y db 0


start:

    mov ah, 0eh
    int 10h

    mov AX, 0012h           
    mov bh, 0
	mov bl, 2
	int 10h
    
    call entrada

    jmp $

entrada:

    mov si, str1
    call print_str
    call recebe_w
    
    call n_line

    xor ah, ah
    mov [aux], ah

    mov si, str2
    call print_str
    call recebe_h
    call n_line

    mov ah, 0              
    int 10h

    mov AX, 0012h          
    mov bh, 0
	mov bl, 2
	int 10h

    mov ah, 02h            
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 10h

    call print_

    ret

print_:

    mov al, '*'
    call print_line

    mov ah, 1
    cmp [height], ah
    je .end

    call loop
    call n_line

    mov al, '*'
    call print_line
    call n_line

    .end:
        ret



loop:

    xor ah, ah
    mov ah, 1
    sub [height], ah
    sub [height], ah

    .loop:

        xor bh, bh
        cmp [height], bh
        je .end

        call n_line   
        call print_m
         

        xor ah, ah
        mov ah, 1
        sub [height], ah

        jmp .loop
    
    .end:
        ret


print_m:

    mov al, 42           
    mov ah, 0xe
	int 10h

    mov ah, 02h             
    mov bh, 0
    mov dh, dh
    mov dl, [width]
    sub dl, 1
    int 10h
    
    mov al, 42             
    mov ah, 0xe
    int 10h
    ret       


print_line:

    mov cl, [y]
    cmp cl, [width]
    je .end

    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h

    mov cl, [y]
    add cl, 1
    mov [y], cl

    jmp print_line

    .end:
        xor cl, cl
        mov [y], cl
        ret

    
recebe_w:

    xor ah, ah
    int 16h
    
    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h

    sub al, '0'
    mov [width], al

    xor ah, ah
    int 16h
    
    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h

    cmp al, 13
    je .end

    sub al, '0'
    mov [aux], al

    mov al, [width]
    mov cl, 10
    mul cl

    add al, [aux]
    mov [width], al

    xor ah, ah
    int 16h
    
    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h

    .end:
        ret

recebe_h:

    xor ah, ah
    int 16h
    
    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h

    sub al, '0'
    mov [height], al

    xor ah, ah
    int 16h
    
    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h

    cmp al, 13
    je .end

    sub al, '0'
    mov [aux], al

    mov al, [height]
    mov cl, 10
    mul cl

    add al, [aux]
    mov [height], al

    xor ah, ah
    int 16h
    
    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h

    .end:
        ret


print_str:
    lodsb

    cmp al, 13
    je done

    mov ah,0eh
    int 10h
    jmp print_str
    done:
        ret

n_line:
    mov ah, 02h            
    mov bh, 0
    add dh, 1
    mov dl, 0
    int 10h
    ret

times 510 - ($-$$) db 0
dw 0xaa55