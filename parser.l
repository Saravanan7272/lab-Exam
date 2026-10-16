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
[0-9]+                     { return NUM; }
[a-zA-Z_][a-zA-Z0-9_]*     { return ID; }
"<="|">="|"=="|"!="|"<"|">" { return RELOP; }
[ \t\n]+                   ;
.                          { return yytext[0]; }
%%

int yywrap() { return 1; }
