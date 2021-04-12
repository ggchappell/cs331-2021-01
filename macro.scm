#lang scheme
; macro.scm  UNFINISHED
; Glenn G. Chappell
; 2021-04-12
;
; For CS F331 / CSCE A331 Spring 2021
; Code from 4/12 - Scheme: Macros


(display "This file contains sample code from April 12, 2021,")
(newline)
(display "for the topic \"Scheme: Macros\".")
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

