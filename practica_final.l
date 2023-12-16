%{
#include <stdlib.h>
#include "practica_final.tab.h"
%}


NumeroPersonajes            [0-9]*
string                 [A-Za-zñÑáéíóúÁÉÍÓÚ\- \t\n]+

%%

[ \t\n]+                            { }  
"# Numero de personajes:"           { yylval.string = strdup(yytext); return NUMEROPERSONAJES;}
{NumeroPersonajes}                  { yylval.valInt = atoi(yytext); return NUMEROPERSONAJESINT;}            
"# Ubicacion\n"{string}             { yylval.string = strdup(yytext + 12); return UBICACION; }
"# Tipo mision\n"{string}           { yylval.string = strdup(yytext + 14); return TIPOMISION; }
"# Recompensa\n"{string}            { yylval.string = strdup(yytext + 12); return RECOMPENSA; }
"# Dificultad\n"{string}            { yylval.string = strdup(yytext + 12); return DIFICULTAD; }
"# Clasificacion mision\n"{string}  { yylval.string = strdup(yytext + 23); return CLASIFICACION; }

%%