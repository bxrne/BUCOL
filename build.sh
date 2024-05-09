#!/bin/bash -e

# if no out folder, create one
if [ ! -d "out" ]; then
  mkdir out
fi

# remove old files
rm -rf out/*

# remove old generated files (gch files: precompiled headers)
rm -rf src/*.gch

# Use flex and bison to generate c files for lexer and parser
flex src/lexer.l
bison -d src/parser.y

# compile all c files
gcc parser.tab.c lex.yy.c src/*.c src/*.h

# move all generated files to out folder
mv parser.tab.c parser.tab.h lex.yy.c out/
mv a.out out/parser