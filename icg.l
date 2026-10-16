%{
#include "y.tab.h"
#include <string.h>
%}

%%
"if"                        { return IF; }
"else"                      { return ELSE; }
"for"                       { return FOR; }
"while"                     { return WHILE; }
[0-9]+                      { strcpy(yylval.str, yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]*      { strcpy(yylval.str, yytext); return ID; }
"<="|">="|"=="|"!="|"<"|">" { strcpy(yylval.str, yytext); return RELOP; }
[ \t\n]                     ;
.                           { return yytext[0]; }
%%

int yywrap(void) { return 1; }
