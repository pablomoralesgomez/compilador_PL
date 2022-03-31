
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


%%	/********* REGLAS GRAMATICALES *********/

program: header global functionArea;



/********* REGLAS DEL HEADER *********/
header: 			/* empty */
|					HEADER '{' headerWrapper '}';

headerWrapper: 		/* empty */
|					headerWrapper headerdcl;

headerdcl: 			typeFunction ID '(' paramHeaderWrapper ')' ';';

paramHeaderWrapper: /* empty */
|					paramHeaderWrapperRecursive;

paramHeaderWrapperRecursive: 	paramHeader 
|					   			paramHeaderWrapperRecursive ',' paramHeader;
			
paramHeader:		typeVariable ID
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

functiondcl: 		typeFunction ID '(' paramWrapper ')' '{' expressionWrapper '}'



variabledcl:		BOOL ID '=' boolExpression ';'
|					INT ID '=' numericExpression ';'
|					FLOAT ID '=' numericExpression ';'
|					CHAR ID '=' charExpression ';'
|					STRING ID '=' LIT_STRING ';'



/********* REGLAS EXPRESIONES CON CHAR *********/
charExpression:		LIT_CHAR
|					valueEvaluation
|					'(' charExpression ')';



/********* REGLAS EXPRESIONES NUMERICAS *********/
numericExpression:	LIT_FLOAT
|					LIT_INT
|					valueEvaluation
|					numericExpression '+' numericExpression
|					numericExpression '-' numericExpression
|					numericExpression '*' numericExpression
|					numericExpression '/' numericExpression
|					numericExpression '%' numericExpression
|					numericExpression '^' numericExpression
|					'(' numericExpression ')'
|					'-' numericExpression;



/********* REGLAS EXPRESIONES BOOLEANAS *********/
boolExpression:		boolLiteral 
|					valueEvaluation
|					NOT boolExpression
|					boolExpression boolJunction boolExpression
|					expression comparisonOperator expression
|					'(' boolExpression ')';

comparisonOperator: EQUALS
|                   NOT_EQ
|                   LESS_EQ
|                   BIGGER_EQ;

boolJunction		OR
|					AND;

boolLiteral:		TRUE
|					FALSE;



valueEvaluation:	functionCall
|					ID '[' LIT_INT ']'
|					ID;



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