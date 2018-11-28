# microcompilers

> The first compiler I ever worked on was the one I wrote in the spring
> of 2009 for [Kent Dybvig](https://www.cs.indiana.edu/~dyb/)’s
> [graduate compilers course](http://web.archive.org/web/20090310121139/http://www.cs.indiana.edu/classes/p523/)
> at Indiana University. Actually, I didn’t write just one compiler for
> Kent’s course that semester; I wrote fifteen compilers, one for each
> week of the course. The first one had an input language that was more
> or less just parenthesized assembly language; its target language was
> x86-64 assembly. Each week, we added more passes to the front of the
> previous week’s compiler, resulting in a new compiler with the same
> target language as the compiler of the previous week, but a slightly
> higher-level input language.

—["My first fifteen compilers"](http://composition.al/blog/2017/07/31/my-first-fifteen-compilers/)
by Lindsey Kuper.

A **compiler** is a program that translates code
from one language to another.

Let's create a compiler that translates
a made-up programming language down to x86-64 assembly.
We'll do it in small steps, starting at the very end:
generating x86-64 assembly that our computer can actually run.

*   [Stage 0 - Generating assembly](stage-0-assembly.md)

*   ...more to come...

Contribute your solution by creating a directory in this repo such as `bryan_hunter+elixir`.


## Resources and clues

[Guide to x86-64](https://web.stanford.edu/class/cs107/guide/x86-64.html)

[One-page x86-64 cheat sheet](https://web.stanford.edu/class/cs107/resources/onepage_x86-64.pdf)

[Compiler Explorer](https://godbolt.org/) is handy for answering the question
"How can I do X in assembly?" as long as you know how to do X in some compiled language,
like C, C++, Rust, or Go.
