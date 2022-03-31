
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


%%	/* REGLAS GRAMATICALES */

program: header global functionArea;


header: 			/* empty */
|					HEADER '{' headerWrapper '}';

headerWrapper: 		/* empty */
|					headerWrapper headerdcl;

headerdcl: 			typeFunction ID '(' paramHeaderWrapper ')' ';';

paramHeaderWrapper: /* empty */
|					paramHeaderWrapperAux;

paramHeaderWrapperAux: paramHeader 
|					   paramHeaderWrapperAux ',' paramHeader;
			
paramHeader:		typeVariable ID
|					typePrimitive '[' ']' ID;


functionArea: 		functionWrapper main functionWrapper;

functionWrapper: 	/* empty */
|					functionWrapper functiondcl;

functiondcl: 		typeFunction ID '(' paramWrapper ')' '{' expressionWrapper '}'


typePrimitive:		BOOL
|					CHAR
|					INT
|					FLOAT;

typeVariable: 		STRING
|					BOOL
|					CHAR
|					INT
|					FLOAT;

typeFunction: 		VOID
|					BOOL
|					CHAR
|					INT
|					FLOAT;
				
%%		