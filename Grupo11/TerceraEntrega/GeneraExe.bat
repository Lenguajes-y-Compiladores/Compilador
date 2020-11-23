c:\GnuWin32\bin\flex Lexico.l
pause
c:\GnuWin32\bin\bison -dyv Sintactico.y
pause
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o Grupo11.exe
pause
pause

Grupo11.exe pruebaSinContar.txt

pause
dot -Tpng intermedia.dot -o intermedia.png
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
del intermedia.dot
del Grupo11.exe
pause