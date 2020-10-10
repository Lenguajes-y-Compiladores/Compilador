%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "y.tab.h"

struct struct_tablaSimbolos{
	char nombre[100];
	char tipo[100];
	char valor[50];
	char longitud[100];
};

FILE *yyin;
int yylval;
char *yyltext;
int puntero_array = 0;

struct struct_tablaSimbolos tablaSimbolos[1000];

int armarTS (char*, char*);
int imprimirTS();
void validarLongitudCadena(char*);

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
{L_C}				{if(imprimirTS() == 1) printf("Error al crear el archivo de la tabla de simbolos\n"); return L_C;}
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

					validarLongitudCadena(yytext); armarTS("ID", yytext); return ID;
					}
					
					
{CTE_ENTERA}		{//controlar el rango y despues guardar en tabla

					armarTS("CTE", yytext); return CTE_ENTERA;
					}
					
{CTE_REAL}			{//lo mismo

					armarTS("CTE", yytext); return CTE_REAL;
					}
					
{CTE_STRING}		{

					validarLongitudCadena(yytext); armarTS("CTE_STR", yytext); return CTE_STRING;
					}
					
{CTE_BINARIA}		{

					armarTS("CTE_BIN", yytext); return CTE_BINARIA;
					}
					
					
{CTE_HEXA}			{

					armarTS("CTE_HEX", yytext); return CTE_HEXA;
					}

"\n"
"\t"
%%

int armarTS (char* tipo, char* nombre){

    char longi_str_cte[10];
	int i;
	int retornar;
	char lexema[50]; 
    char cteBin[25];
    char cteHex[25];
    char aux [50];
	lexema[0]='_';
	lexema[1]='\0';
    int tamAux;
    if(nombre[0] == '\"')
    {
       tamAux = strlen(nombre)-3;
       strcpy(nombre, (nombre+1));
       nombre[tamAux] = '\0'; 
    
    }
	strcat(lexema,nombre);
    
	for(i = 0; i < puntero_array; i++){ //Si esta vacia la TS, no entra
		if(strcmp(tablaSimbolos[i].nombre, lexema) == 0)
			return i; //Si el lexema ya existe en la ts, entonces retorno su posicion.
	}

	if(strcmp(tipo,"CTE")==0){// Si el lexema es una cte, entonces seteo el campo "valor" en la ts.      
       strcpy(tablaSimbolos[puntero_array].valor, nombre);
    }
    else{
        if(strcmp(tipo,"CTE_BIN") == 0){
            itoa(binADecimal(nombre), cteBin, 10);
            strcpy(tablaSimbolos[puntero_array].valor, cteBin);
        }else{
            if(strcmp(tipo, "CTE_HEX") == 0){
                itoa(hexADecimal(nombre), cteHex, 10);
                strcpy(tablaSimbolos[puntero_array].valor, cteHex);
            }else
                tablaSimbolos[puntero_array].valor[0]='\0';
        }
    }
        
	strcpy(tablaSimbolos[puntero_array].nombre, lexema ); //Seteo el campo "nombre" en la ts en todos los casos.

	tablaSimbolos[puntero_array].tipo[0]='\0';
	
    if(strcmp(tipo, "CTE_STR")==0)//Si se trata de una constante string, entonces contar las cantidad de caracteres y setear en ts.
    {
        itoa(strlen(nombre),longi_str_cte,10);
        strcpy(tablaSimbolos[i].longitud,longi_str_cte);
    } else
	       tablaSimbolos[puntero_array].longitud[0]='\0';
	
	retornar = puntero_array;
	puntero_array++;
	
	return retornar; //Si el lexema no existe en la ts, entonces se agrega al final de la ts y se devuelve su posicion.
    
}
/*******************************************/
int imprimirTS(){
	FILE *pf; 
	int i;
	pf = fopen("ts.txt","w"); 

	if (!pf)
	{
		printf("Error al crear el archivo de tabla de simbolos\n");
		return 1;
	}

	fprintf(pf, "Nombre\t\t\t\t\tTipo\t\t\t\t\tValor\t\t\t\t\tLongitud\n");
	for (i = 0; i < puntero_array; i++)
		fprintf(pf,"%s\t\t\t\t\t%s\t\t\t\t\t%s\t\t\t\t\t%s\n", tablaSimbolos[i].nombre,tablaSimbolos[i].tipo,tablaSimbolos[i].valor,tablaSimbolos[i].longitud);
		
	
	fclose(pf); 

	return 0;
}

/****************************************/
void validarLongitudCadena(char* cadena){
    if(strlen(cadena)>30){
        printf("\nString fuera de rango\n");
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

