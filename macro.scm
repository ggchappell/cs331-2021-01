#lang scheme
; macro.scm
; Glenn G. Chappell
; Started: 2021-04-12
; Updated: 2021-04-14
;
; For CS F331 / CSCE A331 Spring 2021
; Code from 4/12 & 4/14 - Scheme: Macros


(display "This file contains sample code from April 12")
(newline)
(display "& April 14, 2021, for the topic \"Scheme: Macros\".")
(newline)
(display "It will execute, but it is not intended to do anything")
(newline)
(display "useful. See the source.")
(newline)


; ***** Single-Pattern Macros *****


; Create pattern-based macro with a single pattern using
; define-syntax-rule. USAGE:
;   (define-syntax-rule (PATTERN) TEMPLATE)

; myquote
; Just like quote.
(define-syntax-rule
  (myquote x)     ; pattern
  'x              ; template
  )

; Try:
;   (myquote (+ 1 2))

; quotetwo
; Takes two arguments and returns a list containing them unevaluated.
; Example:
;   (quotetwo (+ 1 2) (+ 2 3))
; gives
;   ((+ 1 2) (+ 2 3))
(define-syntax-rule
  (quotetwo x y)
  '(x y)
  )

; qlist
; Takes any number of arguments and returns a list containing them
; unevaluated.
; Example:
;   (qlist (+ 1 2) 7 (+ 2 3))
; gives
;   ((+ 1 2) 7 (+ 2 3))
(define-syntax-rule
  (qlist . args)  ; pattern
  'args           ; template
  )

; Try:
;   (qlist (+ 1 2) 7 (+ 2 3))

; deftwo
; Define two identifiers, setting values equal to given expressions.
(define-syntax-rule
  (deftwo v1 e1 v2 e2)
  (begin
    (define v1 e1)
    (define v2 e2)
    )
  )

; Try:
;   (deftwo a (+ 1 2) b (+ 2 3))
;   a
;   b

; for-loop1
; For loop with specified start & end values. proc is called with
; respective values.
(define-syntax-rule
  (for-loop1 (start end) proc)
  (let loop
    (
     [loop-counter start]
     )
    (begin
      (proc loop-counter)
      ; Keep going if loop-counter + 1 <= end
      (cond
        [(<= (+ loop-counter 1) end) (loop (+ loop-counter 1))]
        )
      )
    )
  )

; Try:
;   (for-loop1 (3 7) (lambda (i) (begin (display i) (newline))))

; for-loop2
; For loop with specified loop-counter variable, start & end values. Any
; number of expressions can be given. For each value of the loop-counter
; variable, each expression is evaluated.
(define-syntax-rule
  (for-loop2 (var start end) . body)
  (let loop
    (
     [loop-counter start]
     )
    (begin
      (let ([var loop-counter]) (begin . body))
      (cond
        [(<= (+ loop-counter 1) end) (loop (+ loop-counter 1))]
        )
      )
    )
  )

; Try:
;   (for-loop2 (i 3 (+ 2 5)) (display i) (newline))


; ***** Multiple-Pattern Macros *****


; define-syntax-rule is wrapper around define-syntax & syntax-rules. The
; latter can take multiple patterns beginning wtih the same identifier.

; Here is qlist, expanded version.

(define-syntax qlist2
  (syntax-rules ()
    [(qlist2 . args)
     'args
     ]
    )
  )

; Try:
;   (qlist2 (+ 1 2) 7 (+ 2 3))

; An example using multiple patterns.

; def12
; Define one or two identifiers.
(define-syntax def12
  (syntax-rules ()
    [(def12 v1 e1)
     (define v1 e1)
     ]
    [(def12 v1 e1 v2 e2)
     (begin (define v1 e1) (define v2 e2))
     ]
    )
  )

; Try:
;   (def12 x (+ 5 8))
;   x

; Try:
;   (def12 a (+ 1 2) b (+ 2 3))
;   a
;   b

; defbunch
; Define an arbitrary number of identifiers.
(define-syntax defbunch
  (syntax-rules ()
    [(def12)
     (void)
     ]
    [(defbunch v1 e1 . rest)
     (begin
       (define v1 e1)
       (defbunch . rest)
       )
     ]
    )
  )

; Try:
;   (defbunch a 1 b 2 c (+ 3 3))
;   c


; ***** Keywords in Macros *****


; The list after syntax-rules (which is always empty above) is the list
; of *keywords*. These are words that only match themselves in a
; pattern. The identifier being defined is always a keyword; the list
; allows others to be specified.

; for-each
; For-each loop with specified variable. For each value in the given
; list, in order, the variable is given that value, and the body is
; executed.
; Example usage:
;   (for-each (i in '(2 4 10)) (display i) (newline))

(define-syntax for-each
  (syntax-rules (in)  ; "in" is a keyword
    [(for-each (var in thelist) . body)
     (eval (append '(for-each-helper var) (list thelist) 'body))
     ]
    )
  )

; for-each-helper
; Helper macro for for-each
(define-syntax for-each-helper
  (syntax-rules ()
    [(for-each-helper var (first . rest) . body)
     (let
         ([var first])
       (begin
         (begin . body)
         (for-each-helper var rest . body)
         )
       )
     ]
    [(for-each-helper var () . body)
     (void)
     ]
    )
  )

; Note the use of pattern matching on the list of values in
; for-each-helper.

; Try:
;   (for-each (i in '(2 4 (* 2 5))) (display i) (newline))

; Raise a to the b power: (expt a b)

; Try:
;   (expt 2 3)

; qderiv
; Differentiate, with respect to the given variable, a given expression.
; Returns the code for the derivative, quoted.
; Example usage:
;   (qderiv x (* x (sin x)))
(define-syntax qderiv
  (syntax-rules (+ - * / sqrt log exp expt sin cos tan asin acos atan)
    [(qderiv var (+ a))
     (list '+ (qderiv var a))
     ]
    [(qderiv var (+ a b))
     (list '+ (qderiv var a) (qderiv var b))
     ]
    [(qderiv var (- a))
     (list '- (qderiv var a))
     ]
    [(qderiv var (- a b))
     (list '- (qderiv var a) (qderiv var b))
     ]
    [(qderiv var (* a b))
     (list '+ (list '* 'a (qderiv var b)) (list '* 'b (qderiv var a)))
     ]
    [(qderiv var (/ a))
     (list '- (list '/ (qderiv var a) (list '* 'a 'a)))
     ]
    [(qderiv var (/ a b))
     (list '/ (list '- (list '* 'b (qderiv var a))
                    (list '* 'a (qderiv var b)))
           (list '* 'b 'b))
     ]
    [(qderiv var (sqrt a))
     (list '/ (qderiv var a) (list '* 2 (list 'sqrt 'a)))
     ]
    [(qderiv var (log a))
     (list '/ (qderiv var a) 'a)
     ]
    [(qderiv var (exp a))
     (list '* (list 'exp 'a) (qderiv var a))
     ]
    [(qderiv var (expt a b))
     (list '+ (list '* '(* (expt a b) (log a)) (qderiv var b))
           (list '* '(* b (expt a (- b 1))) (qderiv var a)))
     ]
    [(qderiv var (sin a))
     (list '* (list 'cos 'a) (qderiv var a))
     ]
    [(qderiv var (cos a))
     (list '- (list '* (list 'sin 'a) (qderiv var a)))
     ]
    [(qderiv var (tan a))
     (list '/ (qderiv var a) (list '* (list 'cos 'a) (list 'cos 'a)))
     ]
    [(qderiv var (asin a))
     (list '/ (qderiv var a) (list 'sqrt (list '- 1 (list '* 'a 'a))))
     ]
    [(qderiv var (acos a))
     (list '- (list '/ (qderiv var a)
                    (list 'sqrt (list '- 1 (list '* 'a 'a)))))
     ]
    [(qderiv var (atan a))
     (list '/ (qderiv var a) (list '+ 1 (list '* 'a 'a)))
     ]
    [(qderiv var var2)
     (cond
       [(and (symbol? 'var2) (eq? 'var 'var2)) 1]
       [(number? 'var2) 0]
       [else (error "qderiv: cannot handle expression")]
       )
     ]
    )
  )

; Try:
;   (qderiv x (* x x))
;   (qderiv x (expt x 3))
;   (qderiv x (expt 2 x))
;   (qderiv x (* (sin x) (cos x)))


; deriv
; Differentiate, with respect to the given variable, a given expression.
; Returns the code for the derivative, unquoted.
; Example usage:
;   (define (g x) (deriv x (* x (sin x))))
(define-syntax deriv
  (syntax-rules (+ - * / sqrt log exp expt sin cos tan asin acos atan)
    [(deriv var (+ a))
     (+ (deriv var a))
     ]
    [(deriv var (+ a b))
     (+ (deriv var a) (deriv var b))
     ]
    [(deriv var (- a))
     (- (deriv var a))
     ]
    [(deriv var (- a b))
     (- (deriv var a) (deriv var b))
     ]
    [(deriv var (* a b))
     (+ (* a (deriv var b)) (* b (deriv var a)))
     ]
    [(deriv var (/ a))
     (- (/ (deriv var a) (* a a)))
     ]
    [(deriv var (/ a b))
     (/ (- (* b (deriv var a))
           (* a (deriv var b)))
        (* b b))
     ]
    [(deriv var (sqrt a))
     (/ (deriv var a) (* 2 (sqrt a)))
     ]
    [(deriv var (log a))
     (/ (deriv var a) a)
     ]
    [(deriv var (exp a))
     (* (exp a) (deriv var a))
     ]
    [(deriv var (expt a b))
     (+ (* (* (expt a b) (log a)) (deriv var b))
        (* (* b (expt a (- b 1))) (deriv var a)))
     ]
    [(deriv var (sin a))
     (* (cos a) (deriv var a))
     ]
    [(deriv var (cos a))
     (- (* (sin a) (deriv var a)))
     ]
    [(deriv var (tan a))
     (/ (deriv var a) (* (cos a) (cos a)))
     ]
    [(deriv var (asin a))
     (/ (deriv var a) (sqrt (- 1 (* a a))))
     ]
    [(deriv var (acos a))
     (- (/ (deriv var a) (sqrt (- 1 (* a a)))))
     ]
    [(deriv var (atan a))
     (/ (deriv var a) (+ 1 (* a a)))
     ]
    [(deriv var var2)
     (cond
       [(and (symbol? 'var2) (eq? 'var 'var2)) 1]
       [(number? 'var2) 0]
       [else (error "deriv: cannot handle expression")]
       )
     ]
    )
  )

; Try:
;   (define (g x) (deriv x (* x x)))
;   (g 5)

