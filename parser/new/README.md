gcc -shared -o parser.so parser.tab.c lex.yy.c lua_parser.c -L/usr/lib/x86_64-linux-gnu -I/usr/include/lua5.4 -llua5.4 -lfl -fPIC



bison -d -o parser.tab.c parser.y
flex -o lex.yy.c lexer.l
gcc -Wall -shared -o parser.so parser.tab.c lex.yy.c lua_parser.c -I/usr/include/lua5.4 -L/usr/lib/x86_64-linux-gnu -llua5.4 -fPIC -lfl -lm