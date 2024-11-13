// ==============================================================================
// Archivo     : MCD.s
// Descripción : Calcular el Máximo Común Divisor (MCD).
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:
//using System;

//class Program {
//    static void Main() {
//        int a = 48;
//       int b = 18;
        
      
//        while (b != 0) {
//            int temp = b;
//            b = a % b;
//            a = temp;
//        }
        
//        Console.WriteLine("MCD: " + a);
//    }
//}

.global _start                   // Punto de entrada del programa

.section .data
a: .word 48                      // Primer número (48)
b: .word 18                      // Segundo número (18)

.section .text
_start:
    // Cargar los valores iniciales en registros
    ldr x0, =a                   // Cargar la dirección de `a` en x0
    ldr w1, [x0]                 // Cargar el valor de `a` en w1
    ldr x0, =b                   // Cargar la dirección de `b` en x0
    ldr w2, [x0]                 // Cargar el valor de `b` en w2

euclidean_loop:
    cmp w2, #0                   // Comparar b con 0
    beq end                      // Si b es 0, terminar el bucle

    // Calcular el módulo (a % b) y almacenar en w3
    udiv w3, w1, w2              // División entera: w3 = a / b
    msub w3, w3, w2, w1          // Multiplicar y restar: w3 = a - (a / b) * b (resto)

    // Actualizar los valores de a y b para la próxima iteración
    mov w1, w2                   // a = b
    mov w2, w3                   // b = a % b

    b euclidean_loop              // Repetir el bucle

end:
    // El resultado final (MCD) está en w1

    // Syscall para salir con el MCD como código de salida
    mov w0, w1                   // Mover el MCD a w0 para usarlo como código de salida
    mov x8, #93                  // Número de syscall para exit en Linux ARM64
    svc #0                       // Llamada al sistema para terminar
