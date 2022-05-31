%{

#include <stdio.h>
#include "tab.h"
#include "Q.h"

extern int numlin;
extern int scope;
extern FILE *yyin;

#define true 1
#define false 0

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
}

%token <str>ID
%token MAIN

%type <int4>typeFunction typePrimitive typeVariable
%type <registry> expression
%type <direction> expression

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
|					paramWrapperRecursive;

paramWrapperRecursive: param
|					paramWrapperRecursive ',' param;

param:				typeVariable ID									{add($2, $1, param, 0, false);}
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
																					add(puntero->id, puntero->tipo, local, scope, puntero->array);
																					
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
varAssign: 	stackID '=' expression				{gc("\tI(R%d)=R%d\n",$1,$3);lib_reg($3);lib_reg($1);lib_reg($$);}	//check type
|					stackID ASSIGN_ADD expression		{$$ = assign_reg(entero); gc("\tI(R%d)=R%d+R%d\n",$1,$$,$3);lib_reg($3);lib_reg($1);lib_reg($$);}
|					stackID ASSIGN_SUBS expression	{$$ = assign_reg(entero); gc("\tI(R%d)=R%d-R%d\n",$1,$$,$3);lib_reg($3);lib_reg($1);lib_reg($$);}
|					stackID ASSIGN_MULT expression	{$$ = assign_reg(entero); gc("\tI(R%d)=R%d*R%d\n",$1,$$,$3);lib_reg($3);lib_reg($1);lib_reg($$);}
|					stackID ASSIGN_DIV expression		{$$ = assign_reg(entero); gc("\tI(R%d)=R%d/R%d\n",$1,$$,$3);lib_reg($3);lib_reg($1);lib_reg($$);};



/********* REGLAS DECLARACIÓN DE VARIABLES *********/
variabledcl:		typeVariable ID '=' expression ';' 	{add($2, $1, (scope == 0) ? global : local, scope, false);}
|					arraydcl;


// TODO Pensar que hacer con los arrays en pila

/********* REGLAS DECLARACIÓN DE ARRAY *********/
// FIXME Comprobar si ID es $3
arraydcl:			typePrimitive '[' LIT_INT ']' ID ';' {add($5, $1, (scope == 0) ? global : local, scope, true);}
|					typePrimitive '[' ']' ID '=' ID ';' {add($4, $1, (scope == 0) ? global : local, scope, true);}
|					typePrimitive '[' ']' ID '=' '{' arrayWrapper '}' ';' {add($4, $1, (scope == 0) ? global : local, scope, true);} ;  // comprobar todos los tipos?

arrayWrapper:	/* empty */
|					array;

array:		expression											{$$ = $1;}
|					array ',' expression;


// TODO comprobar tipos?
// TODO comprobar uno a uno si los operadores son correctos y funcionan
// FIXME diferenciar tipos y validar si se puede hacer la función
// FIXME string 
/********* REGLAS EXPRESIONES *********/
expression:	functionCall									{$$ = $1;}
|					ID '[' LIT_INT ']'
|					evalID													{$$ = $1;}
|					literals												{$$ = $1;}
|					NOT expression									{gc("\tR%d=!R%d\n",$2,$2);}
|					'-' expression									{gc("\tR%d=0-R%d\n",$2,$2);}
|					'(' expression ')'
|					expression EQUALS expression		{gc("\tR%d=R%d==R%d\n",$1,$1,$3); lib_reg($3);}
|					expression NOT_EQ expression		{gc("\tR%d=R%d!=R%d\n",$1,$1,$3); lib_reg($3);}
|					expression LESS_EQ expression		{gc("\tR%d=R%d<=R%d\n",$1,$1,$3); lib_reg($3);}
|					expression BIGGER_EQ expression {gc("\tR%d=R%d>=R%d\n",$1,$1,$3); lib_reg($3);}
|					expression '>' expression				{gc("\tR%d=R%d<R%d\n",$1,$1,$3); lib_reg($3);}
|					expression '<' expression 			{gc("\tR%d=R%d<R%d\n",$1,$1,$3); lib_reg($3);}
|					expression OR expression				{gc("\tR%d=R%d||R%d\n",$1,$1,$3); lib_reg($3);}
|					expression AND expression 			{gc("\tR%d=R%d&&R%d\n",$1,$1,$3); lib_reg($3);}
|					expression '+' expression 			{gc("\tR%d=R%d+R%d\n",$1,$1,$3); lib_reg($3);} 
|					expression '-' expression 			{gc("\tR%d=R%d-R%d\n",$1,$1,$3); lib_reg($3);} 
|					expression '*' expression 			{gc("\tR%d=R%d*R%d\n",$1,$1,$3); lib_reg($3);}
|					expression '/' expression 			{gc("\tR%d=R%d/R%d\n",$1,$1,$3); lib_reg($3);}
|					expression '^' expression 			// TODO crear función interna
|					expression '%' expression; 			// TODO crear función interna

literals: 			LIT_INT							{$$ = assign_reg(entero); gc("\tR%d=%d\n",$$, $1);}
|					LIT_FLOAT 								{$$ = assign_reg(comaFlotante); gc("\tR%d=R%f\n",$$,$1);}
|					LIT_CHAR 									{$$ = assign_reg(entero); gc("\tR%d=%d\n",$$, $1);}
|					LIT_STRING 								// TODO arrays
|					boolLiteral								{$$ = $1;};

boolLiteral:		TRUE								{$$ = assign_reg(entero); gc("\tR%d=1\n",$$);}
|					FALSE											{$$ = assign_reg(entero); gc("\tR%d=0\n",$$);};

/* TODO: Hacer comprobaciones a la hora de llamar a la funcion: id correcta, num param, etc */

/********* REGLAS LLAMADA A UNA FUNCION*********/
functionCall: 		ID '(' paramsFunctionCallWrapper ')' {
																		struct nodo *puntero = search($1, funcion);
																		if(puntero == NULL) {
																			yyerror("La funcion no esta declarada en el header");
																		}else{
																			puntero = puntero->param;
																			while(puntero != NULL) {
																				add(puntero->id, puntero->tipo, local, scope, puntero->array);
																				
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
evalID:	stackID {gc("\tR%d=I(R%d)\n",$1,$1);};	//TODO get ID val in registry

stackID: ID 		{$$ = assign_reg(entero);gc("\tR$$=I(%d)\n",$$,$1);};	// TODO get ID position in stack in registry
// TODO function to get address in stack
%%

// TODO crear gc(string)
// TODO crear assign_reg(enum)

void yyerror(char* mens) {
  printf("Error en linea %i: %s \n",numlin,mens);
}

int main(int argc, char** argv) {

    if(argc == 2) {
		yyin = fopen(argv[1],"r");
	}

	yyparse();

    return 0;
}



	