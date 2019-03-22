# Essentials of Compilation - Nanopass

This project is based on Jeremy Siek's "Essentials of Compilation"
which can be found in an early PDF form here:
https://www.dropbox.com/s/ktdw8j0adcc44r0/book.pdf?dl=1

The course isn't quite a full back-to-front implementation, it
starts with a small language and implements that all the way to X86-64
assembly, and then adds language features and their implementations
gradually.

While the book doesn't use the Nanopass framework, I am. You can
find out more about it here:
http://nanopass.org/

The basic idea is that you define a series of languages and passes
in Racket or Scheme. A pass is defined as taking in a type of language
and generating a type of language, which may be the same or may be
different. Since one language may be heavily based on another, you can
define a new one in terms of the old one.

The "Essentials of Compilation" book uses three basic types of languages.
The R series defines the input language. Your first compiler should 
compile the R1 language, which is a simple expression language. At some
point, one of your passes takes in R1, or a form of it, and generates
a C0 language, which has a few operations similar to C. Finally, another
pass will take C0 and generate X86 instructions (first a simple set of
instructions in a language called X860).

I'm not sure it is a good idea to check in solutions from the book
into this repo, since I believe IU and possibly other universities
are actively teaching from it. The skeleton framework here just defines
the first few languages mentioned in the book, but does not work
any of the exercises.
