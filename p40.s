// ==============================================================================
// Archivo     : BinarioDecimal.s 
// Descripción : Convertir binario a decimal en ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:

// Función para convertir binario a decimal
//int BinarioADecimal(int binario)
//{
//    int decimal = 0;   // Inicializamos el acumulador decimal
//    int factor = 1;    // Factor de multiplicación por 2 (equivalente al desplazamiento lógico)

//    while (binario > 0)  // Mientras haya bits por procesar
//    {
//        int bit = binario & 1;  // Obtenemos el bit menos significativo (0 o 1)
//        decimal += bit * factor; // Sumamos el bit multiplicado por su peso (factor)
//        binario >>= 1;  // Desplazamos el número binario a la derecha (dividimos entre 2)
//        factor *= 2;    // Multiplicamos el factor por 2 para la siguiente posición
//    }

//    return decimal;   // El resultado decimal
//}
// -------------------------------
// Sección de código
// -------------------------------

.global _start

.section .text
_start:
    // Número binario en formato de bits (ejemplo: 1101 = decimal 13)
    mov w0, #0b1101         // El número binario 1101 (13 en decimal)
    
    // Llamar a la función de conversión
    bl binario_a_decimal

    // Terminar el programa
    mov w0, #0              // Código de salida 0
    mov x8, #93             // Número de syscall para exit en Linux ARM64
    svc #0

// Función para convertir binario a decimal
binario_a_decimal:
    mov w1, #0              // Inicializamos el acumulador a 0
    mov w2, #1              // Inicializamos el bit shift a 1 (equivalente al factor de 2)
    
convertir_loop:
    cmp w0, #0              // Comprobamos si el número binario es 0
    beq fin_conversion      // Si es 0, terminamos el bucle

    lsr w3, w0, #1          // Realizamos un desplazamiento lógico a la derecha (dividimos entre 2)
    and w4, w0, #1          // Obtenemos el bit menos significativo (0 o 1)
    add w1, w1, w4          // Sumamos el bit al acumulador
    lsl w1, w1, #1          // Desplazamos el acumulador a la izquierda (equivalente a multiplicar por 2)

    mov w0, w3              // Colocamos el número desplazado en w0 para la siguiente iteración
    b convertir_loop         // Continuamos con la siguiente iteración

fin_conversion:
    ret                      // Retornamos, el valor decimal está en w1
