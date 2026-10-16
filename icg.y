%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

int label_id = 1;
int temp_id = 1;

char* new_label(void) {
    static char buf[16];
    sprintf(buf, "L%d", label_id++);
    return strdup(buf);
}

char* new_temp(void) {
    static char buf[16];
    sprintf(buf, "t%d", temp_id++);
    return strdup(buf);
}

char l_start[16], l_body[16], l_false[16], l_exit[16];
char incr_code[128];
%}

%union {
    char str[64];
}

%token <str> ID NUM RELOP FOR WHILE IF ELSE
%type <str> expr cond

%nonassoc IFX
%nonassoc ELSE

%right '='
%left '+' '-'
%left '*' '/'

%%
program : stmt_list
        ;

stmt_list : stmt_list stmt
          | stmt
          ;

stmt : ID '=' expr ';' {printf("%s = %s\n", $1, $3);}
     | for_loop
     | while_loop
     | if_stmt
     ;

for_loop : FOR '(' init ';'
           {
               strcpy(l_start, new_label());
               strcpy(l_body, new_label());
               strcpy(l_exit, new_label());
               printf("%s:\n", l_start);
           }
           cond ';'
           {
               printf("if %s goto %s\n", $6, l_body);
               printf("goto %s\n", l_exit);
               printf("%s:\n", l_body);
           }
           incr ')' body
           {
               if (strlen(incr_code) > 0) {
                   printf("%s\n", incr_code);
               }
               printf("goto %s\n", l_start);
               printf("%s:\n", l_exit);
           }
         ;

while_loop : WHILE '('
             {
                 strcpy(l_start, new_label());
                 strcpy(l_body, new_label());
                 strcpy(l_exit, new_label());
                 printf("%s:\n", l_start);
             }
             cond ')'
             {
                 printf("if %s goto %s\n", $4, l_body);
                 printf("goto %s\n", l_exit);
                 printf("%s:\n", l_body);
             }
             body
             {
                 printf("goto %s\n", l_start);
                 printf("%s:\n", l_exit);
             }
           ;

if_stmt : IF '(' cond ')'{
              strcpy(l_body, new_label());
              strcpy(l_exit, new_label());
              printf("if %s goto %s\n", $3, l_body);
              printf("goto %s\n", l_exit);
              printf("%s:\n", l_body);
          }
          body else_part
        ;

else_part : ELSE
            {
                strcpy(l_false, l_exit);
                strcpy(l_exit, new_label());
                printf("goto %s\n", l_exit);
                printf("%s:\n", l_false);
            }
            body
            {
                printf("%s:\n", l_exit);
            }
          | /* empty */ %prec IFX
            {
                printf("%s:\n", l_exit);
            }
          ;

init : ID '=' expr {
         printf("%s = %s\n", $1, $3);
     }
     | /* empty */
     ;

cond : expr RELOP expr {
         sprintf($$, "%s %s %s", $1, $2, $3);
     }
     | expr {
         sprintf($$, "%s != 0", $1);
     }
     | /* empty */ {
         strcpy($$, "1");
     }
     ;

incr : ID '=' ID '+' NUM {
         char *t = new_temp();
         sprintf(incr_code, "%s = %s + %s\n%s = %s", t, $3, $5, $1, t);
     }
     | ID '=' ID '+' ID {
         char *t = new_temp();
         sprintf(incr_code, "%s = %s + %s\n%s = %s", t, $3, $5, $1, t);
     }
     | ID '+' '+' {
         char *t = new_temp();
         sprintf(incr_code, "%s = %s + 1\n%s = %s", t, $1, $1, t);
     }
     | /* empty */ {
         incr_code[0] = '\0';
     }
     ;

body : '{' stmt_list '}'
     | stmt
     ;

expr : expr '+' expr {
         char *t = new_temp();
         printf("%s = %s + %s\n", t, $1, $3);
         strcpy($$, t);
     }
     | expr '-' expr {
         char *t = new_temp();
         printf("%s = %s - %s\n", t, $1, $3);
         strcpy($$, t);
     }
     | expr '*' expr {
         char *t = new_temp();
         printf("%s = %s * %s\n", t, $1, $3);
         strcpy($$, t);
     }
     | expr '/' expr {
         char *t = new_temp();
         printf("%s = %s / %s\n", t, $1, $3);
         strcpy($$, t);
     }
     | '(' expr ')' {
         strcpy($$, $2);
     }
     | ID {
         strcpy($$, $1);
     }
     | NUM {
         strcpy($$, $1);
     }
     ;
%%

void yyerror(const char *s) {
    printf("Syntax/Parse Error\n");
}

int main() {
    printf("Enter statement (assignment, for, while, if-else):\n");
    printf("--- Three Address Code (TAC) ---\n");
    yyparse();
    return 0;
}
