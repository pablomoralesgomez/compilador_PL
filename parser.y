%{


#include <stdio.h>
#include <stdlib.h>
#include "string.h"
#include "tab.h"

extern int numlin;
extern int scope;
extern FILE *yyin;

FILE *outQ;
char *fName = "out.q.c";

char *line;
int lineSize;

#define true 1
#define false 0

enum op_igualdades{igual, no_igual, mayor, mayor_igual, menor, menor_igual};
enum op_logicos{and, or};
enum op_aritmeticas{sum, sub, mul, divi};
enum op_asignaciones{aigual, asum, asub, amul, adivi};


int int_regs[1   +100];
int float_regs[1 +100];

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

// Variable auxiliar para controlar el movimiento relativo de R7
int r7Displacement = 0;

void yyerror(char*);
void lib_reg(struct reg_tipo*);
int assign_reg(int tipo);
void gc(char* text);

void adde(char*, enum type, enum category, int, int , struct array*);
struct reg_tipo * igualdades(struct reg_tipo*, struct reg_tipo*, enum op_igualdades);
struct reg_tipo * logicos(struct reg_tipo*, struct reg_tipo*, enum op_logicos);
struct reg_tipo * aritmeticas(struct reg_tipo*, struct reg_tipo*, enum op_aritmeticas);
int asignaciones(struct reg_tipo*, char*, enum op_asignaciones);

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
%token PRINT

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
	struct reg_tipo * expr;
	int tip;
}

%token <str>ID
%token MAIN

%type <tip>typeFunction typePrimitive typeVariable
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

program: 			header global functionArea;


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
|					PRINT '(' printeableThings ')' ';'
|					CONTINUE ';'
|					RETURN expression ';';	// FIXME free reg_tipo
/* returnExpression */


printeableThings:	expression	// FIXME free reg_tipo
|					LIT_STRING;


/********* REGLAS DECLARACIÓN DE BUCLES *********/
loop: 				forLoop
|					whileLoop
|					DO whileLoop;

forLoop: 			FOR '(' forStatement ')' '{' statementWrapper '}'			{deleteScope(scope);};

/* HACK variabledcl already has ';' */
/* boolExpression */
forStatement: 		{scope++;} variabledcl {scope--;} expression ';'  varAssign; // FIXME free reg_tipo

/* boolExpression */
whileLoop: 			WHILE '(' expression ')' '{' statementWrapper '}'			{deleteScope(scope);};	// FIXME free reg_tipo



/********* REGLAS DECLARACIÓN DE CONDICIONALES*********/
conditional: 		ifCond elifCond elseCond;

/* boolExpression */
ifCond: 			IF '(' expression ')'  '{' statementWrapper '}'				{deleteScope(scope);}; // FIXME free reg_tipo

/* boolExpression */
elifCond: 			/* empty */
|					elifCond ELIF '(' expression ')'  '{' statementWrapper '}'	{deleteScope(scope);}; // FIXME free reg_tipo

elseCond: 			/* empty */
|					ELSE '{' statementWrapper '}'								{deleteScope(scope);};



/********* REGLAS ASIGNACIONES *********/
varAssign: 	ID '=' expression				{
																		asignaciones($3, $1, aigual);
																		}
|					ID ASSIGN_ADD expression	{
																		asignaciones($3, $1, asum);
																		}
|					ID ASSIGN_SUBS expression	{
																		asignaciones($3, $1, asub);
																		}
|					ID ASSIGN_MULT expression	{
																		asignaciones($3, $1, amul);
																		}
|					ID ASSIGN_DIV expression	{
																		asignaciones($3, $1, adivi);
																		};
//|					LIT_STRING 											// TODO arrays
//|					arrays 											// TODO arrays




/********* REGLAS DECLARACIÓN DE VARIABLES *********/
variabledcl:	typePrimitive ID '=' expression ';' 	{												/*adde($2, $1, (scope == 0) ? global : local, scope, getAddress($1, 1), NULL);
																										snprintf(line,lineSize, "\t//ID initialization: %s - l:%d\n",$2, numlin);
																										gc(line);// FIXME free reg_tipo*/
																										
																										r7Displacement++;
																										adde($2, $1, (scope == 0) ? global : local, scope, +(r7Displacement * 4), NULL);
																										
																										snprintf(line, lineSize, "\tR7 = R7 - %d\n", 4 * r7Displacement);
																										gc(line);
																										snprintf(line, lineSize, "\tI(R6 - %d) = R%d\n", 4 * r7Displacement, $4->reg);
																										gc(line);
																										
																										free($4);
																										}
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
																									tipo_array = -1;
																									longitud_array = 0;
																								}; 

arrayWrapper:	/* empty */
|					array;

// FIXME free reg_tipo
array:		{longitud_array++;} expression				{if($2->tipo != tipo_array) yyerror("El valor del elemento del array es de tipo distinto al declarado para el array.");}
|			array ',' {longitud_array++;} expression 	{if($4->tipo != tipo_array) yyerror("El valor del elemento del array es de tipo distinto al declarado para el array.");};


// TODO string equals string
// TODO comprobar uno a uno si los operadores son correctos y funcionan en q
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
																					struct reg_tipo *ex =  malloc(sizeof(struct reg_tipo));
																					ex->reg = reg;
																					ex->tipo = puntero->tipo; // FIXME if array it should return caracter, not ristra
																					// TODO collect from array
																					}
|					ID															{
																					struct nodo *puntero = find($1);
																					if (puntero->array != NULL) yyerror("La ID es una array");
																					int reg = assign_reg(puntero->tipo);
																					struct reg_tipo *ex = malloc(sizeof(struct reg_tipo));
																					ex->reg = reg;
																					ex->tipo = puntero->tipo;
																					if (puntero->tipo == comaFlotante){
																						snprintf(line,lineSize, "\tRR%d = I(R6 - %d);  //evaluate %s %d\n", reg, puntero->address, $1, numlin);
																						gc(line);
																					}else{
																						snprintf(line,lineSize, "\tR%d = I(R6 - %d);  //evaluate %s %d\n", reg, puntero->address, $1, numlin);
																						gc(line);
																					}
																					$$ = ex;
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
																		struct reg_tipo *res =  malloc(sizeof(struct reg_tipo));
																		res->reg = reg;
																		res->tipo = entero;
																		snprintf(line,lineSize, "\tR%d = %ld;\n",reg, $1);
																		gc(line);
																		$$ = res;
																		}
|					LIT_FLOAT 								{
																		int reg = assign_reg(comaFlotante);
																		struct reg_tipo *res =  malloc(sizeof(struct reg_tipo));
																		res->reg = reg;
																		res->tipo = comaFlotante;
																		snprintf(line,lineSize, "\tRR%d = %f;\n",reg, $1);
																		gc(line);
																		$$ = res;
																		}
|					LIT_CHAR 									{
																		int reg = assign_reg(entero);
																		struct reg_tipo *res =  malloc(sizeof(struct reg_tipo));
																		res->reg = reg;
																		res->tipo = caracter;
																		snprintf(line,lineSize, "\tR%d = %d;\n",reg, $1);
																		gc(line);
																		$$ = res;
																		}
|					boolLiteral								{$$ = $1;};

boolLiteral:		TRUE								{
																		int reg = assign_reg(entero);
																		struct reg_tipo *res =  malloc(sizeof(struct reg_tipo));
																		res->reg = reg;
																		res->tipo = boolean;
																		snprintf(line,lineSize, "\tR%d = 1;\n",reg);
																		gc(line);
																		$$ = res;
																		}
|					FALSE											{
																		int reg = assign_reg(entero);
																		struct reg_tipo *res =  malloc(sizeof(struct reg_tipo));
																		res->reg = reg;
																		res->tipo = boolean;
																		snprintf(line,lineSize, "\tR%d = 0;\n",reg);
																		gc(line);
																		$$ = res;
																		};

/* TODO: Hacer comprobaciones a la hora de llamar a la funcion: id correcta, num param, etc */

/********* REGLAS LLAMADA A UNA FUNCION*********/
functionCall: 		ID {
							functionName = $1; functionNumberParam = countFunctionParameters($1);

							snprintf(line,lineSize, "\n\tR7 = R7 - %d\n", (functionNumberParam + 2) * 4);
							gc(line);
						}
					
					'(' paramsFunctionCallWrapper ')' 	{
																	struct nodo *puntero = search($1, funcion);
																	if(puntero == NULL) {
																		yyerror("La funcion no esta declarada en el header");
																	}
																	
																	snprintf(line,lineSize, "\tP(R7 + %d) = R6\n", (functionNumberParam + 1) * 4);
																	gc(line);	
																	
																	snprintf(line,lineSize, "\tP(R7 + %d) = etiqueta\n", (functionNumberParam) * 4);
																	gc(line);	
																	
																	snprintf(line,lineSize, "L et:\tR7 = R7 + %d\n", (functionNumberParam + 2) * 4);
																	gc(line);	
																	
																	functionNumberParam = -1;
																	functionName = "";
																};		

paramsFunctionCallWrapper: 	/* empty */																										
|					paramsFunctionCall {
											if(checkingParamNumber < functionNumberParam) yyerror("El numero de parametros es menor que en el header.");
											checkingParamNumber = 0;
										};

// FIXME free reg_tipo
paramsFunctionCall: paramsFunctionCall ',' {checkingParamNumber++;} expression 		{
																						struct nodo * param = getParameterByNumber(functionName, checkingParamNumber);
																						if(param == NULL) yyerror("El numero de parametros no se corresponde con el especificado en el header.");
																						if($4->tipo != param->tipo) yyerror("El tipo del parametro no corresponde con el del header");	
																						
																						param->address = checkingParamNumber * 4;

																						if($4->tipo != comaFlotante) {
																							snprintf(line,lineSize, "\tI(R7 + %d) = R%d\n", (checkingParamNumber - 1) * 4, $4->reg);
																						} else {
																							snprintf(line,lineSize, "\tI(R7 + %d) = RR%d\n", (checkingParamNumber - 1) * 4, $4->reg);
																						}
																						gc(line);
																						
																						free($4);
																					}												
|	{checkingParamNumber++;} expression 											{	
																						struct nodo * param = getParameterByNumber(functionName, checkingParamNumber);
																						if(param == NULL) yyerror("El numero de parametros no se corresponde con el especificado en el header.");
																						if($2->tipo != param->tipo) yyerror("El tipo del parametro no corresponde con el del header");	
																						
																						param->address = checkingParamNumber*4;

																						if($2->tipo != comaFlotante) {
																							snprintf(line,lineSize, "\tI(R7 + %d) = R%d\n", (checkingParamNumber - 1) * 4, $2->reg);
																						} else {
																							snprintf(line,lineSize, "\tI(R7 + %d) = RR%d\n", (checkingParamNumber - 1) * 4, $2->reg);
																						}
																						gc(line);
																						
																						free($2);
																					};																					



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
	printf("%s",text);
	fputs(text, outQ);
}

int assign_reg(int tipo){
	int len;
	if (tipo == comaFlotante){
		len = sizeof(float_regs)/sizeof(int_regs[0]);
		for (int i = 0; i < len; i++){
			if (!float_regs[i]){
				float_regs[i] = true;
				return i;
				break;
			}
		}
		yyerror("Fallo de compilador, sin registros comaFlotante");
	}else{
		len = sizeof(int_regs)/sizeof(int_regs[0]);
		for (int i = 0; i < len; i++){
			if (!int_regs[i]){
				int_regs[i] = true;
				return i;
				break;
			}
		}
		yyerror("Fallo de compilador, sin registros entero");
	}

}

void lib_reg(struct reg_tipo* reg){
	int len;
	if (reg->tipo == comaFlotante){
		len = sizeof(float_regs)/sizeof(int_regs[0]);
		if (len <= reg->reg){
			snprintf(line,lineSize,"Fallo de compilador, el registro comaFlotante %d no está disponible, máximo %d",reg->reg, len);
			yyerror(line);
		}
		float_regs[reg->reg] = false;
	}else{
		len = sizeof(int_regs)/sizeof(int_regs[0]);
		if (len <= reg->reg){
			snprintf(line,lineSize,"Fallo de compilador, el registro entero %d no está disponible, máximo %d", reg->reg, len);
			yyerror(line);
		}
		int_regs[reg->reg] = false;
	}
	free(reg);
}

void adde(char* id, enum type tipo, enum category categoria, int scope, int address, struct array *array) {
	if (!add(id, tipo, categoria, scope, address, array)){
		yyerror("Error al añadir a pila, la variable ya existe");
	}
}

void yyerror(char* mens) {
  printf("Error en linea %i: %s \n",numlin,mens);
	fclose(outQ);
  exit(-1);
}

int main(int argc, char** argv) {
	int len = sizeof(float_regs)/sizeof(int_regs[0]);
	for (int i = 0; i < len; i++){
		float_regs[i] = false;
	}

	len = sizeof(int_regs)/sizeof(int_regs[0]);
	for (int i = 0; i < len; i++){
		int_regs[i] = false;
	}

	char charSize = 'a';
	lineSize = sizeof(charSize)*300;
	line = malloc(lineSize);

  if(argc == 2) {
		yyin = fopen(argv[1],"r");
	}

	outQ = fopen(fName,"w");
	fputs("", outQ);
	fclose(outQ);
	outQ = fopen(fName,"a");

	snprintf(line,lineSize, "BEGIN\n");
	gc(line);
	yyparse();
	snprintf(line,lineSize, "END\n");
	gc(line);

	free(line);
	fclose(outQ);

	show();
  return 0;
}


// Funciones auxiliares

struct reg_tipo * igualdades(struct reg_tipo* izq, struct reg_tipo* der, enum op_igualdades operator){
	snprintf(line,lineSize,"\t// Igualdad - l:%d\n",numlin);
	gc(line);

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
			yyerror("Error de compilador en la igualdad");
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
		int reg = assign_reg(entero);
		snprintf(line,lineSize, "\tR%d=RR%d%sRR%d;\n",reg ,izq->reg,op,der->reg); // FIXME get register
		lib_reg(der);
		lib_reg(izq);
		struct reg_tipo *aux =  malloc(sizeof(struct reg_tipo));
		aux->reg = reg;
		aux->tipo = boolean;
		res = aux;
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
	snprintf(line,lineSize,"\t// Logico - l:%d\n",numlin);
	gc(line);

	char op[2];
	if (operator == and){
		strncpy(op, "&&",sizeof(op));
	}else if (operator != or){
		strncpy(op, "||",sizeof(op));
	}else{
		yyerror("Error de compilador en lógicos");
	}

	struct reg_tipo* res;
	if (izq->tipo == boolean && der->tipo == boolean){
		snprintf(line,lineSize, "\tR%d=R%d%sR%d;\n",izq->reg,izq->reg,op,der->reg);
		lib_reg(der);
		res = izq;
	}else{
		yyerror("Fallo en lógicos, asegúrese de que usa tipos correctos");
	}
	res->tipo = boolean;
	gc(line);
	return res;
}


struct reg_tipo * aritmeticas(struct reg_tipo* izq, struct reg_tipo* der, enum op_aritmeticas operator){
	snprintf(line,lineSize,"\t// Aritmetica - l:%d\n",numlin);
	gc(line);

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
		yyerror("Error de compilador en aritméticas");
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
		yyerror("Fallo en aritméticas, asegúrese de que usa tipos correctos");
	}
	gc(line);
	return res;
}

int asignaciones(struct reg_tipo* reg, char* id, enum op_asignaciones operator){
	snprintf(line,lineSize,"\t// Assign %s - l:%d\n",id,numlin);
	gc(line);

	struct nodo *puntero = find(id);

	// Address registry
	int temp = assign_reg(entero);
	struct reg_tipo *address_reg = malloc(sizeof(struct reg_tipo));
	address_reg->reg = temp;
	address_reg->tipo = entero;

	char op[1];
	if (operator == aigual){	// FIXME string
		if (reg->tipo == comaFlotante){
			snprintf(line,lineSize,"\tR%d=0x%05d;\n", address_reg->reg, puntero->address);
			gc(line);
			snprintf(line,lineSize,"\tI(R%d)=RR%d;\n", address_reg->reg, reg->reg);
			gc(line);
		}else{
			snprintf(line,lineSize,"\tR%d=0x%05d;\n", address_reg->reg, puntero->address);
			gc(line);
			snprintf(line,lineSize,"\tI(R%d)=R%d;\n", address_reg->reg, reg->reg);
			gc(line);
		}
		lib_reg(address_reg);
		lib_reg(reg);

		return 0;
	}else{
		if (operator == asum){
			strncpy(op, "+",sizeof(op));
		}else if (operator == asub){
			strncpy(op, "-",sizeof(op));
		}else if (operator == amul){
			strncpy(op, "*",sizeof(op));
		}else if (operator == adivi){
			strncpy(op, "/",sizeof(op));
		}else{
			yyerror("Error de compilador en aritméticas");
		}
	}

	temp = assign_reg(puntero->tipo);
	struct reg_tipo *val = malloc(sizeof(struct reg_tipo));
	val->reg = temp;
	val->tipo = puntero->tipo;

	if(puntero->tipo == entero && reg->tipo == entero){
		// Recogemos direccion en registro direccion
		snprintf(line,lineSize,"\tR%d=0x%05d;\n", address_reg->reg, puntero->address);
		gc(line);
		// Guardamos valor de la direccion (usando el registro direccion) en el registro valor
		snprintf(line,lineSize,"\tR%d=I(R%d);\n", val->reg, address_reg->reg);
		gc(line);
		// Operamos
		snprintf(line,lineSize, "\tR%d=R%d%sR%d;\n",val->reg,val->reg,op,reg->reg);
		gc(line);
		// Guardamos en direccion
		snprintf(line,lineSize, "\tI(R%d)=R%d;\n",address_reg->reg,val->reg);
		gc(line);
	}else if(puntero->tipo == comaFlotante && reg->tipo == comaFlotante){
		// Recogemos direccion en registro direccion
		snprintf(line,lineSize,"\tR%d=0x%05d;\n", address_reg->reg, puntero->address);
		gc(line);
		// Guardamos valor de la direccion (usando el registro direccion) en el registro valor
		snprintf(line,lineSize,"\tRR%d=I(R%d);\n", val->reg, address_reg->reg);
		gc(line);
		// Operamos
		snprintf(line,lineSize, "\tRR%d=RR%d%sRR%d;\n",val->reg,val->reg,op,reg->reg);
		gc(line);
		// Guardamos en direccion
		snprintf(line,lineSize, "\tI(R%d)=RR%d;\n",address_reg->reg,val->reg);
		gc(line);
	}else if(puntero->tipo == entero && reg->tipo == comaFlotante){
		// Recogemos direccion en registro direccion
		snprintf(line,lineSize,"\tR%d=0x%05d;\n", address_reg->reg, puntero->address);
		gc(line);
		// Guardamos valor de la direccion (usando el registro direccion) en el registro valor
		snprintf(line,lineSize,"\tR%d=I(R%d);\n", val->reg, address_reg->reg);
		gc(line);
		// Operamos
		snprintf(line,lineSize, "\tR%d=R%d%sRR%d;\n",val->reg,val->reg,op,reg->reg);
		gc(line);
		// Guardamos en direccion
		snprintf(line,lineSize, "\tI(R%d)=R%d;\n",address_reg->reg,val->reg);
		gc(line);
	}else if(puntero->tipo == comaFlotante && reg->tipo == entero){
		// Recogemos direccion en registro direccion
		snprintf(line,lineSize,"\tR%d=0x%05d;\n", address_reg->reg, puntero->address);
		gc(line);
		// Guardamos valor de la direccion (usando el registro direccion) en el registro valor
		snprintf(line,lineSize,"\tRR%d=I(R%d);\n", val->reg, address_reg->reg);
		gc(line);
		// Operamos
		snprintf(line,lineSize, "\tRR%d=RR%d%sR%d;\n",val->reg,val->reg,op,reg->reg);
		gc(line);
		// Guardamos en direccion
		snprintf(line,lineSize, "\tI(R%d)=RR%d;\n",address_reg->reg,val->reg);
		gc(line);
	}else{
		yyerror("Fallo en asignaciones, asegúrese de que usa tipos correctos");
	}

	lib_reg(val);
	lib_reg(address_reg);
	lib_reg(reg);
	return 0;
}