# MEMORIA PROYECTO FINAL


***Autores: José Manuel Amestoy López, Jordi Núñez Arias***



### GENERADOR DE MISIONES PARA RPGs


**Índice:**
1. Objetivos
2. Ficheros que componen la práctica
3. Instrucciones de compilación/ejecución
4. Descripción del analizador léxico y sintáctico
5. Tratamiento de errores
6. Aclaraciones o comentarios



### 1. Objetivos


El objetivo de este práctica es la realización de un programa que genere misiones para juegos de rol (RPGs).
El usuario proporcionará un archivo en el que irán incluídos datos sobre las misiones (número de personajes,
ubicación, tipo de la misión, recompensa, dificultad y clase de la misión). A partir de este archivo el programa
generará una serie de misiones aleatorias tomando datos del mismo.



### 2. Ficheros que componen la práctica


Los ficheros que componen el proyecto son el **Makefile**, que sirve para compilar y ejecutar el proyecto. Por otra parte está el archivo **practica_final.l**, donde se ha definido los elementos léxicos(tokens) necesarios para tratar el archivo de entrada. Estos tokens son definidos en el archivo **practica_final.y**, donde se define la gramática para la generación de misiones y tratamiento de errores. Por último ser han definido una serie de archivos de prueba para tener en cuenta los diferentes errores que pueden surgir con diferentes archivos de entrada. El archivo **prueba1.txt** contiene un archivo con una sintaxis correcta, **prueba2.txt** es un archivo vacío, y el resto sirven para probar como funciona el programa ante la falta de algún elemento o la introducción de valores incorrectos. 



### 3. Instrucciones de compilación y ejecución


Primero se realiza la comprobación de que todo funciona correctamente ejecutando:

~~~
flex practica_final.l
bison -o practica_final.tab.c practica_final.y -yd -Wcounterexamples
gcc -o practica_final lex.yy.c practica_final.tab.c -lfl -ly
~~~

Para ejecutar el programa sobre un archivo:
~~~

./practica_final < prueba1.txt

~~~

Todo esto está incluído en el Makefile y se ejecutaría mediante el comando: ***make***.



### 4.Descripción del analizador léxico y sintáctico


En el ***analizador léxico*** se define en la sección de declaraciones lo necesario para leer el archivo de entrada: NúmeroPersonajes, string. El primero sirve para reconocer un número entero y el segundo para reconocer cualquier palabra o conjunto de palabras en castellano. En la sección de reglas se permite la introducción de las caracteríscas de las misiones ya mencionadas con anterioridad. 
En el ***analizador sintáctico*** se han definido los tokens y reglas necesarios para reconocer cada una de las partes del archivo de entrada correspondientes a cada una de las características de las misiones a generar. Para cada uno de los tokes se define una variable en la que se guardaran la información correspondiente del archivo de entrada en formato lista (la implementación de las listas está recogida en los archivos list.c y list.h). Se han utilizado las funciones auxiliares **split** y **eliminarEspaciosTabulacionesGuiones** implementadas en c para conseguir guardar la información de las listas en un formato adecuado. La primera sirve para guardar las diferentes lineas del archivo en elementos distintos de la lista y la segunda para eliminar los guiones y los espacios en blanco del archivo original de cada uno de estos elementos.
En el main de este mismo archivo es donde se generan las propias misiones por medio de las selección aleatoria de uno de los elementos de cada una de las listas de características disponibles. Estas misiones generadas serán mostradas en pantalla y guardadas en el archivo misiones.txt que las almacenará en orden de generación y con un número que las identifica.

### 5.Tratamiento de errores

En cuanto al tratamiento de errores se ha comprobado para cada uno de los tokens que está presente en el archivo de entrada, ya que es obligatorio introducir todas las características y además se han introducido errores propios de cada uno de los tokens. Para el número de personajes se comprueba que no sea mayor a 10 y para la dificultad y la clase de la misión se comprueba mediante la función **isInList** que los valores introducidos estén dentro de los valores permitidos para cada uno de ellos.

### 6.Aclaraciones o comentarios



