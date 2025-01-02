#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

// Dichiarazione di yyparse (funzione generata da Bison)
int yyparse();
extern int parsing_result;

// Funzione Lua per chiamare il parser
int l_parse(lua_State *L) {
    const char *input = luaL_checkstring(L, 1); // Prendi l'input da Lua

    // Imposta l'input per il lexer
    extern void yy_scan_string(const char *s);
    yy_scan_string(input);

    // Chiama il parser
    if (yyparse() == 0) { // Se il parsing ha successo
        lua_pushinteger(L, parsing_result); // Restituisci il risultato del parsing
        return 1; // Un valore restituito a Lua
    } else {
        lua_pushnil(L); // Restituisci nil in caso di errore
        lua_pushstring(L, "Errore durante il parsing.");
        return 2; // Due valori restituiti a Lua
    }
}

// Funzione di inizializzazione del modulo Lua
int luaopen_parser(lua_State *L) {
    luaL_Reg functions[] = {
        {"parse", l_parse},
        {NULL, NULL}
    };

    luaL_newlib(L, functions);
    return 1;
}