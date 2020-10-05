%{
#include <stdio.h>
#include <stdlib.h>

#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;

int yyerror();
int yylex();
%}

%token DIM
%token AS
%token INTEGER
%token FLOAT
%token STRING
%token PUT
%token GET
%token WHILE
%token IF
%token ELSE
%token AND
%token OR
%token NOT
%token CONTAR
%token COMA
%token PyC
%token P_A
%token P_C
%token L_A
%token L_C
%token C_A
%token C_C
%token ASIG
%token OP_SUMA
%token OP_RESTA
%token OP_MULT    
%token OP_DIV
%token MAYOR
%token MENOR
%token MAYOR_IGUAL
%token MENOR_IGUAL
%token IGUAL
%token DISTINTO
               
%token ID
%token CTE_ENTERA
%token CTE_REAL
%token CTE_STRING                
%token CTE_BINARIA
%token CTE_HEXA

%%

programa:
		declaracion_variables bloque {printf("\n\tCOMPILACION EXITOSA\n");}
		;

declaracion_variables:
					DIM MENOR lista_variables MAYOR AS MENOR tipos_variables MAYOR {printf("\n\tDeclaracion de variables\n");}
					;

lista_variables:
				ID {printf("\n\tSolo una variable\n");}
				|ID COMA lista_variables {printf("\n\tLista de variables\n");}
				;

tipos_variables:
				tipo_variable {printf("\n\tSolo un tipo\n");}
				|tipo_variable COMA tipos_variables {printf("\n\tTipos de variables\n");}				
				;

tipo_variable:
			INTEGER {printf("\n\tTipo Integer\n");}
			|FLOAT {printf("\n\tTipo Float\n");}
			|STRING {printf("\n\tTipo String\n");}
			;

bloque:
		sentencias {printf("\n\tSentencias\n");}
		|bloque sentencias {printf("\n\tBloque - Sentencia\n");}
		;

sentencias:
			asignacion PyC {printf("\n\tAsignacion\n");}
			//|decision {printf("\n\tDecision\n");}
			//|iteracion {printf("\n\tIteracion\n");}
			|entrada PyC
			|salida PyC
			;

asignacion:
			ID ASIG expresion {printf("\n\tID = Expresion es Asignacion\n");}
			;
/*
decision:
		IF P_A condicion P_C L_A bloque L_C {printf("\n\tIf\n");}
		|IF P_A condicion P_C L_A bloque L_C ELSE L_A bloque L_C {printf("\n\tIf con Else\n");}
		;

iteracion:
			WHILE P_A condicion P_C L_A bloque L_C {printf("\n\tWhile\n");}
			;
			
condicion:
		/////Falta condicion
		;
*/
entrada:
		GET ID
		;

salida:
		PUT ID {printf("\n\tPut ID\n");}
		|PUT CTE_STRING {printf("\n\tPut Cte String\n");}
		;

expresion:
			termino {printf("\n\tTermino es Expresion\n");}
			|expresion OP_SUMA termino {printf("\n\tExpresion + Termino es Expresion\n");}
			|expresion OP_RESTA termino {printf("\n\tExpresion - Termino es Expresion\n");}
			|contar {printf("\n\tContar es Expresion\n");}
			;

termino:
		factor {printf("\n\tFactor es Termino\n");}
		|termino OP_MULT factor {printf("\n\tTermino*Factor es Termino\n");}
		|termino OP_DIV factor {printf("\n\tTermino/Factor es Termino\n");}
		;

factor:
		ID {printf("\n\tID es Factor\n");}
		|CTE_ENTERA {printf("\n\tCte Entera es Factor\n");}
		|CTE_REAL {printf("\n\tCte Real es Factor\n");}
		|CTE_STRING {printf("\n\tCte String es Factor\n");}
		|CTE_BINARIA {printf("\n\tCte Binaria es Factor\n");}
		|CTE_HEXA {printf("\n\tCte Hexa es Factor\n");}
		|P_A expresion P_C {printf("\n\tExpresion entre Parentesis es Factor\n");}
		;

contar:
		CONTAR P_A expresion PyC C_A lista_factores C_C P_C {printf("\n\tContar\n");}
		;

lista_factores:
				factor
				|lista_factores COMA factor
				;

%%

int main(int argc, char* argv[])
{
    if((yyin = fopen(argv[1], "rt")) == NULL)
    {
        printf("\nNo se puede abrir el archivo: %s", argv[1]);
    }
    else
    {
        yyparse();
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




