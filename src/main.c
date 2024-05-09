#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#include "cuckoo.h"
#include "main.h"


bool isDeclared(char *id) {
    if (get(id) == NULL) {
        printf("err | %s not declared\n", id);
        return false;
    }
    return true;
}

bool declareVariable(char *identifier, int size) {
  if (get(identifier) != NULL) { // Overwrite check
    printf("err | %s already declared\n", identifier);
    return false;
  }

  Variable *newVar = set(identifier, size);

  if (newVar == NULL) {
    printf("err | cannot set variable %s\n", identifier);
    return false;
  }

  return true;
}

bool moveFrom(char *source_id, char *dest_id) {
  Variable *source = get(source_id);
  Variable *dest = get(dest_id);

  if (source == NULL) {
    printf("err | %s not declared\n", source_id);
    return false;
  }
  if (dest == NULL) {
    printf("err | %s not declared\n", dest_id);
    return false;
  }

  if (source->size > dest->size) {
    printf("err | cannot move size %d to size %d\n",
           source->size, dest->size);
    return false;
  }

  dest->value = source->value;
  return true;
}

bool moveLiteral(char *int_literal, char *dest_id) {
    Variable *dest = get(dest_id);
    
    if (dest == NULL) {
        printf("err | %s not declared\n", dest_id);
        return false;
    }
    
    int int_literal_size = strlen(int_literal);
    if (int_literal_size > dest->size) {
        printf("err | cannot move size %d to size %d\n", int_literal_size, dest->size);
        return false;
    }
    
    dest->value = atoi(int_literal);
    return true;
}

bool addFrom(char *source_id, char *dest_id) {
    Variable *source = get(source_id);
    Variable *dest = get(dest_id);
    
    if (source == NULL) {
        printf("err | %s not declared\n", source_id);
        return false;
    }
    if (dest == NULL) {
        printf("err | %s not declared\n", dest_id);
        return false;
    }

    int new_value = source->value + dest->value;
    char new_value_str[snprintf(NULL, 0, "%d", new_value)];    
    sprintf(new_value_str, "%d", new_value);

    if (strlen(new_value_str) > dest->size) {
        printf("err | cannot add from size %d to %d)\n", (int) strlen(new_value_str), dest->size);
        return false;
    }
    
    dest->value = new_value;
    return true;
}

bool addLiteral(char *int_literal, char *dest_id) {
    Variable *dest = get(dest_id);
    
    if (dest == NULL) {
        printf("err | %s not declared\n", dest_id);
        return false;
    }

    int int_literal_size = strlen(int_literal);
    if (int_literal_size > dest->size) {
        printf("err | cannot add from size %d to %d)\n", int_literal_size, dest->size);
        return false;
    }
    
    int new_value = atoi(int_literal) + dest->value;
    char new_value_str[snprintf(NULL, 0, "%d", new_value)];
    
    sprintf(new_value_str, "%d", new_value);

    if (strlen(new_value_str) > dest->size) {
        printf("err | cannot add from size %d to %d)\n", (int) strlen(new_value_str), dest->size);
        return false;
    }
    
    dest->value = new_value;
    return true;
}