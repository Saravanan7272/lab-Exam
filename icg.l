%{
#include "y.tab.h"
#include <string.h>
%}

%%
"for"                       { return FOR; }
"while"                     { return WHILE; }
"if"                        { return IF; }
"else"                      { return ELSE; }
"<="|">="|"=="|"!="|"<"|">" { strcpy(yylval.str, yytext); return RELOP; }
[a-zA-Z_][a-zA-Z0-9_]*      { strcpy(yylval.str, yytext); return ID; }
[0-9]+                      { strcpy(yylval.str, yytext); return NUM; }
[ \t\n]                     ;
.                           { return yytext[0]; }
%%

int yywrap(void) { return 1; }
