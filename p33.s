// ==============================================================================
// Archivo     : SumArray.s 
// Descripción : Sumar los elementos de un arreglo en ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:
//using System;

//class Program {
//    static void Main() {
//        int[] arr = {3, 5, 7, 9, 11};  // Arreglo de ejemplo
//        int suma = 0;

//        for (int i = 0; i < arr.Length; i++) {
//            suma += arr[i];
//        }
        
//        Console.WriteLine("Suma de los elementos: " + suma);  // Debería ser 35
//    }
//}


// -------------------------------
// Sección de código
// -------------------------------


.global _start                   // Punto de entrada del programa

.section .data
arr: .word 3, 5, 7, 9, 11        // Definir un arreglo de enteros
length: .word 5                  // Longitud del arreglo (5 elementos)

.section .text
_start:
    ldr x0, =arr                 // Cargar la dirección del arreglo en x0
    ldr x1, =length              // Cargar la dirección de `length` en x1
    ldr w1, [x1]                 // Cargar el valor de `length` en w1 (usando x1 como dirección base)
    mov x2, #0                   // Inicializar el índice en 0 (x2)
    mov w3, #0                   // Inicializar la suma en 0 (w3)

sum_loop:
    cmp x2, x1                   // Comparar índice con la longitud (ahora x1 es de 64 bits)
    bge end_sum                  // Si índice >= longitud, salir del bucle

    ldr w4, [x0, x2, LSL #2]     // Cargar el elemento arr[i] en w4 (usando x2 como offset de 64 bits)
    add w3, w3, w4               // Sumar el valor al acumulador en w3
    add x2, x2, #1               // Incrementar el índice en 1

    b sum_loop                   // Repetir el bucle

end_sum:
    // El resultado final (suma de elementos) está en w3

    // Syscall para salir con la suma como código de salida
    mov w0, w3                   // Mover la suma a w0 para usarlo como código de salida
    mov x8, #93                  // Número de syscall para exit en Linux ARM64
    svc #0                       // Llamada al sistema para terminar