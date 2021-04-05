#lang scheme
; basic.scm
; Glenn G. Chappell
; 2021-04-05
;
; For CS F331 / CSCE A331 Spring 2021
; Code from 4/5 - Scheme: Basics


(display "This file contains sample code from April 5, 2021,")
(newline)
(display "for the topic \"Scheme: Basics\".")
(newline)
(display "It will execute, but it is not intended to do anything")
(newline)
(display "useful. See the source.")
(newline)


; ***** Quick Review / General *****


; Single-line comment begins with semicolon

#| Multiline
   comment |#

#;(comment out a (single
                  expression))

; Scheme code consist of expressions. Form a nontrivial expression using
; a list. The first item should evaluate to a procedure. The rest of the
; items are its arguments. Each item is evaluated; then the procedure is
; called with the arguments.

; Symbol + evaluates to a procedure that returns the sum of its
; arguments.

; Try:
;   (+ 5 3 4 8 1 2 6)

; Scheme has no infix operators.

; Try:
;   (/ 4 2)
;   (/ 4 6)      ; Result is an exact rational
;   (/ 2/3 4)
;   (+ 1/5 0.7)  ; Result is an (inexact) real = floating-point
; Implicit type conversions integer -> rational -> real -> complex

; "Mod" (% in C++) is "modulo".

; Try:
;   (modulo 19 7)

; Numeric equality: =
; There is no standard numeric inequality operator!
; Ordered comparison operators are as usual.
; Logical operations: and or not
; Try:
;   (= 1 2)
;   (not (= 1 2))
;   (and (> 4 1) (<= 5 2))

; Bind a symbol to a value: define

(define abc (+ 5 3))

; Try:
;   abc
;   (* abc (- abc 5))

(define xyz +)

; Try:
;   (xyz 3 4 5)

; To define a procedure, also use "define". The first argument is a
; picture of a call to the procedure. The second argument is an
; expression given the code for the procedure.

(define (sqr x)
  (* x x)
  )

; Try:
;   (sqr 6)

; The following (even?) is actually already defined, and does basically
; the same thing -- probably more efficiently.
(define (even? n)
  (= (modulo n 2) 0)
  )

(define (big? n)
  (> n 20)
  )

(define (!= a b)
  (not (= a b))
  )

; Try:
;   (even 3)
;   (!= 1 3)
;   (!= (+ 1 2) 3)

; if-then-else: (if COND THEN-EXPR ELSE-EXPR)

; Try:
;   (if (= 3 3) "yes" "NO")


; ***** Lists *****


; Get first item of a pair: car
; Get second item of a pair: cdr
; For nonempty lists, "car" returns first item, "cdr" returns list of
; remaining items.
; Leading single quote suppresses evaluation.
; Try:
;   (car '(5 4 2 7))
;   (cdr '(5 4 2 7))

; Construct a pair (like Haskell ":"): cons
; (cons 5 '(4 2 7))

; Combinations of car, cdr are predefined.
; Try:
;   (car (cdr '(5 4 2 7)))
;   (cadr '(5 4 2 7))
;   (car (cdr (cdr '(5 4 2 7))))
;   (caddr '(5 4 2 7))


; ***** Predicates *****


; A predicate is a function that returns a boolean. In Scheme, it is
; conventional to end the name of a predicate with "?".

; Type-checking predicates for null, pair, number: null? pair? number?
; Try:
;   (null? '())
;   (null? '(1 2 3))
;   (null? 2)
;   (pair? '())
;   (pair? '(1 2 3))
;   (pair? 2)
;   (number '())
;   (number? '(1 2 3))
;   (number? 2)


; ***** Write Some *****


; Make a recursive call by using the word being defined inside its body.

; list? is a predicate that determines whether its argument is a list.
; Use it with care, as it is linear-time.

; To crash with an error message, pass a string to "error".

; cond is the Scheme equivalent of Haskell's guards. It takes the place
; of an if ... else if ... else if ... else construction. Note the
; "else" as the last condition in the cond construction below.

; len
; Return the length of a list.
(define (len xs)
  (cond
    [(not (list? xs))  (error "len: arg is not a list")]
    [(null? xs)        0]
    [else              (+ 1 (len (cdr xs)))]
    )
  )

; Try:
;   (len '())
;   (len '(1 2 3 4 5))
;   (len 3)

; lookup
; Given integer and list, return the list item with that index. Uses
; zero-based indexing.
(define (lookup ix xs)
  (cond
    [(null? xs)        (error "lookup: index out of range")]
    [(< ix 0)          (error "lookup: index out of range")]
    [(not (pair? xs))  (error "lookup: arg #2 has bad type")]
    [(= ix 0)          (car xs)]
    [else              (lookup (- ix 1) (cdr xs))]
    )
  )

; "null": variable whose value is an empty list. Can be used like '().

; mymap
; Given a 1-parameter procedure and a list. Does a "map".
(define (mymap f xs)
  (cond
    [(not (list? xs))  (error "mymap: not given a list")]
    [(null? xs)        null]
    [else              (cons
                        (f (car xs))
                        (mymap f (cdr xs))
                        )]
    )
  )

; Try:
;   (mymap sqr '(2 33 -5 50 1 100))

; lambda creates an unnamed procedure. The first argument of lambda is
; like the first argument of define, without the name. The second
; argument is just like the second argument of define.

; Try:
;   ((lambda (x y) (* 10 x y)) 3 4)
;   (mymap (lambda (x) (* x x x)) '(2 33 -5 50 1 100))

; myfilter
; Given a 1-parameter predicate and a list. Does a "filter".
; No error checking, other than automatic type checking.
(define (myfilter p xs)
  (cond
    [(not (list? xs))  (error "myfilter: not given a list")]
    [(null? xs)        null]
    [else
     (let (
           [first  (car xs)]
           [rest   (myfilter p (cdr xs))]
           )
       (cond
         [(p first)  (cons first rest)]
         [else       rest]
         )
       )
     ]
    )
  )

; Try:
;   (myfilter even? '(2 33 -5 50 1 100))
;   (myfilter big? '(2 33 -5 50 1 100))
;   (myfilter (lambda (x) (< x 5)) '(2 33 -5 50 1 100))

