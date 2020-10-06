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
		seccion_declaraciones bloque {printf("\n\tCOMPILACION EXITOSA\n");}
		;

seccion_declaraciones:
						declaracion_variables {printf("\n\tRegla 1: seccion_declaracion -> declaracion_variables\n");}
						|seccion_declaraciones declaracion_variables {printf("\n\tRegla 2: seccion_declaracion -> seccion_declaracion declaracion_variables\n");}

declaracion_variables:
					DIM MENOR lista_variables MAYOR AS MENOR tipos_variables MAYOR {printf("\n\tRegla 3: declaracion_variables -> DIM MENOR lista_variables MAYOR AS MENOR tipos_variables MAYOR\n");}
					;

lista_variables:
				ID {printf("\n\tRegla 4: lista_variables -> ID\n");}
				|ID COMA lista_variables {printf("\n\tRegla 5: lista_variables -> ID COMA lista_variables\n");}
				;

tipos_variables:
				tipo_variable {printf("\n\tRegla 6: tipos_variables -> tipo_variable\n");}
				|tipo_variable COMA tipos_variables {printf("\n\tRegla 7: tipos_variables -> tipo_variable COMA tipos_variables\n");}
				;

tipo_variable:
			INTEGER {printf("\n\tRegla 8: tipo_variable -> INTEGER\n");}
			|FLOAT {printf("\n\tRegla 9: tipo_variable -> FLOAT\n");}
			|STRING {printf("\n\tRegla 10: tipo_variable -> STRING\n");}
			;

bloque:
		sentencias {printf("\n\tRegla 11: bloque -> sentencias\n");}
		|bloque sentencias {printf("\n\tRegla 12: bloque -> bloque sentencias\n");}
		;

sentencias:
			asignacion PyC {printf("\n\tRegla 13: sentencias -> asignacion PyC\n");}
			|decision {printf("\n\tRegla 14: sentencias -> decision\n");}
			|iteracion {printf("\n\tRegla 15: sentencias -> iteracion\n");}
			|entrada PyC {printf("\n\tRegla 16: sentencias -> entrada PyC\n");}
			|salida PyC {printf("\n\tRegla 17: sentencias -> salida PyC\n");}
			;

asignacion:
			ID ASIG expresion {printf("\n\tRegla 18: asignacion -> ID ASIG expresion\n");}
			;

decision:
		IF P_A condicion P_C L_A bloque L_C {printf("\n\tRegla 19: decision -> IF P_A condicion P_C L_A bloque L_C\n");}
		|IF P_A condicion P_C L_A bloque L_C ELSE L_A bloque L_C {printf("\n\tRegla 20: decision -> IF P_A condicion P_C L_A bloque L_C ELSE L_A bloque L_C\n");}
		;

iteracion:
			WHILE P_A condicion P_C L_A bloque L_C {printf("\n\tRegla 21: decision -> IF P_A condicion P_C L_A bloque L_C\n");}
			;
			
condicion:
		comparacion {printf("\n\tRegla 22: condicion -> comparacion\n");}
		|comparacion AND comparacion {printf("\n\tRegla 23: condicion -> comparacion AND comparacion\n");}
		|comparacion OR comparacion {printf("\n\tRegla 24: condicion -> comparacion OR comparacion\n");}
		|NOT comparacion {printf("\n\tRegla 25: condicion -> NOT comparacion\n");}
		;

comparacion:
			expresion comparador expresion {printf("\n\tRegla 26: comparacion -> expresion comparador expresion\n");}
			|P_A expresion comparador expresion P_C {printf("\n\tRegla 27: comparacion -> P_A expresion comparador expresion P_C\n");}
			;

comparador:
			MAYOR {printf("\n\tRegla 28: comparador -> MAYOR\n");}
			|MENOR {printf("\n\tRegla 29: comparador -> MENOR\n");}
			|MAYOR_IGUAL {printf("\n\tRegla 30: comparador -> MAYOR_IGUAL\n");}
			|MENOR_IGUAL {printf("\n\tRegla 31: comparador -> MENOR_IGUAL\n");}
			|IGUAL {printf("\n\tRegla 32: comparador -> IGUAL\n");}
			|DISTINTO {printf("\n\tRegla 33: comparador -> DISTINTO\n");}
			;

entrada:
		GET ID {printf("\n\tRegla 34: entrada -> GET ID\n");}
		;

salida:
		PUT ID {printf("\n\tRegla 35: salida -> PUT ID\n");}
		|PUT CTE_STRING {printf("\n\tRegla 36: salida -> PUT CTE_STRING\n");}
		;

expresion:
			termino {printf("\n\tRegla 37: expresion -> termino\n");}
			|expresion OP_SUMA termino {printf("\n\tRegla 38: expresion -> expresion OP_SUMA termino\n");}
			|expresion OP_RESTA termino {printf("\n\tRegla 39: expresion -> expresion OP_RESTA termino\n");}
			;

termino:
		factor {printf("\n\tRegla 40: termino -> factor\n");}
		|termino OP_MULT factor {printf("\n\tRegla 41: termino -> termino OP_MULT factor\n");}
		|termino OP_DIV factor {printf("\n\tRegla 42: termino -> termino OP_DIV factor\n");}
		;

factor:
		ID {printf("\n\tRegla 43: factor -> ID\n");}
		|CTE_ENTERA {printf("\n\tRegla 44: factor -> CTE_ENTERA\n");}
		|CTE_REAL {printf("\n\tRegla 45: factor -> CTE_REAL\n");}
		|CTE_STRING {printf("\n\tRegla 46: factor -> CTE_STRING\n");}
		|CTE_BINARIA {printf("\n\tRegla 47: factor -> CTE_BINARIA\n");}
		|CTE_HEXA {printf("\n\tRegla 48: factor -> CTE_HEXA\n");}
		|P_A expresion P_C {printf("\n\tRegla 49: factor -> P_A expresion P_C\n");}
		|contar {printf("\n\tRegla 50: factor -> contar\n");}
		;

contar:
		CONTAR P_A expresion PyC C_A lista_constantes C_C P_C {printf("\n\tRegla 51: contar -> CONTAR P_A expresion PyC C_A lista_constantes C_C P_C\n");}
		;

lista_constantes:
				factor {printf("\n\tRegla 52: lista_constantes -> factor\n");}
				|lista_constantes COMA factor {printf("\n\tRegla 53: lista_constantes -> lista_constantes COMA factor\n");}
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




