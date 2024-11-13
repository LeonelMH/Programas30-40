// ==============================================================================
// Archivo     : Invertir.s 
// Descripción : Invertir los elementos de un arreglo en ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:
// public static void InvertArray(int[] arr)
// {
//     int left = 0;
//     int right = arr.Length - 1;
//     
//     while (left < right)
//     {
//         // Intercambiar arr[left] y arr[right]
//         int temp = arr[left];
//         arr[left] = arr[right];
//         arr[right] = temp;
//         
//         left++;
//         right--;
//     }
// }

// -------------------------------
// Sección de código
// -------------------------------

.global _start

.section .data
arr:    .word 3, 5, 7, 9, 11          // Arreglo de enteros
length: .word 5                       // Longitud del arreglo (5 elementos)

.section .text
_start:
    ldr x0, =arr                      // Cargar la dirección del arreglo en x0
    ldr x1, =length                   // Cargar la dirección de `length` en x1
    ldr w1, [x1]                      // Cargar la longitud del arreglo en w1
    sub w1, w1, #1                    // w1 = length - 1 (índice del último elemento)
    mov x2, #0                        // Inicializar el índice inicial (x2 = 0)
    mov x3, x1                        // Inicializar el índice final (x3 = length - 1)

reverse_loop:
    cmp x2, x3                        // Comparar los índices
    bge end_reverse                   // Si x2 >= x3, hemos terminado

    // Intercambiar los elementos arr[x2] y arr[x3]
    ldr w4, [x0, x2, LSL #2]          // Cargar arr[x2] en w4
    ldr w5, [x0, x3, LSL #2]          // Cargar arr[x3] en w5
    str w5, [x0, x2, LSL #2]          // Guardar w5 (arr[x3]) en arr[x2]
    str w4, [x0, x3, LSL #2]          // Guardar w4 (arr[x2]) en arr[x3]

    add x2, x2, #1                    // Incrementar el índice inicial (x2 = x2 + 1)
    sub x3, x3, #1                    // Decrementar el índice final (x3 = x3 - 1)

    b reverse_loop                    // Repetir el bucle

end_reverse:
    // Los elementos están invertidos en el arreglo
    // Terminamos el programa

    mov w0, #0                        // Código de salida 0
    mov x8, #93                       // Número de syscall para exit en Linux ARM64
    svc #0                            // Llamada al sistema para terminar
