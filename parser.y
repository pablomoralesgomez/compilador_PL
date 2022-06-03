%{

#include <stdio.h>
#include <stdlib.h>
#include "string.h"
#include "tab.h"

extern int numlin;
extern int scope;
extern FILE *yyin;

char *line;
int lineSize;

#define true 1
#define false 0

enum op_igualdades{igual, no_igual, mayor, mayor_igual, menor, menor_igual};
enum op_logicos{and, or};
enum op_aritmeticas{sum, sub, mul, divi};

// Struct auxiliar para tratar con valores en la zona de expression
struct reg_tipo{
	int reg;
	int tipo;
};

// Variables auxiliares para comprobar los parámetros de las funciones
char* functionName = "";
int functionNumberParam = -1;
int checkingParamNumber = 0;

// Variables auxiliares para contar el número de parámetros de un array y sus tipos
int longitud_array = 0;
enum type tipo_array = -1;

void yyerror(char*);
void lib_reg(struct reg_tipo*);
int assign_reg(int tipo);
void gc(char* text);

void adde(char*, enum type, enum category, int, int , struct array*);
struct reg_tipo * igualdades(struct reg_tipo*, struct reg_tipo*, enum op_igualdades);
struct reg_tipo * logicos(struct reg_tipo*, struct reg_tipo*, enum op_logicos);
struct reg_tipo * aritmeticas(struct reg_tipo*, struct reg_tipo*, enum op_aritmeticas);

struct nodo * find(char* id);

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
%type <expr> expression literals boolLiteral functionCall
%type <registry> varAssign

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

headerdcl: 			typeFunction ID {adde($2, $1, funcion, 0, -1, NULL);} '(' paramWrapper ')' ';';

paramWrapper: 		/* empty */
|					paramWrapperRecursive  {
												if(checkingParamNumber < functionNumberParam) yyerror("El numero de parametros es menor que en el header.");
												checkingParamNumber = 0;
											};

paramWrapperRecursive: {checkingParamNumber++;} param 
|					paramWrapperRecursive ',' {checkingParamNumber++;} param;

param:				typeVariable ID									{	
																		if(functionName[0] == '\0') {
																			adde($2, $1, param, 0, getAddress($1, 1), NULL);
																		} else {
																			struct nodo * param = getParameterByNumber(functionName, checkingParamNumber);
																			
																			if(param == NULL) yyerror("El parametro o la funcion no esta declarado en el header.");
																			if($1 != param->tipo) yyerror("El tipo del parametro no corresponde con el del header");	
																			if(strcmp($2, param->id) != 0) yyerror("El nombre del parametro no corresponde con el del header");	
																		}
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
functiondcl: 		typeFunction ID {functionName = $2; functionNumberParam = countFunctionParameters($2);} '(' paramWrapper ')' '{'		{
											struct nodo *puntero = search($2, funcion);
											if(puntero == NULL) yyerror("La funcion no esta declarada en el header");
											if($1 != puntero->tipo) yyerror("El tipo de la funcion no corresponde con la del header");
									
											puntero = puntero->param;
											while(puntero != NULL) {
												adde(puntero->id, puntero->tipo, local, scope, puntero->address, puntero->array); // FIXME cuando es array el tipo no es el del puntero, sino entero
												
												puntero = puntero->param;
											}
											
											functionNumberParam = -1;
											functionName = "";
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
varAssign: 	ID '=' expression				{
																		struct nodo *puntero = find($1);
																		snprintf(line,lineSize,"\tI(0x%05d)=R%d;\n",puntero->address,$3->reg);
																		gc(line);
																		lib_reg($3);
																		}
|					ID ASSIGN_ADD expression	{
																		struct nodo *puntero = find($1);
																		snprintf(line,lineSize, "\tI(0x%05d)=R%d+I(0x%05d);\n",puntero->address,$3->reg,puntero->address);
																		gc(line);
																		lib_reg($3);
																		}
|					ID ASSIGN_SUBS expression	{
																		struct nodo *puntero = find($1);
																		snprintf(line,lineSize, "\tI(0x%05d)=R%d-I(0x%05d);\n",puntero->address,$3->reg,puntero->address);
																		gc(line);
																		lib_reg($3);
																		}
|					ID ASSIGN_MULT expression	{
																		struct nodo *puntero = find($1);
																		snprintf(line,lineSize, "\tI(0x%05d)=R%d*I(0x%05d);\n",puntero->address,$3->reg,puntero->address);
																		gc(line);
																		lib_reg($3);
																		}
|					ID ASSIGN_DIV expression	{
																		struct nodo *puntero = find($1);
																		snprintf(line,lineSize, "\tI(0x%05d)=R%d/I(0x%05d);\n",puntero->address,$3->reg,puntero->address);
																		gc(line);
																		lib_reg($3);
																		};	// FIXME tipos
//|					LIT_STRING 											// TODO arrays
//|					arrays 											// TODO arrays




/********* REGLAS DECLARACIÓN DE VARIABLES *********/
variabledcl:	typePrimitive ID '=' expression ';' 	{adde($2, $1, (scope == 0) ? global : local, scope, getAddress($1, 1), NULL);}
|					STRING ID '=' LIT_STRING ';'
|					arraydcl;



// TODO Pensar que hacer con los arrays en pila

/********* REGLAS DECLARACIÓN DE ARRAY *********/
arraydcl:			typePrimitive '[' LIT_INT ']' ID ';' {
																		if ($3 < 0) yyerror("Una array no puede tener un número de elementos negativo");
																		struct array *arr = malloc(sizeof(struct array));
																		arr->length = $3;
																		arr->address = getAddress($1, arr->length);
																		adde($5, $1, (scope == 0) ? global : local, scope, getAddress($1, 1), arr);
																		}
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
																		adde($4, $1, (scope == 0) ? global : local, scope, getAddress(entero,1), puntero->array);
																		}
|					typePrimitive '[' ']' ID '=' '{' {tipo_array = $1;} arrayWrapper '}' ';' 	{
																									struct array *arr = malloc(sizeof(struct array));
																									arr->length = longitud_array;		
																									arr->address = getAddress($1, arr->length);
																									adde($4, $1, (scope == 0) ? global : local, scope, getAddress($1, 1), arr);
																									
																									printf("length = %d\n", longitud_array);
																									
																									tipo_array = -1;
																									longitud_array = 0;
																								}; 

arrayWrapper:	/* empty */
|					array;

array:		{longitud_array++;} expression				{if($2->tipo != tipo_array) yyerror("El valor del elemento del array es de tipo distinto al declarado para el array.");}										
|			array ',' {longitud_array++;} expression 	{if($4->tipo != tipo_array) yyerror("El valor del elemento del array es de tipo distinto al declarado para el array.");};


// TODO string equals string
// TODO comprobar uno a uno si los operadores son correctos y funcionan
// FIXME diferenciar tipos y validar si se puede hacer la función
// FIXME string 
/********* REGLAS EXPRESIONES *********/
expression:	functionCall									{
																					if ($1->tipo == vacio) yyerror("Una funcion void no devuelve parametro");
																					struct reg_tipo *ex = $1;
																					$$ = $1;
																					}
|					ID '[' LIT_INT ']'							{
																					struct nodo *puntero = find($1);
																					if (puntero->array == NULL) yyerror("La ID no es una array");
																					int reg = assign_reg(puntero->tipo);
																					struct reg_tipo ex = {reg ,puntero->tipo};
																					// TODO collect from array
																					}
|					ID															{
																					struct nodo *puntero = find($1);
																					if (puntero->array != NULL) yyerror("La ID es una array");
																					int reg = assign_reg(puntero->tipo);
																					struct reg_tipo ex = {reg ,puntero->tipo};
																					snprintf(line,lineSize, "\tR%d=I(0x%05d);\n", reg, puntero->address);
																					gc(line);
																					$$ = &ex;
																					}
|					literals												{$$ = $1;}
|					NOT expression									{
																					if ($2->tipo != boolean) yyerror("No es un tipo boolean");
																					snprintf(line,lineSize, "\tR%d=!R%d;\n",$2->reg,$2->reg);
																					gc(line);
																					$$ = $2; // same type, same register
																					}												// boolean
|					'-' expression									{
																					if ($2->tipo == comaFlotante){
																						snprintf(line,lineSize, "\tRR%d=0-RR%d;\n",$2->reg,$2->reg);
																					}else if($2->tipo == entero){
																						snprintf(line,lineSize, "\tR%d=0-R%d;\n",$2->reg,$2->reg);
																					}else{
																						yyerror("No es un tipo numérico");
																					}
																					gc(line);
																					$$ = $2; // same type, same register
																					}											// numeros
|					'(' expression ')'							{$$ = $2;} // todos
|					expression EQUALS expression		{
																					$$ = igualdades($1, $3, igual);
																					}
|					expression NOT_EQ expression		{
																					$$ = igualdades($1, $3, no_igual);
																					}
|					expression LESS_EQ expression		{
																					$$ = igualdades($1, $3, menor_igual);
																					}
|					expression BIGGER_EQ expression {
																					$$ = igualdades($1, $3, mayor_igual);
																					}
|					expression '>' expression				{
																					$$ = igualdades($1, $3, menor);
																					}
|					expression '<' expression 			{
																					$$ = igualdades($1, $3, menor);
																					}
|					expression OR expression				{
																					$$ = igualdades($1, $3, or);
																					}
|					expression AND expression 			{
																					$$ = igualdades($1, $3, and);
																					}
|					expression '+' expression 			{
																					$$ = aritmeticas($1, $3, sum);
																					}
|					expression '-' expression 			{
																					$$ = aritmeticas($1, $3, sub);
																					}
|					expression '*' expression 			{
																					$$ = aritmeticas($1, $3, mul);
																					}
|					expression '/' expression 			{
																					$$ = aritmeticas($1, $3, divi);
																					}
|					expression '^' expression 			// TODO crear función interna
|					expression '%' expression; 			// TODO crear función interna

literals: 			LIT_INT							{
																		int reg = assign_reg(entero);
																		struct reg_tipo res = {reg, entero};
																		snprintf(line,lineSize, "\tR%d=%ld;\n",reg, $1);
																		gc(line);
																		$$ = &res;
																		}
|					LIT_FLOAT 								{
																		int reg = assign_reg(comaFlotante);
																		struct reg_tipo res = {reg, comaFlotante};
																		snprintf(line,lineSize, "\tRR%d=%f;\n",reg, $1);
																		gc(line);
																		$$ = &res;
																		}
|					LIT_CHAR 									{
																		int reg = assign_reg(entero);
																		struct reg_tipo res = {reg, caracter};
																		snprintf(line,lineSize, "\tR%d=%d;\n",reg, $1);
																		gc(line);
																		$$ = &res;
																		}
|					boolLiteral								{$$ = $1;};

boolLiteral:		TRUE								{
																		int reg = assign_reg(entero);
																		struct reg_tipo res = {reg, boolean};
																		snprintf(line,lineSize, "\tR%d=1;\n",reg);
																		gc(line);
																		$$ = &res;
																		}
|					FALSE											{
																		int reg = assign_reg(entero);
																		struct reg_tipo res = {reg, boolean};
																		snprintf(line,lineSize, "\tR%d=0;\n",reg);
																		gc(line);
																		$$ = &res;
																		};

/* TODO: Hacer comprobaciones a la hora de llamar a la funcion: id correcta, num param, etc */

/********* REGLAS LLAMADA A UNA FUNCION*********/
functionCall: 		ID {functionName = $1; functionNumberParam = countFunctionParameters($1);}'(' paramsFunctionCallWrapper ')' 	{
																																		struct nodo *puntero = search($1, funcion);
																																		if(puntero == NULL) {
																																			yyerror("La funcion no esta declarada en el header");
																																		}
																																		
																																		functionNumberParam = -1;
																																		functionName = "";
																																		
																																	};		// search id y recoger parámetros, loopearlos en orden

paramsFunctionCallWrapper: 	/* empty */																										// linked list u otro stack vacío
|					paramsFunctionCall {
											if(checkingParamNumber < functionNumberParam) yyerror("El numero de parametros es menor que en el header.");
											checkingParamNumber = 0;
										};

paramsFunctionCall: paramsFunctionCall ',' {checkingParamNumber++;} expression 		{	
																						struct nodo * param = getParameterByNumber(functionName, checkingParamNumber);
																						if(param == NULL) yyerror("El numero de parametros no se corresponde con el especificado en el header.");
																						if($4->tipo != param->tipo) yyerror("El tipo del parametro no corresponde con el del header");	
																					}														// stackear parámetros
|	{checkingParamNumber++;} expression 											{	
																						struct nodo * param = getParameterByNumber(functionName, checkingParamNumber);
																						if(param == NULL) yyerror("El numero de parametros no se corresponde con el especificado en el header.");
																						if($2->tipo != param->tipo) yyerror("El tipo del parametro no corresponde con el del header");	
																					};																					// linked list u otro stack



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
	printf("%s",text); // TODO do
}

int assign_reg(int tipo){
	if (tipo == comaFlotante){

	}else{

	}
	// TODO do
	return 1;
}

void lib_reg(struct reg_tipo* reg){
	if (reg->tipo == comaFlotante){

	}else{
		
	}
	// TODO do
}

void adde(char* id, enum type tipo, enum category categoria, int scope, int address, struct array *array) {
	if (!add(id, tipo, categoria, scope, address, array)){
		yyerror("Error al añadir a pila, la variable ya existe");
	}
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


// Funciones auxiliares

struct reg_tipo * igualdades(struct reg_tipo* izq, struct reg_tipo* der, enum op_igualdades operator){
	char op[2];
	if (operator == igual){
		strncpy(op, "==",sizeof(op));
	}else if (operator == no_igual){
		strncpy(op, "!=",sizeof(op));
	}else{
		if (izq->tipo == boolean && der->tipo == boolean){
			yyerror("Fallo en igualdad, asegúrese de que usa tipos correctos");
		}
		if (operator == mayor){
			strncpy(op, ">",sizeof(op));
		}else if (operator == mayor_igual){
			strncpy(op, ">=",sizeof(op));
		}else if (operator == menor){
			strncpy(op, "<",sizeof(op));
		}else if (operator == menor_igual){
			strncpy(op, "<=",sizeof(op));
		}else{
			yyerror("Error de compilador");
		}
	}


	struct reg_tipo* res;
	if (izq->tipo == caracter && der->tipo == caracter ||
			izq->tipo == entero && der->tipo == entero ||
			izq->tipo == entero && der->tipo == caracter ||
			izq->tipo == caracter && der->tipo == entero ||
			izq->tipo == boolean && der->tipo == boolean){
		snprintf(line,lineSize, "\tR%d=R%d%sR%d;\n",izq->reg,izq->reg,op,der->reg);
		lib_reg(der);
		res = izq;
	}else if(izq->tipo == comaFlotante && der->tipo == comaFlotante){
		snprintf(line,lineSize, "\tR%d=RR%d%sRR%d;\n",izq->reg,izq->reg,op,der->reg); // FIXME get register
		lib_reg(der);
		res = izq;
	}else if(izq->tipo == comaFlotante && der->tipo == entero){
		snprintf(line,lineSize, "\tR%d=RR%d%sR%d;\n",der->reg,izq->reg,op,der->reg);
		lib_reg(izq);
		res = der;
	}else if(izq->tipo == entero && der->tipo == comaFlotante){
		snprintf(line,lineSize, "\tR%d=R%d%sRR%d;\n",izq->reg,izq->reg,op,der->reg);
		lib_reg(der);
		res = izq;
	}else{
		yyerror("Fallo en igualdad, asegúrese de que usa tipos correctos");
	}
	res->tipo = boolean;
	gc(line);
	return res;
}


struct reg_tipo * logicos(struct reg_tipo* izq, struct reg_tipo* der, enum op_logicos operator){
	char op[2];
	if (operator == and){
		strncpy(op, "&&",sizeof(op));
	} else if (operator != or){
		strncpy(op, "||",sizeof(op));
	}

	struct reg_tipo* res;
	if (izq->tipo == boolean && der->tipo == boolean){
		snprintf(line,lineSize, "\tR%d=R%d%sR%d;\n",izq->reg,izq->reg,op,der->reg);
		lib_reg(der);
		res = izq;
	}else{
		yyerror("Fallo en igualdad, asegúrese de que usa tipos correctos");
	}
	res->tipo = boolean;
	gc(line);
	return res;
}


struct reg_tipo * aritmeticas(struct reg_tipo* izq, struct reg_tipo* der, enum op_aritmeticas operator){
	char op[1];
	if (operator == sum){
		strncpy(op, "+",sizeof(op));
	}else if (operator == sub){
		strncpy(op, "-",sizeof(op));
	}else if (operator == mul){
		strncpy(op, "*",sizeof(op));
	}else if (operator == divi){
		strncpy(op, "/",sizeof(op));
	}else{
		yyerror("Error de compilador");
	}

	struct reg_tipo* res;
	if (izq->tipo == caracter && der->tipo == caracter ||
			izq->tipo == entero && der->tipo == entero ||
			izq->tipo == entero && der->tipo == caracter ||
			izq->tipo == caracter && der->tipo == entero){
		snprintf(line,lineSize, "\tR%d=R%d%sR%d;\n",izq->reg,izq->reg,op,der->reg);
		lib_reg(der);
		res = izq;
	}else if(izq->tipo == comaFlotante && der->tipo == comaFlotante){
		snprintf(line,lineSize, "\tRR%d=RR%d%sRR%d;\n",izq->reg,izq->reg,op,der->reg);
		lib_reg(der);
		res = izq;
	}else if(izq->tipo == comaFlotante && der->tipo == entero){
		snprintf(line,lineSize, "\tRR%d=RR%d%sR%d;\n",izq->reg,izq->reg,op,der->reg);
		lib_reg(der);
		res = izq;
	}else if(izq->tipo == entero && der->tipo == comaFlotante){
		snprintf(line,lineSize, "\tRR%d=R%d%sRR%d;\n",der->reg,izq->reg,op,der->reg);
		lib_reg(izq);
		res = der;
	}else{
		yyerror("Fallo en igualdad, asegúrese de que usa tipos correctos");
	}
	res->tipo = boolean;
	gc(line);
	return res;
}