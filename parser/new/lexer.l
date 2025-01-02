%{
#include "parser.tab.h"
#include <stdlib.h>
%}

%%

[0-9]+            { yylval.num = atof(yytext); return NUMBER; }
\"[^\"]*\"        { yylval.str = strdup(yytext); return STRING; }
[ \t\n\r]+         { /* ignora spazi, tabulazioni e nuove righe */ }
.                  { return yytext[0]; }

%%
