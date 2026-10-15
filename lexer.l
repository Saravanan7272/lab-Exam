%{
#include <stdio.h>
%}

%%
"int"|"float"|"char"|"if"|"else"|"while"|"for"     { printf("<KEYWORD, %s>\n", yytext); }
[a-zA-Z_][a-zA-Z0-9_]*                             { printf("<ID, %s>\n", yytext); }
[0-9]+(\.[0-9]+)?                                  { printf("<NUM, %s>\n", yytext); }
"++"|"--"|"+"|"-"|"*"|"/"|"="|"<="|">="|"=="|"<"|">" { printf("<OP, %s>\n", yytext); }
[;,(){}]                                           { printf("<PUNCT, %s>\n", yytext); }
[ \t\n]+                                           ; /* ignore whitespace */
.                                                  { printf("<UNKNOWN, %s>\n", yytext); }
%%

int yywrap() { return 1; }

int main() {
    yylex();
    return 0;
}
