.data
prompt_degree: .asciiz "Ingrese el grado del polinomio: "
prompt_coeff: .asciiz "Ingrese el coeficiente a"
prompt_x: .asciiz "Ingrese el valor de x: "
result_format: .asciiz "El resultado es: %.2f\n"

.text
.globl main

# Leer un número de punto flotante desde la entrada estándar
read_float:
    li $v0, 6         # Código de syscall para leer un número en punto flotante
    syscall
    jr $ra

main:
    # Preguntar al usuario el grado del polinomio
    li $v0, 4
    la $a0, prompt_degree
    syscall

    # Leer el grado del polinomio desde la entrada estándar
    li $v0, 5
    syscall
    move $t0, $v0 # Almacena el grado en $t0

    # Calcular la cantidad de coeficientes
    li $t1, 1     # Coeficiente a0
    addi $t2, $t0, 1
    mul $t2, $t2, $t1

    # Reservar memoria para los coeficientes (4 bytes por coeficiente en punto flotante)
    li $v0, 9
    move $a0, $t2
    syscall
    move $t3, $v0 # Almacena la dirección de memoria reservada en $t3

    # Leer los coeficientes
    li $t4, 0     # Inicializa el índice del coeficiente
    loop_read_coeff:
        # Preguntar al usuario el coeficiente actual
        li $v0, 4
        la $a0, prompt_coeff
        syscall

        # Leer un coeficiente en punto flotante
        li $v0, 6
        syscall
        swc1 $f0, 0($t3) # Almacena el coeficiente en la memoria reservada
        addiu $t3, $t3, 4

        addi $t4, $t4, 1
        bne $t4, $t2, loop_read_coeff

    # Preguntar al usuario el valor de x
    li $v0, 4
    la $a0, prompt_x
    syscall

    # Leer el valor de x como punto flotante
    jal read_float
    mov.s $f2, $f0

    # Calcular la evaluación del polinomio
    li $t4, 0     # Inicializa el índice del coeficiente
    li $f1, 0.0   # Inicializa el resultado

    loop_eval_polynomial:
        lwc1 $f0, 0($t3)  # Carga el coeficiente actual
        mul.s $f0, $f0, $f1
        add.s $f1, $f1, $f0

        addiu $t3, $t3, 4
        addi $t4, $t4, 1
        blt $t4, $t2, loop_eval_polynomial

    # Imprimir el resultado
    li $v0, 2
    mov.s $f12, $f1
    syscall

    # Salir del programa
    li $v0, 10
    syscall
