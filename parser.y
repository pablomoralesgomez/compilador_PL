%{

#include <stdio.h>
#include <stdlib.h>
#include "tab.h"

extern int numlin;
extern int scope;
extern FILE *yyin;

char *line;
int lineSize;

#define true 1
#define false 0


// Struct auxiliar para tratar con valores en la zona de expression
struct reg_tipo{
	int reg;
	int tipo;
};


void yyerror(char*);

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
	int registry;
	int direction;
	struct reg_tipo * expr;
}

%token <str>ID
%token MAIN

%type <int4>typeFunction typePrimitive typeVariable
%type <expr> expression

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


// TODO Levantar error cuando los adds no funcionan
/********* REGLAS DEL HEADER *********/
header: 			/* empty */
|					HEADER '{' headerWrapper '}';

headerWrapper: 		/* empty */
|					headerWrapper headerdcl;

headerdcl: 			typeFunction ID {add($2, $1, funcion, 0, -1, NULL);} '(' paramWrapper ')' ';';

paramWrapper: 		/* empty */
|					paramWrapperRecursive;

paramWrapperRecursive: param
|					paramWrapperRecursive ',' param;

param:				typeVariable ID									{add($2, $1, param, 0, -1, NULL);}
|					typePrimitive '[' ']' ID						{add($2, $1, param, 0, -1, NULL);};



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
functiondcl: 		typeFunction ID '(' paramWrapper ')' '{'		{
																		struct nodo *puntero = search($2, funcion);
																		if(puntero == NULL) {
																			yyerror("La funcion no esta declarada en el header");
																		} else {
																			if($1 != puntero->tipo) {
																				yyerror("El tipo de la funcion no corresponde con la del header");
																			} else {
																				puntero = puntero->param;
																				while(puntero != NULL) {
																					add(puntero->id, puntero->tipo, local, scope, getAddress(puntero->tipo, 1), puntero->array); // FIXME cuando es array el tipo no es el del puntero, sino entero
																					
																					puntero = puntero->param;
																				}
																			}
																		}
																	}	
															
										statementWrapper '}'					{deleteScope(scope);};

main:           	INT MAIN '(' ')' '{' statementWrapper '}'					{deleteScope(scope);};



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
varAssign: 	ID '=' expression				{snprintf(line,lineSize,"\tI(R%d)=R%d\n",$1,$3);gc(line); lib_reg($3);lib_reg($1);lib_reg($$);}	//check type
|					ID ASSIGN_ADD expression		{$$ = assign_reg(entero); snprintf(line,lineSize, "\tI(R%d)=R%d+R%d\n",$1,$$,$3);gc(line); lib_reg($3);lib_reg($1);lib_reg($$);}
|					ID ASSIGN_SUBS expression	{$$ = assign_reg(entero); snprintf(line,lineSize, "\tI(R%d)=R%d-R%d\n",$1,$$,$3);gc(line); lib_reg($3);lib_reg($1);lib_reg($$);}
|					ID ASSIGN_MULT expression	{$$ = assign_reg(entero); snprintf(line,lineSize, "\tI(R%d)=R%d*R%d\n",$1,$$,$3);gc(line); lib_reg($3);lib_reg($1);lib_reg($$);}
|					ID ASSIGN_DIV expression		{$$ = assign_reg(entero); snprintf(line,lineSize, "\tI(R%d)=R%d/R%d\n",$1,$$,$3);gc(line); lib_reg($3);lib_reg($1);lib_reg($$);};
//|					LIT_STRING 											// TODO arrays
//|					arrays 											// TODO arrays




/********* REGLAS DECLARACIÓN DE VARIABLES *********/
variabledcl:	typeVariable ID '=' expression ';' 	{add($2, $1, (scope == 0) ? global : local, scope, getAddress($1, 1), NULL);}
|					STRING ID '=' expression ';'
|					arraydcl;



// TODO Pensar que hacer con los arrays en pila
// TODO cambiar true por el número de elementos

/********* REGLAS DECLARACIÓN DE ARRAY *********/
// FIXME Comprobar si ID es $3
arraydcl:			typePrimitive '[' LIT_INT ']' ID ';' {
																								struct array *arr = malloc(sizeof(struct arr));
																								arr->length = $3;
																								arr->address = getAddress($1, arr->length);
																								add($5, $1, (scope == 0) ? global : local, scope, getAddress(entero, 1), arr);} // FIXME números negativos
|					typePrimitive '[' ']' ID '=' ID ';' {
																								struct nodo* puntero = find($6);
																								if (puntero == NULL){
																									yyerror("La segunda ID no está definida");
																								};
																								if($1 != puntero->tipo) {
																									yyerror("El tipo de ambas ID no coincide");
																								};
																								if (puntero->array == 0){
																									yyerror("La segunda ID no es una array");
																								};
																								add($4, $1, (scope == 0) ? global : local, scope, getAddress(entero), puntero->array);}
|					typePrimitive '[' ']' ID '=' '{' arrayWrapper '}' ';' {
																								struct array *arr = malloc(sizeof(struct arr));
																								arr->length = $3;
																								arr->address = getAddress($1, arr->length);
																								add($4, $1, (scope == 0) ? global : local, scope, getAddress(entero, 1), arr);} ;  // FIXME length, comprobar todos los tipos?

arrayWrapper:	/* empty */
|					array;

array:		expression											{$$ = $1;}
|					array ',' expression;


// TODO comprobar tipos?
// TODO comprobar uno a uno si los operadores son correctos y funcionan
// FIXME diferenciar tipos y validar si se puede hacer la función
// FIXME string 
/********* REGLAS EXPRESIONES *********/
expression:	functionCall									{
																					struct expr ex;
																					ex->reg = -1;
																					ex->tipo = -1;
																					}
|					ID '[' LIT_INT ']'							{
																					struct expr ex;
																					ex->reg = -1;
																					ex->tipo = -1;
																					}
|					ID															{
																					struct nodo *puntero = find($1);
																					int reg = assign_reg(entero);
																					struct reg_tipo res = {puntero->tipo, reg};
																					snprintf(line,lineSize, "\tR%d=I(%d)\n", reg, puntero->address);
																					gc(line);
																					$$ = &res;
																					}
|					literals												{$$ = $1;}
|					NOT expression									{snprintf(line,lineSize, "\tR%d=!R%d\n",$2,$2);gc(line);}												// boolean
|					'-' expression									{snprintf(line,lineSize, "\tR%d=0-R%d\n",$2,$2);gc(line);}											// numeros
|					'(' expression ')'																																															// todos
|					expression EQUALS expression		{snprintf(line,lineSize, "\tR%d=R%d==R%d\n",$1,$1,$3);	gc(line);lib_reg($3);}	// string char float int    float-int int-char
|					expression NOT_EQ expression		{snprintf(line,lineSize, "\tR%d=R%d!=R%d\n",$1,$1,$3);	gc(line);lib_reg($3);}
|					expression LESS_EQ expression		{snprintf(line,lineSize, "\tR%d=R%d<=R%d\n",$1,$1,$3);	gc(line);lib_reg($3);}
|					expression BIGGER_EQ expression {snprintf(line,lineSize, "\tR%d=R%d>=R%d\n",$1,$1,$3);	gc(line);lib_reg($3);}
|					expression '>' expression				{snprintf(line,lineSize, "\tR%d=R%d<R%d\n",$1,$1,$3);		gc(line);lib_reg($3);}
|					expression '<' expression 			{snprintf(line,lineSize, "\tR%d=R%d<R%d\n",$1,$1,$3);		gc(line);lib_reg($3);}
|					expression OR expression				{snprintf(line,lineSize, "\tR%d=R%d||R%d\n",$1,$1,$3);	gc(line);lib_reg($3);}
|					expression AND expression 			{snprintf(line,lineSize, "\tR%d=R%d&&R%d\n",$1,$1,$3);	gc(line);lib_reg($3);}
|					expression '+' expression 			{snprintf(line,lineSize, "\tR%d=R%d+R%d\n",$1,$1,$3);		gc(line);lib_reg($3);}
|					expression '-' expression 			{snprintf(line,lineSize, "\tR%d=R%d-R%d\n",$1,$1,$3);		gc(line);lib_reg($3);}
|					expression '*' expression 			{snprintf(line,lineSize, "\tR%d=R%d*R%d\n",$1,$1,$3);		gc(line);lib_reg($3);}
|					expression '/' expression 			{snprintf(line,lineSize, "\tR%d=R%d/R%d\n",$1,$1,$3);		gc(line);lib_reg($3);}
|					expression '^' expression 			// TODO crear función interna
|					expression '%' expression; 			// TODO crear función interna

literals: 			LIT_INT							{
																		int reg = assign_reg(entero);
																		struct reg_tipo res = {entero, reg};
																		snprintf(line,lineSize, "\tR%d=%d\n",reg, $1);
																		gc(line);
																		$$ = &res;
																		}
|					LIT_FLOAT 								{
																		int reg = assign_reg(comaFlotante);
																		struct reg_tipo res = {comaFlotante, reg};
																		snprintf(line,lineSize, "\tRR%d=%f\n",reg, $1);
																		gc(line);
																		$$ = &res;
																		}
|					LIT_CHAR 									{
																		int reg = assign_reg(entero);
																		struct reg_tipo res = {caracter, reg};
																		snprintf(line,lineSize, "\tR%d=%d\n",reg, $1);
																		gc(line);
																		$$ = &res;
																		}
|					boolLiteral								{$$ = $1;};

boolLiteral:		TRUE								{
																		int reg = assign_reg(entero);
																		struct reg_tipo res = {boolean, reg};
																		snprintf(line,lineSize, "\tR%d=1\n",reg);
																		gc(line);
																		$$ = &res;
																		}
|					FALSE											{
																		int reg = assign_reg(entero);
																		struct reg_tipo res = {boolean, reg};
																		snprintf(line,lineSize, "\tR%d=0\n",reg);
																		gc(line);
																		$$ = &res;
																		};

/* TODO: Hacer comprobaciones a la hora de llamar a la funcion: id correcta, num param, etc */

/********* REGLAS LLAMADA A UNA FUNCION*********/
functionCall: 		ID '(' paramsFunctionCallWrapper ')' {
																		struct nodo *puntero = search($1, funcion);
																		if(puntero == NULL) {
																			yyerror("La funcion no esta declarada en el header");
																		}else{
																			puntero = puntero->param;
																			while(puntero != NULL) {
																				add(puntero->id, puntero->tipo, local, scope, puntero->address, puntero->array);
																				
																				puntero = puntero->param;
																			}
																		}}; // search id y recoger parámetros, loopearlos en orden

paramsFunctionCallWrapper: 	/* empty */	// linked list u otro stack vacío
|					paramsFunctionCall;

paramsFunctionCall: paramsFunctionCall ',' expression // stackear parámetros
|					expression;	// linked list u otro stack



/********* REGLAS TIPOS *********/
typePrimitive:		BOOL 			{$$ = boolean;}
|					CHAR			{$$ = caracter;}
|					INT				{$$ = entero;}
|					FLOAT			{$$ = comaFlotante;};

typeVariable: 		STRING			{$$ = ristra;}
|					typePrimitive	{$$ = $1;};	

typeFunction: 		VOID			{$$ = vacio;}
|					typePrimitive	{$$ = $1;};


/********* MISCELÁNEA Q *********/
//ID:	stackID {gc("\tR%d=I(R%d)\n",$1,$1);};	//TODO get ID val in registry

//stackID: ID 		{$$ = assign_reg(entero);gc("\tR$$=I(%d)\n",$$,$1);};	// TODO get ID position in stack in registry
// TODO function to get address in stack
%%

struct nodo * find(char* id){
	struct nodo *puntero = search(id, local);
	if (puntero == NULL){
		puntero = search(id, global);
		if (puntero == NULL){
			yyerror("ID no existente");
		}
	}
	return puntero;
}

void gc(char* text){
	printf(text); // TODO do
}

int assign_reg(int tipo){
	// TODO check type
	// TODO do
	return 1;
}

void lib_reg(int reg){
	// TODO do
}

void yyerror(char* mens) {
  printf("Error en linea %i: %s \n",numlin,mens);
  exit(-1);
}

int main(int argc, char** argv) {
	char charSize = 'a';
	lineSize = sizeof(charSize)*300;
	line = malloc(lineSize);

  if(argc == 2) {
		yyin = fopen(argv[1],"r");
	}

	yyparse();

	free(line);
  return 0;
}



	