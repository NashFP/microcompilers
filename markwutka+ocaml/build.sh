#!/bin/sh
ocamlc -i -c x64.ml > x64.mli
ocamlopt -o genprogram x64.ml genprogram.ml
./genprogram
as -o program.o program.s
ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc program.o -o program
