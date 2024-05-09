#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "cuckoo.h"

#define HASH_SIZE 20
#define MAX_RETRIES 5

// Cuckoo hashing implementation
static Variable* hashTable1[HASH_SIZE];
static Variable* hashTable2[HASH_SIZE];


unsigned hash1(char* s) {
    unsigned hashval = 0;
    while (*s != '\0') { 
        hashval = *s + 31 * hashval;
        s++;
    }
    return hashval % HASH_SIZE;
}

// Need both hash functions to be independent to avoid infinite loops
unsigned hash2(char* s) {
    unsigned hashval = 0;
    while (*s != '\0') {
        hashval = *s + 17 * hashval; 
        s++;
    }
    return hashval % HASH_SIZE;
}

Variable* get(char* identifier) {
    unsigned hashval1 = hash1(identifier);
    Variable* var1 = hashTable1[hashval1];

    // Check if the variable is in the first table
    if (var1 != NULL && strcmp(var1->identifier, identifier) == 0) {
        return var1;
    }
    
    // Check if the variable is in the second table
    unsigned hashval2 = hash2(identifier);
    Variable* var2 = hashTable2[hashval2];
    if (var2 != NULL && strcmp(var2->identifier, identifier) == 0) {
        return var2;
    }
    
    return NULL;
}

Variable* set(char* identifier, int size) {
    Variable* newVar = (Variable*)malloc(sizeof(Variable));
    if (newVar == NULL) {
        return NULL; // Memory allocation failed
    }
    newVar->identifier = strdup(identifier);
    if (newVar->identifier == NULL) {
        free(newVar); 
        return NULL; // Memory allocation failed
    }
    newVar->size = size;
    newVar->value = 0; // This will be my integer null value
    
    unsigned hashval1 = hash1(identifier);
    unsigned hashval2 = hash2(identifier);
    
    for (int i = 0; i < MAX_RETRIES; i++) { 
        if (hashTable1[hashval1] == NULL) {
            hashTable1[hashval1] = newVar;
            return newVar;
        }
        if (hashTable2[hashval2] == NULL) { 
            hashTable2[hashval2] = newVar;
            return newVar;
        }
        
        // Evict existing variable from the table (the cuckoo step)
        Variable* evictedVar = hashTable1[hashval1];
        hashTable1[hashval1] = newVar;
        newVar = evictedVar; // Try to insert evicted variable in the other table
        hashval1 = hash2(newVar->identifier);
        hashval2 = hash1(newVar->identifier);
    }
    
    free(newVar->identifier);
    free(newVar);
    return NULL;
}