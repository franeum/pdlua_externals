#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

//compile:
//gcc -shared -fPIC -o myregistry.so test_registry.c -I/usr/include/lua5.4 -L/usr/local/lib -llua5.4

// Funzione per salvare un oggetto nel registro
int save_to_registry(lua_State *L) {
    // L'oggetto da salvare è sullo stack al primo indice
    lua_pushvalue(L, 1); // Duplica l'oggetto
    int ref = luaL_ref(L, LUA_REGISTRYINDEX); // Salva nel registro
    lua_pushinteger(L, ref); // Restituisce il riferimento
    return 1; // Restituisce un risultato (il riferimento)
}

// Funzione per recuperare un oggetto dal registro
int retrieve_from_registry(lua_State *L) {
    int ref = luaL_checkinteger(L, 1); // Riferimento come argomento
    lua_rawgeti(L, LUA_REGISTRYINDEX, ref); // Recupera l'oggetto
    return 1; // Restituisce l'oggetto
}

// Funzione per rimuovere un oggetto dal registro
int remove_from_registry(lua_State *L) {
    int ref = luaL_checkinteger(L, 1); // Riferimento come argomento
    luaL_unref(L, LUA_REGISTRYINDEX, ref); // Libera il riferimento
    return 0; // Nessun valore restituito
}

// Libreria da registrare in Lua
static const struct luaL_Reg registry_funcs[] = {
    {"save", save_to_registry},
    {"retrieve", retrieve_from_registry},
    {"remove", remove_from_registry},
    {NULL, NULL}
};

int luaopen_myregistry(lua_State *L) {
    luaL_newlib(L, registry_funcs); // Crea una libreria Lua
    return 1;
}
