%{

#include <stdio.h>

extern int numlin;
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

%token LIT_INT		
%token LIT_FLOAT	
%token LIT_CHAR	
%token LIT_STRING	
%token TRUE		
%token FALSE		

%token ID	
%token MAIN


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

program: 			header global functionArea;



/********* REGLAS DEL HEADER *********/
header: 			/* empty */
|					HEADER '{' headerWrapper '}' {printf("Header\n");};					

headerWrapper: 		/* empty */
|					headerWrapper headerdcl;

headerdcl: 			typeFunction ID '(' paramWrapper ')' ';' 	{printf("Declaracion\n");};

paramWrapper: 		/* empty */
|					paramWrapperRecursive;

paramWrapperRecursive: param 
|					paramWrapperRecursive ',' param;
			
param:				typeVariable ID
|					typePrimitive '[' ']' ID;



/********* REGLAS DEL GLOBAL *********/
global:				/* empty */
|					GLOBAL '{' globalWrapper '}';

globalWrapper:		/* empty */
|					globalWrapper variabledcl;



/********* REGLAS ZONA DE DECLARACIÓN DE FUNCIONES *********/
functionArea: 		functionWrapper main functionWrapper;

functionWrapper: 	/* empty */
|					functionWrapper functiondcl;

/* ID can't be 'main' */
functiondcl: 		typeFunction ID '(' paramWrapper ')' '{' statementWrapper '}';

main:           	INT MAIN '(' ')' '{' statementWrapper '}'			{printf("Esto es el main\n");};				



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
variabledcl:		typeVariable ID '=' expression ';'
|					arraydcl;



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

literals: LIT_INT
|					LIT_FLOAT
|					LIT_CHAR
|					LIT_STRING
|					boolLiteral;

boolLiteral:		TRUE
|					FALSE;


/********* REGLAS LLAMADA A UNA FUNCION*********/
functionCall: 		ID '(' paramsFunctionCallWrapper')';

paramsFunctionCallWrapper: 	/* empty */
|					paramsFunctionCall;

paramsFunctionCall: paramsFunctionCall ',' expression
|					expression;



/********* REGLAS TIPOS *********/
typePrimitive:		BOOL
|					CHAR
|					INT
|					FLOAT;

typeVariable: 		STRING
|					typePrimitive;

typeFunction: 		VOID
|					typePrimitive;
		
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



	