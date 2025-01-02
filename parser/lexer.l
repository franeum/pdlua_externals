%{
#include "parser.tab.h"  // Include il file generato da Bison
#include <stdio.h>
%}

/* Regole del lexer */
%%
[0-9]+        { yylval.intval = atoi(yytext); return NUMBER; }  // Usa 'intval' per yylval
[ \t\n]+      { /* Ignora spazi e newline */ }
"("           { return '('; }
")"           { return ')'; }
"+"           { return '+'; }
"-"           { return '-'; }
"*"           { return '*'; }
"/"           { return '/'; }
.             { fprintf(stderr, "Token non riconosciuto: %s\n", yytext); return 0; }
%%
