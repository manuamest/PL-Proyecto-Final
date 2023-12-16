%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "list.c"
#include <time.h>

int yylex(void);
void yyerror (char const *);
int numeroMision = 0;
int numeroPersonajes;
char* ubicaciones;
char* tiposmision;
char* recompensas;
char* dificultad;
char* clasificaion;

//++++++++++++++++++++++++++++++++++++++++++++++++PARTE DE LISTAS++++++++++++++++++++++++++++++++++++++++++++++++

void printList(tList L) {
    tPosL pos;

    printf("[ ");
    for (pos = first(L); pos != LNULL; pos = next(pos, L)) {
        printf("%s", getItem(pos, L));

        // Coma y espacio si no es el último elemento
        if (next(pos, L) != LNULL) {
            printf(", ");
        }
    }
    printf(" ]\n");
}

tList split(const char *input) {
    tList result;
    createEmptyList(&result);

    tPosL lastPos = LNULL;
    char *copy = strdup(input);  // Duplicar el string para no modificar el original
    char *token = strtok(copy, "\n");
    
    // Iterar sobre los tokens y agregarlos a la lista
    while (token != NULL) {
        insertItem(token, last(result), &result);
        lastPos = next(lastPos, result);
        token = strtok(NULL, "\n");
    }

    //free(copy);  // No se puede hacer este free pq te cargas el resultado xd

    return result;
}
void eliminarEspaciosTabulacionesGuiones(char *cadena) {
    // Obtener la longitud de la cadena
    size_t longitud = strlen(cadena);

    // Índice para recorrer la cadena original
    int indiceOriginal = 0;

    // Índice para construir la nueva cadena sin espacios, tabulaciones y guiones
    int indiceNueva = 0;

    while (indiceOriginal < longitud) {
        // Verificar si el carácter actual no es espacio, tabulación ni guión
        if (cadena[indiceOriginal] != ' ' && cadena[indiceOriginal] != '\t' && cadena[indiceOriginal] != '-') {
            // Si no es ninguno de los caracteres a eliminar, copiarlo a la nueva cadena
            cadena[indiceNueva] = cadena[indiceOriginal];
            indiceNueva++;
        }

        // Mover al siguiente carácter en la cadena original
        indiceOriginal++;
    }

    // Establecer el carácter nulo al final de la nueva cadena
    cadena[indiceNueva] = '\0';
}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++PARTE DE RANDOM+++++++++++++++++++++++++++++++++++++++++++++

//N = 0 M = lastpos
//numero = rand () % (N-M+1) + M;

tItemL obtenerElementoAleatorio(tList L) {
    if (isEmptyList(L)) {
        return 0;
    }

    // Genera un índice aleatorio entre el primer y último elemento de la lista
    tPosL indiceAleatorio = (rand() % (last(L) - first(L) + 1) + first(L));

    // Utiliza findItem para recuperar el elemento en el índice aleatorio
    return getItem(indiceAleatorio, L);
}

%}

%union{
	char* string;
    int valInt;
}

%token <valInt> NUMEROPERSONAJESINT
%token <string> UBICACION TIPOMISION RECOMPENSA NUMEROPERSONAJES DIFICULTAD CLASIFICACION

%start S

%%
S:      
    NUMEROPERSONAJES NUMEROPERSONAJESINT UBICACION TIPOMISION RECOMPENSA DIFICULTAD CLASIFICACION {
        printf("Numero de personajes: %d\n", $2);
        printf("Ubicacion: %s\n", $3);
        printf("Tipo mision: %s\n", $4);
        numeroPersonajes = $2;
        ubicaciones = $3;
        tiposmision = $4;
        recompensas = $5;
        dificultad = $6;
        clasificaion = $7;
        eliminarEspaciosTabulacionesGuiones(ubicaciones);
        tList ListaUbicaciones = split(ubicaciones);
        printList(ListaUbicaciones);
        eliminarEspaciosTabulacionesGuiones(tiposmision);
        tList ListaTiposMision = split(tiposmision);
        printList(ListaTiposMision);
        eliminarEspaciosTabulacionesGuiones(recompensas);
        tList ListaRecompensas = split(recompensas);
        printList(ListaRecompensas);
        eliminarEspaciosTabulacionesGuiones(dificultad);
        tList ListaDificultad = split(dificultad);
        printList(ListaDificultad);
        eliminarEspaciosTabulacionesGuiones(clasificaion);
        tList ListaClasificacion = split(clasificaion);
        printList(ListaClasificacion);
        //printf("%s", obtenerElementoAleatorio(ListaUbicaciones));

        /*
        PRINTF PARA CREAR MISIONES
        */

        // Obtener ubicación aleatoria
        char* ubicacionAleatoria = obtenerElementoAleatorio(ListaUbicaciones);

        // Obtener tipo de misión aleatoria
        char* tipoMisionAleatoria = obtenerElementoAleatorio(ListaTiposMision);

        // Obtener recompensa aleatoria
        char* recompensaAleatoria = obtenerElementoAleatorio(ListaRecompensas);

        // Obtener dificultad aleatoria
        char* dificultadAleatoria = obtenerElementoAleatorio(ListaDificultad);
    
        // Obtener clasificación aleatoria
        char* clasificacionAleatoria = obtenerElementoAleatorio(ListaClasificacion);
        
        // Leer archivo
        FILE *archivo_lectura = fopen("misiones.txt", "r");
        if (archivo_lectura != NULL) {
            
            fseek(archivo_lectura, -2, SEEK_END);  // Ir al final del archivo

            // Retroceder hasta encontrar el primer salto de línea
            while (fgetc(archivo_lectura) != '\n') {
                if (ftell(archivo_lectura) == 1) {
                    // Si no hay salto de línea y estamos al principio del archivo,
                    // intentamos buscar al principio después de esperar 0.1 segundos
                    fclose(archivo_lectura);
                    usleep(100000);  // 0.1 segundos en microsegundos
                    archivo_lectura = fopen("misiones.txt", "r");
                    break;
                }
                fseek(archivo_lectura, -2, SEEK_CUR);
            }

            // Leer el último número de misión
            fscanf(archivo_lectura, "#%03d", &numeroMision);
            fclose(archivo_lectura);
        }

        numeroMision++;

        // Guardar información en un archivo
        FILE *archivo = fopen("misiones.txt", "a");
        fprintf(archivo, "#%03d %s, dificultad %s: %s en %s\n", numeroMision, clasificacionAleatoria, dificultadAleatoria, tipoMisionAleatoria, ubicacionAleatoria);
        fclose(archivo);

        // Imprimir cabecera de la misión
        printf("#%03d %s, dificultad %s: %s en %s\n", numeroMision, clasificacionAleatoria, dificultadAleatoria, tipoMisionAleatoria, ubicacionAleatoria);

        // Construir párrafo de misión
        printf("¡Atención aventureros!\n");
        printf("Una nueva misión ha surgido en la %s. Se recomiendan ir en un grupo de al menos %d personas.\n", ubicacionAleatoria, numeroPersonajes);

        // Agregar detalles según el tipo de misión
        if (strcmp(tipoMisionAleatoria, "Eliminacion") == 0) {
            printf("Se requiere la eliminación de una amenaza enemiga. \n");
        } else if (strcmp(tipoMisionAleatoria, "Rescate") == 0) {
            printf("Un grupo de personas necesita ser rescatado de una situación peligrosa. \n");
        } else if (strcmp(tipoMisionAleatoria, "Tesoro") == 0) {
            printf("Un valioso tesoro ha sido descubierto y está esperando a ser reclamado. \n");
        } else {
            printf("Se requiere de ayuda para completar un %s\n", tipoMisionAleatoria);
        }

        // Agregar información sobre la recompensa
        printf("A cambio de completar esta misión, se ofrece una recompensa: %s.\n", recompensaAleatoria);
        printf("¡Buena suerte en tu viaje!\n");

        //TODO:Añadir gestion de errores

        return 0;
    }
    | error {
        printf("A");
    }
    ;
%%

int main(int argc, char *argv[]) {
    srand(time(NULL));
	extern FILE *yyin;
	yyin = fopen(argv[1], "r");
	yyparse();
	return 0;
}