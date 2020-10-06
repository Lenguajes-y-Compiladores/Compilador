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
STRING				"STRING"|"String"
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
{COMENTARIO}		
{DIM}				{return DIM;}
{AS}				{return AS;}
{INTEGER}			{return INTEGER;}
{FLOAT}				{return FLOAT;}
{STRING}			{return STRING;}
{PUT}				{return PUT;}
{GET}				{return GET;}
{WHILE}				{return WHILE;}
{IF}				{return IF;}
{ELSE}				{return ELSE;}
{AND}				{return AND;}
{OR}				{return OR;}
{NOT}				{return NOT;}
{CONTAR}			{return CONTAR;}
{COMA}				{return COMA;}
{PyC}				{return PyC;}
{P_A}				{return P_A;}
{P_C}				{return P_C;}
{L_A}				{return L_A;}
{L_C}				{return L_C;}
{C_A}				{return C_A;}
{C_C}				{return C_C;}
{ASIG}				{return ASIG;}
{OP_SUMA}			{return OP_SUMA;}
{OP_RESTA}			{return OP_RESTA;}
{OP_MULT}			{return OP_MULT;}
{OP_DIV}			{return OP_DIV;}
{MAYOR}				{return MAYOR;}
{MENOR}				{return MENOR;}
{MAYOR_IGUAL}		{return MAYOR_IGUAL;}
{MENOR_IGUAL}		{return MENOR_IGUAL;}
{IGUAL}				{return IGUAL;}
{DISTINTO}		 	{return DISTINTO;}

{ID}				{//guardar el ID en Tabla de simbolo

					return ID;
					}
					
					
{CTE_ENTERA}		{//controlar el rango y despues guardar en tabla

					return CTE_ENTERA;
					}
					
{CTE_REAL}			{//lo mismo

					return CTE_REAL;
					}
					
{CTE_STRING}		{

					return CTE_STRING;
					}
					
{CTE_BINARIA}		{

					return CTE_BINARIA;
					}
					
					
{CTE_HEXA}			{

					return CTE_HEXA;
					}

"\n"
"\t"
