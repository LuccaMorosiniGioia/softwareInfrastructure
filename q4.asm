org 0x7c00
jmp 0x0000:start

str1 db 'Digite o tamanho da base: ', 13, 10, 0
str2 db 'Digite o tamanho da altura: ', 13, 10, 0
new_line db '', 13, 10, 0

width_u db 0  ;unidade
width_d db 0  ;dezena
width db 0

height_u db 0 ;unidade
height_d db 0 ;dezena
height db 0

aux db 0
x db 1
y db 0


start:
    mov ah, 0eh
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

    call soma

    call loop

    ret

soma:
    
    call height_
    call width_
    ret

height_:
    mov ax, [height_d]
    mov cx, 10
    mul cx

    add ax, [height_u]
    ;sub ax, 1
    mov [height], ax
    ret

width_:
    mov ax, [width_d]
    mov cx, 10
    mul cx

    add ax, [width_u]
    sub ax, 1
    mov [height], ax
    ret

loop:

    call n_line
    mov al, '*'
    call print_line
    call n_line

    call outside_loop

    call n_line
    mov al, '*'
    call print_line
    call n_line

    ret



outside_loop:

    call n_line

    mov cl, [x]
    cmp cl, [height]
    je .end

    mov cl, [y]
    add cl, 1
    mov [x], cl

    call inside_loop

    jmp outside_loop

    .end:
        ret

inside_loop:

    mov cl, [y]
    cmp cl, [width]
    je .end
    
    call cmp
    
    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h

    mov cl, [y]
    add cl, 1
    mov [y], cl

    jmp inside_loop

    .end:
        jmp reset_y

reset_y:
    xor cl, cl
    mov [y], cl
    ret

cmp:
    xor dl, dl
    cmp dl, [y]
    je asterisco

    jmp espaco

asterisco:
    mov al, '*'
    ret

espaco:
    mov al, ' '
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

    cmp al, 13
    je .end

    sub al, '0'

    call salva_w

    mov ah, 1
    add [aux], ah

    jmp recebe_w

    .end:
        ret


salva_w:
    
    xor cl, cl
    cmp [aux], cl
    je unidade_w

    mov [width_d], al
    ret 

unidade_w:
    mov [width_u], al
    ret

recebe_h:

    xor ah, ah
    int 16h
    
    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h

    cmp al, 13
    je .end

    sub al, '0'

    call salva_h

    mov ah, 1
    add [aux], ah

    jmp recebe_h


    .end:
        ret

salva_h:
    
    xor cl, cl
    cmp [aux], cl
    je unidade_h

    mov [height_d], al
    ret 
    
unidade_h:
    mov [width_u], al
    ret

print_str:
    lodsb
    cmp al, 0
    je done

    mov ah,0eh
    int 10h
    jmp print_str
    done:
        ret

n_line:
    mov si, new_line
    call print_str
    ret

times 510 - ($-$$) db 0
dw 0xaa55