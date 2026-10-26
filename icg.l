%{
#include "y.tab.h"
#include <string.h>
%}

%%
"if"                        { return IF; }
"else"                      { return ELSE; }
"for"                       { return FOR; }
"while"                     { return WHILE; }
[a-zA-Z_][a-zA-Z0-9_]*      { strcpy(yylval.str, yytext); return ID; }
[0-9]+                      { strcpy(yylval.str, yytext); return NUM; }
"<="|">="|"=="|"!="|"<"|">" { strcpy(yylval.str, yytext); return RELOP; }
[ \t\n]+                     ;
.                           { return yytext[0]; }
%%

int yywrap() { return 1; }
