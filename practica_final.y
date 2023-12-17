%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "list.c"
#include <time.h>
#include <unistd.h>

int yylex(void);
void yyerror (char const *);
int numeroMision = 0;
int numeroPersonajes;
char* ubicaciones;
char* tiposmision;
char* recompensas;
char* dificultad;
char* clasificacion;
tList ListaUbicaciones;
tList ListaTiposMision;
tList ListaDificultad;
tList ListaRecompensas;
tList ListaClasificacion;

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

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++MANEJO DE CONTENIDO DE LISTAS+++++++++++++++++++++++++++++++++++++
char* dificultades_validas[] = {"Facil", "Moderada", "Dificil", "Experto", "Legendario"};
char* clasificaciones_validas[] = {"Principal", "Secundaria", "Gremio", "Eventoespecial"};

// Función auxiliar para comprobar si un elemento está en la lista
bool isInList(char* elemento, tList lista) {
    tPosL p;
    for (p = first(lista); p != LNULL; p = next(p, lista)) {
        if (strcmp(getItem(p, lista), elemento) == 0) {
            return true;
        }
    }
return false;
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
    numeropersonajes ubicacion tipomision recompensa dificultad clasificacion {
        printf("La sintaxis del archivo de entrada es correcta. El resultado es:\n");
    }
    | error {
        printf("Error, el archivo de entrada debe seguir el formato:\n# Numeropersonajes:\n# Ubicacion\n# Tipomision\n# Recompensa\n# Dificultad\n# Clasificacion\n");
        exit(3);
    }
    ;

numeropersonajes: 
     NUMEROPERSONAJES NUMEROPERSONAJESINT {
        numeroPersonajes = $2;
        if(numeroPersonajes > 10){
            printf("El número de personajes no puede ser mayor que 10\n");        
            exit(1);
        }
    }
    | NUMEROPERSONAJES {
      printf("Error, es necesario introducir el número de personajes para generar las misiones\n");
      exit(2);
    };

ubicacion:  
    {
      printf("Error, es necesario introducir las ubicaciones para generar las misiones\n");
      exit(2);
    }
    | UBICACION {
        ubicaciones = $1;
        eliminarEspaciosTabulacionesGuiones(ubicaciones);
        ListaUbicaciones = split(ubicaciones);
    };

tipomision:
    {
      printf("Error, es necesario introducir el tipo de la misión para generar las misiones\n");
      exit(2);
    }
    | TIPOMISION {
        tiposmision = $1;
        eliminarEspaciosTabulacionesGuiones(tiposmision);
        ListaTiposMision = split(tiposmision);
    };
recompensa:
    {
        printf("Error, es necesario introducir la recompensa para generar las misiones\n");
        exit(2);

    }
    | RECOMPENSA {
        recompensas = $1;
        eliminarEspaciosTabulacionesGuiones(recompensas);
        ListaRecompensas = split(recompensas);
    };

dificultad:
    {        
        printf("Error, es necesario introducir la dificultad para generar las misiones\n");
        exit(2);
    }
    | DIFICULTAD {
        tList dificultadvalida;
        createEmptyList(&dificultadvalida);
        
        for (int i = 0; i < sizeof(dificultades_validas) / sizeof(dificultades_validas[0]); i++) {
            insertItem(dificultades_validas[i], last(dificultadvalida), &dificultadvalida);
        }

        dificultad = $1;
        eliminarEspaciosTabulacionesGuiones(dificultad);
        ListaDificultad = split(dificultad);
        for (tPosL p = first(ListaDificultad); p != LNULL; p = next(p, ListaDificultad)) {
            if (!isInList(getItem(p, ListaDificultad), dificultadvalida)) {
            printf("Error, la dificultad solo puede ser de estos cinco tipos: Facil, Moderada, Dificil, Experto, Legendario\n");
            exit(1);
            }
        }
    };

clasificacion:
    {
        printf("Error, es necesario introducir la clase de la misión para generar las misiones\n");
        exit(2);
    }
    | CLASIFICACION {
        tList clasificacionvalida;
        createEmptyList(&clasificacionvalida);
        
        for (int i = 0; i < sizeof(clasificaciones_validas) / sizeof(clasificaciones_validas[0]); i++) {
            insertItem(clasificaciones_validas[i], last(clasificacionvalida), &clasificacionvalida);
        }

        clasificacion = $1;
        eliminarEspaciosTabulacionesGuiones(clasificacion);
        ListaClasificacion = split(clasificacion);
        for (tPosL p = first(ListaClasificacion); p != LNULL; p = next(p, ListaClasificacion)) {
            if (!isInList(getItem(p, ListaClasificacion), clasificacionvalida)) {
            printf("Error, la clase de la misión solo puede ser de estos cuatro tipos: Principal, Secundaria, Gremio, Evento especial\n");
            exit(1);
            }
        }
    };
    
%%

int main(int argc, char *argv[]) {
    srand(time(NULL));
	extern FILE *yyin;
	yyin = fopen(argv[1], "r");
	yyparse();
            
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
        printf("Una nueva misión ha surgido en el/la %s. Se recomiendan ir en un grupo de %d personas.\n", ubicacionAleatoria, numeroPersonajes);

        // Agregar detalles según el tipo de misión
        if (strcmp(tipoMisionAleatoria, "Eliminacion") == 0) {
            printf("Se requiere la eliminación de una amenaza enemiga. \n");
        } else if (strcmp(tipoMisionAleatoria, "Rescate") == 0) {
            printf("Un grupo de personas necesita ser rescatado de una situación peligrosa. \n");
        } else if (strcmp(tipoMisionAleatoria, "Tesoro") == 0) {
            printf("Un valioso tesoro ha sido descubierto y está esperando a ser reclamado. \n");
        } else {
            printf("Se requiere de ayuda para completar un/una %s\n", tipoMisionAleatoria);
        }

        // Agregar información sobre la recompensa
        printf("A cambio de completar esta misión, se ofrece una recompensa: %s.\n", recompensaAleatoria);
        printf("¡Buena suerte en tu viaje!\n");

	return 0;
}