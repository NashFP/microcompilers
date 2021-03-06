# Chapter 0 - Generating assembly

Your first compiler should translate code
from a list of lists
to assembly code that your computer can run.

For example, if you're writing your compiler in Clojure, your input might
look like this.

```clojure
((.text)
 (.globl _main :# "-- Begin function main")
 (.label _main)
 (pushq :%rax)
 (leaq	[L_.str :%rip] :%rdi)
 (callq	_puts)
 (xorl	:%eax :%eax)
 (popq :%rcx)
 (retq)

 (.label L_.str)
 (.asciz "hello world"))
```

Don't worry if this looks like gibberish to you.
You don't have to understand x86-64 assembly language to get started.

What's important is that this is plain old Clojure data, just a list of lists.
And all you are going to do is print a line of output for each list.

The output should look something like this:

```asm
	.text
	.globl	_main		## -- Begin function main
_main:
	pushq	%rax
	leaq	L_.str(%rip), %rdi
	callq	_puts
	xorl	%eax, %eax
	popq	%rcx
	retq
L_.str:
	.asciz	"hello world"
```

If you have a Mac, you can run this code!
Put it in a file called `program.s`.
The commands to run it are:

```console
$ as program.s -o program.o
$ ld -macosx_version_min 10.14 -lc program.o -o program
$ ./program
hello world
```

*   `as` is the assembler.
    It transforms assembly (`program.s`, which is just an ASCII text file)
    to an "object file" containing binary machine code (`program.o`).

*   `ld` is the linker.
    It combines object files with other libraries
    to produce an executable file (`program`).

*   `-lc` means "link `libc`", the C standard library.
    That's the library that provies the `_puts` function.

The commands are similar on Linux, but the syntax is (unfortunately) a bit different.


## What's the point?

From here on out, we'll be writing pure functions that operate on lists
(or arrays, or however you like to handle data in your favorite programming language).
This stage gives us a way to go from those lists or arrays to actual running code.


## How to generate examples of assembly code

It's easier if you start with some programs you'd like to be able to compile.

The simplest way is to write those programs in C and use an existing C
compiler to generate assembly for you. On a Mac, it's probably easiest to
install XCode, write a little C program like this:

    ```c
    // hello.c

    #include <stdio.h>

    int main() {
        puts("hello microcompiler world");
        return 0;
    }
    ```

Then use this command: `clang++ -O2 -fomit-frame-pointer -S hello.c`

*   `-O2` means optimize aggressively.
    This makes the compiler generate far fewer instructions,
    so the output is usually much easier to understand.

*   `-fomit-frame-pointer` means generate even fewer instructions.

*   `-S` means, produce assembly as text (in a file `hello.s`)
    rather than a complete executable.
