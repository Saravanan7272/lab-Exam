#include <stdio.h>
#include <stdlib.h>

int main() {
  printf("lexer\n");

  system("lex l.l");
  system("gcc lex.yy.c -o lex");
  system("./lex< input.txt");

  printf("syntax");

  system("yacc -d s.y");
  system("lex s.l");
  system("gcc y.tab.c lex.yy.c -o syn");
  system("./syn < input.txt");

  printf("Generating TAC...\n");

  system("yacc -d tac.y");
  system("lex tac.l");
  system("gcc y.tab.c lex.yy.c -o compiler -ll");
  system("./compiler < input.txt > tac.txt");

  printf("Optimizing TAC...\n");

  system("gcc optimize.c -o optimize");
  system("./optimize");

  printf("Generating target code...\n");

  system("gcc target.c -o target");
  system("./target");

  return 0;
}