#lang scheme
; data.scm
; Glenn G. Chappell
; 2021-04-07
;
; For CS F331 / CSCE A331 Spring 2021
; Code from 4/7 - Scheme: Data


(display "This file contains sample code from April 7, 2021,")
(newline)
(display "for the topic \"Scheme: Data\".")
(newline)
(display "It will execute, but it is not intended to do anything")
(newline)
(display "useful. See the source.")
(newline)


; ***** Evaluation *****


; Suppress evaluation: quote
; Try:
;   (+ 5 3)
;   (quote (+ 5 3))

; Leading single quote (') is syntactic sugar for a list beginning with
; quote.
; Try:
;   '(+ 5 3)
;   (quote (quote (a b c)))

; Evaluate arguments: eval
; Try:
;   (list "hello" '+ 1 2 3)
;   (eval (cdr (list "hello" '+ 1 2 3)))

; Call a procedure with given arguments: apply
; Try:
;   (apply + '(1 2 3))


; ***** Closures *****


; makemult
; Given a number k, returns a function that multiplies by k.
(define (makemult k)
  (if (number? k)
      (lambda (x) (* x k))
      (error "makemult: arg is not a number")
      )
  )

; Try:
;   (define f (makemult 2))
;   (define g (makemult 10))
;    (f 7)
;    (g 7)


; ***** Data Format *****


; Dot notation creates a pair literal.
; Try:
;   '(1 . 2)

; List notation is shorthand.
; Try:
;   '(1 . (2 . (3 . (4 . ()))))

; car & cdr are really about pairs, not lists.
; Try:
;   (car '(1 . 2))
;   (cdr '(1 . 2))

; Dot may be used before the last item in a list-like construction.
; Try:
;   '(1 2 3 4 5 . 6)
;   '(1 . (2 . (3 . (4 . (5 . 6)))))


; ***** Varying Number of Parameters *****


; add
; Just like +.
(define (add . args)
  (if (null? args)
      0
      (+ (car args) (apply add (cdr args)))
      )
  )

; Try:
;   (add 3 6)
;   (add 1 2 3 4 5 6)
;   (add 42)
;   (add)


; ***** Manipulating Trees *****


; atomsum
; Return the sum of all the atoms in a tree. All atoms must be numbers.
(define (atomsum t)
  (cond
    [(null? t)   0]
    [(pair? t)   (+ (atomsum (car t)) (atomsum (cdr t)))]
    [(number? t) t]
    [else        (error "atomsum: atom is not a number")]
    )
  )

; Try:
;   (atomsum '(1 (3 (5) ((7 9))) 11 (((13))) () (15)))
;   (atomsum '(20 "abc"))

; atommap
; Given a one-parameter procedure and a tree, return the tree with each
; atom replaced by (f atom).
(define (atommap f t)
  (cond
    [(null? t)   null]
    [(pair? t)   (cons (atommap f (car t)) (atommap f (cdr t)))]
    [else        (f t)]  ; May cause an error - we do not know
    )
  )

; Try:
;   (atommap sqr '(1 (2 (3) ((4))) () (5)))


; ***** Lazy Evaluation *****


; We create lazy lists as follows: construct a list as usual, from pairs
; and null, but wherever there is a pair, its two elements are promises
; wrapping the first item in the list and the lazy list of the rest of
; the items. Note that, unlike ordinary Scheme lists, a lazy list may be
; infinite.

; countfrom
; Given a number, return an infinite lazy list (see above) with items
; k, k+1, k+2, etc.
(define (countfrom k)
  (cons (delay k) (delay (countfrom (+ 1 k))))
  )

; posints
; Infinite lazy list (see above) with items 1, 2, 3, etc.
(define posints (countfrom 1))

; ff
; Given two numbers a, b, return an infinite lazy list (see above) whose
; first two items are a, b, and each subsequent item is the sum of the
; previous two: a, b, a+b, a+2b, 2a+3b, etc.
(define (ff a b)
  (cons (delay a) (delay (ff b (+ a b))))
  )

; fibos, lucas
; Infinite lazy lists (see above) of all Fibonacci numbers and all Lucas
; numbers, respectively.
(define fibos (ff 0 1))
(define lucas (ff 2 1))

; take
; Given a number "count" and a list or lazy list (see above). Returns a
; regular (non-lazy) list of the first count items.
(define (take count lxs)
  (cond
    [(<= count 0)    null]
    [(null? lxs)     null]
    [(pair? lxs)     (cons (force (car lxs))
                           (take (- count 1) (force (cdr lxs)))
                           )
                     ]
    [else            (error "printit: 2nd arg has bad type")]
    )
  )

; Try:
;   (take 5 '(1 2 3 4 5 6 7 8 9))
;   (take 100 posints)
;   (take 20 fibos)
;   (take 20 lucas)

