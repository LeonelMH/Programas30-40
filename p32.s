// ==============================================================================
// Archivo     : Potencia.s 
// Descripción : Calcular la potencia x^n usando ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:
//using System;

//class Program {
//    static void Main() {
//        int x = 3;  // Base
//        int n = 4;  // Exponente
//        int result = 1;

        // Calcular x^n mediante multiplicación repetida
//        for (int i = 0; i < n; i++) {
//            result *= x;
//        }
        
//        Console.WriteLine("Resultado: " + result);  // Debería ser 3^4 = 81
//    }
//}

// -------------------------------
// Sección de código
// -------------------------------

.global _start                   // Punto de entrada del programa

.section .data
x: .word 3                       // Base (x)
n: .word 4                       // Exponente (n)

.section .text
_start:
    // Cargar valores iniciales en registros
    ldr x0, =x                   // Cargar la dirección de `x` en x0
    ldr w1, [x0]                 // Cargar el valor de `x` (base) en w1
    ldr x0, =n                   // Cargar la dirección de `n` en x0
    ldr w2, [x0]                 // Cargar el valor de `n` (exponente) en w2
    mov w3, #1                   // Inicializar el resultado en 1 (w3 = 1)

    // Comenzar el bucle de multiplicación repetida
power_loop:
    cmp w2, #0                   // Comprobar si el exponente es 0
    beq end                      // Si n == 0, salir del bucle

    mul w3, w3, w1               // Multiplicar el resultado por la base (w3 *= x)
    sub w2, w2, #1               // Decrementar el exponente (n--)
    b power_loop                 // Repetir el bucle

end:
    // El resultado final (x^n) está en w3

    // Syscall para salir con el resultado como código de salida
    mov w0, w3                   // Mover el resultado a w0 para usarlo como código de salida
    mov x8, #93                  // Número de syscall para exit en Linux ARM64
    svc #0                       // Llamada al sistema para terminar