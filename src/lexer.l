%option case-insensitive
%option noyywrap

%{
#include "parser.tab.h"
#include <ctype.h>
#include <string.h>
%}

CHAR [A-Za-z1-9-]
SAFECHAR [A-WYZa-wyz]
IGNORE [ \t\n]

%%
{IGNORE}+ /* ignore whitespaces and newlines */
"." return(PERIOD); /* EOL */ 

"BEGINNING" return(BEGINNING);
"BODY" return(BODY);
"END" return(END);

"MOVE" return(MOVE);
"ADD" return(ADD);

"INPUT" return(INPUT);
"PRINT" return(PRINT);

"TO" return(TO); // ADD operand
";" return(SEMICOLON); /* seperates identifiers in PRINT stmt */  

^X+ { yylval.size = strlen(yytext); return(CAPACITY); } // #X = #DIGITS

{SAFECHAR}+{CHAR}* | // Basic Identifiers 
[Xx]{CHAR}*[^Xx .";]{CHAR}* { yylval.str = strdup(yytext); return(IDENTIFIER); }

[0-9]+ { yylval.str = strdup(yytext); return(INTEGER_LITERAL); }
\"[^";.]*\" { yylval.str = strdup(yytext); return(STRING_LITERAL); } /* Excluding literal escapable tokens */ 

. return(0); /* ignore everything else */
%%
