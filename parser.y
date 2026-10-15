%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%token ID NUM TYPE IF ELSE WHILE FOR RELOP INC DEC
%right '='
%left '+' '-'
%left '*' '/'

%%
program : stmt_list                 { printf("\nStatus: Syntactically Valid!\n"); }
        ;

stmt_list : stmt stmt_list
          | /* empty */
          ;

stmt : TYPE ID ';'
     | assignment ';'
     | IF '(' cond ')' stmt
     | IF '(' cond ')' stmt ELSE stmt
     | WHILE '(' cond ')' stmt
     | FOR '(' opt_assign ';' opt_cond ';' opt_assign ')' stmt
     | '{' stmt_list '}'
     ;

assignment : ID '=' expr
           | ID INC
           | ID DEC
           ;

opt_assign : assignment
           | TYPE ID '=' expr
           | /* empty */
           ;

opt_cond : cond
         | /* empty */
         ;

cond : expr RELOP expr
     | expr
     ;

expr : expr '+' expr
     | expr '-' expr
     | expr '*' expr
     | expr '/' expr
     | '(' expr ')'
     | ID
     | NUM
     ;
%%

void yyerror(const char *s) {
    printf("\nStatus: Syntax Error (Invalid Syntax)!\n");
    exit(0);
}

int main(void) {
    printf("Enter code:\n");
    yyparse();
    return 0;
}
