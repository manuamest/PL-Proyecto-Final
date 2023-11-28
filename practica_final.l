
%{
#include <stdlib.h>
#include "practica_final.tab.h"
%}



NumeroPersonajes            [0-9]*
Ubicaciones                 [A-Z|a-z|ñÑáéíóúÁÉÍÓÚ,| \t]+

%%

[ \t\n]+                         { }  
"Número de personajes: "         { yylval.string = strdup(yytext); return NUMEROPERSONAJES;}
{NumeroPersonajes}               { yylval.valInt = atoi(yytext); return NUMERO;}
"Ubicación: "                    { yylval.string = strdup(yytext); return UBICACION;}
{Ubicaciones}                    { yylval.string = strdup(yytext); return NOMBREUBICACION;}

%%


