%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "y.tab.h"

int yystopparser=0;
FILE  *yyin;

struct struct_tablaSimbolos{
	char nombre[100];
	char tipo[100];
	char valor[50];
	char longitud[100];
};

int puntero_array = 0;

struct struct_tablaSimbolos tablaSimbolos[1000];

int armarTS (char*, char*);
int imprimirTS();

int yyerror();
int yylex();

/*****************PARA EL TIPO***********************/
char tablaVariables [100][15];
int contadorVariables = 0;
int contadorTipo = 0;
char* auxTDD;

int buscar_TS(char* nombre);
int set_Tipo_TS(char* nombre, char* tipo);
/***************************************************/
/*******************ARBOL***************************/
typedef struct nodo{
    char dato[20];
    struct nodo* hijoDer;
    struct nodo* hijoIzq;
}nodo; //estructura para el arbol sintactico

typedef nodo* t_dato; //Estructura para el dato de la pila dinamica

// Estructura para el nodo de la pila dinamica
typedef struct s_nodo
{
    t_dato dato;
    struct s_nodo* psig;
} t_nodo;

// Estructura para la pila dinamica
typedef t_nodo* t_pila;


nodo* crearNodo(const char* , nodo* , nodo* );
nodo* crearHoja(const char*);
void crear_pila(t_pila *pp);
int apilarDinamica(t_pila *, const t_dato *);
int desapilarDinamica(t_pila *,t_dato *);
int verTopeDinamica(t_pila *,t_dato *);
void escribirArbol(nodo *);
int inOrden(FILE *, struct nodo*);
int esHoja(nodo *);
/***************************************************/

nodo* bloquePtr = NULL;
nodo* sentenciasPtr = NULL;
nodo* asignacionPtr = NULL;
nodo* decisionPtr = NULL;
nodo* iteracionPtr = NULL;
nodo* condicionPtr = NULL;
nodo* comparacionPtr = NULL;
nodo* comparadorPtr = NULL;
nodo* entradaPtr = NULL;
nodo* salidaPtr = NULL;
nodo* expresionPtr = NULL;
nodo* terminoPtr = NULL;
nodo* factorPtr = NULL;
nodo* contarPtr = NULL;
nodo* listaContantesPtr = NULL;
t_pila pila = NULL;


%}

%union {
	char * int_val;
	char * float_val;
	char * str_val;
	char * strid_val;
}

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
               
%token <str_val> ID
%token <int_val> CTE_ENTERA
%token <float_val> CTE_REAL
%token <str_val> CTE_STRING                
%token CTE_BINARIA
%token CTE_HEXA

%%

programa:
		seccion_declaraciones bloque {printf("\n\tCOMPILACION EXITOSA\n"); escribirArbol(bloquePtr);}
		;

seccion_declaraciones:
						declaracion_variables {printf("\n\tRegla 1: seccion_declaracion -> declaracion_variables\n");}
						|seccion_declaraciones declaracion_variables {printf("\n\tRegla 2: seccion_declaracion -> seccion_declaracion declaracion_variables\n");}

declaracion_variables:
					DIM MENOR lista_variables MAYOR AS MENOR tipos_variables MAYOR {printf("\n\tRegla 3: declaracion_variables -> DIM MENOR lista_variables MAYOR AS MENOR tipos_variables MAYOR\n");}
					;

lista_variables:
				ID {strcpy(tablaVariables[contadorVariables],yylval.strid_val); contadorVariables++; printf("\n\tRegla 4: lista_variables -> ID\n");}
				|lista_variables COMA ID {strcpy(tablaVariables[contadorVariables],yylval.strid_val); contadorVariables++; printf("\n\tRegla 5: lista_variables -> ID COMA lista_variables\n");}
				;

tipos_variables:
				tipo_variable {set_Tipo_TS(tablaVariables[contadorTipo], auxTDD); contadorTipo++;   printf("\n\tRegla 6: tipos_variables -> tipo_variable\n");}
				|tipos_variables COMA tipo_variable {set_Tipo_TS(tablaVariables[contadorTipo], auxTDD); contadorTipo++; printf("\n\tRegla 7: tipos_variables -> tipo_variable COMA tipos_variables\n");}
				;

tipo_variable:
			INTEGER {auxTDD = "int"; printf("\n\tRegla 8: tipo_variable -> INTEGER\n");}
			|FLOAT {auxTDD = "float"; printf("\n\tRegla 9: tipo_variable -> FLOAT\n");}
			|STRING {auxTDD = "string"; printf("\n\tRegla 10: tipo_variable -> STRING\n");}
			;

bloque:
		sentencias {
            bloquePtr = sentenciasPtr;
            apilarDinamica(&pila, &bloquePtr);
            printf("\n\tRegla 11: bloque -> sentencias\n");
        }
		|bloque sentencias {
			bloquePtr = crearNodo("BLOQUE", bloquePtr, sentenciasPtr);
			apilarDinamica(&pila, &bloquePtr);
			printf("\n\tRegla 12: bloque -> bloque sentencias\n");
		}
		;

sentencias:
			asignacion PyC {
				sentenciasPtr = asignacionPtr;
				printf("\n\tRegla 13: sentencias -> asignacion PyC\n");
			}
			|decision {
				sentenciasPtr = decisionPtr;
				printf("\n\tRegla 14: sentencias -> decision\n");
			}
			|iteracion {
				sentenciasPtr = iteracionPtr;
				printf("\n\tRegla 15: sentencias -> iteracion\n");
			}
			|entrada PyC {
				sentenciasPtr = entradaPtr;
				printf("\n\tRegla 16: sentencias -> entrada PyC\n");
			}
			|salida PyC {
				sentenciasPtr = salidaPtr;
				printf("\n\tRegla 17: sentencias -> salida PyC\n");
			}
			;

asignacion:
			ID ASIG expresion {
				asignacionPtr = crearNodo("=", crearHoja($1), expresionPtr);
				printf("\n\tRegla 18: asignacion -> ID ASIG expresion\n");
			}
			;

decision:
		IF P_A condicion P_C L_A bloque L_C {
			nodo * ret = NULL;
			desapilarDinamica(&pila, &ret);
			bloquePtr = ret;
			desapilarDinamica(&pila, &ret);
			decisionPtr = crearNodo("IF", ret, bloquePtr);
			printf("\n\tRegla 19: decision -> IF P_A condicion P_C L_A bloque L_C\n");
		}
		|IF P_A condicion P_C L_A bloque L_C ELSE L_A bloque L_C {printf("\n\tRegla 20: decision -> IF P_A condicion P_C L_A bloque L_C ELSE L_A bloque L_C\n");}
		;

iteracion:
			WHILE P_A condicion P_C L_A bloque L_C {printf("\n\tRegla 21: iteracion -> WHILE P_A condicion P_C L_A bloque L_C\n");}
			;
			
condicion:
		comparacion {
			condicionPtr = comparacionPtr;
			printf("\n\tRegla 22: condicion -> comparacion\n");
		}
		|comparacion AND comparacion {
			printf("\n\tRegla 23: condicion -> comparacion AND comparacion\n");
		}
		|comparacion OR comparacion {
			printf("\n\tRegla 24: condicion -> comparacion OR comparacion\n");
		}
		|NOT comparacion {
			printf("\n\tRegla 25: condicion -> NOT comparacion\n");
		}
		;

comparacion:
			expresion comparador expresion {printf("\n\tRegla 26: comparacion -> expresion comparador expresion\n");}
			|P_A expresion comparador expresion P_C {printf("\n\tRegla 27: comparacion -> P_A expresion comparador expresion P_C\n");}
			;

comparador:
			MAYOR {
				comparadorPtr = crearHoja(">");
				printf("\n\tRegla 28: comparador -> MAYOR\n");
			}
			|MENOR {
				comparadorPtr = crearHoja("<");
				printf("\n\tRegla 29: comparador -> MENOR\n");
			}
			|MAYOR_IGUAL {
				comparadorPtr = crearHoja(">=");
				printf("\n\tRegla 30: comparador -> MAYOR_IGUAL\n");
			}
			|MENOR_IGUAL {
				comparadorPtr = crearHoja("<=");
				printf("\n\tRegla 31: comparador -> MENOR_IGUAL\n");
			}
			|IGUAL {
				comparadorPtr = crearHoja("==");
				printf("\n\tRegla 32: comparador -> IGUAL\n");
			}
			|DISTINTO {
				comparadorPtr = crearHoja("!=");
				printf("\n\tRegla 33: comparador -> DISTINTO\n");
			}
			;

entrada:
		GET ID {
			entradaPtr = crearNodo("GET", crearHoja($2), crearHoja("@STDIN"));
			printf("\n\tRegla 34: entrada -> GET ID\n");
		}
		;

salida:
		PUT ID {
			salidaPtr = crearNodo("PUT", crearHoja("@STDOUT"), crearHoja($2));
			printf("\n\tRegla 35: salida -> PUT ID\n");
		}
		|PUT CTE_STRING {
			salidaPtr = crearNodo("PUT", crearHoja("@STDOUT"), crearHoja($2));
			printf("\n\tRegla 36: salida -> PUT CTE_STRING\n");
		}
		;

expresion:
			termino {
				expresionPtr = terminoPtr;
				printf("\n\tRegla 37: expresion -> termino\n");
			}
			|expresion OP_SUMA termino {
				expresionPtr = crearNodo("+", expresionPtr, terminoPtr);
				printf("\n\tRegla 38: expresion -> expresion OP_SUMA termino\n");
			}
			|expresion OP_RESTA termino {
				expresionPtr = crearNodo("-", expresionPtr, terminoPtr);
				printf("\n\tRegla 39: expresion -> expresion OP_RESTA termino\n");
			}
			;

termino:
		factor {
			terminoPtr = factorPtr;
			printf("\n\tRegla 40: termino -> factor\n");
		}
		|termino OP_MULT factor {
			terminoPtr = crearNodo("*", terminoPtr, factorPtr);
			printf("\n\tRegla 41: termino -> termino OP_MULT factor\n");
		}
		|termino OP_DIV factor {
			terminoPtr = crearNodo("/", terminoPtr, factorPtr);
			printf("\n\tRegla 42: termino -> termino OP_DIV factor\n");
		}
		;

factor:
		ID {
			factorPtr = crearHoja($1);
			printf("\n\tRegla 43: factor -> ID\n");
		}
		|CTE_ENTERA {
			factorPtr = crearHoja($1);
			printf("\n\tRegla 44: factor -> CTE_ENTERA\n");
		}
		|CTE_REAL {
			factorPtr = crearHoja($1);
			printf("\n\tRegla 45: factor -> CTE_REAL\n");
		}
		|CTE_STRING {
			factorPtr = crearHoja($1);
			printf("\n\tRegla 46: factor -> CTE_STRING\n");
		}
		|CTE_BINARIA {
			//factorPtr = crearHoja($1);
			printf("\n\tRegla 47: factor -> CTE_BINARIA\n");
		}
		|CTE_HEXA {
			//factorPtr = crearHoja($1);
			printf("\n\tRegla 48: factor -> CTE_HEXA\n");
		}
		|P_A expresion P_C {
			factorPtr = expresionPtr;
			//nodo *ret = NULL;
			//desapilarDinamica(&pila, &ret);
			printf("\n\tRegla 49: factor -> P_A expresion P_C\n");
		}
		|contar {
			factorPtr = contarPtr;
			printf("\n\tRegla 50: factor -> contar\n");
		}
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
		if(imprimirTS() == 1) 
			printf("Error al crear el archivo de la tabla de simbolos\n");
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

/*******************************************/
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
       tamAux = strlen(nombre)-2;
       strcpy(nombre, (nombre+1));
       nombre[tamAux] = '\0'; 
    
    }/********/
    if(nombre[0] == '@')
    {
        strcpy(lexema,nombre);
        strcpy(tablaSimbolos[puntero_array].tipo, tipo);
    }/******/
	
	if(strcmp(tipo,"ID")==0){
		strcpy(lexema,nombre);
		//strcpy(tablaSimbolos[puntero_array].tipo, "ID");
	}else
		strcat(lexema,nombre);
    
	for(i = 0; i < puntero_array; i++){ //Si esta vacia la TS, no entra
		if(strcmp(tablaSimbolos[i].nombre, lexema) == 0)
			return i; //Si el lexema ya existe en la ts, entonces retorno su posicion.
	}

	if(strcmp(tipo,"CTE_ENT")==0){// Si el lexema es una cte, entonces seteo el campo "valor" en la ts.
		strcpy(tablaSimbolos[puntero_array].tipo, "Entero");
		strcpy(tablaSimbolos[puntero_array].valor, nombre);
    }
	else{
		if(strcmp(tipo,"CTE_FLOAT")==0){
			strcpy(tablaSimbolos[puntero_array].tipo, "Real");
			strcpy(tablaSimbolos[puntero_array].valor, nombre);
		}
		else{
			if(strcmp(tipo,"CTE_BIN") == 0){
				itoa(binADecimal(nombre), cteBin, 10);
				strcpy(tablaSimbolos[puntero_array].tipo, "Binario");
				strcpy(tablaSimbolos[puntero_array].valor, cteBin);
			}else{
				if(strcmp(tipo, "CTE_HEX") == 0){
					itoa(hexADecimal(nombre), cteHex, 10);
					strcpy(tablaSimbolos[puntero_array].tipo, "Hexadecimal");
					strcpy(tablaSimbolos[puntero_array].valor, cteHex);
				}else
					tablaSimbolos[puntero_array].valor[0]='\0';
						
			}
		}
	}
        
	strcpy(tablaSimbolos[puntero_array].nombre, lexema ); //Seteo el campo "nombre" en la ts en todos los casos.

	//tablaSimbolos[puntero_array].tipo[0]='\0';
	
    if(strcmp(tipo, "CTE_STR")==0)//Si se trata de una constante string, entonces contar las cantidad de caracteres y setear en ts.
    {
        itoa(strlen(nombre),longi_str_cte,10);
		strcpy(tablaSimbolos[i].tipo, "String");
        strcpy(tablaSimbolos[i].longitud,longi_str_cte);
		strcpy(tablaSimbolos[i].valor,nombre);
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

	fprintf(pf, "%-35s %-20s %-45s %-20s\n", "Nombre", "Tipo", "Valor", "Longitud");
	for (i = 0; i < puntero_array; i++)
		fprintf(pf, "%-35s %-20s %-45s %-20s\n", tablaSimbolos[i].nombre,tablaSimbolos[i].tipo,tablaSimbolos[i].valor,tablaSimbolos[i].longitud);
		
	
	fclose(pf); 

	return 0;
}
/***************************/
int set_Tipo_TS(char* nombre, char* tipo){
    if(contadorTipo> contadorVariables){
        printf("contadorTipo > contadorVariables");
        return 0;
    }
    int pos = buscar_TS(nombre);
    if(pos == -1){
        printf("\ntablaVariables[contadorTipo]: %s\n",nombre);
        printf("\nNo encontrado\n");
        exit(1);
    }
    strcpy(tablaSimbolos[pos].tipo,tipo);
    return 0;   
        
}

int buscar_TS(char* nombre){
int i;
    for(i = 0; i < puntero_array ; i++){
		if(strcmp(tablaSimbolos[i].nombre, nombre) == 0){
			return i;
		}
	}
    return -1;
}
/***************************/
/********ARBOL**************/

nodo* crearNodo(const char *d, nodo* hI, nodo* hD) {
	nodo* nodoPadre = (nodo*)malloc(sizeof(nodo));
    if(nodoPadre == NULL) {
        printf("No hay memoria disponible");
        exit(1);
    }
    strcpy(nodoPadre->dato, d);
    nodoPadre->hijoDer = hD;
    nodoPadre->hijoIzq = hI;
    //escribeLog(nodoPadre->dato, nodoPadre->hijoIzq->dato, nodoPadre->hijoDer->dato);
    return nodoPadre;
}

nodo* crearHoja(const char *d) {
	nodo* nuevoNodo = (nodo*)malloc(sizeof(nodo));
    if(nuevoNodo == NULL) {
        printf("No hay memoria disponible");
        exit(1);
    }
    strcpy(nuevoNodo->dato, d);
    nuevoNodo->hijoDer = NULL;
    nuevoNodo->hijoIzq = NULL;
    if(strncmp(nuevoNodo->dato, "@", 1) == 0) {
        armarTS("int", nuevoNodo->dato);
        //InsertarToken_TS(nuevoNodo->dato, "int", strlen(nuevoNodo->dato), "");
    }
    return nuevoNodo;
}

void crear_pila(t_pila *pp)
{
    *pp = NULL;
}

int apilarDinamica(t_pila *PP, const t_dato *pd)
{
    t_nodo *pnue= (t_nodo *)malloc(sizeof(t_nodo));
    if(!pnue)
        return 0;

    pnue->dato = *pd;
    pnue->psig = *PP;
    *PP=pnue;
    return 1;

}

int desapilarDinamica(t_pila *pp, t_dato *pd)
{
    t_nodo *aux;
    if(*pp==NULL)
        return 0;

    aux = *pp;
    *pd = aux->dato; //== (*pp)->dato
    *pp = aux->psig;
    free(aux);
    return 1;

}

int verTopeDinamica(t_pila *PP, t_dato *pd)
{

    if(!*PP)
        return 0;
    *pd=(*PP)->dato;

}

void escribirArbol(nodo *padre) {
    FILE *archivo = fopen("intermedia.txt", "w");
    if (archivo == NULL) {
        return;
    }
    inOrden(archivo, padre);
    fclose(archivo);
}

int inOrden(FILE *archivo, struct nodo* raiz) {
    if (raiz != NULL) {
        int izq = inOrden(archivo, raiz->hijoIzq);
        if (izq == 1) {
            if (esHoja(raiz->hijoDer)) {
                // la izquierda ya esta, y la derecha es hoja
                fprintf(archivo, "%s  ", raiz->hijoIzq);
                fprintf(archivo, "%s  ", raiz->dato);
                fprintf(archivo, "%s  ", raiz->hijoDer);
                fprintf(archivo, "\n");
                return 1;
            }
            // estoy pasando de izquierda a derecha (ya dibuje la izquierda)
            // printf("%s  ", raiz->dato);
        }

        inOrden(archivo, raiz->hijoDer);

        if (esHoja(raiz->hijoIzq) && esHoja(raiz->hijoDer)) {
            // soy nodo mas a la izquierda con dos hijos hojas 
            fprintf(archivo, "%s  ", raiz->hijoIzq);
            fprintf(archivo, "%s  ", raiz->dato);
            fprintf(archivo, "%s  ", raiz->hijoDer);
            fprintf(archivo, "\n");  
            return 1;
        }

        if (izq == 1) {
            // porque a la izquierda imprimi y seguro la derecha va encontrar dibujarse
            return 1;
        }

        if (izq == 0 && raiz->hijoIzq != NULL) {
            // resulta que mi hijo de la derecha tiene mas prioridad y al subir tengo que imprimirme
            fprintf(archivo, "%s  ", raiz->hijoIzq);
            fprintf(archivo, "%s  ", raiz->dato);
            fprintf(archivo, "%s  ", raiz->hijoDer);
            fprintf(archivo, "\n");
            return 1;
        }
    }
    // porque estoy a la izquierda pero soy hoja y mi padre todavia no me imprimio
    return 0;
}

int esHoja(nodo *hoja) {
    if (hoja == NULL) {
        return 0;
    }
    return hoja->hijoIzq == NULL && hoja->hijoDer == NULL;
}

/***************************/