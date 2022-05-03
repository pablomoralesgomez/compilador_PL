%{

#define IF 				258
#define ELIF 			259
#define ELSE 			260
	
#define WHILE 			261
#define DO 				262
#define FOR 			263
#define CONTINUE 		264
#define BREAK 			265

#define AND 			266
#define OR 				267
#define NOT 			268

#define EQUALS 			269
#define NOT_EQ 			270
#define LESS_EQ 		271
#define BIGGER_EQ 		272

#define VOID 			273
#define INT 			274
#define FLOAT 			275
#define CHAR 			276
#define BOOL 			277
#define STRING 			278

#define HEADER 			279
#define GLOBAL 			280
#define RETURN 			281

#define ASSIGN_ADD 		282
#define ASSIGN_SUBS 	283
#define ASSIGN_MULT 	284
#define ASSIGN_DIV 		285

#define LIT_INT			286
#define LIT_FLOAT		287
#define LIT_CHAR		288
#define LIT_STRING		289
#define TRUE			290	
#define FALSE			291

#define ID				292

#define MAIN			293

int numlin = 1;
void error(char*);

%}


%%
if							{return IF;}
elif						{return ELIF;}
else						{return ELSE;}

while						{return WHILE;}
do							{return DO;}
for							{return FOR;}
continue					{return CONTINUE;}
break						{return BREAK;}

and							{return AND;}
or							{return OR;}
not							{return NOT;}

==							{return EQUALS;}
!=							{return NOT_EQ;}
\<=							{return LESS_EQ;}
\>=							{return BIGGER_EQ;}

void						{return VOID;}
int							{return INT;}
float						{return FLOAT;}
char						{return CHAR;}
boolean						{return BOOL;}
String						{return STRING;}

header						{return HEADER;}
global						{return GLOBAL;}
return						{return RETURN;}

\+=							{return ASSIGN_ADD;}
-=							{return ASSIGN_SUBS;}
\*=							{return ASSIGN_MULT;}
\/=							{return ASSIGN_DIV;}

-?[0-9]+					{return LIT_INT;}
-?[0-9]+\.[0-9]*			{return LIT_FLOAT;}
\'.?\'						{return LIT_CHAR;}
\"[^"']*\"					{return LIT_STRING;}
true						{return TRUE;}
false						{return FALSE;}

main						{return MAIN;}

[A-Za-z_][A-Za-z0-9_-]*		{return ID;}


#.*$						{/* ignoramos los comentarios */}
[[\]{}().+\-*/%=<>?:,^;] 	{return yytext[0];}
\n 							{numlin++;}
[ |\t] 						{/* ignoramos espacios y tab */}

.							{error("caracter no registrado");}
<<EOF>> 					{return 0;}
%%

int yywrap() { 
	return 1; 
}

void error(char* mens) {
    printf("Error lexico en linea %i: %s\n",numlin,mens);
}

int main(int argc, char** argv) {
    int s;
    if(argc == 2) {
		yyin=fopen(argv[1],"r"); 
	}
	/* else yyin=stdin */
	
	s = yylex();
	while(s) {
		printf("%d \n", s);
		s = yylex();
	}
	
    return 0;
}

