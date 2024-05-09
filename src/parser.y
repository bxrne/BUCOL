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

declarations: declaration | declarations declaration {
    // Minimum one declaration
}


// program monolith keywords require '.' as end of call.  
beginning: BEGINNING PERIOD 
body: BODY PERIOD
end: END PERIOD

statements: statement | statements statement {
    // a statement can be comprised of one or more statements
}

// you can declare vars, assign them vals, add those vals, input and output those vals.
statement: assignment | addition | declaration | input | print 

// Series of Xs for capactiy 
declaration: CAPACITY IDENTIFIER PERIOD
{
    valid = valid && declareVariable($2, $1);
} 

// Move values between identifiers 
assignment: MOVE IDENTIFIER TO IDENTIFIER PERIOD
{
    valid = valid && moveFrom($2, $4);
}

// Assign an integer to an identifier
assignment: MOVE INTEGER_LITERAL TO IDENTIFIER PERIOD
{
    valid = valid && moveLiteral($2, $4);
}

// Add an integer to an identifier
addition: ADD INTEGER_LITERAL TO IDENTIFIER PERIOD
{
    valid = valid && addLiteral($2, $4);
}

// Add the value of an identifier to another (result affects 2nd operand)

addition: ADD IDENTIFIER TO IDENTIFIER PERIOD
{
    valid = valid && addFrom($2, $4);
}


// Take in values for identifiers in inputlist (any number of them)
input: INPUT inputlist PERIOD

//  Valid variable = declared
variable: IDENTIFIER {
   valid = valid && isDeclared($1);
}

// one or more variables
inputlist: variable | variable SEMICOLON inputlist 

// Outputs each item in the printlist
print: PRINT printlist PERIOD

// Can print one or more string literal or assigned values
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
