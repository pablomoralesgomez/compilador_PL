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

int tagCount = 1;
int br = 0;
int co = 0;
int fi = 0;
int statCount = 0;


int int_regs[1  + 5];
int float_regs[1 +3];

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

// Variable auxiliar para controlar que los return son correctos y se encuentran en el lugar adecuado
int returnScope1 = false;
int returnCount = -1;
int funcTipo = -1;

// Funciones auxiliares para contar cuantos registros hay ocupados y asi poder salvarlos en la llamada de una funcion
int countOccupiedIntReg();
int countOccupiedFloatReg();

void yyerror(char*);

void lib_reg(struct reg_tipo*);
int assign_reg(int);
void gc(char* text);

void adde(char*, enum type, enum category, int, int , struct array*);
struct reg_tipo * igualdades(struct reg_tipo*, struct reg_tipo*, enum op_igualdades);
struct reg_tipo * logicos(struct reg_tipo*, struct reg_tipo*, enum op_logicos);
struct reg_tipo * aritmeticas(struct reg_tipo*, struct reg_tipo*, enum op_aritmeticas);
int asignaciones(struct reg_tipo*, char*, enum op_asignaciones);
int getTag();
char getLetter(enum type);
int getStat();

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
	struct reg_tipo * expr;
	int tip;
	int int1;
}

%token <str>ID
%token MAIN

%type <tip> typeFunction typePrimitive typeVariable
%type <str> functionCall
%type <expr> expression literals boolLiteral printeableThings

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

program: 			global header functionArea;


/********* REGLAS DEL HEADER *********/
header: 			/* empty */
|					HEADER '{' headerWrapper '}';

headerWrapper: 		/* empty */
|					headerWrapper headerdcl;

headerdcl: 			typeFunction ID {adde($2, $1, funcion, 0, getTag(), NULL);} '(' paramWrapper ')' ';';

paramWrapper: 		/* empty */
|					paramWrapperRecursive  {
												if(checkingParamNumber < functionNumberParam) yyerror("El numero de parametros es menor que en el header.");
												checkingParamNumber = 0;
											};

paramWrapperRecursive: {checkingParamNumber++;} param
|					paramWrapperRecursive ',' {checkingParamNumber++;} param;

param:				typeVariable ID									{
																		if(functionName[0] == '\0') {
																			adde($2, $1, param, 0, checkingParamNumber*4, NULL);
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
|					globalWrapper variabledcl;



/********* REGLAS ZONA DE DECLARACIÓN DE FUNCIONES *********/
functionArea: 		functionWrapper main functionWrapper;

functionWrapper: 	/* empty */					{br = 0; co = 0;}
|					functionWrapper functiondcl {br = 0; co = 0;};

/* ID can't be 'main' */
/* already checked? */
functiondcl: 		typeFunction ID {functionName = $2; functionNumberParam = countFunctionParameters($2); funcTipo=$1; returnCount = 0;} '(' paramWrapper ')' '{'		{
											struct nodo *puntero = search($2, funcion);
											if(puntero == NULL) yyerror("La funcion no esta declarada en el header");
											if($1 != puntero->tipo) yyerror("El tipo de la funcion no corresponde con la del header");

											snprintf(line, lineSize, "\n// Funcion %s\n L %d:\tR6 = R7 + %d;\t\t\t// Situamos R6 justo encima de los parametros y debajo de la etiqueta de regreso y la antigua posicion de R6 - l:%d\n", puntero->id, puntero->address, functionNumberParam*4, numlin);
											gc(line);

											puntero = puntero->param;
											while(puntero != NULL) {
												adde(puntero->id, puntero->tipo, local, scope, puntero->address, puntero->array); // FIXME cuando es array el tipo no es el del puntero, sino entero

												puntero = puntero->param;
											}

											$<int1>$ = r7Displacement;
											r7Displacement = functionNumberParam;

											functionNumberParam = -1;
											functionName = "";
										}
										statementWrapper '}'					{	
																					if(returnCount > 0 && $1 == vacio) yyerror("Las funciones tipo void no permiten el uso de return.");	
																					if(returnCount < 1 && $1 != vacio) yyerror("La funcion no retorna ningún valor.");
																					if(!returnScope1) yyerror("Puede que los return de esta funcion sean inaccesibles. Sitúe uno al final de la función para evitarlo.");
																					
																					snprintf(line, lineSize, "\tR7 = R6;\t\t\t// Eliminamos todas las variables locales y los param de pila - l:%d\n", numlin);
																					gc(line);
																					
																					snprintf(line, lineSize, "\tR6 = P(R7 + 4);\t\t\t// Devolvemos R6 a su posicion previa - l:%d\n", numlin);
																					gc(line);
																					
																					if($1 != comaFlotante) {
																						snprintf(line, lineSize, "\tR5 = I(R0);\t\t\t// Guardamos el valor resultado - l:%d\n", numlin);
																					} else {
																						snprintf(line, lineSize, "\tRR3 = F(RR0);\t\t\t// Guardamos el valor resultado - l:%d\n", numlin);
																					}
																					gc(line);
																					
																					snprintf(line, lineSize, "\tR0 = P(R7);\t\t\t// Recogemos el valor de la etiqueta para regresar a la rutina anterior - l:%d\n", numlin);
																					gc(line);
																					
																					snprintf(line, lineSize, "\tGT(R0);\t\t\t\t// Volvemos a la rutina anterior - l:%d\n", numlin);
																					gc(line);

																					r7Displacement = $<int1>8;
																					funcTipo = -1;
																					returnCount = -1;
																					returnScope1 = false;
																					deleteScope(scope);
																				};

main:           	INT MAIN '(' ')' '{'

					{
						snprintf(line, lineSize, "\n// Funcion main\n");
						gc(line);

						snprintf(line, lineSize, "L 0:\tR6 = R7;\t\t\t// Inicio del programa\n");
						gc(line);
					}

					statementWrapper '}'					{
																snprintf(line, lineSize, "\tR0 = 0;\t\t\t\t// Exito\n");
																gc(line);

																snprintf(line, lineSize, "\tGT(-2);\t\t\t\t// Fin del programa\n");
																gc(line);

																deleteScope(scope);
															};



/********* REGLAS DECLARACIÓN DE STATEMENT *********/
statementWrapper: 	/* empty */
|					statementWrapper statement;

/* FIXME CONTINUE BREAK RETURN */
statement: 			loop
|					conditional
|					variabledcl
|					functionCall ';'
|					varAssign ';'
|					BREAK ';'			{
												if (br){
													snprintf(line,lineSize, "\tGT(%d);\t\t\t\t// break- l:%d\n", br,numlin);
													gc(line);
												}else{
													yyerror("Break fuera de bucle");
												}
												}
|					PRINT '(' printeableThings ')' ';' {
																							int stat = getStat();
																							int tag = getTag();
																							snprintf(line, lineSize, "STAT(%d)\n// print - l:%d\n", stat, numlin);
																							gc(line);
																							snprintf(line, lineSize, "\tSTR(0x%05x,\"1\");\n", getAddress(entero,-1));
																							gc(line);
																							snprintf(line, lineSize, "CODE(%d)\n", stat);
																							gc(line);
																							snprintf(line,lineSize, "\tR0=R%d;\t\t\t\t\n", numlin);
																							gc(line);							
																							snprintf(line,lineSize, "\tR0=R%d;\t\t\t\t", numlin);
																							gc(line);
																							snprintf(line,lineSize, "L %d:\t\t\t\t\t\t\n", tag);
																							gc(line);
																							}
|					CONTINUE ';'	{
												if (co){
													snprintf(line,lineSize, "\tGT(%d);\t\t\t\t// continue - l:%d\n", co,numlin);
													gc(line);
												}else{
													yyerror("Continue fuera de bucle");
												}
												}
|					RETURN expression ';'		{
													if(funcTipo != $2->tipo) yyerror("El tipo de la funcion no se corresponde con el que se desea retornar.");
													if(scope == 1) returnScope1 = true;
													returnCount++;
													
													snprintf(line, lineSize, "\tR7 = R6;\t\t\t// Eliminamos todas las variables locales y los param de pila - l:%d\n", numlin);
													gc(line);
													
													snprintf(line, lineSize, "\tR6 = P(R7 + 4);\t\t\t// Devolvemos R6 a su posicion previa - l:%d\n", numlin);
													gc(line);
													
													if($2->tipo != comaFlotante) {
														snprintf(line, lineSize, "\tR5 = I(R0);\t\t\t// Guardamos el valor resultado - l:%d\n", numlin);
													} else {
														snprintf(line, lineSize, "\tRR3 = F(RR0);\t\t\t// Guardamos el valor resultado - l:%d\n", numlin);
													}
													gc(line);
													
													snprintf(line, lineSize, "\tR0 = P(R7);\t\t\t// Recogemos el valor de la etiqueta para regresar a la rutina anterior - l:%d\n", numlin);
													gc(line);
													
													snprintf(line, lineSize, "\tGT(R0);\t\t\t\t// Volvemos a la rutina anterior - l:%d\n", numlin);
													gc(line);
													lib_reg($2);
												};

/* returnExpression */


printeableThings:	expression	// FIXME free reg_tipo
|					LIT_STRING;


/********* REGLAS DECLARACIÓN DE BUCLES *********/
loop: 				forLoop
|					whileLoop
|					DO whileLoop;		// FIXME

/* HACK variabledcl already has ';' */
forLoop: 	{$<int1>$ = co;}//1 								//Store previous continue tag
					{$<int1>$ = br;}//2 								//Store previous break tag
					{co = getTag(); $<int1>$ = co;}//3	//Store current continue tag
					{br = getTag(); $<int1>$ = br;}//4	//Store current break tag
					//5		6			7					8						9
					FOR '(' {scope++;} variabledcl {scope--;}
					{
					snprintf(line,lineSize, "L %d:\t\t\t\t\t\t// for con - l:%d\n", $<int1>3,numlin);
					gc(line);
					}// 10
					// 11				12
					expression ';'
					{
					if ($11->tipo != boolean){
						yyerror("La expresión del bucle no es booleana");
					}
					snprintf(line,lineSize, "\tIF (!R%d) GT(%d); // for bool - l:%d\n",$11->reg, $<int1>4,numlin);
					gc(line);
					lib_reg($11);
					}//13
					//14			15	16					17
					varAssign ')' '{' statementWrapper '}'
					{
					co = $<int1>1;	// Retrieve previous continue tag
					br = $<int1>2;	// Retrieve previous break tag
					snprintf(line,lineSize, "L %d:\t\t\t\t\t\t// for bre - l:%d\n", $<int1>4,numlin);
					gc(line);

					deleteScope(scope);
					};

whileLoop: 	{$<int1>$ = co;}//1 									//Store previous continue tag
						{$<int1>$ = br;}//2 									//Store previous break tag
						{co = getTag(); $<int1>$ = co;}//3		//Store current continue tag
						{br = getTag(); $<int1>$ = br;}//4		//Store current break tag
						{
						snprintf(line,lineSize, "L %d:\t\t\t\t\t\t// while con - l:%d\n", $<int1>3,numlin);
						gc(line);
						}//5
						//6			7			8				9
						WHILE '(' expression ')'
						{
						if ($8->tipo != boolean){
							yyerror("La expresión del bucle no es booleana");
						}
						snprintf(line,lineSize, "\tIF (!R%d) GT(%d);\t\t\t// while bool - l:%d\n",$8->reg, $<int1>4,numlin);
						gc(line);
						lib_reg($8);
						}
						'{' statementWrapper '}'
						{
						co = $<int1>1;	// Retrieve previous continue tag
						br = $<int1>2;	// Retrieve previous break tag
						snprintf(line,lineSize, "\tGT(%d);\t\t\t\t// while repeat - l:%d\n", $<int1>3,numlin);
						gc(line);
						snprintf(line,lineSize, "L %d:\t\t\t\t\t\t// while bre - l:%d\n", $<int1>4,numlin);
						gc(line);
						deleteScope(scope);
						};



/********* REGLAS DECLARACIÓN DE CONDICIONALES*********/
conditional: 	{$<int1>$ = fi;}//1 								//Store previous if tag
							{fi = getTag(); $<int1>$ = fi;}//2	//Store current if tag
							{snprintf(line,lineSize, "\t\t\t\t\t\t// if start - l:%d\n",numlin);gc(line);}

							ifCond elifCond elseCond

							{
							fi = $<int1>1;	// Retrieve previous if tag
							snprintf(line,lineSize, "L %d:\t\t\t\t\t\t// if exit - l:%d\n", $<int1>2,numlin);
							gc(line);
							};


ifCond: 			{$<int1>$ = getTag();}	// if not
							IF '(' expression ')' {
							if ($4->tipo != boolean){
								yyerror("La expresión del if no es booleana");
							}
							snprintf(line,lineSize, "\tIF (!R%d) GT(%d);\t\t\t// if bool - l:%d\n",$4->reg, $<int1>1,numlin);
							gc(line);
							lib_reg($4);
							}
							'{' statementWrapper
							{
							snprintf(line,lineSize, "\tGT(%d);\t\t\t\t// exit if - l:%d\n",fi,numlin);
							gc(line);
							}
							'}'
							{
							snprintf(line,lineSize, "L %d:\t\t\t\t\t\t// if not - l:%d\n", $<int1>1,numlin);
							gc(line);
							deleteScope(scope);
							};

elifCond: 			/* empty */
|					elifCond
					{$<int1>$ = getTag();}	// if not
					ELIF '(' expression ')' {
					if ($5->tipo != boolean){
						yyerror("La expresión del if no es booleana");
					}
					snprintf(line,lineSize, "\tIF (!R%d) GT(%d);\t\t\t\t// elif bool - l:%d\n",$5->reg, $<int1>2,numlin);
					gc(line);
					lib_reg($5);
					}
					'{' statementWrapper
					{
					snprintf(line,lineSize, "\tGT(%d);\t\t\t\t// exit elif - l:%d\n",fi,numlin);
					gc(line);
					}
					'}'
					{
					snprintf(line,lineSize, "L %d:\t\t\t\t\t\t// elif not - l:%d\n", $<int1>2,numlin);
					gc(line);
					deleteScope(scope);
					};

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
variabledcl:	typePrimitive ID '=' expression ';'
															{
															if ($1 != $4->tipo){
																if (!($1 == entero && $4->tipo == comaFlotante ||
																		$1 == comaFlotante && $4->tipo == entero)){
																	yyerror("Los tipos no coinciden");
																}
															}
															if (scope == 0){
																adde($2, $1, global, scope, getAddress($1, -1), NULL);
																struct nodo *puntero = search($2, global);

																int stat = getStat();
																snprintf(line, lineSize, "STAT(%d)\n", stat);
																gc(line);
																snprintf(line, lineSize, "\tDAT(0x%05x,%c,0);\t\t\t// Guardamos espacio variable global %s - l:%d\n", puntero->address, getLetter($1), $2, numlin);
																gc(line);
																snprintf(line, lineSize, "CODE(%d)\n", stat);
																gc(line);
																

																struct reg_tipo *ad = malloc(sizeof(struct reg_tipo));
																ad->reg = assign_reg(entero);
																ad->tipo = entero;
																snprintf(line, lineSize, "\tR%d=0x%05x;\t\t\t\t// Guardamos en la variable global %s su valor - l:%d\n", ad->reg, puntero->address,$2, numlin);
																gc(line);
																if ($4->tipo == comaFlotante){
																	snprintf(line, lineSize, "\tF(R%d) = RR%d;\t\t\t\t\n", ad->reg, $4->reg);
																	gc(line);
																}else{
																	snprintf(line, lineSize, "\tI(R%d) = R%d;\t\t\t\t\n", ad->reg, $4->reg);
																	gc(line);
																}
																free(ad);
															}else{
                                r7Displacement++;
                                adde($2, $1, local, scope, (r7Displacement * 4), NULL);

                                snprintf(line, lineSize, "\tR7 = R7 - 4;\t\t\t// Reservamos espacio en pila para la variable %s l:%d\n", $2, numlin);
                                gc(line);

                                if($4->tipo == comaFlotante) {
                                  if($1 == comaFlotante) {
                                    snprintf(line, lineSize, "\tF(R6 - %d) = RR%d;\t\t\t// Declaramos la variable %s l:%d\n", 4 * r7Displacement, $4->reg, $2, numlin);
                                  } else if($1 == entero) {
                                    snprintf(line, lineSize, "\tI(R6 - %d) = RR%d;\t\t\t// Declaramos la variable %s l:%d\n", 4 * r7Displacement, $4->reg, $2, numlin);
                                  } else {
                                    yyerror("El tipo de la variable y el que se quiere asignar no coinciden.");
                                  }
                                } else if($4->tipo == entero){
                                  if($1 == comaFlotante) {
                                    snprintf(line, lineSize, "\tF(R6 - %d) = R%d;\t\t\t// Declaramos la variable %s l:%d\n", 4 * r7Displacement, $4->reg, $2, numlin);
                                  } else if($1 == entero) {
                                    snprintf(line, lineSize, "\tI(R6 - %d) = R%d;\t\t\t// Declaramos la variable %s l:%d\n", 4 * r7Displacement, $4->reg, $2, numlin);
                                  } else {
                                    yyerror("El tipo de la variable y el que se quiere asignar no coinciden.");
                                  }
                                } else {
                                  if($1 != $4->tipo) yyerror("El tipo de la variable y el que se quiere asignar no coinciden.");
                                  snprintf(line, lineSize, "\tI(R6 - %d) = R%d;\t\t\t// Declaramos la variable %s l:%d\n", 4 * r7Displacement, $4->reg, $2, numlin);
                                }

                                gc(line);
															}
															lib_reg($4);
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
																struct nodo *puntero = search($1, funcion);

																if (puntero->tipo == vacio) yyerror("Una funcion void no devuelve valor.");

																struct reg_tipo *ex = malloc(sizeof(struct reg_tipo));
																
																if(puntero->tipo != comaFlotante) {
																	ex->reg = 5;
																} else {
																	ex->reg = 3;
																}
																ex->tipo = puntero->tipo;
																$$ = ex;
															}
|					ID '[' LIT_INT ']'						{
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
																						snprintf(line,lineSize, "\tRR%d = F(R6 - %d);\t\t// evaluate %s - l:%d\n", reg, puntero->address, $1, numlin);
																						gc(line);
																					}else{
																						snprintf(line,lineSize, "\tR%d = I(R6 - %d);\t\t\t// evaluate %s - l:%d\n", reg, puntero->address, $1, numlin);
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
																					$$ = logicos($1, $3, or);
																					}
|					expression AND expression 			{
																					$$ = logicos($1, $3, and);
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
																		snprintf(line,lineSize, "\tR%d = %ld;\t\t\t\t// LIT INT - l:%d\n",reg, $1,numlin);
																		gc(line);
																		$$ = res;
																		}
|					LIT_FLOAT 								{
																		int reg = assign_reg(comaFlotante);
																		struct reg_tipo *res =  malloc(sizeof(struct reg_tipo));
																		res->reg = reg;
																		res->tipo = comaFlotante;
																		snprintf(line,lineSize, "\tRR%d = %f;\t\t\t\t// LIT FLOAT - l:%d\n",reg, $1,numlin);
																		gc(line);
																		$$ = res;
																		}
|					LIT_CHAR 									{
																		int reg = assign_reg(entero);
																		struct reg_tipo *res =  malloc(sizeof(struct reg_tipo));
																		res->reg = reg;
																		res->tipo = caracter;
																		snprintf(line,lineSize, "\tR%d = %d;\t\t\t\t// LIT CHAR - l:%d\n",reg, $1,numlin);
																		gc(line);
																		$$ = res;
																		}
|					boolLiteral								{$$ = $1;};

boolLiteral:		TRUE								{
																		int reg = assign_reg(entero);
																		struct reg_tipo *res =  malloc(sizeof(struct reg_tipo));
																		res->reg = reg;
																		res->tipo = boolean;
																		snprintf(line,lineSize, "\tR%d = 1;\t\t\t\t// LIT TRUE - l:%d\n",reg,numlin);
																		gc(line);
																		$$ = res;
																		}
|					FALSE											{
																		int reg = assign_reg(entero);
																		struct reg_tipo *res =  malloc(sizeof(struct reg_tipo));
																		res->reg = reg;
																		res->tipo = boolean;
																		snprintf(line,lineSize, "\tR%d = 0;\t\t\t\t// LIT FALSE - l:%d\n",reg,numlin);
																		gc(line);
																		$$ = res;
																		};

/* TODO: Hacer comprobaciones a la hora de llamar a la funcion: id correcta, num param, etc */

/********* REGLAS LLAMADA A UNA FUNCION*********/
functionCall: 		ID {
							functionName = $1; functionNumberParam = countFunctionParameters($1);
							
							// Guardamos los registros activos
							int countIntReg = countOccupiedIntReg();
							int countAux = 0;
							
							while(countAux < countIntReg) {
								snprintf(line,lineSize, "\tR7 = R7 - 4;\t\t\t// Salvamos los registros enteros activos - l:%d\n", numlin);
								gc(line);
								
								snprintf(line,lineSize, "\tI(R6 - %d) = R%d;\n", (r7Displacement + countAux +1) * 4, countAux);
								gc(line);
								
								countAux++;
							}
							
							countAux = 0;
							int countFloatReg = countOccupiedFloatReg();
							
							while(countAux < countFloatReg) {
								snprintf(line,lineSize, "\tR7 = R7 - 4;\t\t\t// Salvamos los registros coma flotante activos - l:%d\n", numlin);
								gc(line);
								
								snprintf(line,lineSize, "\tF(R6 - %d) = RR%d;\n", (r7Displacement + countIntReg + countAux +1) * 4, countAux);
								gc(line);
								
								countAux++;
							}
	
							snprintf(line,lineSize, "\tR7 = R7 - %d;\t\t\t// Reservamos espacio en pila para los parametros, la etiqueta de regreso y la posicion actual de R6 (llamada a funcion) - l:%d\n", (functionNumberParam + 2) * 4, numlin);
							gc(line);
						}

					'(' paramsFunctionCallWrapper ')' 	{
																	struct nodo *puntero = search($1, funcion);
																	if(puntero == NULL) {
																		yyerror("La funcion no esta declarada en el header");
																	}

																	int tag = getTag();
																	
																	snprintf(line,lineSize, "\tP(R7 + %d) = R6;\t\t\t// Guardamos la posicion actual de R6 en el espacio reservado - l:%d\n", (functionNumberParam + 1) * 4, numlin);
																	gc(line);	
																	
																	snprintf(line,lineSize, "\tP(R7 + %d) = %d;\t\t\t// Guardamos la etiqueta de regreso a la rutina actual en el espacio reservado - l:%d\n", (functionNumberParam) * 4, tag, numlin);
																	gc(line);	
																	
																	snprintf(line,lineSize, "\tGT(%d);\t\t\t\t// Saltamos a la funcion que se esta llamando - l:%d\n", puntero->address, numlin);
																	gc(line);
																	
																	snprintf(line,lineSize, "L %d:\tR7 = R7 + 8;\t\t\t// Recuperamos el resto del espacio reservado para la etiqueta y la posicion de R6 - l:%d\n", tag, numlin);
																	gc(line);	
																	
																	int countFloatReg = countOccupiedFloatReg();
							
																	while(countFloatReg > 0) {
																		snprintf(line,lineSize, "\tRR%d = F(R7);\t\t\t// Recuperamos el valor del registro salvado - l:%d\n", countFloatReg - 1, numlin);
																		gc(line);
																		
																		snprintf(line,lineSize, "\tR7 = R7 + 4;\n");
																		gc(line);
																		
																		countFloatReg--;
																	}
																											
																	int countIntReg = countOccupiedIntReg();
																	
																	while(countIntReg > 0) {
																		snprintf(line,lineSize, "\tR%d = I(R7);\t\t\t// Recuperamos el valor del registro salvado - l:%d\n", countIntReg - 1, numlin);
																		gc(line);
																		
																		snprintf(line,lineSize, "\tR7 = R7 + 4;\n");
																		gc(line);
																		
																		countIntReg--;
																	}

																	functionNumberParam = -1;
																	functionName = "";

																	$$ = $1;
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

																						if($4->tipo != comaFlotante) {
																							snprintf(line,lineSize, "\tI(R7 + %d) = R%d;\t\t\t// Guardamos el valor del parametro en el espacio reservado por la pila l:%d\n", (checkingParamNumber - 1) * 4, $4->reg, numlin);
																						} else {
																							snprintf(line,lineSize, "\tF(R7 + %d) = RR%d;\t\t\t// Guardamos el valor del parametro en el espacio reservado por la pila l:%d\n", (checkingParamNumber - 1) * 4, $4->reg, numlin);
																						}
																						gc(line);

																						lib_reg($4);
																					}
|	{checkingParamNumber++;} expression 											{
																						struct nodo * param = getParameterByNumber(functionName, checkingParamNumber);
																						if(param == NULL) yyerror("El numero de parametros no se corresponde con el especificado en el header.");
																						if($2->tipo != param->tipo) yyerror("El tipo del parametro no corresponde con el del header");

																						param->address = checkingParamNumber*4;

																						if($2->tipo != comaFlotante) {
																							snprintf(line,lineSize, "\tI(R7 + %d) = R%d;\t\t\t// Guardamos el valor del parametro en el espacio reservado por la pila l:%d\n", (checkingParamNumber - 1) * 4, $2->reg, numlin);
																						} else {
																							snprintf(line,lineSize, "\tF(R7 + %d) = RR%d;\t\t\t// Guardamos el valor del parametro en el espacio reservado por la pila l:%d\n", (checkingParamNumber - 1) * 4, $2->reg, numlin);
																						}
																						gc(line);

																						lib_reg($2);
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

int getTag(){
	int res = tagCount;
	tagCount = tagCount + 1;
	return res;
}

void gc(char* text){
	printf("%s",text);
	fputs(text, outQ);
}

// Contamos cuantos registros enteros estan ocupados para salvarlos antes de llamar a una funcion
int countOccupiedIntReg() {
	int len;
	len = sizeof(int_regs)/sizeof(int_regs[0]);
	
	int res = 0;
	
	for (int i = 0; i < len; i++){
		if (int_regs[i] == true) res++;
	}
	return res;
}

// Contamos cuantos registros de coma flotante estan ocupados para salvarlos antes de llamar a una funcion
int countOccupiedFloatReg() {
	int len;
	len = sizeof(float_regs)/sizeof(float_regs[0]);
	
	int res = 0;
	
	for (int i = 0; i < len; i++){
		if (float_regs[i] == true) res++;
	}
	return res;
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


	lineSize = sizeof(char)*300;
	line = malloc(lineSize);

  if(argc == 2) {
		yyin = fopen(argv[1],"r");
	}

	outQ = fopen(fName,"w");
	fputs("", outQ);
	fclose(outQ);
	outQ = fopen(fName,"a");
	snprintf(line,lineSize, "#include \"Q.h\"\n");
	gc(line);
	snprintf(line,lineSize, "BEGIN\n");
	gc(line);
	yyparse();
	snprintf(line,lineSize, "END\n");
	gc(line);

	free(line);
	fclose(outQ);

	//show();
  return 0;
}


// Funciones auxiliares

struct reg_tipo * igualdades(struct reg_tipo* izq, struct reg_tipo* der, enum op_igualdades operator){
	char *comment = malloc(lineSize);
	snprintf(comment,lineSize,"\t\t\t// Igualdad - l:%d",numlin);

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
		snprintf(line,lineSize, "\tR%d=R%d%sR%d;%s\n",izq->reg,izq->reg,op,der->reg,comment);
		lib_reg(der);
		res = izq;
	}else if(izq->tipo == comaFlotante && der->tipo == comaFlotante){
		int reg = assign_reg(entero);
		snprintf(line,lineSize, "\tR%d=RR%d%sRR%d;%s\n",reg ,izq->reg,op,der->reg,comment); // FIXME get register
		lib_reg(der);
		lib_reg(izq);
		struct reg_tipo *aux =  malloc(sizeof(struct reg_tipo));
		aux->reg = reg;
		aux->tipo = boolean;
		res = aux;
	}else if(izq->tipo == comaFlotante && der->tipo == entero){
		snprintf(line,lineSize, "\tR%d=RR%d%sR%d;%s\n",der->reg,izq->reg,op,der->reg,comment);
		lib_reg(izq);
		res = der;
	}else if(izq->tipo == entero && der->tipo == comaFlotante){
		snprintf(line,lineSize, "\tR%d=R%d%sRR%d;%s\n",izq->reg,izq->reg,op,der->reg,comment);
		lib_reg(der);
		res = izq;
	}else{
		yyerror("Fallo en igualdad, asegúrese de que usa tipos correctos");
	}
	res->tipo = boolean;
	gc(line);
	free(comment);
	return res;
}


struct reg_tipo * logicos(struct reg_tipo* izq, struct reg_tipo* der, enum op_logicos operator){
	char *comment = malloc(lineSize);
	snprintf(comment,lineSize,"\t\t\t// Logico - l:%d",numlin);

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
		snprintf(line,lineSize, "\tR%d=R%d%sR%d;%s\n",izq->reg,izq->reg,op,der->reg,comment);
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
	char *comment = malloc(lineSize);
	snprintf(comment,lineSize,"\t\t\t// Aritmetica - l:%d",numlin);


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
		snprintf(line,lineSize, "\tR%d=R%d%sR%d;%s\n",izq->reg,izq->reg,op,der->reg, comment);
		lib_reg(der);
		res = izq;
	}else if(izq->tipo == comaFlotante && der->tipo == comaFlotante){
		snprintf(line,lineSize, "\tRR%d=RR%d%sRR%d;%s\n",izq->reg,izq->reg,op,der->reg, comment);
		lib_reg(der);
		res = izq;
	}else if(izq->tipo == comaFlotante && der->tipo == entero){
		snprintf(line,lineSize, "\tRR%d=RR%d%sR%d;%s\n",izq->reg,izq->reg,op,der->reg, comment);
		lib_reg(der);
		res = izq;
	}else if(izq->tipo == entero && der->tipo == comaFlotante){
		snprintf(line,lineSize, "\tRR%d=R%d%sRR%d;%s\n",der->reg,izq->reg,op,der->reg, comment);
		lib_reg(izq);
		res = der;
	}else{
		yyerror("Fallo en aritméticas, asegúrese de que usa tipos correctos");
	}
	gc(line);
	free(comment);
	return res;
}

int asignaciones(struct reg_tipo* reg, char* id, enum op_asignaciones operator){
	
	char op[1];
	struct nodo *puntero = find(id);
	
	if(operator == aigual) {	
	
		if(reg->tipo == comaFlotante) {
			if(puntero->tipo == comaFlotante) {
				snprintf(line,lineSize,"\tF(R6 - %d) = RR%d;\t\t\t// Asignacion - l:%d\n", puntero->address, reg->reg, numlin);

			} else if(puntero->tipo == entero) {
				snprintf(line,lineSize,"\tI(R6 - %d) = RR%d;\t\t\t// Asignacion - l:%d\n", puntero->address, reg->reg, numlin);

			} else {
				yyerror("No puede asignar una expresion de ese tipo a esta variable.");
			}
			
		} else if(reg->tipo == entero) {
			if(puntero->tipo == comaFlotante) {
				snprintf(line,lineSize,"\tF(R6 - %d) = R%d;\t\t\t// Asignacion - l:%d\n", puntero->address, reg->reg, numlin);

			} else if(puntero->tipo == entero) {
				snprintf(line,lineSize,"\tI(R6 - %d) = R%d;\t\t\t// Asignacion - l:%d\n", puntero->address, reg->reg, numlin);

			} else {
				yyerror("No puede asignar una expresion de ese tipo a esta variable.");
			}
		} else {
			if(reg->tipo != puntero->tipo) yyerror("El tipo de la expresion a la derecha no puede asignarse a una variable de este tipo.");
	
			snprintf(line,lineSize,"\tI(R6 - %d) = R%d;\t\t\t// Asignacion - l:%d\n", puntero->address, reg->reg, numlin);
			
			
		}
		gc(line);
		
		return 0;
	} else {
	
		if (operator == asum){
			strncpy(op, "+", sizeof(op));
			
		}else if (operator == asub){
			strncpy(op, "-", sizeof(op));
			
		}else if (operator == amul){
			strncpy(op, "*", sizeof(op));
			
		}else if (operator == adivi){
			strncpy(op, "/", sizeof(op));
			
		}else{
			yyerror("Error de compilador en aritméticas");
		}
	}
	
	int new_reg = assign_reg(puntero->tipo);
	
	struct reg_tipo *address_puntero = malloc(sizeof(struct reg_tipo));	
	address_puntero->reg = new_reg;
	address_puntero->tipo = puntero->tipo;
	
	if(puntero->tipo == entero && reg->tipo == entero) {
		snprintf(line,lineSize,"\tR%d = I(R6 - %d);\t\t\t// Cargamos la variable sobre la que se realiza la operacion y se asigna - l:%d\n", address_puntero->reg, puntero->address, numlin);
		gc(line);
		
		snprintf(line,lineSize,"\tR%d = R%d %s R%d;\t\t\t// Realizamos la operacion - l:%d\n", address_puntero->reg, address_puntero->reg, op, reg->reg, numlin);
		gc(line);
		
		snprintf(line,lineSize,"\tI(R6 - %d) = R%d;\t\t\t// Asignamos el nuevo resultado en la zona reservada para la variable cargada - l:%d\n", puntero->address, address_puntero->reg, numlin);
		gc(line);
	} else if(puntero->tipo == entero && reg->tipo == comaFlotante) {
		snprintf(line,lineSize,"\tR%d = I(R6 - %d);\t\t\t// Cargamos la variable sobre la que se realiza la operacion y se asigna - l:%d\n", address_puntero->reg, puntero->address, numlin);
		gc(line);
		
		snprintf(line,lineSize,"\tR%d = R%d %s RR%d;\t\t\t// Realizamos la operacion - l:%d\n", address_puntero->reg, address_puntero->reg, op, reg->reg, numlin);
		gc(line);
		
		snprintf(line,lineSize,"\tI(R6 - %d) = R%d;\t\t\t// Asignamos el nuevo resultado en la zona reservada para la variable cargada - l:%d\n", puntero->address, address_puntero->reg, numlin);
		gc(line);
	} else if(puntero->tipo == comaFlotante && reg->tipo == entero) {
		snprintf(line,lineSize,"\tRR%d = F(R6 - %d);\t\t\t// Cargamos la variable sobre la que se realiza la operacion y se asigna - l:%d\n", address_puntero->reg, puntero->address, numlin);
		gc(line);
		
		snprintf(line,lineSize,"\tRR%d = RR%d %s R%d;\t\t\t// Realizamos la operacion - l:%d\n", address_puntero->reg, address_puntero->reg, op, reg->reg, numlin);
		gc(line);
		
		snprintf(line,lineSize,"\tF(R6 - %d) = RR%d;\t\t\t// Asignamos el nuevo resultado en la zona reservada para la variable cargada - l:%d\n", puntero->address, address_puntero->reg, numlin);
		gc(line);
	} else if(puntero->tipo == comaFlotante && reg->tipo == comaFlotante) {
		snprintf(line,lineSize,"\tRR%d = F(R6 - %d);\t\t\t// Cargamos la variable sobre la que se realiza la operacion y se asigna - l:%d\n", address_puntero->reg, puntero->address, numlin);
		gc(line);
		
		snprintf(line,lineSize,"\tRR%d = RR%d %s RR%d;\t\t\t// Realizamos la operacion - l:%d\n", address_puntero->reg, address_puntero->reg, op, reg->reg, numlin);
		gc(line);
		
		snprintf(line,lineSize,"\tF(R6 - %d) = RR%d;\t\t\t// Asignamos el nuevo resultado en la zona reservada para la variable cargada - l:%d\n", puntero->address, address_puntero->reg, numlin);
		gc(line);
	} else {
		yyerror("Los tipos usados en la asignacion no estan permitidos.");
	}
	
	lib_reg(reg);
	lib_reg(address_puntero);
	
	return 0;
}


char getLetter(enum type tipo){
	if (tipo == entero) {
		return 'I';
	}else if(tipo == caracter){
		return 'U';
	}else if(tipo == boolean){
		// We will trean them as chars
		return 'U';
	}else if(tipo == comaFlotante){
		return 'F';
	}
	yyerror("Error de compilador, tipo no definido");
	return '\'';
}

int getStat(){
	int res = statCount;
	statCount = statCount + 1;
	return res;
}