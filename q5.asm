

org 0x7c00
jmp 0x0000:start

primeiro_numerador db  0 ; numerador da primeira fraçao recebida
primeiro_denominador db 0  ; denominador da primeira fraçao recebida
segundo_numerador db 0  ; numerador da segunda fraçao recebida
segundo_denominador db 0 ; denominador da segunda fraçao recebida

result db 0
string times 10 db 0
string1 times 10 db 0
denominador_final db 0

start:
    
    mov ah, 0
    mov al, 12h
    int 10h
    
    call readNumerador1
    ;call calcNumerador
    ;call calcDenominador
putchar:
	mov ah, 0x0e 
	int 10h
	ret
reverse:						; mov si, string
	mov di, si
	xor cx, cx					; zerar contador
	.loop1:						; botar string na stack
		lodsb
		cmp al, 0
		je .endloop1
		inc cl
		push ax
		jmp .loop1
	.endloop1:
	.loop2: 					; remover string da stack				
		pop ax
		stosb
		loop .loop2
	ret
tostring:						; mov ax, int / mov di, string
	push di
	.loop1:
		cmp ax, 0
		je .endloop1
		xor dx, dx
		mov bx, 10
		div bx					; ax = 9999 -> ax = 999, dx = 9
		xchg ax, dx				; swap ax, dx
		add ax, 48				; 9 + '0' = '9'
		stosb
		xchg ax, dx
		jmp .loop1
	.endloop1:
	pop si
	cmp si, di
	jne .done
	mov al, 48
	stosb
	.done:
		mov al, 0
		stosb
		call reverse
		ret

prints:							; mov si, string
	.loop:
		lodsb					; bota character em al 
		cmp al, 0
		je .endloop
		call putchar
		jmp .loop
	.endloop:
	ret
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

    add ax, dx

	mov di, string
	call tostring
	mov si, string
	call prints
   
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
	
    mov di, string1
	call tostring
	mov si, string1
	call prints
    
  








times 510 - ($-$$) db 0
dw 0xaa55

