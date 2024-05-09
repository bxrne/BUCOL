#ifndef MAIN_H
#define MAIN_H

#include <stdbool.h>

bool declareVariable(char* identifier, int size);
bool isDeclared(char* id);

bool moveFrom(char* source_id, char* dest_id); // uses identifier to get value
bool moveLiteral(char* int_literal, char* dest_id);

bool addFrom(char* source_id, char* dest_id); // uses identifier to get value
bool addLiteral(char* int_literal, char* dest_id);

#endif
