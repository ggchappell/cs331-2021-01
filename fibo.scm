#lang scheme
; fibo.scm
; Glenn G. Chappell
; 2021-04-02
;
; For CS F331 / CSCE A331 Spring 2021
; Compute Fibonacci Numbers


; The Fibonacci number F(n), for n >= 0, is defined by F(0) = 0,
; F(1) = 1, and for n >= 2, F(n) = F(n-2) + F(n-1).


; advance
; Given a size-2 list (a b) of consecutive Fibonacci numbers, return the
; list of the next such pair: (b a+b).
(define (advance p)
    (list (cadr p) (+ (car p) (cadr p)))
)
    ; Note: (car p) is the first element of p ("a"), and (cadr p) is the
    ; second element ("b").


; fibopair
; Given integer n >= 0, return the size-2 list (F(n) F(n+1)).
; Recursive.
(define (fibopair n)
    (if (= n 0)
        '(0 1)
        (advance (fibopair (- n 1)))
    )
)


; fibo
; Given n >= 0, return Fibonacci number F(n).
(define (fibo n)
    (car (fibopair n))
)


; displayfibos
; Given integers a, b with 0 <= a <= b, print Fibonacci numbers F(a) to
; F(b), each on a separate line, nicely formatted.
; Recursive.
(define (displayfibos a b)
    (begin
        (display "F(")
        (display a)
        (display ") = ")
        (display (fibo a))
        (newline)
        (if (< (+ a 1) b)
            (displayfibos (+ a 1) b) ; Scheme has loops; I use recursion
                                     ;  cuz I want to; Scheme does TCO,
                                     ;  so the call stack won't fill up
            (void)  ; Else do nothing
        )
    )
)


; Main program
; Print some Fibonacci numbers
(define how_many_to_print 20)
(display "Fibonacci Numbers")
(newline)
(displayfibos 0 how_many_to_print)
(newline)

