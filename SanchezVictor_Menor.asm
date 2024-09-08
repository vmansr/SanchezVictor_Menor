.data                        #Esta directiva marca el inicio de la secci�n de datos.
    msg_cantidad:    .asciiz "Ingrese la cantidad de numeros a comparar (3-5): "
    msg_numero:      .asciiz "Ingrese el numero "
    msg_menor:       .asciiz "El numero menor es: "
    msg_error:       .asciiz "Error: La cantidad debe estar entre 3 y 5.\n"
    newline:         .asciiz "\n" #indica que son cadenas de caracteres terminadas en nulo.

.text                       #Esta directiva marca el inicio de la secci�n de c�digo.
.globl main                 #Hace que la etiqueta main sea global, permitiendo que sea el punto de entrada del programa.

main:
    # Pedir cantidad de n�meros
    li $v0, 4              #Carga el valor 4 en $v0, que es el c�digo para imprimir una cadena.
    la $a0, msg_cantidad   #Carga la direcci�n de msg_cantidad en $a0.
    syscall                #Llama al sistema para ejecutar la impresi�n.

    # Leer cantidad
    li $v0, 5              #Prepara para leer un entero.
    syscall                #Lee el entero ingresado por el usuario.
    move $s0, $v0  # $s0 = cantidad. Mueve el valor le�do a $s0 para guardarlo como la cantidad de n�meros

    # Verificar si la cantidad est� entre 3 y 5
    blt $s0, 3, error_cantidad
    bgt $s0, 5, error_cantidad

    # Inicializar contador
    li $t0, 1  # contador

    # Leer el primer n�mero y establecerlo como el menor inicial. Esta secci�n imprime el mensaje para pedir el primer n�mero.
    li $v0, 4
    la $a0, msg_numero
    syscall

    li $v0, 1
    move $a0, $t0
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    #Lee el primer n�mero ingresado por el usuario y lo guarda en $s1 como el menor inicial.
    li $v0, 5
    syscall
    move $s1, $v0  # $s1 = menor

    # Incrementar contador
    addi $t0, $t0, 1

comparar_loop:         #Este es el inicio del bucle principal que pide los n�meros restantes. Imprime el mensaje para pedir cada n�mero, incluyendo el contador actual
    # Pedir n�mero
    li $v0, 4
    la $a0, msg_numero
    syscall

    li $v0, 1
    move $a0, $t0
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    # Lee el n�mero ingresado por el usuario y lo guarda en $t1.
    li $v0, 5
    syscall
    move $t1, $v0  # $t1 = n�mero actual

    # Compara el n�mero actual con el menor.
    bge $t1, $s1, no_actualizar    #Si el n�mero actual es mayor o igual al menor, salta a no_actualizar.
    move $s1, $t1                  #Si no, actualiza el menor con el n�mero actual.

no_actualizar:
    # Incrementar contador y comparar. Si el contador es menor o igual que la cantidad total, vuelve a "comparar_loop".
    addi $t0, $t0, 1
    ble $t0, $s0, comparar_loop

    # Mostrar resultado. Imprime el mensaje final y el n�mero menor.
    li $v0, 4
    la $a0, msg_menor
    syscall

    li $v0, 1
    move $a0, $s1
    syscall                     #Termina el programa.

    # Salir del programa
    li $v0, 10
    syscall

error_cantidad:             #Esta secci�n se ejecuta si la cantidad ingresada no est� entre 3 y 5.
                            #Imprime un mensaje de error y vuelve al inicio del programa.
    li $v0, 4
    la $a0, msg_error
    syscall
    j main