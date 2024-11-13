// ==============================================================================
// Archivo     : MCM.s
// Descripción : Calcular el Mínimo Común Múltiplo (MCM).
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:
//using System;

//class Program {
//    static int GCD(int a, int b) {
//        while (b != 0) {
//            int temp = b;
//            b = a % b;
//            a = temp;
//        }
//        return a;
//    }

//    static int LCM(int a, int b) {
//        return Math.Abs(a * b) / GCD(a, b);
//    }

//   static void Main() {
//        int a = 48;
//        int b = 18;
//        Console.WriteLine("MCM: " + LCM(a, b));
//    }
//}

// -------------------------------
// Sección de código
// -------------------------------

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

    // Guardar copias de los valores iniciales de `a` y `b` para calcular el MCM al final
    mov w3, w1                   // Copiar `a` en w3
    mov w4, w2                   // Copiar `b` en w4

    // Calcular el MCD usando el Algoritmo de Euclides
euclidean_loop:
    cmp w2, #0                   // Comparar b con 0
    beq calc_lcm                 // Si b es 0, terminar el bucle y pasar al cálculo del MCM

    // Calcular el módulo (a % b) y almacenar en w5
    udiv w5, w1, w2              // División entera: w5 = a / b
    msub w5, w5, w2, w1          // Multiplicar y restar: w5 = a - (a / b) * b (resto)

    // Actualizar los valores de a y b para la próxima iteración
    mov w1, w2                   // a = b
    mov w2, w5                   // b = a % b

    b euclidean_loop              // Repetir el bucle

calc_lcm:
    // Ahora el MCD está en w1
    // Calcular el MCM: (a * b) / MCD usando los valores en w3 y w4
    mul w5, w3, w4               // Multiplicación de a y b: w5 = a * b
    udiv w6, w5, w1              // División entera: MCM = (a * b) / MCD, almacenar en w6

    // Syscall para salir con el MCM como código de salida
    mov w0, w6                   // Mover el MCM a w0 para usarlo como código de salida
    mov x8, #93                  // Número de syscall para exit en Linux ARM64
    svc #0                       // Llamada al sistema para terminar