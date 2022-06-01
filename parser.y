%{

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "tab.h"

extern int numlin;
extern int scope;
extern FILE *yyin;

#define true 1
#define false 0

void yyerror(char*);


// Variables auxiliares para comprobar los parámetros de las funciones
char* functionName = "";
int functionNumberParam = -1;
int checkingParamNumber = 0;

%}
/* SIMBOLOS TERMINALES */

%token IF
%token ELIF
%token ELSE

%token WHILE
%token DO
%token FOR
%token CONTINUE
%token BREAK

%token AND
%token OR
%token NOT

%token EQUALS
%token NOT_EQ
%token LESS_EQ
%token BIGGER_EQ

%token VOID
%token INT
%token FLOAT
%token CHAR
%token BOOL
%token STRING

%token HEADER
%token GLOBAL
%token RETURN

%token ASSIGN_ADD
%token ASSIGN_SUBS
%token ASSIGN_MULT
%token ASSIGN_DIV

%token <int4>LIT_INT
%token <fl>LIT_FLOAT
%token <ch>LIT_CHAR
%token <str>LIT_STRING

%token TRUE
%token FALSE

%union{
  char *str;
  long int4;
  float fl;
  char ch;
}

%token <str>ID
%token MAIN


%type <int4>typeFunction typePrimitive typeVariable


%start program

%right '=' ASSIGN_ADD ASSIGN_DIV ASSIGN_MULT ASSIGN_SUBS
%left OR
%left AND
%left  EQUALS NOT_EQ
%left '<' '>' LESS_EQ BIGGER_EQ
%left '+' '-'
%left '*' '/' '%'
%right '^'
%right NOT



%%	/********* REGLAS GRAMATICALES *********/

program: 			header global functionArea 						{show();};



/********* REGLAS DEL HEADER *********/
header: 			/* empty */
|					HEADER '{' headerWrapper '}';

headerWrapper: 		/* empty */
|					headerWrapper headerdcl;

headerdcl: 			typeFunction ID {add($2, $1, funcion, 0, false);} '(' paramWrapper ')' ';';

paramWrapper: 		/* empty */
|					paramWrapperRecursive  {
												if(checkingParamNumber < functionNumberParam) yyerror("El numero de parametros es menor que en el header.");
												checkingParamNumber = 0;
											};

paramWrapperRecursive: {checkingParamNumber++;} param 
|					paramWrapperRecursive ',' {checkingParamNumber++;} param;

param:				typeVariable ID									{	
																		if(functionName[0] == '\0') {
																			add($2, $1, param, 0, false);
																		} else {
																			struct nodo * param = getParameterByNumber(functionName, checkingParamNumber);
																			
																			if(param == NULL) {
																				yyerror("El parametro no esta declarado en el header.");
																			} else {
																				if($1 != param->tipo) yyerror("El tipo del parametro no corresponde con el del header");	
																				if(strcmp($2, param->id) != 0) yyerror("El nombre del parametro no corresponde con el del header");
																			}
																			
																		}
																		printf("%s %d %d\n", functionName, functionNumberParam, checkingParamNumber);
																	}
|					typePrimitive '[' ']' ID;						/* TODO: AÑADIR ARRAYS A LA PILA */



/********* REGLAS DEL GLOBAL *********/
global:				/* empty */
|					GLOBAL '{' {scope = 0;} globalWrapper  '}' 		{scope = 0;};

globalWrapper:		/* empty */
|					globalWrapper variabledcl ;



/********* REGLAS ZONA DE DECLARACIÓN DE FUNCIONES *********/
functionArea: 		functionWrapper main functionWrapper;

functionWrapper: 	/* empty */
|					functionWrapper functiondcl;

/* ID can't be 'main' */
/* already checked? */
functiondcl: 		typeFunction ID {functionName = $2; functionNumberParam = countFunctionParameters($2);}'(' paramWrapper ')' '{'		{

																																			struct nodo *puntero = search($2, funcion);;
																																			if(puntero == NULL) {
																																				yyerror("La funcion no esta declarada en el header");
																																			} else {
																																				if($1 != puntero->tipo) {
																																					yyerror("El tipo de la funcion no corresponde con la del header");
																																				} else {
																																					puntero = puntero->param;
																																					while(puntero != NULL) {
																																						add(puntero->id, puntero->tipo, local, scope, puntero->array);
																																						
																																						puntero = puntero->param;
																																					}
																																				}
																																			}
																																			
																																			functionNumberParam = -1;
																																			functionName = "";
																																		}	
															
										statementWrapper '}'					{deleteScope(scope);};

main:           	INT MAIN '(' ')' '{' statementWrapper '}'					{deleteScope(scope); printf("%s\n", functionName);};



/********* REGLAS DECLARACIÓN DE STATEMENT *********/
statementWrapper: 	/* empty */
|					statementWrapper statement;

/* FIXME CONTINUE BREAK RETURN */
statement: 			loop
|					conditional
|					variabledcl
|					functionCall ';'
|					varAssign ';'
|					BREAK ';'
|					CONTINUE ';'
|					RETURN expression ';';
/* returnExpression */



/********* REGLAS DECLARACIÓN DE BUCLES *********/
loop: 				forLoop
|					whileLoop
|					DO whileLoop;

forLoop: 			FOR '(' forStatement ')' '{' statementWrapper '}'			{deleteScope(scope);};

/* HACK variabledcl already has ';' */
/* boolExpression */
forStatement: 		variabledcl expression ';'  varAssign;

/* boolExpression */
whileLoop: 			WHILE '(' expression ')' '{' statementWrapper '}'			{deleteScope(scope);};



/********* REGLAS DECLARACIÓN DE CONDICIONALES*********/
conditional: 		ifCond elifCond elseCond;

/* boolExpression */
ifCond: 			IF '(' expression ')'  '{' statementWrapper '}'				{deleteScope(scope);};

/* boolExpression */
elifCond: 			/* empty */
|					elifCond ELIF '(' expression ')'  '{' statementWrapper '}'	{deleteScope(scope);};

elseCond: 			/* empty */
|					ELSE '{' statementWrapper '}'								{deleteScope(scope);};



/********* REGLAS ASIGNACIONES *********/
varAssign: 			ID assignSymbols expression;

assignSymbols: '='
|					ASSIGN_ADD
|					ASSIGN_SUBS
|					ASSIGN_MULT
|					ASSIGN_DIV;



/********* REGLAS DECLARACIÓN DE VARIABLES *********/
variabledcl:		typeVariable ID '=' expression ';' 						{add($2, $1, (scope == 0) ? global : local, scope, false);}
|					arraydcl;


// TODO Pensar que hacer con los arrays en pila

/********* REGLAS DECLARACIÓN DE ARRAY *********/
// FIXME Comprobar si ID es $3
arraydcl:			typePrimitive '[' LIT_INT ']' ID ';' 					/*{add($5, $1, (scope == 0) ? global : local, scope, true);}*/
|					typePrimitive '[' ']' ID '=' ID ';' 					/*{add($4, $1, (scope == 0) ? global : local, scope, true);}*/
|					typePrimitive '[' ']' ID '=' '{' arrayWrapper '}' ';' 	/*{add($4, $1, (scope == 0) ? global : local, scope, true);}*/ ;  // comprobar todos los tipos?

arrayWrapper:	/* empty */
|					array;

array:		expression // ir pasando el tipo para arriba?
|					array ',' expression;


// TODO comprobar tipos?
// TODO comprobar uno a uno si los operadores son correctos y funcionan
// FIXME diferenciar tipos y validar si se puede hacer la función
// FIXME string 
/********* REGLAS EXPRESIONES *********/
expression:	functionCall
|					ID '[' LIT_INT ']'
|					ID															
|					literals										/*{$$ = $1;}*/
|					NOT expression									/*{$$ = $2; gc("\tR%d=!R%d\n",$$,$$);}*/
|					'-' expression									/*{$$ = $2; gc("\tR%d=0-R%d\n",$$,$$);}*/
|					'(' expression ')'                              /**/
|					expression EQUALS expression					/*{$$ = $1; gc("\tR%d=R%d==R%d\n",$$,$1,$3); lib_reg($3);}*/
|					expression NOT_EQ expression					/*{$$ = $1; gc("\tR%d=R%d!=R%d\n",$$,$1,$3); lib_reg($3);}*/
|					expression LESS_EQ expression					/*{$$ = $1; gc("\tR%d=R%d<=R%d\n",$$,$1,$3); lib_reg($3);}*/
|					expression BIGGER_EQ expression 				/*{$$ = $1; gc("\tR%d=R%d>=R%d\n",$$,$1,$3); lib_reg($3);}*/
|					expression '>' expression						/*{$$ = $1; gc("\tR%d=R%d<R%d\n",$$,$1,$3); lib_reg($3);}*/
|					expression '<' expression 						/*{$$ = $1; gc("\tR%d=R%d<R%d\n",$$,$1,$3); lib_reg($3);}*/
|					expression OR expression						/*{$$ = $1; gc("\tR%d=R%d||R%d\n",$$,$1,$3); lib_reg($3);}*/
|					expression AND expression 						/*{$$ = $1; gc("\tR%d=R%d&&R%d\n",$$,$1,$3); lib_reg($3);}*/
|					expression '+' expression 						/*{$$ = $1; gc("\tR%d=R%d+R%d\n",$$,$1,$3); lib_reg($3);}*/
|					expression '-' expression 						/*{$$ = $1; gc("\tR%d=R%d-R%d\n",$$,$1,$3); lib_reg($3);}*/
|					expression '*' expression 						/*{$$ = $1; gc("\tR%d=R%d*R%d\n",$$,$1,$3); lib_reg($3);}*/
|					expression '/' expression 						/*{$$ = $1; gc("\tR%d=R%d/R%d\n",$$,$1,$3); lib_reg($3);}*/
|					expression '^' expression 						// TODO crear función interna
|					expression '%' expression; 						// TODO crear función interna

literals: 			LIT_INT											/*{$$ = assig_reg(entero); gc("\tR%d=%d\n",$$, $1);}*/
|					LIT_FLOAT 										/*{$$ = assig_reg(comaFlotante); gc("\tR%d=R%f\n",$$,$1);}*/
|					LIT_CHAR 										/*{$$ = assig_reg(entero); gc("\tR%d=%d\n",$$, $1);}*/
|					LIT_STRING 										// TODO arrays
|					boolLiteral										/*{$$ = $1;}*/;

boolLiteral:		TRUE											/*{$$ = assig_reg(entero); gc("\tR%d=1\n",$$);}*/
|					FALSE											/*{$$ = assig_reg(entero); gc("\tR%d=0\n",$$);}*/;

/* TODO: Hacer comprobaciones a la hora de llamar a la funcion: id correcta, num param, etc */

/********* REGLAS LLAMADA A UNA FUNCION*********/
	functionCall: 		ID '(' paramsFunctionCallWrapper ')' 	{
																	struct nodo *puntero = search($1, funcion);
																	if(puntero == NULL) {
																		yyerror("La funcion no esta declarada en el header");
																	}
																}; 	// search id y recoger parámetros, loopearlos en orden

paramsFunctionCallWrapper: 	/* empty */								// linked list u otro stack vacío
|					paramsFunctionCall;

paramsFunctionCall: paramsFunctionCall ',' expression 				// stackear parámetros
|					expression;										// linked list u otro stack



/********* REGLAS TIPOS *********/
typePrimitive:		BOOL 			{$$ = boolean;}
|					CHAR			{$$ = caracter;}
|					INT				{$$ = entero;}
|					FLOAT			{$$ = comaFlotante;};

typeVariable: 		STRING			{$$ = ristra;}
|					typePrimitive	{$$ = $1;};	

typeFunction: 		VOID			{$$ = vacio;}
|					typePrimitive	{$$ = $1;};

%%

// TODO crear gc(string)
// TODO crear assig_reg(enum)

void yyerror(char* mens) {
  printf("Error en linea %i: %s \n",numlin,mens);
  exit(-1);
}

int main(int argc, char** argv) {

    if(argc == 2) {
		yyin = fopen(argv[1],"r");
	}

	yyparse();

    return 0;
}



	