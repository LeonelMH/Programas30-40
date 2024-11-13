// ==============================================================================
// Archivo     : Encontrar.s 
// Descripción : Encontrar el segundo elemento más grande en ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:

//public static int FindSecondLargest(int[] arr)
//{
//    int largest = int.MinValue;
//    int secondLargest = int.MinValue;

//    foreach (int num in arr)
//    {
//        if (num > largest)
//        {
//            secondLargest = largest;
//            largest = num;
//        }
//        else if (num > secondLargest && num < largest)
//        {
//            secondLargest = num;
//        }
//    }

//    return secondLargest;
//}

// -------------------------------
// Sección de código
// -------------------------------

.global _start

.section .data
arr:    .word 3, 5, 7, 9, 11         // Arreglo de enteros
length: .word 5                      // Longitud del arreglo (5 elementos)

.section .text
_start:
    ldr x0, =arr                     // Cargar la dirección del arreglo en x0
    ldr x1, =length                  // Cargar la dirección de `length` en x1
    ldr w1, [x1]                     // Cargar la longitud del arreglo en w1
    mov w2, #0                       // Inicializar el valor más grande (w2 = 0)
    mov w3, #0                       // Inicializar el segundo valor más grande (w3 = 0)

    // Comenzar a iterar sobre el arreglo
    mov x4, #0                       // Índice (x4) del primer elemento

find_second_largest:
    cmp x4, x1                       // Comparar índice con la longitud del arreglo
    bge end_find_second_largest      // Si índice >= longitud, salir

    ldr w5, [x0, x4, LSL #2]         // Cargar arr[i] en w5

    // Si arr[i] es mayor que el mayor (w2), actualizar ambos valores
    cmp w5, w2
    ble check_second_largest         // Si arr[i] <= mayor, continuar
    mov w3, w2                       // El segundo más grande es el antiguo mayor
    mov w2, w5                       // El mayor se actualiza a arr[i]
    b next_iteration

check_second_largest:
    // Si arr[i] es mayor que el segundo más grande (w3) y menor que el mayor (w2), actualizar el segundo más grande
    cmp w5, w3
    ble next_iteration               // Si arr[i] <= segundo más grande, continuar
    cmp w5, w2
    bge next_iteration               // Si arr[i] >= mayor, continuar
    mov w3, w5                       // Actualizar el segundo más grande a arr[i]

next_iteration:
    add x4, x4, #1                   // Incrementar el índice (x4 = x4 + 1)
    b find_second_largest            // Repetir el bucle

end_find_second_largest:
    // El segundo más grande se encuentra en w3
    mov w0, w3                        // Mover el segundo más grande a w0 (código de salida)
    mov x8, #93                       // Número de syscall para exit en Linux ARM64
    svc #0                            // Llamada al sistema para terminar