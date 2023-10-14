section .data
    ; Declarar las variables de punto flotante
    a_signo dd 0
    a_exponente dd 0
    a_significando dd 0
    b_signo dd 0
    b_exponente dd 0
    b_significando dd 0
    resultado_signo dd 0
    resultado_exponente dd 0
    resultado_significando dd 0

section .bss
    input_format db "Ingrese el primer número en formato (signo, exponente, significando): ",0
    output_format db "Resultado (signo, exponente, significando): %c %d %d",10,0
    input_buffer db 32

section .text
global _start

_start:
    ; Leer el primer número
    mov edx, input_format
    mov ecx, a_signo
    mov ebx, 32
    call input

    mov edx, input_format
    mov ecx, a_exponente
    mov ebx, 32
    call input

    mov edx, input_format
    mov ecx, a_significando
    mov ebx, 32
    call input

    ; Leer el segundo número
    mov edx, input_format
    mov ecx, b_signo
    mov ebx, 32
    call input

    mov edx, input_format
    mov ecx, b_exponente
    mov ebx, 32
    call input

    mov edx, input_format
    mov ecx, b_significando
    mov ebx, 32
    call input

    ; Llamar a la función multiplicar
    mov eax, [a_signo]
    mov ebx, [a_exponente]
    mov ecx, [a_significando]
    mov esi, [b_signo]
    mov edi, [b_exponente]
    mov ebp, [b_significando]
    call multiplicar

    ; Imprimir el resultado
    mov eax, 4
    mov ebx, 1
    mov edx, output_format
    lea ecx, [resultado_signo]
    mov esi, [resultado_exponente]
    mov edi, [resultado_significando]
    call printf

    ; Salir del programa
    mov eax, 1
    int 0x80

multiplicar:
    ; Comprobar si a o b son cero
    mov eax, ebx
    test eax, eax
    jz .a_is_zero
    mov eax, ebp
    test eax, eax
    jz .b_is_zero

    ; Calcular la suma de exponentes
    mov eax, [ebx]
    sub eax, 127
    mov ebx, [ebp]
    sub ebx, 127
    add eax, ebx
    add eax, 127
    mov [esi], eax

    ; Comprobar overflow en exponente
    cmp eax, 255
    ja .overflow_exponente

    ; Calcular el producto de significandos
    mov eax, [ecx]
    mov ebx, [edi]
    mul ebx
    mov [edi], eax

    ; Comprobar bit 48 para redondear
    test edx, 1
    jz .no_rounding
    add [edi], 1
    .no_rounding:

    ; Calcular el signo del resultado
    mov eax, [ebx]
    xor eax, [esi]
    mov [esi], eax

    ret

    .a_is_zero:
        ; Devolver a si a es cero
        ret

    .b_is_zero:
        ; Devolver b si b es cero
        ret

    .overflow_exponente:
        ; Manejar overflow en exponente
        ; (Colocar aquí el código para manejar el error)

input:
    ; Leer una línea de entrada y almacenarla en el búfer de entrada
    mov eax, 0
    mov ebx, 0
    mov edx, ebx
    int 0x80

    ; Terminar la cadena de entrada con un carácter nulo
    mov ecx, eax
    mov byte [ecx], 0

    ret

printf:
    ; Imprimir una cadena formateada en stdout
    mov eax, 4
    int 0x80

    ret
