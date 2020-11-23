%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "y.tab.h"

#define ETIQUETA_IF 0
#define ETIQUETA_WHILE 1

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
char * obtenerTipoTS(char * tipo);
void verificarDeclaraciones();
/***************************************************/
/*******************ARBOL***************************/
typedef struct nodo{
    char dato[30];
    char tipo[15];
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

nodo* retorno = NULL;

nodo* crearNodo(const char* , nodo* , nodo* );
nodo* crearHoja(const char*, char * tipo);
void crear_pila(t_pila *pp);
int apilarDinamica(t_pila *, t_dato *);
nodo * desapilarDinamica(t_pila *);
nodo * verTopeDinamica(t_pila *PP);
void escribirArbol(nodo *);
int inOrden(FILE *, struct nodo*);
int esHoja(nodo *);

void escribirGragh(nodo* padre);
void llenarGragh(nodo* padre, FILE *arch, int numNodo);
void liberarMemoria(nodo* padre);
char * comparadorOpuesto(nodo* );
//void validarComparacion();
char * conGuion(const char *valor);
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
nodo* pivot = NULL;

/*************ASSEMBLER************************/
////variables
int cantAux=0;
int tieneElse=0;
int condicionOR=0;
int esWhile = 0;

int numEtiqWhile = 0;
int numEtiqIf = 0;

int pilaNumEtiqWhile [10];
int pilaNumEtiqIf [10];

int topePilaWhile = 0;
int topePilaIf = 0;

int asignacionString= 0;
char instruccionPut[50];

////funciones

void generarAssembler(nodo * raiz);
char * nombreAssembler (char * nombre);
char * ponerComillas(char * valor);
char * verSiVaInterrogacion(char *valor);
void apilarEtiqueta(const int tipoEtiqueta);
int desapilarEtiqueta(const int tipoEtiqueta);
int verTopePilaEtiqueta(const int tipoEtiqueta);
void verOperacion(FILE * fp, nodo * raiz);
int esAritmetica(const char *operador);
char* obtenerInstruccionAritmetica(const char *operador);
int esComparacion(const char * comparador);
char *cargaEntero(const nodo * hijo);
char* obtenerSalto();
int pedirAux(char* tipo);
char* obtenerInstruccionPut(nodo* nodo);
char* obtenerInstruccionGet(nodo* nodo);
char* obtenerInstruccionComparacion(const char *comparador);
void  recorrerArbolParaAssembler(FILE * fp, nodo* raiz);
/***************************************************/
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
%token <int_val>CTE_BINARIA
%token <int_val>CTE_HEXA

%%

programa:
		seccion_declaraciones {verificarDeclaraciones();} bloque {printf("\n\tCOMPILACION EXITOSA\n"); escribirArbol(bloquePtr); escribirGragh(bloquePtr);}
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
            bloquePtr = desapilarDinamica(&pila);
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
                char tipoAux [15];
                strcpy(tipoAux,obtenerTipoTS($1)); 
                asignacionPtr = crearNodo("=", crearHoja($1,tipoAux), desapilarDinamica(&pila));
				printf("\n\tRegla 18: asignacion -> ID ASIG expresion\n");
			}
			;

decision:
		IF P_A condicion P_C L_A bloque L_C {
			bloquePtr = desapilarDinamica(&pila);
			decisionPtr = crearNodo("IF", desapilarDinamica(&pila), bloquePtr);
			printf("\n\tRegla 19: decision -> IF P_A condicion P_C L_A bloque L_C\n");
		}
		|IF P_A condicion P_C L_A bloque L_C ELSE L_A bloque L_C {
            bloquePtr = desapilarDinamica(&pila);
            decisionPtr = crearNodo("IF", desapilarDinamica(&pila), crearNodo("CUERPO", desapilarDinamica(&pila), bloquePtr));
            printf("\n\tRegla 20: decision -> IF P_A condicion P_C L_A bloque L_C ELSE L_A bloque L_C\n");}
		;

iteracion:
			WHILE P_A condicion P_C L_A bloque L_C {
                bloquePtr = desapilarDinamica(&pila);
                iteracionPtr = crearNodo("WHILE", desapilarDinamica(&pila), crearNodo("CUERPO", bloquePtr, NULL));
                printf("\n\tRegla 21: iteracion -> WHILE P_A condicion P_C L_A bloque L_C\n");}
			;
			
condicion:
		comparacion {
			condicionPtr = comparacionPtr;
			printf("\n\tRegla 22: condicion -> comparacion\n");
		}
		|comparacion AND comparacion {
            condicionPtr = crearNodo("AND", desapilarDinamica(&pila), desapilarDinamica(&pila));
            apilarDinamica(&pila, &condicionPtr);
			printf("\n\tRegla 23: condicion -> comparacion AND comparacion\n");
		}
		|comparacion OR comparacion {
            condicionPtr = crearNodo("OR", desapilarDinamica(&pila), desapilarDinamica(&pila));
            apilarDinamica(&pila, &condicionPtr);
			printf("\n\tRegla 24: condicion -> comparacion OR comparacion\n");
		}
		|NOT comparacion {
            strcpy(comparacionPtr->dato, comparadorOpuesto(comparacionPtr));
            condicionPtr = comparacionPtr;
			printf("\n\tRegla 25: condicion -> NOT comparacion\n");
		}
		;

comparacion:
			expresion comparador expresion {
                //validarComparacion();
                comparacionPtr = crearNodo(comparadorPtr->dato, desapilarDinamica(&pila), desapilarDinamica(&pila));
                apilarDinamica(&pila,&comparacionPtr);
                printf("\n\tRegla 26: comparacion -> expresion comparador expresion\n");
            }
			|P_A expresion comparador expresion P_C {
                comparacionPtr = crearNodo(comparadorPtr->dato, desapilarDinamica(&pila), desapilarDinamica(&pila));
                apilarDinamica(&pila,&comparacionPtr);
                printf("\n\tRegla 27: comparacion -> P_A expresion comparador expresion P_C\n");
            }
			;

comparador:
			MAYOR {
				comparadorPtr = crearHoja(">", "NULL");
				printf("\n\tRegla 28: comparador -> MAYOR\n");
			}
			|MENOR {
				comparadorPtr = crearHoja("<", "NULL");
				printf("\n\tRegla 29: comparador -> MENOR\n");
			}
			|MAYOR_IGUAL {
				comparadorPtr = crearHoja(">=", "NULL");
				printf("\n\tRegla 30: comparador -> MAYOR_IGUAL\n");
			}
			|MENOR_IGUAL {
				comparadorPtr = crearHoja("<=", "NULL");
				printf("\n\tRegla 31: comparador -> MENOR_IGUAL\n");
			}
			|IGUAL {
				comparadorPtr = crearHoja("==", "NULL");
				printf("\n\tRegla 32: comparador -> IGUAL\n");
			}
			|DISTINTO {
				comparadorPtr = crearHoja("<>", "NULL");
				printf("\n\tRegla 33: comparador -> DISTINTO\n");
			}
			;

entrada:
		GET ID {
            char tipoAux [15];
            strcpy(tipoAux,obtenerTipoTS($2)); 
			entradaPtr = crearNodo("GET", crearHoja($2, tipoAux), crearHoja("@STDIN", tipoAux));
			printf("\n\tRegla 34: entrada -> GET ID\n");
		}
		;

salida:
		PUT ID {
            char tipoAux [15];
            strcpy(tipoAux,obtenerTipoTS($2));
            printf("\nTIPO ID: %s\n", tipoAux);
			salidaPtr = crearNodo("PUT", crearHoja("@STDOUT", tipoAux), crearHoja($2, tipoAux));
			printf("\n\tRegla 35: salida -> PUT ID\n");
		}
		|PUT CTE_STRING {
            
			salidaPtr = crearNodo("PUT", crearHoja("@STDOUT", "Cte_Entera"), crearHoja(conGuion(nombreAssembler($2)), "Cte_String"));
			printf("\n\tRegla 36: salida -> PUT CTE_STRING\n");
		}
		;

expresion:
			termino {
                if(terminoPtr != verTopeDinamica(&pila))
                    apilarDinamica(&pila, &terminoPtr);
                
				//expresionPtr = terminoPtr;
				printf("\n\tRegla 37: expresion -> termino\n");
			}
			|expresion OP_SUMA termino {
                desapilarDinamica(&pila);
                expresionPtr = crearNodo("+", desapilarDinamica(&pila), terminoPtr);
                apilarDinamica(&pila, &expresionPtr);
				printf("\n\tRegla 38: expresion -> expresion OP_SUMA termino\n");
			}
			|expresion OP_RESTA termino {
                desapilarDinamica(&pila);
                expresionPtr = crearNodo("-", desapilarDinamica(&pila), terminoPtr);
                //expresionPtr = crearNodo("-", desapilarDinamica(&pila), terminoPtr);
                //nodo* aux = crearNodo("-", desapilarDinamica(&pila), terminoPtr);
				apilarDinamica(&pila, &expresionPtr);
                //expresionPtr = crearNodo("-", expresionPtr, terminoPtr);
				printf("\n\tRegla 39: expresion -> expresion OP_RESTA termino\n");
			}
			;

termino:
		factor {
			terminoPtr = factorPtr;
            apilarDinamica(&pila, &terminoPtr);
			printf("\n\tRegla 40: termino -> factor\n");
		}
		|termino OP_MULT factor {
			terminoPtr = crearNodo("*", desapilarDinamica(&pila), factorPtr);
            apilarDinamica(&pila, &terminoPtr);
			printf("\n\tRegla 41: termino -> termino OP_MULT factor\n");
		}
		|termino OP_DIV factor {
			terminoPtr = crearNodo("/", desapilarDinamica(&pila), factorPtr);
            apilarDinamica(&pila, &terminoPtr);
			printf("\n\tRegla 42: termino -> termino OP_DIV factor\n");
		}
		;

factor:
		ID {
            char tipoAux [15];
            strcpy(tipoAux,obtenerTipoTS($1));
			factorPtr = crearHoja($1, tipoAux);
			printf("\n\tRegla 43: factor -> ID\n");
		}
		|CTE_ENTERA {
			factorPtr = crearHoja(conGuion($1),"Cte_Entera");
			printf("\n\tRegla 44: factor -> CTE_ENTERA\n");
		}
		|CTE_REAL {
			factorPtr = crearHoja(conGuion(nombreAssembler($1)),"Cte_Real");
			printf("\n\tRegla 45: factor -> CTE_REAL\n");
		}
		|CTE_STRING {
			factorPtr = crearHoja(conGuion(nombreAssembler($1)),"Cte_String");
			printf("\n\tRegla 46: factor -> CTE_STRING\n");
		}
		|CTE_BINARIA {
            /*char nombre [25];
            nombre[0] = '_';
            nombre[1] = '\0';
            int pos = buscar_TS(strcat(nombre,$1));
            if(pos == -1){
                printf("\nNo encontrado\n");
                exit(1);
            }*/
			factorPtr = crearHoja(conGuion($1), "Cte_Binario");
			printf("\n\tRegla 47: factor -> CTE_BINARIA\n");
		}
		|CTE_HEXA {
            /*char nombre [25];
            nombre[0] = '_';
            nombre[1] = '\0';
            int pos = buscar_TS(strcat(nombre,$1));
            if(pos == -1){
                printf("\nNo encontrado\n");
                exit(1);
            }*/
			factorPtr = crearHoja(conGuion($1),"Cte_Hexadecimal");
			printf("\n\tRegla 48: factor -> CTE_HEXA\n");
		}
		|P_A expresion P_C {
            
			factorPtr = desapilarDinamica(&pila);
            
            //apilarDinamica(&pila, &factorPtr);
            //factorPtr = expresionPtr;
			//nodo *ret = NULL;
			//desapilarDinamica(&pila, &ret);
			printf("\n\tRegla 49: factor -> P_A expresion P_C\n");
		}
		|contar {
			factorPtr = contarPtr;
            //apilarDinamica(&pila, &factorPtr);
			printf("\n\tRegla 50: factor -> contar\n");
		}
		;

contar:
		CONTAR P_A expresion { pivot = desapilarDinamica(&pila);} PyC C_A lista_constantes C_C P_C {
			contarPtr = listaContantesPtr;
            //contarPtr = desapilarDinamica(&pila);
			printf("\n\tRegla 51: contar -> CONTAR P_A expresion PyC C_A lista_constantes C_C P_C\n");
		}
		;

lista_constantes:
				factor {
					listaContantesPtr = crearNodo("CONTAR", crearNodo("IF", crearNodo("==", pivot, factorPtr), crearNodo("=", crearHoja("@CONT", "Cte_Entera"), crearNodo("+", crearHoja("@CONT", "Cte_Entera"), crearHoja("1", "Cte_Entera")))), NULL);
					//apilarDinamica(&pila, &listaContantesPtr);
					printf("\n\tRegla 52: lista_constantes -> factor\n");
				}
				|lista_constantes COMA factor {
					listaContantesPtr = crearNodo("CONTAR", crearNodo("IF", crearNodo("==", pivot, factorPtr), crearNodo("=", crearHoja("@CONT", "Cte_Entera"), crearNodo("+", crearHoja("@CONT", "Cte_Entera"), crearHoja("1", "Cte_Entera")))), listaContantesPtr);
					//apilarDinamica(&pila, &listaContantesPtr);
					printf("\n\tRegla 53: lista_constantes -> lista_constantes COMA factor\n");
				}
				;

%%

///////////////////////////////////////////////////////////////////////////////

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
   
    generarAssembler(bloquePtr);
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
        //strcpy(lexema,nombre);
        strcpy(tablaSimbolos[puntero_array].tipo, tipo);
    }/******/
	
	if(strcmp(tipo,"ID")==0 || nombre[0] == '@'){
		strcpy(lexema,nombre);
	}else
		strcat(lexema,nombre);
    
	for(i = 0; i < puntero_array; i++){ //Si esta vacia la TS, no entra
		if(strcmp(tablaSimbolos[i].nombre, lexema) == 0){
            return i; //Si el lexema ya existe en la ts, entonces retorno su posicion.
        }
			
	}

	if(strcmp(tipo,"CTE_ENT")==0){// Si el lexema es una cte, entonces seteo el campo "valor" en la ts.
		strcpy(tablaSimbolos[puntero_array].tipo, "Cte_Entera");
		strcpy(tablaSimbolos[puntero_array].valor, nombre);
    }
	else{
		if(strcmp(tipo,"CTE_FLOAT")==0){
			strcpy(tablaSimbolos[puntero_array].tipo, "Cte_Real");
			strcpy(tablaSimbolos[puntero_array].valor, nombre);
		}
		else{
			if(strcmp(tipo,"CTE_BIN") == 0){
				itoa(binADecimal(nombre), cteBin, 10);
				strcpy(tablaSimbolos[puntero_array].tipo, "Cte_Binario");
				strcpy(tablaSimbolos[puntero_array].valor, cteBin);
			}else{
				if(strcmp(tipo, "CTE_HEX") == 0){
					itoa(hexADecimal(nombre), cteHex, 10);
					strcpy(tablaSimbolos[puntero_array].tipo, "Cte_Hexadecimal");
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
		strcpy(tablaSimbolos[i].tipo, "Cte_String");
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

	fprintf(pf, "%-35s %-20s %-45s %-20s\n", "NOMBRE", "TIPO", "VALOR", "LONGITUD");
	for (i = 0; i < puntero_array; i++)
		fprintf(pf, "%-35s %-20s %-45s %-20s\n", tablaSimbolos[i].nombre,tablaSimbolos[i].tipo,tablaSimbolos[i].valor,tablaSimbolos[i].longitud);
		
	
	fclose(pf); 

	return 0;
}
/***************************/
int set_Tipo_TS(char* nombre, char* tipo){
    if(contadorTipo > contadorVariables){
        printf("contadorTipo > contadorVariables");
        return 0;
    }
    int pos = buscar_TS(nombre);
    if(pos == -1){
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

char * obtenerTipoTS(char * nombre){
    int pos = buscar_TS(nombre);
    if(pos == -1){
        printf("\nNo encontrado\n");
        exit(1);
    }  
    return tablaSimbolos[pos].tipo;
}

void verificarDeclaraciones(){
	if(contadorVariables != contadorTipo){
		printf("\nLa cantidad de variables declaradas es distinto a la cantidad de Tipos\n");
		printf("Por favor, declare correctamente y vuelva a ejecutar el programa\n");
		exit(1);
	}

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
    strcpy(nodoPadre->tipo, "NULL");
    nodoPadre->hijoDer = hD;
    nodoPadre->hijoIzq = hI;
    return nodoPadre;
}

nodo* crearHoja(const char *d, char * tipo) {
	nodo* nuevoNodo = (nodo*)malloc(sizeof(nodo));
    if(nuevoNodo == NULL) {
        printf("No hay memoria disponible");
        exit(1);
    }
    strcpy(nuevoNodo->dato, d);
    strcpy(nuevoNodo->tipo, tipo);
    nuevoNodo->hijoDer = NULL;
    nuevoNodo->hijoIzq = NULL;
    if(strncmp(nuevoNodo->dato, "@", 1) == 0) {
        armarTS(tipo, nuevoNodo->dato);
    }
    return nuevoNodo;
}

void crear_pila(t_pila *pp)
{
    *pp = NULL;
}

int apilarDinamica(t_pila *PP, t_dato *pd)
{
    t_nodo *pnue= (t_nodo *)malloc(sizeof(t_nodo));
    if(!pnue)
        return 0;

    pnue->dato = *pd;
    pnue->psig = *PP;
    *PP=pnue;
    return 1;

}

nodo * desapilarDinamica(t_pila *pp)
{
    t_nodo *aux;
    
    if(*pp==NULL)
        return 0;

    aux = *pp;
    nodo * pd = aux->dato; //== (*pp)->dato
    *pp = aux->psig;
    free(aux);
    return pd;
}


nodo * verTopeDinamica(t_pila *PP)
{

    if(!*PP)
        return 0;
    nodo * pd = (*PP)->dato;
    return pd;
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
char * conGuion(const char *valor){
    char nombre[32] = "_";
	strcat(nombre, valor);
	return strdup(nombre);
}

/***************************/

void llenarGragh(nodo* padre, FILE *arch, int numNodo) {
    if(padre == NULL) {
        return;
    }
    int numHI = numNodo*2+1;
    int numHD = numNodo*2+2;
    
    if(padre->hijoIzq) {
        fprintf(arch, "\t\"%s@%d\" -> \"%s@%d\"\n", padre->dato, numNodo, padre->hijoIzq->dato, numHI);
    }
    if(padre->hijoDer) {
        fprintf(arch, "\t\"%s@%d\" -> \"%s@%d\"\n", padre->dato, numNodo, padre->hijoDer->dato, numHD);
    }
    llenarGragh(padre->hijoIzq, arch, numHI);
    llenarGragh(padre->hijoDer, arch, numHD);
    return;
}

void escribirGragh(nodo* padre) {
    FILE *archivo;
	archivo = fopen("intermedia.dot", "w");
	if (archivo == NULL) {
		return;
	}
    //escribir la plantilla para dibujar el grafo
    fprintf(archivo, "%s\n", "digraph G {");
    llenarGragh(padre, archivo, 0);
    fprintf(archivo, "%s", "}");
    
    fclose(archivo);
    //liberarMemoria(padre);
    return;
}

/***************************/
char * comparadorOpuesto(nodo* raiz){
    
    if(strcmp(raiz->dato, "==") == 0) {
        return "<>";
    } else if (strcmp(raiz->dato, "<>") == 0) {
        return "==";
    } else if (strcmp(raiz->dato, "<") == 0) {
        return ">=";
    } else if (strcmp(raiz->dato, "<=") == 0) {
        return ">";
    } else if (strcmp(raiz->dato, ">") == 0) {
        return "<=";
    } else if (strcmp(raiz->dato, ">=") == 0) {
        return "<";
    }
}

void liberarMemoria(nodo* padre) {
    if(padre == NULL) {
        return;
    }
    liberarMemoria(padre->hijoDer);
    liberarMemoria(padre->hijoIzq);
    free(padre);
    return;
}
/////////////////ASSEMBLER//////////////////////////////////
void generarAssembler(nodo * raiz){
    int i;
    FILE *fp = fopen("Final.asm", "w");
    if(!fp)
	{
		printf("Error al guardar el archivo assembler.\n");
		exit(1);
	}
    
    ///cabecera
    fprintf(fp,"include macros2.asm\n");
	fprintf(fp,"include number.asm\n\n");
	fprintf(fp,".MODEL LARGE\n.386\n.STACK 200h\n\nMAXTEXTSIZE equ 100\n\n.DATA\n\n");

    ///TABLA DE SIMBOLO
    for(i=0; i<puntero_array; i++){
        
        if (strcmp(tablaSimbolos[i].tipo,"Cte_String")==0)
            fprintf(fp, "%-32s\tDB\t%s,'$', %s dup (?)\n", nombreAssembler(tablaSimbolos[i].nombre), ponerComillas(tablaSimbolos[i].valor),
                    tablaSimbolos[i].longitud);
        else
            fprintf(fp, "%-32s\tDD\t%s\n", nombreAssembler(tablaSimbolos[i].nombre), verSiVaInterrogacion(tablaSimbolos[i].valor));
    }
    
    ///CODIGO
    fprintf(fp,"\n.CODE\n");
    if(asignacionString == 1){
        // funciones para manejo de entrada/salida y cadenas
        fprintf(fp,"\nstrlen proc\n\tmov bx, 0\n\tstrl01:\n\tcmp BYTE PTR [si+bx],'$'\n\tje strend\n\tinc bx\n\tjmp strl01\n\tstrend:\n\tret\nstrlen endp\n");
        fprintf(fp,"\ncopiar proc\n\tcall strlen\n\tcmp bx , MAXTEXTSIZE\n\tjle copiarSizeOk\n\tmov bx , MAXTEXTSIZE\n\tcopiarSizeOk:\n\tmov cx , bx\n\tcld\n\trep movsb\n\tmov al , '$'\n\tmov byte ptr[di],al\n\tret\ncopiar endp\n");
        fprintf(fp,"\nconcat proc\n\tpush ds\n\tpush si\n\tcall strlen\n\tmov dx , bx\n\tmov si , di\n\tpush es\n\tpop ds\n\tcall strlen\n\tadd di, bx\n\tadd bx, dx\n\tcmp bx , MAXTEXTSIZE\n\tjg concatSizeMal\n\tconcatSizeOk:\n\tmov cx , dx\n\tjmp concatSigo\n\tconcatSizeMal:\n\tsub bx , MAXTEXTSIZE\n\tsub dx , bx\n\tmov cx , dx\n\tconcatSigo:\n\tpush ds\n\tpop es\n\tpop si\n\tpop ds\n\tcld\n\trep movsb\n\tmov al , '$'\n\tmov byte ptr[di],al\n\tret\nconcat endp\n");
    }
    
    
    fprintf(fp, "\nSTART:\nMOV AX,@DATA\nMOV DS,AX\nMOV es,ax\nFINIT\nFFREE\n\n");
    
    ///INSTRUCCIONES
    recorrerArbolParaAssembler(fp, raiz);
    
    ///FINAL
    fprintf(fp, "\nliberar:\n");
    fprintf(fp, "\tffree\n");
    fprintf(fp,"\tmov ax, 4c00h\n");
	fprintf(fp,"\tint 21h\n\n");
	fprintf(fp,";FIN DEL PROGRAMA DE USUARIO\n");
    
    
    fprintf(fp,"\nend");
    fclose(fp);
}

char * nombreAssembler (char * nombre){
    char *ini=nombre;
    
    while((ini= strchr(nombre,' ')) != NULL || (ini= strchr(nombre,'.'))!= NULL || (ini= strchr(nombre,'!')) != NULL || (ini= strchr(nombre,':')) != NULL || (ini= strchr(nombre,' ')) != NULL)
        *ini = '_';
    return nombre;    
}

char * ponerComillas(char * valor){
    char res[50];
    res[0]= '"';
    res[1]='\0';
    strcat(res, valor);
    //strcat(res, res[0]);
    res[strlen(res)-1] = '"';
  
    return strcpy(valor,res);
}
char * verSiVaInterrogacion(char *valor) {
    if (strcmp(valor, "") == 0) {
        return "?";
    }
    return valor;
}

void apilarEtiqueta(const int tipoEtiqueta){
    if (tipoEtiqueta == ETIQUETA_IF) {
        numEtiqIf++;
        pilaNumEtiqIf[topePilaIf++] = numEtiqIf;
    }

    if (tipoEtiqueta == ETIQUETA_WHILE) {
        numEtiqWhile++;
        pilaNumEtiqWhile[topePilaWhile++] = numEtiqWhile;
    }
}

int desapilarEtiqueta(const int tipoEtiqueta) {
    if (tipoEtiqueta == ETIQUETA_IF) {
        return pilaNumEtiqIf[--topePilaIf];
    }
    if (tipoEtiqueta == ETIQUETA_WHILE) {
        return pilaNumEtiqWhile[--topePilaWhile];
    }
}

int verTopePilaEtiqueta(const int tipoEtiqueta) {
    if (tipoEtiqueta == ETIQUETA_IF) {
        return pilaNumEtiqIf[topePilaIf - 1];
    }
    if (tipoEtiqueta == ETIQUETA_WHILE) {
        return pilaNumEtiqWhile[topePilaWhile - 1];
    }
}

int esAritmetica(const char *operador) {
    // siendo aritmetica hay un lote de instrucciones predefinido, igual si es comparacion
    
    return strcmp(operador, "+") == 0 ||
    strcmp(operador, "-") == 0 ||
    strcmp(operador, "*") == 0 ||
    strcmp(operador, "/") == 0 ||
    strcmp(operador, "=") == 0;
}
void verOperacion(FILE * fp, nodo * raiz){
    if (esAritmetica(raiz->dato)){
        
        if(strcmp(raiz->dato, "=")==0){
        
            if(strcmp(raiz->tipo, "Cte_String")==0){
                asignacionString = 1;
                fprintf(fp, "MOV si, OFFSET   %s\n", raiz->hijoDer);
                fprintf(fp, "MOV di, OFFSET  %s\n", raiz->hijoIzq);
                fprintf(fp, "CALL asignString\n");
            }else{
               
                fprintf(fp, "f%sld %s\n", cargaEntero(raiz->hijoDer), raiz->hijoDer->dato);
                fprintf(fp, "f%sstp %s\n", cargaEntero(raiz->hijoIzq), raiz->hijoIzq->dato);
            }
        } else{
            fprintf(fp, "f%sld %s\n", cargaEntero(raiz->hijoIzq), raiz->hijoIzq->dato); //st0 = izq
            fprintf(fp, "f%sld %s\n", cargaEntero(raiz->hijoDer), raiz->hijoDer->dato); //st0 = der st1 = izq
            fprintf(fp, "%s\n", obtenerInstruccionAritmetica(raiz->dato));
            fprintf(fp, "f%sstp @aux%d\n", cargaEntero(raiz), pedirAux(raiz->tipo));

            // Guardo en el arbol el dato del resultado, si uso un aux
            sprintf(raiz->dato, "@aux%d", cantAux);
            
        }
    }
    if(esComparacion(raiz->dato)){
        // esto funciona para comparaciones simples
        fprintf(fp, "f%sld %s\n", cargaEntero(raiz->hijoDer), raiz->hijoDer->dato); //st0 = der
        fprintf(fp, "f%sld %s\n", cargaEntero(raiz->hijoIzq), raiz->hijoIzq->dato); //st0 = izq  st1 = der
        fprintf(fp, "fcom\n"); // compara ST0 con ST1"
        fprintf(fp, "fstsw ax\n");
        fprintf(fp, "sahf\n");
        if (esWhile)
            fprintf(fp, "%s %s%d\n", obtenerInstruccionComparacion(raiz->dato), obtenerSalto(), verTopePilaEtiqueta(ETIQUETA_WHILE));
        else
            fprintf(fp, "%s %s%d\n", obtenerInstruccionComparacion(raiz->dato), obtenerSalto(), verTopePilaEtiqueta(ETIQUETA_IF));
    }
    
    if(strcmp(raiz->dato, "GET") == 0) {
        fprintf(fp, "%s %s\n", obtenerInstruccionGet(raiz->hijoIzq), raiz->hijoIzq->dato);
    }

    if(strcmp(raiz->dato, "PUT") == 0) {
        fprintf(fp, "%s\n", obtenerInstruccionPut(raiz->hijoDer));
        fprintf(fp, "newLine 1\n");
    }
}

int esComparacion(const char *comparador) {
    // es necesaria esta funcion para que no entren los nodos AND, OR, NOT, etc que no tienen accion
    return strcmp(comparador, ">") == 0 ||
    strcmp(comparador, ">=") == 0 ||
    strcmp(comparador, "<") == 0 ||
    strcmp(comparador, "<=") == 0 ||
    strcmp(comparador, "==") == 0 ||
    strcmp(comparador, "<>") == 0;
}

char* obtenerSalto() {
    if(condicionOR) {
        if(esWhile)
            return "startWhile";
        return "startIf";
    } else {
        if(esWhile)
            return "endwhile";
        if (tieneElse) {
            return "else";
        } else {
            return "endif";
        }
    }
}

char* obtenerInstruccionComparacion(const char *comparador) {
    
    if(condicionOR) {
        condicionOR = 0;
        if (strcmp(comparador, ">") == 0)
            return "JNBE";
        if (strcmp(comparador, ">=") == 0)
            return "JNB";
        if (strcmp(comparador, "<") == 0)
            return "JNAE";
        if (strcmp(comparador, "<=") == 0)
            return "JNA";
        if (strcmp(comparador, "==") == 0)
            return "JE";
        if (strcmp(comparador, "<>") == 0)
            return "JNE";
    } else {
        if (strcmp(comparador, ">") == 0)
            return "JNA";
        if (strcmp(comparador, ">=") == 0)
            return "JNAE";
        if (strcmp(comparador, "<") == 0)
            return "JNB";
        if (strcmp(comparador, "<=") == 0)
            return "JNBE";
        if (strcmp(comparador, "==") == 0)
            return "JNE";
        if (strcmp(comparador, "<>") == 0)
            return "JE";
    }
}

int pedirAux(char* tipo) {
    cantAux++;
    char aux[15];
    sprintf(aux, "@aux%d", cantAux);
    armarTS(tipo, aux);
    return cantAux;
}

char* obtenerInstruccionAritmetica(const char *operador) {
    if (strcmp(operador, "+") == 0)
        return "fadd";
    if (strcmp(operador, "-") == 0)
        return "fsub";
    if (strcmp(operador, "*") == 0)
        return "fmul";
    if (strcmp(operador, "/") == 0)
        return "fdiv";
}

char *cargaEntero(const nodo * hijo) {
    if (strcmp(hijo->tipo, "Cte_Entera")==0 || strcmp(hijo->tipo, "int")==0 || strcmp(hijo->tipo, "Cte_Binario")==0 || strcmp(hijo->tipo, "Cte_Hexadecimal")==0) {
        return "i";
    }
    return "";
}

void  recorrerArbolParaAssembler(FILE * fp, nodo* raiz){
   
    if(raiz != NULL){
        int nodoActualIf = 0;
        int nodoActualWhile = 0;
        
        if(strcmp(raiz->dato, "IF") == 0){
            tieneElse = 0;
            nodoActualIf = 1;
            // pido nueva etiqueta porque estoy empezando a recorrer un IF
            apilarEtiqueta(ETIQUETA_IF);
            
            if (strcmp(raiz->hijoDer->dato, "CUERPO") == 0) {
                tieneElse = 1;
            }
            if (strcmp(raiz->hijoIzq->dato, "OR") == 0) {
                condicionOR = 1;
            }
        }
        if(strcmp(raiz->dato, "WHILE") == 0) {
            nodoActualWhile = 1;
            esWhile = 1;
            apilarEtiqueta(ETIQUETA_WHILE);
            
            fprintf(fp, "condicionWhile%d:\n", verTopePilaEtiqueta(ETIQUETA_WHILE));
            
            if (strcmp(raiz->hijoIzq->dato, "OR") == 0) {
                condicionOR = 1;
            }
        }
        // RECORRO LA IZQUIERDA
        recorrerArbolParaAssembler(fp, raiz->hijoIzq);
        
        // PASE POR LA IZQUIERDA

        if(nodoActualIf) {
            fprintf(fp, "startIf%d:\n", verTopePilaEtiqueta(ETIQUETA_IF));
        }
        if(tieneElse && strcmp(raiz->dato, "CUERPO") == 0) {
            fprintf(fp, "JMP endif%d\n", verTopePilaEtiqueta(ETIQUETA_IF));
            fprintf(fp, "else%d:\n", verTopePilaEtiqueta(ETIQUETA_IF));
        
        }
        
        if(nodoActualWhile) {
            fprintf(fp, "startWhile%d:\n", verTopePilaEtiqueta(ETIQUETA_WHILE));
            esWhile = 0; 
        }
        
        // RECORRO LA DERECHA
        recorrerArbolParaAssembler(fp, raiz->hijoDer);
        // PASE POR LA DERECHA
        
        if (nodoActualIf) {
            fprintf(fp, "endif%d:\n", desapilarEtiqueta(ETIQUETA_IF));
        }
        //while 
        if(nodoActualWhile) {
            fprintf(fp, "JMP condicionWhile%d\n", verTopePilaEtiqueta(ETIQUETA_WHILE));
            fprintf(fp, "endwhile%d:\n", desapilarEtiqueta(ETIQUETA_WHILE));
        }
        
        if (esHoja(raiz->hijoIzq) && esHoja(raiz->hijoDer)) {
            // soy nodo mas a la izquierda con dos hijos hojas
            verOperacion(fp, raiz);
            
            // reduzco arbol
            raiz->hijoIzq = NULL;
            raiz->hijoDer = NULL;
        }
        
    }
}

char* obtenerInstruccionGet(nodo* nodo) {
    // Solo se permite get para IDs
    if (strcmp(nodo->tipo, "int")==0)
        return "GetInt";
    if (strcmp(nodo->tipo, "float")==0)
        return "GetFloat";
    if (strcmp(nodo->tipo,"string")==0)
        return "GetString";
}


char* obtenerInstruccionPut(nodo* nodo) {
    // Los prints solo se permiten pueden IDs o strings
    char tipoAux [15];
    strcpy(tipoAux, nodo->tipo);

    if (strcmp(tipoAux, "int")==0) {
        sprintf(instruccionPut, "DisplayInteger %s", nodo);
    } else if (strcmp(tipoAux, "float")==0) {
        sprintf(instruccionPut, "DisplayFloat %s,2", nodo);
    } else if (strcmp(tipoAux, "string")==0) {
        sprintf(instruccionPut, "DisplayString %s", nodo);
    } else if (strcmp(tipoAux, "Cte_String")==0) {
        sprintf(instruccionPut, "DisplayString %s", nodo->dato);
    }
    return instruccionPut;
}