#lang scheme
; check_scheme.scm
; Glenn G. Chappell
; 2021-03-16
;
; For CS F331 / CSCE A331 Spring 2021
; A Scheme Program to Run
; Used in Assignment 5, Exercise A


; Useful Functions

(define (a x y)
  (if (null? x)
      y
      (cons (car x) (a (cdr x) y)))
  )

(define (aa . xs)
  (if (null? xs)
      '()
      (a (car xs) (apply aa (cdr xs)))
      )
  )

(define (m d ns)
  (if (null? ns)
      '()
      (let ([n (+ d (car ns))])
        (cons (integer->char n) (m n (cdr ns))))
      )
  )

(define (mm ns) (list->string (m 0 ns)))


; Data

(define cds1 '(89 22 6 -85 36 5 -5 -36))
(define cds2 '(68 14 -9 5 -3 -75 89 -10))
(define cds3 '(6 -3 -82 47 39 -21 11 8))
(define cds4 '(-11 5 -9 -57 -12 68 5 -5))
(define cds5 '(10 -71 77 -84 89 -10 6 -54))


; Output

(display "Secret message #4:\n\n")
(display (mm (aa cds1 cds2 cds3 cds4 cds5)))
(newline)
(newline)

