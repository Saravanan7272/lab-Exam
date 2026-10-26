%{
#include "y.tab.h"
%}

%%
"int"|"float"|"char"       { return TYPE; }
"if"                       { return IF; }
"else"                     { return ELSE; }
"for"                      { return FOR; }
"while"                    { return WHILE; }
"++"                       { return INC; }
"--"                       { return DEC; }
[a-zA-Z_][a-zA-Z0-9_]*     { return ID; }
[0-9]+                     { return NUM; }
"<="|">="|"=="|"!="|"<"|">" { return RELOP; }
[ \t\n]+                   ;
.                          { return yytext[0]; }
%%

int yywrap() { return 1; }
