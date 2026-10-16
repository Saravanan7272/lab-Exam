#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

#define MAX 32

struct Statement {
    char raw[64];
    char res[16];
    char arg1[16];
    char op[8];
    char arg2[16];
    char opt[64];
    int is_label;
    int is_loop;
    int is_invariant;
} code[MAX];

int isNum(const char *s) {
    for (int i = 0; s[i]; i++) {
        if (!isdigit((unsigned char)s[i])) return 0;
    }
    return 1;
}


int main() {
    int n = 0, i, in_loop = 0;
    char line[64];


    printf("Enter number of lines: ");
    if (scanf("%d", &n) != 1 || n <= 0) return 0;
    getchar(); // consume newline


    for (i = 0; i < n; i++) {
        if (!fgets(line, sizeof(line), stdin)) break;
        if (strlen(line) == 0) { i--; continue; }

        strcpy(code[i].raw, line);
        code[i].is_label = 0;
        code[i].is_invariant = 0;
        code[i].opt[0] = '\0';

        // Check if label or jump
        if (line[strlen(line) - 1] == ':') {
            code[i].is_label = 1;
            in_loop = 1;
            continue;
        }
        if (strncmp(line, "goto", 4) == 0 || strncmp(line, "if", 2) == 0) {
            code[i].is_loop = 1;
            if (strncmp(line, "goto", 4) == 0) in_loop = 0;
            continue;
        }

        // Parse: res = arg1 op arg2 OR res = arg1
        char eq;
        int parsed = sscanf(line, "%s %c %s %s %s", code[i].res, &eq, code[i].arg1, code[i].op, code[i].arg2);

        if (parsed == 5) {
            // Technique 1: Strength Reduction
            // (a) Exponentiation to multiplication: x ** 2 -> x * x
            if (strcmp(code[i].op, "**") == 0 && strcmp(code[i].arg2, "2") == 0) {
                sprintf(code[i].opt, "%s = %s * %s", code[i].res, code[i].arg1, code[i].arg1);
            }
            // (b) Multiplication to addition: x * 2 -> x + x
            else if (strcmp(code[i].op, "*") == 0 && strcmp(code[i].arg2, "2") == 0) {
                sprintf(code[i].opt, "%s = %s + %s", code[i].res, code[i].arg1, code[i].arg1);
            }
            else if (strcmp(code[i].op, "*") == 0 && strcmp(code[i].arg1, "2") == 0) {
                sprintf(code[i].opt, "%s = %s + %s", code[i].res, code[i].arg2, code[i].arg2);
            }
            // Technique 2: Constant Folding (both operands are numeric)
            else if (isNum(code[i].arg1) && isNum(code[i].arg2)) {
                int v1 = atoi(code[i].arg1);
                int v2 = atoi(code[i].arg2);
                int res = 0;
                if (strcmp(code[i].op, "+") == 0) res = v1 + v2;
                else if (strcmp(code[i].op, "-") == 0) res = v1 - v2;
                else if (strcmp(code[i].op, "*") == 0) res = v1 * v2;
                else if (strcmp(code[i].op, "/") == 0) res = v2 ? v1 / v2 : 0;
                sprintf(code[i].opt, "%s = %d", code[i].res, res);
            }
            // Technique 3: Algebraic Simplification
            else if (strcmp(code[i].op, "+") == 0 && strcmp(code[i].arg2, "0") == 0) {
                sprintf(code[i].opt, "%s = %s", code[i].res, code[i].arg1);
            }
            else if (strcmp(code[i].op, "+") == 0 && strcmp(code[i].arg1, "0") == 0) {
                sprintf(code[i].opt, "%s = %s", code[i].res, code[i].arg2);
            }
            else if (strcmp(code[i].op, "*") == 0 && strcmp(code[i].arg2, "1") == 0) {
                sprintf(code[i].opt, "%s = %s", code[i].res, code[i].arg1);
            }
            else if (strcmp(code[i].op, "*") == 0 && strcmp(code[i].arg2, "0") == 0) {
                sprintf(code[i].opt, "%s = 0", code[i].res);
            }
            // Technique 4: Code Motion inside a loop
            // If statement is inside a loop, but operands are invariants (e.g. not 'i' or 'x')
            else if (in_loop && strcmp(code[i].arg1, "i") != 0 && strcmp(code[i].arg2, "i") != 0 &&
                     strcmp(code[i].arg1, "x") != 0 && strcmp(code[i].arg2, "x") != 0) {
                code[i].is_invariant = 1;
                sprintf(code[i].opt, "%s = %s %s %s", code[i].res, code[i].arg1, code[i].op, code[i].arg2);
            }
            else {
                sprintf(code[i].opt, "%s = %s %s %s", code[i].res, code[i].arg1, code[i].op, code[i].arg2);
            }
        } else {
            strcpy(code[i].opt, line);
        }
    }

    printf("\n--- Optimized Code ---\n");
    // Print hoisted loop-invariant statements first (Code Motion)
    for (i = 0; i < n; i++) {
        if (code[i].is_invariant) {
            printf("%-20s\n", code[i].opt);
        }
    }

    // Print remaining statements
    for (i = 0; i < n; i++) {
        if (code[i].is_invariant) continue; // already hoisted

        if (code[i].is_label) {
            printf("%s\n", code[i].raw);
        } else {
            printf("%s\n", code[i].opt);
        }
    }

    return 0;
}
