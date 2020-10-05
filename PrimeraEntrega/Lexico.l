%{
#include <stdio.h>
#include <stdlib.h>

#include "y.tab.h"

FILE *yyin;
int yylval;
char *yyltext;

%}
%option noyywrap
%option yylineno

DIM					"DIM"|"dim"
AS					"AS"|"as"
INTEGER				"INTEGER"|"Integer"
FLOAT				"FLOAT"|"Float"
STRING				"STRING"|"string"
PUT					"PUT"|"put"
GET					"GET"|"get"
WHILE				"WHILE"|"while"
IF					"IF"|"if"
ELSE				"ELSE"|"Else"
AND					"AND"|"and"
OR					"OR"|"or"
NOT					"NOT"|"not"
CONTAR				"CONTAR"|"contar"
COMA				","
PyC					";"
P_A					"("
P_C					")"
L_A					"{"
L_C					"}"
C_A					"["
C_C					"]"
ASIG				"="
OP_SUMA				"+"
OP_RESTA			"-"
OP_MULT				"*"
OP_DIV				"/"
MAYOR				">"
MENOR				"<"
MAYOR_IGUAL			">="
MENOR_IGUAL			"<="
IGUAL				"=="
DISTINTO			"<>"

BINARIO				[0-1]
HEXA				[A-F]
DIGITO				[0-9]
LETRA				[a-zA-Z]
DELIM				[ \t\r]
CARACTER			[a-z|A-Z|0-9|=|>|<|!|:|+|-|*|/|?|¿|!|¡|@|%|#|&|°|´|^|`|~|/|\\|-|_|.|,|;|¬|\|á|é|í|ó|ú|ü||]
VALID_STRING		({CARACTER}+|{DELIM})*
COMENTARIO			\*-.({VALID_STRING}|\*|\-)*.-\*

ID					{LETRA}({LETRA}|{DIGITO})*
CTE_STRING			\"{VALID_STRING}\"
CTE_REAL			{DIGITO}+\.{DIGITO}*
CTE_ENTERA			{DIGITO}+
CTE_BINARIA			0b{BINARIO}+
CTE_HEXA			0x({DIGITO}|{HEXA})+

%%
{COMENTARIO}		printf("Comentario: %s\n", yytext);
{DIM}				{printf("dim: %s\n", yytext); return DIM;}
{AS}				{printf("as: %s\n", yytext); return AS;}
{INTEGER}			{printf("INTEGER: %s\n", yytext); return INTEGER;}
{FLOAT}				{printf("Float: %s\n", yytext); return FLOAT;}
{STRING}			{printf("String: %s\n", yytext); return STRING;}
{PUT}				{printf("put: %s\n", yytext); return PUT;}
{GET}				{printf("get: %s\n", yytext); return GET;}
{WHILE}				{printf("While: %s\n", yytext); return WHILE;}
{IF}				{printf("if: %s\n", yytext); return IF;}
{ELSE}				{printf("else: %s\n", yytext); return ELSE;}
{AND}				{printf("and: %s\n", yytext); return AND;}
{OR}				{printf("or: %s\n", yytext); return OR;}
{NOT}				{printf("not: %s\n", yytext); return NOT;}
{CONTAR}			{printf("Contar: %s\n", yytext); return CONTAR;}
{COMA}				{printf("Coma: %s\n", yytext); return COMA;}
{PyC}				{printf("pyc: %s\n", yytext); return PyC;}
{P_A}				{printf("P A: %s\n", yytext); return P_A;}
{P_C}				{printf("P C: %s\n", yytext); return P_C;}
{L_A}				{printf("L A: %s\n", yytext); return L_A;}
{L_C}				{printf("L C: %s\n", yytext); return L_C;}
{C_A}				{printf("C A: %s\n", yytext); return C_A;}
{C_C}				{printf("C C: %s\n", yytext); return C_C;}
{ASIG}				{printf("Asignacion: %s\n", yytext); return ASIG;}
{OP_SUMA}			{printf("Suma: %s\n", yytext); return OP_SUMA;}
{OP_RESTA}			{printf("resta: %s\n", yytext); return OP_RESTA;}
{OP_MULT}			{printf("multi: %s\n", yytext); return OP_MULT;}
{OP_DIV}			{printf("Divi: %s\n", yytext); return OP_DIV;}
{MAYOR}				{printf("Mayor: %s\n", yytext); return MAYOR;}
{MENOR}				{printf("Menor: %s\n", yytext); return MENOR;}
{MAYOR_IGUAL}		{printf("mayorIgu: %s\n", yytext); return MAYOR_IGUAL;}
{MENOR_IGUAL}		{printf("menorigu: %s\n", yytext); return MENOR_IGUAL;}
{IGUAL}				{printf("igual: %s\n", yytext); return IGUAL;}
{DISTINTO}		 	{printf("distinto: %s\n", yytext); return DISTINTO;}

{ID}				{//guardar el ID en Tabla de simbolo
					printf("ID: %s\n", yytext);

					return ID;
					}
					
					
{CTE_ENTERA}		{//controlar el rango y despues guardar en tabla

					printf("CTE_ENTERA: %s\n", yytext);

					return CTE_ENTERA;
					}
					
{CTE_REAL}			{//lo mismo

					printf("CTE_REAL: %s\n", yytext);

					return CTE_REAL;
					}
					
{CTE_STRING}		{

					printf("CTE_STRING: %s\n", yytext);
					return CTE_STRING;
					}
					
{CTE_BINARIA}		{
					printf("CTE_BINARIA: %s\n", yytext);


					return CTE_BINARIA;
					}
					
					
{CTE_HEXA}			{
					printf("\nCTE_HEXA: %s\n", yytext);


					return CTE_HEXA;
					}

"\n"
"\t"
