org 0x7c00
jmp 0x0000:start

azul db 'azul',13,10,0
stringUser db 'vermelho',13,10,0
amarelo db 'amarelo', 13,10,0
verde db 'verde', 13,10,0
vermelho db 'vermelho', 13,10,0

naoExiste db 'nao existe', 13,10,0


start:
    xor ax, ax ;zera ax
    mov ds, ax ;zera ds
    mov es, ax ;zera es

    mov ah, 0
    mov al, 12h
    int 10h


    .checkAzul:                         ;ds:di points to second string                                   
        mov esi, azul
        mov edi, stringUser
        mov ecx, 8  ; selects the length of the first string as maximum for comparison
        rep cmpsb         ; comparison of ECX number of bytes
        mov eax, 4        ; does not modify flags 
        mov ebx, 1        ; does not modify flags
        je goPrintAzul       ; checks ZERO flag

    .checkAmarelo:
        mov esi, amarelo
        mov edi, stringUser
        mov ecx, 8  ; selects the length of the first string as maximum for comparison
        rep cmpsb         ; comparison of ECX number of bytes
        mov eax, 4        ; does not modify flags 
        mov ebx, 1        ; does not modify flags
        je goPrintAmarelo       ; checks ZERO flag

    .checkVerde:
        mov esi, verde
        mov edi, stringUser
        mov ecx, 8  ; selects the length of the first string as maximum for comparison
        rep cmpsb         ; comparison of ECX number of bytes
        mov eax, 4        ; does not modify flags 
        mov ebx, 1        ; does not modify flags
        je goPrintVerde      ; checks ZERO flag

    .checkVermelho:
        mov esi, vermelho
        mov edi, stringUser
        mov ecx, 8  ; selects the length of the first string as maximum for comparison
        rep cmpsb         ; comparison of ECX number of bytes
        mov eax, 4        ; does not modify flags 
        mov ebx, 1        ; does not modify flags
        je goPrintVermelho      ; checks ZERO flag
    
    jmp goPrintNaoExiste
    


goPrintAzul:
    mov si, azul;aponta para inicio de azul
    call printAzul
    call done
goPrintAmarelo:
    mov si, amarelo;aponta para inicio de azul    
    call printAmarelo
    call done
goPrintVerde:
    mov si, verde;aponta para inicio de azul    
    call printVerde
    call done
goPrintVermelho:
    mov si, vermelho;aponta para inicio de azul    
    call printVermelho
    call done

goPrintNaoExiste:
    mov si, naoExiste;aponta para inicio de azul    
    call printNaoExiste
    call done



getTec:
    xor ah, ah
    int 16h
    mov ah, 0Eh
    mov bh, 5 ; Cor do fundo da tela
    mov bl, 15 ; cor da linha do texto
    int 10h


    cmp al, 13 ;compara a parte baixa do registrador al com quebra de linha
    jne getTec

printAzul:
    
    lodsb ;carrega um caractere de si para al e passa pro proximo
    cmp al, 0 ;compara se o registrador al eh igual a zero
    je .done ; se for, pula pra .done e retorna

    ;se nao terminou
    mov bl, 1 ; cor azul da linha do texto
    mov ah, 0eh ;
    int 10h ;interrupcao de video
    jmp printAzul

    ;se terminou
    .done:
        ret
printAmarelo:
    lodsb ;carrega um caractere de si para al e passa pro proximo
    cmp al, 0 ;compara se o registrador al eh igual a zero
    je .done ; se for, pula pra .done e retorna

    ;se nao terminou
    mov bl, 14 ; cor amarela da linha do texto
    mov ah, 0eh
    int 10h ;interrupcao de video
    jmp printAmarelo

    ;se terminou
    .done:
        ret
printVermelho:
    lodsb ;carrega um caractere de si para al e passa pro proximo
    cmp al, 0 ;compara se o registrador al eh igual a zero
    je .done ; se for, pula pra .done e retorna

    ;se nao terminou
    mov bl, 4 ; cor amarela da linha do texto
    mov ah, 0eh
    int 10h ;interrupcao de video
    jmp printVermelho

    ;se terminou
    .done:
        ret

printVerde:
    lodsb ;carrega um caractere de si para al e passa pro proximo
    cmp al, 0 ;compara se o registrador al eh igual a zero
    je .done ; se for, pula pra .done e retorna

    ;se nao terminou
    mov bl, 2 ; cor amarela da linha do texto
    mov ah, 0eh
    int 10h ;interrupcao de video
    jmp printVerde

    ;se terminou
    .done:
        ret

printNaoExiste:
    lodsb ;carrega um caractere de si para al e passa pro proximo
    cmp al, 0 ;compara se o registrador al eh igual a zero
    je .done ; se for, pula pra .done e retorna

    ;se nao terminou
    mov bl, 2 ; cor amarela da linha do texto
    mov ah, 0eh
    int 10h ;interrupcao de video
    jmp printNaoExiste

    ;se terminou
    .done:
        ret



done:
    jmp $
    
times 510 - ($-$$) db 0
dw 0xaa55