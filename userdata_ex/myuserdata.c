#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

// Struttura del userdata per memorizzare il riferimento a una tabella Lua
typedef struct {
    int ref; // Riferimento alla tabella Lua nei registri
} MyUserData;

// Funzione per convertire una tabella Lua in un userdata
static int convert_to_userdata(lua_State *L) {
    // Controlla che il primo argomento sia una tabella
    luaL_checktype(L, 1, LUA_TTABLE);

    // Crea il userdata
    MyUserData *ud = (MyUserData *)lua_newuserdata(L, sizeof(MyUserData));

    // Memorizza la tabella Lua nei registri e salva il riferimento
    lua_pushvalue(L, 1); // Duplica la tabella sulla cima dello stack
    ud->ref = luaL_ref(L, LUA_REGISTRYINDEX); // Salva nei registri

    // Imposta una metatabella per il userdata
    luaL_getmetatable(L, "MyUserDataMeta");
    lua_setmetatable(L, -2);

    return 1; // Restituisce il userdata
}

// Funzione per convertire un userdata in una tabella Lua
static int userdata_to_table(lua_State *L) {
    // Controlla che il primo argomento sia un userdata valido
    MyUserData *ud = (MyUserData *)luaL_checkudata(L, 1, "MyUserDataMeta");

    // Recupera la tabella Lua dai registri
    lua_rawgeti(L, LUA_REGISTRYINDEX, ud->ref);

    return 1; // Restituisce la tabella
}

// Garbage collector per rimuovere il riferimento
static int userdata_gc(lua_State *L) {
    MyUserData *ud = (MyUserData *)luaL_checkudata(L, 1, "MyUserDataMeta");

    // Rimuove il riferimento dalla tabella dei registri
    luaL_unref(L, LUA_REGISTRYINDEX, ud->ref);

    return 0; // Non restituisce nulla
}

// Registrazione delle funzioni nel modulo
int luaopen_myuserdata(lua_State *L) {
    // Creare una metatabella per il userdata
    luaL_newmetatable(L, "MyUserDataMeta");

    // Aggiungere il garbage collector
    lua_pushcfunction(L, userdata_gc);
    lua_setfield(L, -2, "__gc");

    // Imposta la metatabella come __index per metodi futuri (se servono)
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");

    // Registrare le funzioni globali
    lua_register(L, "convert_to_userdata", convert_to_userdata);
    lua_register(L, "userdata_to_table", userdata_to_table);

    return 0;
}