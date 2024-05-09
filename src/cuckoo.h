#ifndef VARIABLES_H
#define VARIABLES_H

typedef struct Variable {
    char* identifier;
    int size;
    int value;
} Variable;

Variable* get(char* identifier);
Variable* set(char* identifier, int size);

#endif