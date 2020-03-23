org 0x7c00
jmp 0x0000:start

primeiro_numerador db  0 ; numerador da primeira fraçao recebida
primeiro_denominador db 0  ; denominador da primeira fraçao recebida
segundo_numerador db 0  ; numerador da segunda fraçao recebida
segundo_denominador db 0 ; denominador da segunda fraçao recebida

result1 db 0
result2 db 0

start:
    
    mov ah, 0
    mov al, 12h
    int 10h
    
    call readNumerador1
    call calcNumerador
    call calcDenominador

    jmp endOfCode


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
    mov edi, primeiro_numerador
    mov [di],bl
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
    mov edi,primeiro_denominador
    mov [di],bl
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
    mov edi, segundo_numerador
    mov [di],bl
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
    mov edi, segundo_denominador
    mov [di],bl
    jmp readDenominador2

    .done:
        jmp calcNumerador


calcNumerador:
    xor ah, ah
    xor al, al

    mov al, [primeiro_numerador]
    mov bl, [segundo_denominador]

    mul bl
    aam
    mov dh, ah 
    mov dl, al;
;------------------------
    xor ah, ah
    xor al, al

    mov al, [segundo_numerador]
    mov bl, [primeiro_denominador]

    mul bl
    aam
    add dh, ah 
    add dl, al;

   
    
    add dh,'0'
    add dl,'0'
    mov ah, 0Eh
    mov al, dh
    mov bl, 15 ; cor da linha do texto
    int 10h


    mov ah, 0Eh
    mov al, dl
    mov bl, 15 ; cor da linha do texto
    int 10h

    mov ah, 0Eh
    mov al, '/'
    mov bl, 15 ; cor da linha do texto
    int 10h
    .done:
        jmp calcDenominador

calcDenominador:
    xor ah, ah
    xor al, al
    mov al, [primeiro_denominador]
    mov bl, [segundo_denominador]

    mul bl
    aam
    add ah, '0'
    add al,'0'

    mov dx, ax
    mov ah, 0Eh
    mov al, dh
    mov bl, 15 ; cor da linha do texto
    int 10h

    mov ah, 0Eh
    mov al, dl
    mov bl, 15 ; cor da linha do texto
    int 10h
    .done:
        jmp endOfCode





endOfCode:
    jmp $




times 510 - ($-$$) db 0
dw 0xaa55

; nasm -f bin q5.asm -o q5.bin
; qemu-system-i386 q2.bin