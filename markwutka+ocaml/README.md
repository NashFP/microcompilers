# OCaml Microcompiler

The x64.ml file defines instructions, directives, and addressing modes
for generating x86-64 instructions, but is not complete.

Since everything is defined with OCaml types, defining a program is not as
pretty as it is in a Lispy language. Here is a simple "hello world" that works
on Linux:

```ocaml

open X64

let program = [
    Directive_text;
    Directive_globl "_start";
    Directive_label "_start";
    
    Inst_lea (Addr_Mode_Indirect_Disp (Address_label "L_.str", Reg_rip), Addr_Mode_Reg Reg_rdi);
    Inst_call "puts";

    Inst_mov (Addr_Mode_Immed (Address_value (Int64.of_int 60)), Addr_Mode_Reg Reg_rax);
    Inst_mov (Addr_Mode_Immed (Address_value (Int64.of_int 0)), Addr_Mode_Reg Reg_rdi);
    Inst_syscall;
             
    Directive_label "L_.str";
    Directive_asciz "hello world"];;
                
             
write_instrs_to_file program "program.s"

    
```

The generated assembly looks like this:

```assemble
.text
    .globl _start
_start:
    lea L_.str(%rip),%rdi
    call puts
    mov $60,%rax
    mov $0,%rdi
    syscall
L_.str:
    .asciz "hello world"
```

To compile the OCaml to generate the program, do:
```bash
ocamlc -i -c x64.ml > x64.mli
ocamlopt -o genprogram x64.ml genprogram.ml
```

Then run genprogram:
```bash
./genprogram
```

Next, assemble the program.s file:
```bash
as -o program.o program.s
```

Now link the program:
```bash
ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc program.o -o program
```

Finally, run the program:
```bash
./program
```

All of these steps are contained in the build.sh script.
