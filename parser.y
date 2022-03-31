
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
|					BOOL '[' ']' ID '=' '{' boolArray '}' ';'; 

boolArrayWrapper:	/* empty */
|					boolArrayWrapper boolArray;

boolArray:			boolArray
|					boolArray boolExpression;

charArrayWrapper: 	/* empty */
|					charArrayWrapper charArray;

charArray:			charArray
|					charArray ',' charExpression;

numArrayWrapper:	/* empty */
|					numArrayWrapper numArray;

numArray:			numArray
|					numArray ',' numExpression;



/********* REGLAS EXPRESIONES CON STRING *********/
stringExpression:	LIT_STRING
|					ID
|					stringExpression '+' stringExpression;



/********* REGLAS EXPRESIONES CON CHAR *********/
charExpression:		LIT_CHAR
|					valueEvaluation;



/********* REGLAS EXPRESIONES NUMERICAS *********/
numExpression:	LIT_FLOAT
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

boolJunction		OR
|					AND;

boolLiteral:		TRUE
|					FALSE;



/********* REGLAS MISCELANEA PENDIENTE CLASIFICACION *********/
valueEvaluation:	functionCall
|					ID '[' LIT_INT ']'
|					ID;

charNumExpression:	charExpression
|					numExpression;

expression:			numExpression
|					charExpression
|					boolExpression
|					stringExpression;



/********* REGLAS LLAMADA A UNA FUNCION*********/
functionCall:		ID '(' paramsFunctionCallWrapper')' 

paramsFunctionCallWrapper: 	/* empty */
|							paramsFunctionCall;

paramsFunctionCall: paramsFunctionCall 
|					paramsFunctionCall ',' expression
|					paramsFunctionCall ',' ID;



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