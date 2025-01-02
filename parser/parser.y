%{
#include <stdio.h>
#include <stdlib.h>

// Variabile globale per il risultato del parsing
int parsing_result;

// Funzione di errore
void yyerror(const char *msg);
%}

/* Dichiarazione dell'unione per i tipi */
%union {
    int intval; // Usato per rappresentare numeri interi
}

/* Dichiarazione dei token */
%token <intval> NUMBER

/* Associazione degli operatori */
%left '+' '-'
%left '*' '/'
%right UMINUS

/* Tipo delle regole */
%type <intval> expr

%%
/* Regola principale */
expr:
    NUMBER            { $$ = $1; parsing_result = $$; }  /* Numero */
  | expr '+' expr     { $$ = $1 + $3; parsing_result = $$; } /* Somma */
  | expr '-' expr     { $$ = $1 - $3; parsing_result = $$; } /* Sottrazione */
  | expr '*' expr     { $$ = $1 * $3; parsing_result = $$; } /* Moltiplicazione */
  | expr '/' expr     { 
                        if ($3 == 0) {
                            yyerror("Divisione per zero");
                            YYABORT;
                        }
                        $$ = $1 / $3; 
                        parsing_result = $$;
                      } /* Divisione */
  | '(' expr ')'      { $$ = $2; parsing_result = $$; } /* Parentesi */
  | '-' expr %prec UMINUS { $$ = -$2; parsing_result = $$; } /* Negazione unaria */
;

%%

/* Funzione di errore */
void yyerror(const char *msg) {
    fprintf(stderr, "Errore di sintassi: %s\n", msg);
}
