# Compiler Design Lab Exam - Quick Reference

Minimal, standalone implementations of all 5 compiler phases.
Each module is a **single, unified program** supporting:
- Arithmetic Expressions (`a = b + c * d;`)
- Conditionals (`if` and `if-else`)
- Loops (`while` and `for`)
- 4 Code Optimization Techniques (Constant Folding, Algebraic Simplification, Strength Reduction, Code Motion)
- Complete Target Code Generation (Arithmetic, Simple Copies, Labels, Unconditional Jumps `JMP`, and Conditional Jumps `CMP` + `JLE`/`JGT`/`JE`/`JNE`)

---

## 1. Lexical Analysis (`lexer.l`)
Tokenizes code into Keywords (`if`, `else`, `while`, `for`, `int`, etc.), Identifiers, Numbers, Operators, and Punctuators.

**Compilation & Run:**
```bash
lex lexer.l
gcc lex.yy.c -o lexer
./lexer < sample_code.txt
```

---

## 2. Syntax Analysis (`parser.l`, `parser.y`)
Validates declarations, assignments, `if`, `if-else`, `while`, and `for` loops.

**Compilation & Run:**
```bash
yacc -d parser.y
lex parser.l
gcc y.tab.c lex.yy.c -o parser
./parser
```

---

## 3. Intermediate Code Generation (`icg.l`, `icg.y`)
Single unified ICG module generating Three-Address Code (TAC) for **all** standard language constructs!

**Compilation & Run:**
```bash
yacc -d icg.y
lex icg.l
gcc y.tab.c lex.yy.c -o icg
./icg
```

---

## 4. Code Optimization (`optimize.c`)
Implements all **4 core optimization techniques**:
1. **Constant Folding:** Evaluates constant arithmetic at compile time (`5 * 3` -> `15`).
2. **Algebraic Simplification:** Applies algebraic identities (`a + 0` -> `a`, `b * 1` -> `b`, `c * 0` -> `0`).
3. **Strength Reduction:** Replaces expensive operations with cheaper ones (`x * 2` -> `x + x`, `d ** 2` -> `d * d`).
4. **Code Motion (Loop-Invariant Hoisting):** Moves invariant statements (`t5 = a + b`) outside the loop header `L1:`!

**Compilation & Run:**
```bash
gcc optimize.c -o optimize
./optimize
```

---

## 5. Code Generation (`codegen.c`)
Translates **any** Three-Address Code into Target Machine Assembly (Registers + Jumps).

Supports:
- **Labels:** `L1:` $\rightarrow$ `L1:`
- **Unconditional Jumps:** `goto L2` $\rightarrow$ `JMP L2`
- **Conditional Jumps:** `if a <= 10 goto L1` $\rightarrow$ `CMP a, 10` followed by `JLE L1`
- **Binary Arithmetic:** `t1 = a + b` $\rightarrow$ `MOV R0, a; ADD R0, b; MOV t1, R0`
- **Simple Assignments:** `x = t1` $\rightarrow$ `MOV R0, t1; MOV x, R0`

**Compilation & Run:**
```bash
gcc codegen.c -o codegen
./codegen
```

**Test Case (Loop / Conditional TAC):**
```text
11
i = 1
L1:
if i <= 10 goto L2
goto L3
L2:
t2 = x + i
x = t2
t1 = i + 1
i = t1
goto L1
L3:
```

**Generated Target Assembly:**
```text
MOV R0, 1
MOV i, R0

L1:
CMP i, 10
JLE L2
JMP L3

L2:
MOV R0, x
ADD R0, i
MOV t2, R0

MOV R0, t2
MOV x, R0

MOV R0, i
ADD R0, 1
MOV t1, R0

MOV R0, t1
MOV i, R0

JMP L1
L3:
```
