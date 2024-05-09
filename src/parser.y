%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#include "src/main.h"

extern int yylex();
extern int yyparse();
extern void yyerror(char *s);

bool valid = true;
%}

%union {
    int size;
    char *str;   
}

%token <str> IDENTIFIER INTEGER_LITERAL STRING_LITERAL
%token <size> CAPACITY

%token PERIOD BEGINNING BODY END TO MOVE ADD INPUT PRINT SEMICOLON
%%

program: beginning declarations body statements end {
    if (valid) {
        printf("Program is well formed!\n");
    } else {
        printf("Badly formed program, try again!\n");
    }
} 

declarations: declaration | declarations declaration 


beginning: BEGINNING PERIOD 
body: BODY PERIOD
end: END PERIOD

statements: statement | statements statement 

statement: assignment | addition | declaration | input | print 

declaration: CAPACITY IDENTIFIER PERIOD
{
    valid = valid && declareVariable($2, $1);
} 

assignment: MOVE IDENTIFIER TO IDENTIFIER PERIOD
{
    valid = valid && moveFrom($2, $4);
}

assignment: MOVE INTEGER_LITERAL TO IDENTIFIER PERIOD
{
    valid = valid && moveLiteral($2, $4);
}

addition: ADD INTEGER_LITERAL TO IDENTIFIER PERIOD
{
    valid = valid && addLiteral($2, $4);
}

addition: ADD IDENTIFIER TO IDENTIFIER PERIOD
{
    valid = valid && addFrom($2, $4);
}

input: INPUT inputlist PERIOD

variable: IDENTIFIER {
   valid = valid && isDeclared($1);
}

inputlist: variable | variable SEMICOLON inputlist 

print: PRINT printlist PERIOD

printlist: variable | STRING_LITERAL | variable SEMICOLON printlist | STRING_LITERAL SEMICOLON printlist

%%

extern FILE *yyin;

int main() {
    do {
        yyparse();
    } while (!feof(yyin));
    return 0;
}

void yyerror(char *s) {
    valid = false;
    fprintf(stderr, "%s\n", s);
}
