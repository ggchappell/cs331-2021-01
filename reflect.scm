#lang scheme
; reflect.scm
; Glenn G. Chappell
; 2021-03-31
;
; For CS F331 / CSCE A331 Spring 2021
; Very Simple Scheme Reflection


; ======================================================================
; BEGIN code you can ignore, to deal with weird issues involving "eval".


; For reasons involving namespaces, the way we use "eval" in the REPL
; does not work in a program. The following code allows us to call
; "eval" here, but we must add a second argument to eval: ns, which
; represents a namespace. So where we would do "(eval xyz)" in the REPL,
; we use "(eval xyz ns)" here.
(define-namespace-anchor anc)
(define ns (namespace-anchor->namespace anc))


; END code you can ignore. Start paying attention again. :-)
; ======================================================================


; Print opening message.
(display "Here is an itty bitty demo of reflection in Scheme.")
(newline)
(newline)

; Make some code: expression #1.
(define
  expr1
  '(/ (+ a 2) (- b))
)

; Print expression #1.
(display "Step 1. Create some code. Here it is:")
(newline)
(display "  ")
(display expr1)
(newline)
(newline)

; Make more code: expression #2, built from parts of expression #1.
(define
  expr2
  (list '* (cadr expr1) (caddr expr1))
  ; Above, cadr returns 2nd item of given list; caddr returns 3rd item.
)

; Print expression #2.
(display "Step 2. Construct new code from pieces of the above code:")
(newline)
(display "  ")
(display expr2)
(newline)
(newline)

; Define the variables used in our expressions.
(define a 100)
(define b 5)

; Print our variables.
(display "Step 3. Define the variables used in the constructed code:")
(newline)
(display "  a: ")
(display a)
(newline)
(display "  b: ")
(display b)
(newline)
(newline)

; Evaluate the expression #2.
(define
  result
  (eval expr2 ns)  ; "ns" is a namespace (you may ignore it for now)
)

; Print the result of evaluating expression #2, check correctness.
(display "Step 4. Evaluate the second piece of code.")
(newline)
(display "  Result: ")
(display result)
(newline)
(if
  (= result -510)
  (display "And that's correct! (100 + 2) * (-5) = ")
  (display "Alas & alack, that's wrong! (100 + 2) * (-5) != ")
)
(display result)
(newline)
(newline)

; Print closing message.
(display "You can look at the source code for this program to see that")
(newline)
(display "I am telling the truth; the second code snippit was indeed")
(newline)
(display "constructed, at runtime, from parts of the first snippet,")
(newline)
(display "and then executed.")
(newline)
(newline)
(display "This actually isn't the way runtime code transformations are")
(newline)
(display "typically done, but it does demonstrate that Scheme supports")
(newline)
(display "reflection very well. Manipulating code at runtime, and then")
(newline)
(display "executing the result, is straightforward.")
(newline)

