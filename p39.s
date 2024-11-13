// ==============================================================================
// Archivo     : DecimalBinario.s 
// Descripción : Convertir decimal a binario en ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:

/7using System;

//public class ConversionDecimalABinario
//{
//    public static void DecimalABinario(int num)
//    {
//        if (num > 1)
//        {
//            DecimalABinario(num / 2);  // Llamada recursiva
//        }
//        Console.Write(num % 2);  // Imprime el resto (0 o 1)
//    }

//    public static void Main()
//    {
//        int numero = 13;  // Número a convertir
//        Console.Write("El número en binario es: ");
//        DecimalABinario(numero);
//        Console.WriteLine();
//    }
//}


// -------------------------------
// Sección de código
// -------------------------------

.global _start

.section .text
_start:
    mov w0, #13          // Número a convertir (decimal 13)
    bl decimal_a_binario // Llamar a la función para convertir a binario

    // Salir del programa
    mov w0, #0           // Código de salida 0
    mov x8, #93          // Número de syscall para exit en Linux ARM64
    svc #0

// Función para convertir decimal a binario
decimal_a_binario:
    cmp w0, #0           // Comparar el número con 0
    beq fin_conversion   // Si es 0, terminamos

    // Llamada recursiva
    mov w1, w0           // Copiar el número a w1
    lsr w1, w1, #1       // Dividir el número entre 2 (equivalente a udiv w1, w1, #2)
    bl decimal_a_binario // Llamar de nuevo a la función para la división

    // Imprimir el resto (0 o 1)
    and w2, w0, #1       // Obtener el resto de la división (0 o 1)
    add w0, w2, #48      // Convertir a carácter ASCII ('0' o '1') en w0
    mov x8, #64          // Número de syscall para write
    mov x1, x0           // Dirección del carácter
    mov x2, #1           // Tamaño de un byte
    svc #0

fin_conversion:
    ret                   // Retornar al programa principal
