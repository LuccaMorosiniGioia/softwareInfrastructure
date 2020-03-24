org 0x7c00
jmp 0x0000:start

primeiro_numerador db  0 ; numerador da primeira fraçao recebida
primeiro_denominador db 0  ; denominador da primeira fraçao recebida
segundo_numerador db 0  ; numerador da segunda fraçao recebida
segundo_denominador db 0 ; denominador da segunda fraçao recebida

result db 0

denominador_final db 0

start:
    
    mov ah, 0
    mov al, 12h
    int 10h
    
    call readNumerador1
    ;call calcNumerador
    ;call calcDenominador



readNumerador1:
    xor ah, ah
    int 16h
    mov ah, 0Eh
    mov bh, 0 ; Cor do fundo da tela
    mov bl, 15 ; cor da linha do texto
    int 10h
    
    cmp al, '/'
    je readDenominador1  ;se não for igual a /, salva o primeiro numerador, caso seja barra, vai ler o primeiro denominador
    mov bl, al
    sub bl, '0'
    mov [primeiro_numerador],bl
    jmp readNumerador1


readDenominador1:
    xor ah, ah
    int 16h
    mov ah, 0Eh
    mov bh, 0 ; Cor do fundo da tela
    mov bl, 15 ; cor da linha do texto
    int 10h

    cmp al,32
    je readNumerador2  ;se não for igual a ' ', salva o primeiro denominador, caso seja espaço, vai ler o segundo numerador
    mov bl, al
    sub bl, '0'
    mov [primeiro_denominador],bl
    jmp readDenominador1


readNumerador2:
    xor ah, ah
    int 16h
    mov ah, 0Eh
    mov bh, 0 ; Cor do fundo da tela
    mov bl, 15 ; cor da linha do texto
    int 10h ;printa o caractere recebido

    cmp al, '/'
    je readDenominador2  ;se não for igual a /, salva o segundo numerador, caso seja barra, vai ler o segundo denominador
    mov bl, al
    sub bl, '0'
    mov [segundo_numerador],bl
    jmp readNumerador2


readDenominador2:
    xor ah, ah
    int 16h
    mov ah, 0Eh
    mov bh, 0 ; Cor do fundo da tela
    mov bl, 15 ; cor da linha do texto
    int 10h ;printa o caractere recebido

    cmp al, 'c'
    je .done  ;se não for igual a /, salva o segundo numerador, caso seja barra, vai ler o segundo denominador
    mov bl, al
    sub bl, '0' 
    mov [segundo_denominador],bl
    jmp readDenominador2
    
    .done:
        jmp calcNumerador


calcNumerador:
    xor ah, ah
    xor al, al

    mov al, [primeiro_numerador]
    mov bl, [segundo_denominador]

    mul bl
    mov dx, ax 


    xor ah, ah
    xor al, al

    mov al, [segundo_numerador]
    mov bl, [primeiro_denominador]

    mul bl

    add dh, ah 
    add dl, al;

    mov ax, dx
    mov bl, 10
    div bl
    push ax
    
    mov ah, 0Eh
    add al,'0'
    mov bl, 15 ; cor da linha do texto
    int 10h

    pop ax
    mov al, ah
    mov ah, 0Eh
    add al,'0'
    mov bl, 15 ; cor da linha do texto
    int 10h


    mov ah, 0Eh
    mov al,'/'
    mov bl, 15 ; cor da linha do texto
    int 10h


calcDenominador:
    xor ah, ah
    xor al, al
    mov al, [primeiro_denominador]
    mov bl, [segundo_denominador]

    mul bl

    mov bl, 10
    div bl
    push ax
    
    mov ah, 0Eh
    add al,'0'
    mov bl, 15 ; cor da linha do texto
    int 10h

    pop ax
    mov al, ah
    mov ah, 0Eh
    add al,'0'
    mov bl, 15 ; cor da linha do texto
    int 10h











times 510 - ($-$$) db 0
dw 0xaa55