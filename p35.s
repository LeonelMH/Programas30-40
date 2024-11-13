// ==============================================================================
// Archivo     : Rotacion.s 
// Descripción : 	Rotación de un arreglo (izquierda/derecha) en ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:

//public static void RotateRight(int[] arr, int k)
//{
//    int n = arr.Length;
//   k = k % n;  // Asegurarse de que k esté dentro del rango de la longitud del arreglo

    // Rotación a la derecha
//    for (int i = 0; i < k; i++)
//    {
//        int last = arr[n - 1];  // Último elemento
//        for (int j = n - 1; j > 0; j--)
//        {
//            arr[j] = arr[j - 1];  // Desplazar elementos hacia la derecha
//        }
//        arr[0] = last;  // Colocar el último elemento en el primer lugar
//    }
//}

// -------------------------------
// Sección de código
// -------------------------------

.global _start

.section .data
arr:    .word 3, 5, 7, 9, 11          // Arreglo de enteros
length: .word 5                       // Longitud del arreglo (5 elementos)
k:      .word 1                       // Número de posiciones a rotar (k = 1)

.section .text
_start:
    ldr x0, =arr                      // Cargar la dirección del arreglo en x0
    ldr x1, =length                   // Cargar la dirección de `length` en x1
    ldr w1, [x1]                      // Cargar la longitud del arreglo en w1
    ldr x2, =k                        // Cargar la dirección de `k` en x2
    ldr w2, [x2]                      // Cargar el número de posiciones a rotar (k) en w2

    // Asegurarnos de que k esté dentro de los límites de longitud
    udiv w3, w2, w1                    // w3 = k / length
    mul w3, w3, w1                     // w3 = (k / length) * length
    sub w2, w2, w3                     // w2 = k % length (número de posiciones a rotar efectivas)

    // Rotar a la derecha: copiar arr[length - k] a arr[0], arr[length - k + 1] a arr[1], etc.
    sub w4, w1, w2                     // w4 = length - k (índice de inicio para la rotación)
    mov x3, #0                         // Índice para recorrer el arreglo desde 0
    add x5, x0, x3, LSL #2             // Dirección del primer elemento (arr[0])
    ldr w6, [x5]                       // Cargar arr[0] en w5

    // Bucle para realizar la rotación
rotate_loop:
    cmp x3, x4                         // Comparar si hemos recorrido el arreglo
    bge end_rotate                     // Si hemos recorrido todo, terminar

    // Mover arr[i] a arr[i+1]
    ldr w7, [x0, x3, LSL #2]           // Cargar arr[x3] en w6
    str w7, [x0, x3, LSL #2]           // Guardar arr[x3] en arr[x3+1]

    add x3, x3, #1                     // Avanzar índice (x3 = x3 + 1)
    b rotate_loop                      // Repetir el bucle

end_rotate:
    mov w0, #0                         // Código de salida 0
    mov x8, #93                        // Número de syscall para exit en Linux ARM64
    svc #0                             // Llamada al sistema para terminar
