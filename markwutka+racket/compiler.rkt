#lang nanopass

(define-language R0
  (entry Program)
  (terminals (datum (d)))
  (Exp (exp)
       d
       (read)
       (- exp)
       (+ exp0 exp1))
  (Program ()
           (program exp)))
        

(define (datum? d)
  (fixnum? d))

(define (var? v)
  (symbol? v))

(define (int? i)
  (fixnum? i))

(define (register? r)
  (member r '(rsp rbp rax rbx rcx rdx rsi rdi r8 r9 r10 r11
                  r12 r13 r14 r15)))

(define (label? l)
  (symbol? l))

(define-language R1
  (extends R0)
  (terminals
   (+ (var (v))))
  (Exp (exp)
       (+ v
          (let ([v* exp*] ...) exp1))))

(define-language X860
  (entry Program)
  (terminals
   (register (r))
   (int (i))
   (label (lab)))
  (Arg (arg)
       (int i)
       (reg r)
       (deref r i))
  (Instr (instr)
         (addq arg0 arg1)
         (subq arg0 arg1)
         (movq arg0 arg1)
         (retq)
         (negq arg)
         (callq lab)
         (pushq arg)
         (popq arg))
  (Block (blk)
         (block lab instr* ... instr))
  (Program ()
           (program lab ((lab* . blk*) ...))))

(define-language C0
  (entry C0)
  (terminals
   (int (i))
   (var (v))
   (label (lab)))
  (Arg (arg)
       i
       v)
  (Exp (exp)
       arg
       (read)
       (- arg)
       (+ arg0 arg1))
  (Stmt (stmt)
        (assign v exp))
  (Tail (tail)
        (return exp)
        (seq stmt tail))
  (C0 ()
      (program lab ((lab* . tail*)))))
