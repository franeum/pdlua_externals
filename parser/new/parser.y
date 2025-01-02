%{
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include <stdio.h>
#include <stdlib.h>

lua_State *L;  // Dichiarazione della variabile globale L, la quale rappresenta l'interprete Lua

int yylex(void);  // Dichiarazione della funzione yylex
void yyerror(const char* msg);  // Dichiarazione della funzione yyerror
int yy_scan_string(const char* str);  // Dichiarazione di yy_scan_string

struct list {
    int size;
    double* data;
};

%}

%union {
    double num;    // Usato per i numeri
    char* str;     // Usato per le stringhe
    struct list* lst;  // Usato per gestire le liste
}

%token <num> NUMBER
%token <str> STRING
%type <num> expr
%type <str> input
%type <lst> list

%%

input:
    ;

expr:
    NUMBER  { $$ = $1; }
    | STRING { $$ = (double)strtod($1, NULL); }  // converte la stringa in double
    | '[' list ']' {
        lua_newtable(L);
        for (int i = 0; i < $2->size; ++i) {
            lua_pushnumber(L, $2->data[i]);
            lua_rawseti(L, -2, i + 1);  // salva nell'indice della tabella Lua
        }
        $$ = 0.0;  // nessun valore di ritorno specificato
    }
    ;

list:
    expr               { $$ = malloc(sizeof(struct list)); $$->size = 1; $$->data = malloc(sizeof(double)); $$->data[0] = $1; }
    | list expr        { $$ = realloc($$, sizeof(struct list) + sizeof(double) * ($$->size + 1)); 
                         $$->data[$$->size] = $2; $$->size++; }
    ;

%%

int main(void) {
    L = luaL_newstate();  // Crea un nuovo stato Lua
    luaL_openlibs(L);  // Apre le librerie Lua
    yyparse();  // Parsea l'input
    lua_close(L);  // Chiude lo stato Lua
    return 0;
}

void yyerror(const char* msg) {
    fprintf(stderr, "Error: %s\n", msg);
}
