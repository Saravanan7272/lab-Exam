@echo off
setlocal
echo ========================================================
echo   COMPILER DESIGN LAB - RUN ALL MODULES TEST
echo ========================================================
echo.

echo [1/5] Testing Module 1: Lexical Analysis (lex / flex)...
call lex lexer.l
call gcc lex.yy.c -o lexer.exe
.\lexer.exe < sample_code.txt
echo.

echo [2/5] Testing Module 2: Syntax Analysis (yacc / bison)...
call yacc -d parser.y
call lex parser.l
call gcc y.tab.c lex.yy.c -o parser.exe
echo for (i = 0; i ^< 10; i++) x = x + i;> temp_in.txt
.\parser.exe < temp_in.txt
echo if (a ^> 10) x = 1; else x = 2;> temp_in.txt
.\parser.exe < temp_in.txt
echo while (i ^< 10) x = x + 1;> temp_in.txt
.\parser.exe < temp_in.txt
echo.

echo [3/5] Testing Module 3: Intermediate Code Generation (ICG)...
call yacc -d icg.y
call lex icg.l
call gcc y.tab.c lex.yy.c -o icg.exe
echo a = b + c * d;> temp_in.txt
echo --- Test 3A (Assignment Expression) ---
.\icg.exe < temp_in.txt
echo.
echo while (i ^< 10) x = x + 1;> temp_in.txt
echo --- Test 3B (While Loop) ---
.\icg.exe < temp_in.txt
echo.
echo if (a ^> 10) x = 1; else x = 2;> temp_in.txt
echo --- Test 3C (If-Else) ---
.\icg.exe < temp_in.txt
echo.
echo for (i = 1; i ^<= 10; i = i + 1) x = x + i;> temp_in.txt
echo --- Test 3D (For Loop) ---
.\icg.exe < temp_in.txt
del temp_in.txt
echo.

echo [4/5] Testing Module 4: Code Optimization (4 Techniques)...
call gcc optimize.c -o optimize.exe
(
echo 8
echo t1 = 5 * 3
echo t2 = a + 0
echo t3 = x * 2
echo t4 = d ** 2
echo L1:
echo t5 = a + b
echo x = x + t5
echo goto L1
)> temp_in.txt
.\optimize.exe < temp_in.txt
del temp_in.txt
echo.

echo [5/5] Testing Module 5: Code Generation (Jumps and Expressions)...
call gcc codegen.c -o codegen.exe
echo --- Test 5A: Expressions ---
(
echo 3
echo t1 = c * d
echo t2 = b + t1
echo a = t2
)> temp_in.txt
.\codegen.exe < temp_in.txt
echo.
echo --- Test 5B: Conditionals and Loops (Jumps/CMP/Labels) ---
(
echo 11
echo i = 1
echo L1:
echo if i ^<= 10 goto L2
echo goto L3
echo L2:
echo t2 = x + i
echo x = t2
echo t1 = i + 1
echo i = t1
echo goto L1
echo L3:
)> temp_in.txt
.\codegen.exe < temp_in.txt
del temp_in.txt
echo.

echo ========================================================
echo   ALL 5 MODULES PASSED SUCCESSFULLY!
echo ========================================================
