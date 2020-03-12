org 0x7c00
jmp 0x0000:start


ans db 0
x db 0 

start:
    push 1 ; flag para o final da pilha
    mov ah, 0
    mov ax, 13h
    int 10h

    mov ah, 1
    mov [ans], ah

begin:

    xor ah, ah
    int 16h

    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h

    sub al, '0'
    mov [x], al ; passa para x a quantidade de entradas

    xor ah, ah
    int 16h

    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h

main:

    xor ah, ah
    cmp [x], ah ; final da entrada
    je $
    mov ah, 1
    sub [x], ah

    mov al, [x]
    add al, '0'

    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h

    call main

    xor ah, ah
    int 16h 

    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h

    cmp al, 13 ; '\n'
    je clean_stck ; reiniciar a pilha

    
    ; caso seja uma abertura adicionamos na pilha
    cmp al, '('
    je add_stck
    cmp al, '{'
    je add_stck
    cmp al, '['
    je add_stck

    ; comparamos com o que esta no topo da pilha
    cmp al, ')'
    je cmp_p
    cmp al, '}'
    je cmp_ch
    cmp al, ']'
    je cmp_co

debug:
    mov al, 'K'
    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h
    jmp $
    
add_stck: 
    push ax

cmp_p: ; compara com '('

    pop ax
    mov ah, 1
    cmp al, ah ; pilha vazia
    je n_b ; nao balanceado
    cmp al, '('
    jne n_b ; nao balanceado
    ret ; continua a testar

cmp_co: ; compara com '['

    pop ax
    mov ah, 1
    cmp ah, al ; pilha vazia
    je n_b ; nao balanceado
    cmp al, '['
    jne n_b ; nao balanceado
    ret ; continua a testar

cmp_ch: ; compara com '{'

    pop ax
    mov ah, 1
    cmp ah, al
    je n_b ; n balanceado
    cmp al, '{'
    jne n_b ; nao balanceado
    ret ; continua a testar
    
clean_stck:

    pop ax
    cmp al, 1
    jne clean_stck
    push 1
    call clean_stck
    xor ah, ah
    cmp [ans], ah
    je okay
    jne n_okay
    jmp main

okay:

    mov al, 'S'
    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h
    mov al, 13
    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h
    ret 

n_okay:

    mov al, 'N'
    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h
    mov al, 13
    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h
    ret 

n_b:
    xor ah, ah
    mov [ans], ah
    ret


times 510 - ($-$$) db 0
dw 0xaa55