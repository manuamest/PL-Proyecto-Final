%{
#include <stdlib.h>
#include "practica_final.tab.h"
%}



NumeroPersonajes            [0-9]*
string                 [A-Za-zñÑáéíóúÁÉÍÓÚ\- \t]+

%%

[ \t\n]+                         { }  
"# Numero de personajes:"         { yylval.string = strdup(yytext); return NUMEROPERSONAJES;}
{NumeroPersonajes}               { yylval.valInt = atoi(yytext); return NUMEROPERSONAJESINT;}
"# Ubicacion:"                    { yylval.string = strdup(yytext); return UBICACION;}
{string}                   { printf("{%s}",yytext); yylval.string = strdup(yytext); return STR;}
"# Tipo mision:"                  { yylval.string = strdup(yytext); return TIPOMISION;}                     
{string}                     { yylval.string = strdup(yytext); return STR;}

%%
