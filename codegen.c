#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

void trim(char *s) {
    int len = strlen(s);
    while (len > 0 && (s[len - 1] == '\n' || s[len - 1] == '\r' || isspace((unsigned char)s[len - 1]))) {
        s[--len] = '\0';
    }
}


int main() {
    int n = 20, i;
    char line[128];

    for (i = 0; i < n; i++) {
        if (!fgets(line, sizeof(line), stdin)) break;
        trim(line);
        if (strlen(line) == 0) { i--; continue; }
        
        // 1. Label definition (e.g. "L1:")
        if (line[strlen(line) - 1] == ':') {
            printf("%s\n", line);
            continue;
        }

        // 2. Unconditional Jump (e.g. "goto L2")
        char target[32];
        if (sscanf(line, "goto %s", target) == 1) {
            printf("JMP %s\n", target);
            continue;
        }

        // 3. Conditional Jump (e.g. "if i <= 10 goto L1")
        char op1[32], relop[8], op2[32], dest[32];
        if (sscanf(line, "if %s %s %s goto %s", op1, relop, op2, dest) == 4) {
            printf("CMP %s, %s\n", op1, op2);
            if (strcmp(relop, "<") == 0)       printf("JLT %s\n", dest);
            else if (strcmp(relop, "<=") == 0) printf("JLE %s\n", dest);
            else if (strcmp(relop, ">") == 0)  printf("JGT %s\n", dest);
            else if (strcmp(relop, ">=") == 0) printf("JGE %s\n", dest);
            else if (strcmp(relop, "==") == 0) printf("JE %s\n", dest);
            else if (strcmp(relop, "!=") == 0) printf("JNE %s\n", dest);
            else                               printf("JMP %s\n", dest);
            continue;
        }

        // 4. Arithmetic Assignment (e.g. "t1 = a + b") or Simple Assignment ("x = t1")
        char res[32], rhs1[32], op[8], rhs2[32];
        char eq;
        int parts = sscanf(line, "%s %c %s %s %s", res, &eq, rhs1, op, rhs2);

        if (parts == 5) {
            // Binary arithmetic: res = rhs1 op rhs2
            printf("MOV R0, %s\n", rhs1);
            if (op[0] == '+')      printf("ADD R0, %s\n", rhs2);
            else if (op[0] == '-') printf("SUB R0, %s\n", rhs2);
            else if (op[0] == '*') printf("MUL R0, %s\n", rhs2);
            else if (op[0] == '/') printf("DIV R0, %s\n", rhs2);
            printf("MOV %s, R0\n\n", res);
        } else if (parts >= 3) {
            // Copy / Simple assignment: res = rhs1 (e.g. "x = t1" or "i = 1")
            printf("MOV R0, %s\n", rhs1);
            printf("MOV %s, R0\n\n", res);
        }
    }

    return 0;
}
