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