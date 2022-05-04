
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

%left ',' 
%right '=' ASSIGN_ADD ASSIGN_DIV ASSIGN_MULT ASSIGN_SUBS
%left OR
%left AND
%left EQUAL NOT_EQUAL
%left '<' '>' LESS_EQUAL GREATER_EQUAL
%left '+' '-'
%left '*' '/' '%'
%right NOT 
%right '^'
%left '[' '(' '.'


%%	/********* REGLAS GRAMATICALES *********/

program: 			header global functionArea;



/********* REGLAS DEL HEADER *********/
header: 			/* empty */
|					HEADER '{' headerWrapper '}';

headerWrapper: 		/* empty */
|					headerWrapper headerdcl;

headerdcl: 			typeFunction ID '(' paramWrapper ')' ';';

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

main:           	INT MAIN '(' ')' '{' statementWrapper '}';



/********* REGLAS DECLARACIÓN DE STATEMENT *********/
statementWrapper: 	/* empty */
|					statementWrapper statement;

/* FIXME CONTINUE BREAK RETURN*/
statement: 			loop
|					conditional
|					variabledcl
|					functionCall ';'
|					varAssign ';'
|					BREAK ';'
|					CONTINUE ';'
|					RETURN returnExpression ';';



/********* REGLAS DECLARACIÓN DE BUCLES *********/
loop: 				forLoop
|					whileLoop
|					DO whileLoop;

forLoop: 			FOR '(' forStatement ')' '{' statementWrapper '}';

/* HACK variabledcl already has ';' */
forStatement: 		variabledcl boolExpression ';'  varAssign;

whileLoop: 			WHILE '(' boolExpression ')' '{' statementWrapper '}';



/********* REGLAS DECLARACIÓN DE CONDICIONALES*********/
conditional: 		ifCond elifCond elseCond;

ifCond: 			IF '(' boolExpression ')'  '{' statementWrapper '}';

elifCond: 			/* empty */
|					elifCond ELIF '(' boolExpression ')'  '{' statementWrapper '}';

elseCond: 			/* empty */
|					ELSE '{' statementWrapper '}';



/********* REGLAS ASIGNACIONES *********/
varAssign: 			ID '=' expression
|					ID ASSIGN_ADD charNumStringExpression
|					ID ASSIGN_SUBS charNumStringExpression
|					ID ASSIGN_MULT charNumExpression
|					ID ASSIGN_DIV charNumExpression;



/********* REGLAS DECLARACIÓN DE VARIABLES *********/
variabledcl:		BOOL ID '=' boolExpression ';'
|					INT ID '=' numExpression ';'
|					FLOAT ID '=' numExpression ';'
|					CHAR ID '=' charExpression ';'
|					STRING ID '=' stringExpression ';'
|					arraydcl;



/********* REGLAS DECLARACIÓN DE ARRAY *********/
arraydcl:			typePrimitive '[' LIT_INT ']' ID ';'
|					typePrimitive '[' ']' ID '=' ID ';'
|					FLOAT '[' ']' ID '=' '{' numArrayWrapper '}' ';' 
|					INT '[' ']' ID '=' '{' numArrayWrapper '}' ';' 
|					CHAR '[' ']' ID '=' '{' charArrayWrapper '}' ';' 
|					BOOL '[' ']' ID '=' '{' boolArrayWrapper '}' ';'; 

numArrayWrapper:	/* empty */
|					numArray;

numArray:			numExpression
|					numArray ',' numExpression;

charArrayWrapper: 	/* empty */
|					charArray;

charArray:			charExpression
|					charArray ',' charExpression;

boolArrayWrapper:	/* empty */
|					boolArray;

boolArray:			boolExpression
|					boolArray ',' boolExpression;



/********* REGLAS EXPRESIONES CON STRING *********/
stringExpression:	LIT_STRING
|					ID
|					stringExpression '+' stringExpression;



/********* REGLAS EXPRESIONES CON CHAR *********/
charExpression:		LIT_CHAR
|					valueEvaluation;



/********* REGLAS EXPRESIONES NUMERICAS *********/
numExpression:		LIT_FLOAT
|					LIT_INT
|					valueEvaluation
|					numExpression '+' numExpression
|					numExpression '-' numExpression
|					numExpression '*' numExpression
|					numExpression '/' numExpression
|					numExpression '%' numExpression
|					numExpression '^' numExpression
|					'(' numExpression ')'
|					'-' numExpression;



/********* REGLAS EXPRESIONES BOOLEANAS *********/
boolExpression:		boolLiteral 
|					valueEvaluation
|					NOT boolExpression
|					boolExpression boolJunction boolExpression
|					charNumExpression comparisonOperator charNumExpression
|					'(' boolExpression ')';

comparisonOperator:	EQUALS
|                   NOT_EQ
|                   LESS_EQ
|                   BIGGER_EQ;

boolJunction:		OR
|					AND;

boolLiteral:		TRUE
|					FALSE;



/********* REGLAS MISCELANEA PENDIENTE CLASIFICACION *********/
valueEvaluation:	functionCall
|					ID '[' LIT_INT ']'
|					ID;

charNumExpression:	charExpression
|					numExpression;

charNumStringExpression: charExpression
|					numExpression
|					stringExpression;

expression:			numExpression
|					charExpression
|					boolExpression
|					stringExpression;

returnExpression: 	boolExpression
|					charExpression
|					numExpression;



/********* REGLAS LLAMADA A UNA FUNCION*********/
functionCall: 		ID '(' paramsFunctionCallWrapper')';

paramsFunctionCallWrapper: 	/* empty */
|					paramsFunctionCall;

paramsFunctionCall: paramsFunctionCall ',' expression
|					paramsFunctionCall ',' ID
|					ID
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



int main() {
	yyparse();
	return 1;
}


	