section .data
    message db "Enter a number: ", 0
    primeMsg db "It's a prime number.", 0xA, 0
    notPrimeMsg db "Not a prime number.", 0xA, 0

section .bss
    num resb 5

section .text
    global _start

_start:
    ; print message to ask for a number
    mov eax, 4
    mov ebx, 1
    mov ecx, message
    mov edx, 16
    int 0x80

    ; read number from user
    mov eax, 3
    mov ebx, 0
    mov ecx, num
    mov edx, 5
    int 0x80

    ; convert string to integer
    mov esi, num
    xor eax, eax
    xor ebx, ebx
convert_loop:
    mov bl, byte [esi]
    cmp bl, 0xA  ; newline character
    je check_prime
    sub bl, 30h
    imul eax, eax, 10
    add eax, ebx
    inc esi
    jmp convert_loop

check_prime:
    ; check if number is less than 2
    cmp eax, 2
    jb not_prime

    ; check for factors
    mov ebx, 2
prime_loop:
    mov edx, 0
    div ebx
    cmp edx, 0
    je not_prime
    inc ebx
    cmp ebx, eax
    jb prime_loop

    ; print prime message
    mov eax, 4
    mov ebx, 1
    mov ecx, primeMsg
    mov edx, 20
    int 0x80
    jmp end

not_prime:
    ; print not prime message
    mov eax, 4
    mov ebx, 1
    mov ecx, notPrimeMsg
    mov edx, 21
    int 0x80

end:
    ; exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
