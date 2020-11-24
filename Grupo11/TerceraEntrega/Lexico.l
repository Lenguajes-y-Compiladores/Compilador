%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "y.tab.h"
#define TOPE_ENTERO 65535
#define TOPE_REAL 4294967296

FILE *yyin;
//int yylval;
//char *yyltext;

void validarLongitudCadena(char*);
void validarLimitesInt(char*);
void validarLimitesFloat(char*);
int binADecimal(char*);
long hexADecimal (char*);


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

{ID}				{
					validarLongitudCadena(yytext)/*; armarTS("ID", yytext)*/; yylval.strid_val = strdup(yytext); return ID;
					}
					
					
{CTE_ENTERA}		{
					validarLimitesInt(yytext);
					armarTS("CTE_ENT", yytext); yylval.int_val= strdup(yytext); return CTE_ENTERA;
					}
					
{CTE_REAL}			{
					validarLimitesFloat(yytext);
					armarTS("CTE_FLOAT", yytext); yylval.float_val= strdup(yytext); return CTE_REAL;
					}
					
{CTE_STRING}		{

					validarLongitudCadena(yytext); armarTS("CTE_STR", yytext); yylval.str_val= strdup(yytext); return CTE_STRING;
					}
					
{CTE_BINARIA}		{

					armarTS("CTE_BIN", yytext); yylval.int_val= strdup(yytext); return CTE_BINARIA;
					}
					
					
{CTE_HEXA}			{

					armarTS("CTE_HEX", yytext); yylval.int_val= strdup(yytext); return CTE_HEXA;
					}

" "
"\n"
"\t"
%%

/****************************************/
void validarLongitudCadena(char* cadena){
    if(strlen(cadena)>32){
        printf("\nString fuera de rango\n");
        system("Pause");
        exit(1);
    }
}

/****************************************/
void validarLimitesInt(char* entero){
	if(atoi(entero)>TOPE_ENTERO){
		printf("\nCte Entera fuera de rango\n");
		system("Pause");
        exit(1);
	}
}

/****************************************/
void validarLimitesFloat(char* real){
	if(atof(real) > TOPE_REAL){
		printf("\nCte Real fuera de rango\n");
		system("Pause");
        exit(1);
	}
}

/****************************************/
int binADecimal(char* cad)
{
    int num;
    int exp = 1;
    if(cad[0]== '0' && cad[1]== 'b')
    {
        int tamNumBin = strlen(cad)-1;
        int resultado = 0;

        for( ; tamNumBin >= 2; tamNumBin-- )
        {
            num = cad[tamNumBin] - '0';
            if ((num > 1) || (num < 0))
            {
                puts("\nNo es binario! \n");
                return -1;
            }
            if( num == 1 ){
                resultado += exp;
            }
            exp *= 2;
        }
        return resultado;
    }
    puts("\nNo es  binario!\n");
    return -1;
}

/***************************************/
long hexADecimal (char* cad)
{
    int num;
    int base = 16;
    int exp = 0;
    long resultado = 0;
    if(cad[0] == '0' && cad[1] == 'x')
    {
        int tamNumHex = strlen(cad)-1;
        for( ; tamNumHex >= 2; tamNumHex-- )
        {
            num = cad[tamNumHex] - '0';
            if(num >9)
            {
                switch(cad[tamNumHex])
                {
                    case 'A':
                        num = 10;
                        break;
                    case 'B':
                        num = 11;
                        break;
                    case 'C':
                        num = 12;
                        break;
                    case 'D':
                        num = 13;
                        break;
                    case 'E':
                        num = 14;
                        break;
                    case 'F':
                        num = 15;
                        break;
                }
            }
            resultado += (num * (int)pow(base, exp));
            exp++;
        }
        return resultado;
    }
    puts("\nNo es  Hexadecimal!\n");
    return -1;

}