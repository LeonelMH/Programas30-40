// ==============================================================================
// Archivo     : Pila.s 
// Descripción : Implementar una pila usando un arreglo en ARM64.
// Plataforma  : ARM64 (AArch64) en Raspberry Pi OS (Linux basado en Debian).
// Autor       : Leonel Martinez Huitron
// Matricula   : 22210777
// Fecha       : 10/11/2024
// ==============================================================================

//Equivalente en C#:
//public class Stack
//{
//    private int[] arr;   // Arreglo que almacena los elementos de la pila
//    private int top;     // Índice de la cima de la pila

//    public Stack(int size)
//    {
//        arr = new int[size];  // Inicializar el arreglo con un tamaño dado
//        top = -1;             // La pila está vacía inicialmente
//    }

    // Método para agregar un valor a la pila
//    public void Push(int value)
//    {
//        if (top == arr.Length - 1)  // Verificar si la pila está llena
//        {
//            Console.WriteLine("La pila está llena.");
//            return;
//        }

//        top++;                     // Incrementar el índice de la cima
//        arr[top] = value;           // Almacenar el valor en la cima de la pila
//    }

    // Método para eliminar el valor de la cima de la pila
//    public int Pop()
//    {
//        if (top == -1)  // Verificar si la pila está vacía
//        {
//            Console.WriteLine("La pila está vacía.");
//            return -1;  // Retornar un valor inválido
//        }

//        int value = arr[top];  // Obtener el valor de la cima
//        top--;                 // Decrementar el índice de la cima
//        return value;          // Retornar el valor retirado
//    }

    // Método para ver el valor en la cima sin eliminarlo
//    public int Peek()
//    {
//        if (top == -1)
//        {
//            Console.WriteLine("La pila está vacía.");
//            return -1;
//        }
//        return arr[top];  // Retornar el valor de la cima
//    }

    // Método para verificar si la pila está vacía
//    public bool IsEmpty()
//    {
//        return top == -1;
//    }
//}

//public class Program
//{
//    public static void Main()
//    {
//        Stack stack = new Stack(10);  // Crear una pila con capacidad para 10 elementos

//        stack.Push(5);   // Agregar 5 a la pila
//        stack.Push(10);  // Agregar 10 a la pila
//        stack.Push(20);  // Agregar 20 a la pila

//        Console.WriteLine("Cima de la pila: " + stack.Peek());  // Ver el valor en la cima

//        Console.WriteLine("Pop: " + stack.Pop());  // Eliminar el valor de la cima
//        Console.WriteLine("Pop: " + stack.Pop());  // Eliminar el valor de la cima

//        Console.WriteLine("Cima de la pila después de pop: " + stack.Peek());
//    }
//}


// -------------------------------
// Sección de código
// -------------------------------

.global _start

.section .data
arr:    .space 40               // Arreglo con espacio para 10 enteros (4 bytes cada uno, 4 * 10 = 40 bytes)
top:    .word -1                // Índice de la cima de la pila (comienza en -1, significa que está vacía)
max_size: .word 10              // Tamaño máximo de la pila (10 elementos)

.section .text
_start:
    // Operación PUSH (agregar un valor a la pila)
    ldr x0, =arr                  // Cargar la dirección base del arreglo
    ldr x1, =top                  // Cargar la dirección del índice "top"
    ldr x2, =max_size             // Cargar la dirección de "max_size"
    ldr w2, [x2]                  // Cargar el tamaño máximo de la pila en w2 (10)

    ldr w1, [x1]                  // Cargar el valor de "top" en w1
    add w1, w1, #1                // Incrementar el índice "top" (apunta al siguiente espacio disponible)
    cmp w1, w2                    // Verificar si "top" excede el tamaño máximo
    bge end_push                  // Si "top" >= max_size, no se puede agregar más, salir

    str w1, [x1]                  // Guardar el nuevo valor de "top" en la memoria

    ldr w3, =5                    // El valor a agregar (ejemplo: 5)
    
    // Ahora, el cálculo del desplazamiento debe hacerse en un registro de 64 bits (x1)
    // Usamos x1 como el índice y lo desplazamos 2 bits a la izquierda para calcular el desplazamiento
    str w3, [x0, x1, LSL #2]      // Guardar el valor en el arreglo arr[top] (desplazamiento de 64 bits)

end_push:
    // Operación POP (eliminar el valor de la cima de la pila)
    ldr w1, [x1]                  // Cargar el valor de "top"
    cmp w1, #0                    // Verificar si la pila está vacía
    ble end_pop                   // Si la pila está vacía, salir

    sub w1, w1, #1                // Decrementar el índice "top"
    ldr w3, [x0, x1, LSL #2]      // Cargar el valor de la cima de la pila en w3 (usando desplazamiento de 64 bits)
    str w1, [x1]                  // Actualizar el índice "top"
    
    // En este punto, w3 contiene el valor retirado de la pila.

end_pop:
    mov w0, #0                    // Código de salida 0
    mov x8, #93                   // Número de syscall para exit en Linux ARM64
    svc #0                         // Llamada al sistema para terminar
