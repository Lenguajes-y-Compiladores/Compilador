%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <conio.h>
    //#include "y.tab.h"
    FILE *yyin;
    int yylval;
    char* yyltext;

%}
%option noyywrap
%option yylineno

BINARIO [0-1]
HEXADECIMAL [0-9A-F]
DIGITO  [0-9]
LETRA   [a-zA-Z]
SIMBOLO [(),.<>!? ;]
PUNTO "."
STRING \".*\"
MAYUSCULAS [A-Z]
MINUSCULAS [a-z]
CONTAR "contar"

DIM DIM
PUT PUT
GET GET
WHILE while
IF if
ELSE Else
AS AS
OPERADOR_ASIGNACION ":"
OPERADOR_MENOR "<"
OPERADOR_MENOR_IGUAL "<="
OPERADOR_MAYOR ">"
OPERADOR_DISTINTO "<>"
OPERADOR_MAS "+"
OPERADOR_MULTIPLICACION "*"
OPERADOR_DIVISION "/"
COMA ","
PUNTO_Y_COMA ";"
CONSTANTE_BIN 0b{BINARIO}+
CONSTANTE_HEX 0x{HEXADECIMAL}+
TIPO_DATO {MAYUSCULAS}.{MINUSCULAS}+
ID {LETRA}+
CONSTANTE ({DIGITO}+{PUNTO}?{DIGITO}+|{DIGITO}+)
PARENTESIS_ABIERTO "("
PARENTESIS_CERRADO ")"
LLAVE_ABIERTA "{"
LLAVE_CERRADA "}"
CORCHETE_ABIERTO "["
CORCHETE_CERRADO "]"


%%

{DIM} printf("\nPalabra reservada DIM: %s\n", yytext);
{PUT} printf("\nPalabra reservada PUT: %s\n", yytext);
{GET} printf("\nPalabra reservada GET: %s\n", yytext);
{WHILE} printf("\nPalabra reservada while: %s\n", yytext);
{IF} printf("\nPalabra reservada IF: %s\n", yytext);
{ELSE} printf("\nPalabra reservada ELSE: %s\n", yytext);
{AS} printf("\nPalabra reservada: %s\n", yytext);
{OPERADOR_ASIGNACION} printf("\nOperador asignacion: %s\n", yytext);
{OPERADOR_MENOR} printf("\nOperador menor: %s\n", yytext);
{OPERADOR_MENOR_IGUAL} printf("\nOperador menor igual: %s\n", yytext);
{OPERADOR_MAYOR} printf("\nOperador mayor: %s\n", yytext);
{OPERADOR_DISTINTO} printf("\nOperador distinto: %s\n", yytext);
{OPERADOR_MAS} printf("\nOperador mas: %s\n", yytext);
{OPERADOR_MULTIPLICACION} printf("\nOperador multiplicacion: %s\n", yytext);
{OPERADOR_DIVISION} printf("\nOperador division: %s\n", yytext);
{COMA} printf("\nComa: %s\n", yytext);
{PUNTO_Y_COMA} printf("\nPunto y coma: %s\n", yytext);
{CONTAR} printf("\nFuncion Contar: %s\n", yytext);
{ID} printf("\nID: %s\n", yytext);
{TIPO_DATO} printf("\nTipo Dato: %s\n", yytext);
{CONSTANTE} printf("\nConstante: %s\n", yytext);
{STRING} printf("\nConstante String: %s\n", yytext);
{CONSTANTE_BIN} printf("\nConstante Binaria: %s\n", yytext);
{CONSTANTE_HEX} printf("\nConstante Hexadecimal: %s\n", yytext);
{PARENTESIS_ABIERTO} printf("\nParentesis abierto: %s\n", yytext);
{PARENTESIS_CERRADO} printf("\nParentesis cerrado: %s\n", yytext);
{LLAVE_ABIERTA} printf("\nLlave abierta: %s\n", yytext);
{LLAVE_CERRADA} printf("\nLlave cerrada: %s\n", yytext);
{CORCHETE_ABIERTO} printf("\nCorchete abierto: %s\n", yytext);
{CORCHETE_CERRADO} printf("\nCorchete cerrado: %s\n", yytext);
"\n"
"\t"
%%
int main(int argc, char* argv[])
{
    if((yyin = fopen(argv[1], "rt")) == NULL)
    {
        printf("\nNo se puede abrir el archivo: %s", argv[1]);
    }
    else
    {
        yylex();
    }
    fclose(yyin);
    return 0;
}
int yyerror(void)
{
    printf("Syntax Error\n");
    system("Pause");
    exit(1);
}