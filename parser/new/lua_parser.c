#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
#include "parser.tab.h"

static int parse(lua_State *L) {
    const char *input = luaL_checkstring(L, 1);
    yy_scan_string(input);
    yyparse();
    return 0;
}

int luaopen_parser(lua_State *L) {
    static const luaL_Reg parser_funcs[] = {
        {"parse", parse},
        {NULL, NULL}
    };
    luaL_newlib(L, parser_funcs);
    return 1;
}
