# microcompilers

My sketch of a compiler is in [assemble.clj](assemble.clj).

I am calling my little language "micro".


### TODO

* Stand up an end-to-end test that runs hello.micro

* Stand up some unit tests for instructions

* Try describing this language (at least loosely) using a Clojure spec

* Assembly language features that might be worth trying out:
    * 4-operand indirect addressing mode (lol)
    * indirect `jmp` and `call`
