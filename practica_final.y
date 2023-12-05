%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror (char const *);


%}

%union{
	char* string;
    int valInt;
}

%token <string> NUMEROPERSONAJES UBICACION UBICACIONSTR TIPOMISION TIPOMISIONSTR STR
%token <valInt> NUMEROPERSONAJESINT

%start S

%%
S:      
    NUMEROPERSONAJES NUMEROPERSONAJESINT UBICACION ubicacion TIPOMISION tipomision {
        printf("Numero de personajes: %d\n", $2);
        printf("Ubicacion: \n");
        printf("Tipo mision: \n");
    }
    ;

ubicacion:
     STR {
        printf("%s\n", $1);
    }
    | STR ubicacion {
        printf("%s\n", $1);
    }
    ;

tipomision:
     STR {
        printf("%s\n", $1);

    }
    | STR tipomision {
        printf("%s\n", $1);
    }
    ;
%%

int main(int argc, char *argv[]) {
	extern FILE *yyin;
	yyin = fopen(argv[1], "r");
	yyparse();
	return 0;
}
