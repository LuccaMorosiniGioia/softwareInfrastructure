org 0x7c00
jmp 0x0000:start


ans db 1
x db 0 

start:

    mov ah, 0
    mov ax, 13h
    int 10h

    mov ah, 1
    mov [ans], ah ; seta a flag answer como true

begin:

    xor ah, ah ; le quantos casos teste
    int 16h

    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h

    sub al, '0'
    mov [x], al ; salva em x a quant de casos

    xor ah, ah
    int 16h ; pega o ultimo \n

    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h

main:

    push 1 ; inicializa a stack com 1 antes de processar cada caso
    xor ah, ah 
    cmp [x], ah ; compara X com 0, quando for true todos os casos foram processados
    je $ ; finaliza
    mov ah, 1
    sub [x], ah ; x--

    call leitura

    

leitura:

    xor ah, ah ; recebe o 1 char
    int 16h 

    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h

    cmp al, 13 ; \n indica o fim da entrada, entao podemos olhar nossa flag ans e printar a resposta
    je end_

    call add_ ;checa se a entrada é '(' || '[' || '{', caso seja iremos add eles na stack
    call cmp  ; se a entrada for ')' || '[' || '}', olhamos o topo da pilha e comparamos
    
    jmp leitura

    

cmp: ; divide os casos
    
    cmp al, ')'
    je cmp_p
    cmp al, '}'
    je cmp_ch
    cmp al, ']'
    je cmp_co
    ret


add_: ; ve qual eh o char e add ele na stack

    cmp al, '('
    je add_stck_p
    cmp al, '{'
    je add_stck_ch
    cmp al, '['
    je add_stck_co
    ret 

    
add_stck_p: 
    pop bx ; pop e push da stack em bx, pois no topo da pilha estava salvo o endereço de retorno da nossa funcao, assim o preservamos
    push '('
    push bx
    ret 

add_stck_co: 

    pop bx
    push '['
    push bx
    ret

add_stck_ch: 

    pop bx
    push '{'
    push bx
    ret 

cmp_p:

    pop bx ; preservando o endereço de retorno
    pop ax
    push bx
    mov cl, 1 
    cmp al, cl ; vemos primeiro se nossa pilha n esta vazia
    je n_b_1 ; seta ans=0 e trata o caso de termos tirado o 1 da base da stck
    cmp al, '(' 
    jne n_b ; caso o topo da pilha n contenha o char correto-> ans = 0
    ret 

cmp_co: 

    pop bx
    pop ax
    push bx
    mov bh, 1
    cmp al, bh 
    je n_b_1 
    cmp al, '['
    jne n_b 
    ret 

cmp_ch: 

    pop bx
    pop ax
    push bx
    mov bh, 1
    cmp al, bh 
    je n_b_1 
    cmp al, '{'
    jne n_b 
    ret 
    
end_:
    ;call checa_stck ; essa funcao deveria checar se depois da entrada acabar a pilha ficou vazia ou nao, pq se n estiver a saida eh false - deu erro :( 
    call print_ans 
    jmp main

checa_stck:
    pop bx
    pop ax
    push bx
    cmp al, 1
    jne n_b_1
    ret

n_b:
    xor ah, ah
    mov [ans], ah
    ret

n_b_1: ; muda ans para falso e adiciona 1 novamente a pilha, usada nos casos onde precisamos retirar o 1 

    pop bx
    push 1
    push bx
    xor ah, ah
    mov [ans], ah
    ret

print_ans: ; olha o valor de ans e printa a reposta
    xor ah, ah
    cmp [ans], ah
    je n_okay
    jmp okay

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

 ; FUNCOES DE DEBUG:
debug:
    mov al, 'A'
    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h
    ret

print_al:
    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h
    ret

pop_stck:
    pop bx
    pop ax
    push bx
    mov ah, 0Eh
    mov bh, 0
    mov bl, 2
    int 10h
    ret


times 510 - ($-$$) db 0
dw 0xaa55