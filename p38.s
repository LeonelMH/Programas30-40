// ==============================================================================
// Archivo     : Colas.s 
// Descripción : Implementar una cola usando un arreglo en ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:


// -------------------------------
// Sección de código
// -------------------------------

.global _start

.section .data
arr:        .space 40                // Arreglo con espacio para 10 enteros (4 bytes cada uno, 4 * 10 = 40 bytes)
front:      .word 0                  // Índice del frente de la cola
rear:       .word 0                  // Índice del final de la cola
max_size:   .word 10                 // Tamaño máximo de la cola (10 elementos)

.section .text
_start:
    // Operación Enqueue (agregar un valor a la cola)
    ldr x0, =arr                    // Cargar la dirección base del arreglo
    ldr x1, =front                  // Cargar la dirección del índice "front"
    ldr x2, =rear                   // Cargar la dirección del índice "rear"
    ldr x3, =max_size               // Cargar la dirección de "max_size"
    
    ldr w4, [x1]                    // Cargar el valor de "front" en w4
    ldr w5, [x2]                    // Cargar el valor de "rear" en w5
    ldr w6, [x3]                    // Cargar el tamaño máximo de la cola en w6
    
    cmp w5, w4                      // Comparar "front" con "rear"
    beq queue_empty                 // Si están iguales, la cola está vacía
    
    add w5, w5, #1                  // Incrementar el índice de "rear"
    cmp w5, w6                      // Comparar "rear" con "max_size"
    bge queue_full                  // Si "rear" >= "max_size", la cola está llena
    
    str w5, [x2]                    // Actualizar el índice "rear"
    
    ldr w7, =5                       // El valor a agregar (ejemplo: 5)
    str w7, [x0, x5, LSL #2]         // Guardar el valor en el arreglo arr[rear] (desplazamiento de 64 bits)

queue_full:
    // Salir si la cola está llena, código de salida 1
    mov w0, #1
    mov x8, #93
    svc #0

queue_empty:
    // Operación Dequeue (eliminar un valor de la cola)
    ldr w4, [x1]                    // Cargar el valor de "front"
    ldr w5, [x2]                    // Cargar el valor de "rear"
    
    cmp w4, w5                      // Comparar "front" con "rear"
    beq end_program                 // Si son iguales, la cola está vacía, salir
    
    ldr w8, [x0, x4, LSL #2]        // Cargar el valor de la cima de la cola en w8
    add w4, w4, #1                  // Incrementar el índice "front"
    cmp w4, w6                      // Comparar "front" con "max_size"
    bge reset_front                 // Si "front" >= "max_size", reiniciar a 0
    
    str w4, [x1]                    // Actualizar el índice "front"
    
    // El valor de la cima de la cola está ahora en w8 (lo que hemos "desencolado")
    
reset_front:
    mov w4, #0                      // Resetear "front" a 0
    str w4, [x1]                    // Guardar el valor de "front"
    
end_program:
    mov w0, #0                      // Código de salida 0
    mov x8, #93                     // Número de syscall para exit en Linux ARM64
    svc #0                           // Llamada al sistema para terminar
