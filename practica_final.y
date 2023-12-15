%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "list.c"

int yylex(void);
void yyerror (char const *);
int numeroPersonajes;
char* ubicaciones;
char* tiposmision;
char* recompensas;

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
srand(time(NULL));
//N = 0 M = lastpos
//numero = rand () % (N-M+1) + M;

%}

%union{
	char* string;
    int valInt;
}

%token <valInt> NUMEROPERSONAJESINT
%token <string> UBICACION TIPOMISION RECOMPENSA NUMEROPERSONAJES

%start S

%%
S:      
    NUMEROPERSONAJES NUMEROPERSONAJESINT UBICACION TIPOMISION RECOMPENSA {
        printf("Numero de personajes: %d\n", $2);
        printf("Ubicacion: %s\n", $3);
        printf("Tipo mision: %s\n", $4);
        numeroPersonajes = $2;
        ubicaciones = $3;
        tiposmision = $4;
        recompensas = $5;
        eliminarEspaciosTabulacionesGuiones(ubicaciones);
        tList ListaUbicaciones = split(ubicaciones);
        printList(ListaUbicaciones);
        eliminarEspaciosTabulacionesGuiones(tiposmision);
        tList ListaTiposMision = split(tiposmision);
        printList(ListaTiposMision);
        eliminarEspaciosTabulacionesGuiones(recompensas);
        tList ListaRecompensas = split(recompensas);
        printList(ListaRecompensas);



        return 0;
    }
    ;
%%

int main(int argc, char *argv[]) {
	extern FILE *yyin;
	yyin = fopen(argv[1], "r");
	yyparse();
	return 0;
}