.data
    prompt_base: .asciiz "Ingrese la base: "
    prompt_exponent: .asciiz "Ingrese el exponente: "
    result_msg: .asciiz "El resultado es: "

.text
.globl main

# Función para imprimir un mensaje
print_message:
    # Argumento: Dirección de la cadena a imprimir
    # Código de salida: Ninguno
    li $v0, 4
    syscall
    jr $ra

# Función para leer un entero desde la entrada estándar
read_integer:
    # Argumento: Ninguno
    # Código de salida: Entero leído en $v0
    li $v0, 5
    syscall
    jr $ra

# Procedimiento para calcular la potencia
# Argumentos: $a0 = base, $a1 = exponente
# Resultado: $v0 = resultado
pot:
    # Guardar registros $ra, $a0, y $a1 en la pila
    subi $sp, $sp, 12
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)

    # Verificar caso base (exponente = 0)
    lw $t0, 8($sp)
    beqz $t0, base_cero

    # Verificar caso base (exponente = 1)
    li $t1, 1
    beq $t0, $t1, base_uno

    # Inicializar resultado a 1
    li $v0, 1

    # Realizar el cálculo de la potencia
    lw $t2, 4($sp)  # Cargar la base en $t2
    lw $t3, 8($sp)  # Cargar el exponente en $t3
    loop:
        beqz $t3, exit_loop  # Si el exponente es 0, salir del bucle
        mul $v0, $v0, $t2   # Multiplicar resultado por la base
        subi $t3, $t3, 1    # Decrementar el exponente
        j loop

    exit_loop:
    j done

    base_cero:
    # Caso base: base^0 = 1
    li $v0, 1
    j done

    base_uno:
    # Caso base: base^1 = base
    lw $v0, 4($sp)

    done:
    # Restaurar registros desde la pila
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

main:
    # Imprimir mensaje y leer la base
    la $a0, prompt_base
    jal print_message
    jal read_integer

    # Almacenar la base en $a0
    move $a0, $v0

    # Imprimir mensaje y leer el exponente
    la $a0, prompt_exponent
    jal print_message
    jal read_integer

    # Almacenar el exponente en $a1
    move $a1, $v0

    # Llamar a la función pot para calcular la potencia
    jal pot

    # Imprimir el resultado
    la $a0, result_msg
    jal print_message
    move $a0, $v0
    li $v0, 1
    syscall

    # Terminar el programa
    li $v0, 10
    syscall
