%{

#include <stdio.h> 
#include "parser.tab.h"

int numlin = 1;
int scope = 0;
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
print						{return PRINT;}

\+=							{return ASSIGN_ADD;}
-=							{return ASSIGN_SUBS;}
\*=							{return ASSIGN_MULT;}
\/=							{return ASSIGN_DIV;}

-?[0-9]+					{yylval.int4 = atoi(yytext) ;return LIT_INT;}
-?[0-9]+\.[0-9]*			{yylval.fl = atof(yytext);return LIT_FLOAT;}
\'.\'						{yylval.ch = yytext[1];return LIT_CHAR;}

\"[^"']*\"					{yylval.str = malloc(sizeof(char)*strlen(yytext)); strncpy(yylval.str, yytext+1, strlen(yytext)-2);return LIT_STRING;}
true						{return TRUE;}
false						{return FALSE;}

main						{return MAIN;}

[A-Za-z_][A-Za-z0-9_-]*		{yylval.str = strdup(yytext);return (ID);}


#.*$						{/* ignoramos los comentarios */}

[[\]{}().+\-*/%=<>?:,^;] 	{	int asciiCode = yytext[0];
								if(asciiCode == 123) scope++;
								if(asciiCode == 125) scope--;
								return asciiCode;
							}
							
\n 							{numlin++;}
[ |\t|\r] 					{/* ignoramos espacios y tab */}

.							{yyerror("caracter no registrado");}
<<EOF>> 					{return 0;}
%%

int yywrap() { 
	return 1; 
}