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

%token <string> NUMEROPERSONAJES UBICACION NOMBREUBICACION
%token <valInt> NUMERO

%start S

%%
S:      
    NUMEROPERSONAJES NUMERO UBICACION NOMBREUBICACION{
        printf("Numero de personajes: %d\n", $2);
        printf("Ubicacion: %s\n", $4);

    }
    ;
%%

int main(int argc, char *argv[]) {
	extern FILE *yyin;
	yyin = fopen(argv[1], "r");
	yyparse();
	return 0;
}