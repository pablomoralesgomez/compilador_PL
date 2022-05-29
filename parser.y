%{

#include <stdio.h>
#include "tab.h"

extern int numlin;
extern int scope;
extern FILE *yyin;

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

headerdcl: 			typeFunction ID {add($2, $1, funcion, 0);} '(' paramWrapper ')' ';';

paramWrapper: 		/* empty */
|					paramWrapperRecursive;

paramWrapperRecursive: param
|					paramWrapperRecursive ',' param;

param:				typeVariable ID									{add($2, $1, param, 0);}
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
																					add(puntero->id, puntero->tipo, local, scope);
																					
																					puntero = puntero->param;
																				}
																			}
																			
																		}
																	}	
															
										statementWrapper '}'		{deleteScope(scope);};

main:           	INT MAIN '(' ')' '{' statementWrapper '}';



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

forLoop: 			FOR '(' forStatement ')' '{' statementWrapper '}';

/* HACK variabledcl already has ';' */
/* boolExpression */
forStatement: 		variabledcl expression ';'  varAssign;

/* boolExpression */
whileLoop: 			WHILE '(' expression ')' '{' statementWrapper '}';



/********* REGLAS DECLARACIÓN DE CONDICIONALES*********/
conditional: 		ifCond elifCond elseCond;

/* boolExpression */
ifCond: 			IF '(' expression ')'  '{' statementWrapper '}';

/* boolExpression */
elifCond: 			/* empty */
|					elifCond ELIF '(' expression ')'  '{' statementWrapper '}';

elseCond: 			/* empty */
|					ELSE '{' statementWrapper '}';



/********* REGLAS ASIGNACIONES *********/
varAssign: 			ID assignSymbols expression;

assignSymbols: '='
|					ASSIGN_ADD
|					ASSIGN_SUBS
|					ASSIGN_MULT
|					ASSIGN_DIV;



/********* REGLAS DECLARACIÓN DE VARIABLES *********/
variabledcl:		typeVariable ID '=' expression ';' 						{
																				if(scope == 0) {
																					add($2, $1, global, scope);
																				} else {
																					add($2, $1, local, scope);
																				}
																			};
|					arraydcl;


/* TODO: Pensar que hacer con los arrays en pila */

/********* REGLAS DECLARACIÓN DE ARRAY *********/
arraydcl:			typePrimitive '[' LIT_INT ']' ID ';'
|					typePrimitive '[' ']' ID '=' ID ';'
|					typePrimitive '[' ']' ID '=' '{' arrayWrapper '}' ';';

arrayWrapper:	/* empty */
|					array;

array:		expression
|					array ',' expression;



/********* REGLAS EXPRESIONES *********/
expression:	functionCall
|					ID '[' LIT_INT ']'
|					ID
|					literals
|					NOT expression
|					'-' expression
|					'(' expression ')'
|					expression EQUALS expression
|					expression NOT_EQ expression
|					expression LESS_EQ expression
|					expression BIGGER_EQ expression
|					expression '>' expression
|					expression '<' expression
|					expression OR expression
|					expression AND expression
|					expression '+' expression
|					expression '-' expression
|					expression '*' expression
|					expression '/' expression
|					expression '^' expression
|					expression '%' expression;

literals: 			LIT_INT 						{printf("digito %ld\n",$1);}
|					LIT_FLOAT 						{printf("float %f\n",$1);}
|					LIT_CHAR 						{printf("char %c\n",$1);}
|					LIT_STRING 						{printf("string %s\n",$1);}
|					boolLiteral;

boolLiteral:		TRUE
|					FALSE;

/* TODO: Hacer comprobaciones a la hora de llamar a la funcion: id correcta, num param, etc */

/********* REGLAS LLAMADA A UNA FUNCION*********/
functionCall: 		ID '(' paramsFunctionCallWrapper')';

paramsFunctionCallWrapper: 	/* empty */
|					paramsFunctionCall;

paramsFunctionCall: paramsFunctionCall ',' expression
|					expression;



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



	