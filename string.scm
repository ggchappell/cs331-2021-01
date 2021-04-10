#lang scheme
; string.scm
; Glenn G. Chappell
; 2021-04-09
;
; For CS F331 / CSCE A331 Spring 2021
; Code from 4/9 - Scheme: Strings & I/O


(display "This file contains sample code from April 9, 2021,")
(newline)
(display "for the topic \"Scheme: Strings & I/O\".")
(newline)
(display "It will execute, but it is not intended to do anything")
(newline)
(display "useful. See the source.")
(newline)


; ***** Strings *****


; String literals use double quotes. Backslash escapes are recognized.
; Try:
;   "Hello there!"
;   "Hello there, \"Egbert\"!"

; Check for string: string?
; Try:
;   (string? "42")
;   (string? 42)

; Get length of string: string-length
; Try:
;   (string-length "Hello!")

; Concatenate strings: string-append
; Try:
;   (string-append "abc" "def" "ghi" "jklmnop")

; Get substring: (substring STRING START PAST_END)
; Try:
;   (substring "Howdy thar" 2 7)

; Convert number to string: number->string
; Try:
;   (number->string 42)

; Convert string to number: string->number
; Try:
;   (string->number "42")
;   (string->number "Howdy!")


; ***** Characters *****


; Character literals begin with #\
;   Try:
;   #\A
;   #\newline
;   #\space

; Check for character: char?
; Try:
;   (char? #\x)
;   (char? "x")
;   (char? 42)

; Get ASCII value/Unicode codepoint: char->integer
; Try:
;   (char->integer #\A)

; Reverse: integer->char
; Try:
;   (integer->char 65)

; Convert strings <-> lists of chars: string->list, list->string
; Try:
;   (string->list "Howdy thar"!)
;   (list->string '(#\a #\b #\c))


; ***** Comparisons *****


; Type-specific comparisons
; Try:
;   (string=? "abc" "abc")
;   (string=? "abc" "def")
;   (string=? 42 42)
;   (string<? "abc" "def")
;   (char=? #\A #\B)

; General comparisons: equal?
; Try:
;   (equal? "abc" "abc")
;   (equal? "abc" "def")
;   (equal? #\A #\A)
;   (equal? #\A "A")

; Watch out for numbers.
; Try:
;   (= 2 2.0)
;   (equal? 2 2.0)


; ***** Console Output *****


; Output to the console: define, newline
; Try:
;   (display "Hello")
;   (newline)

; Combine multiple expressions into one: begin
; Try:
;   (begin (display "abc") (display "def") (newline) (newline))

; hello-there
; Print some text to the console.
(define (hello-there)
  (begin
    (display "Hello there,")
    (newline)
    (display "everyone!")
    (newline)
    )
  )

; Try:
;   (hello-there)


; ***** Console Interaction *****


; Read a line from the console & return it: read-line
; Try:
;   (read-line)
;   (display (read-line))

; A way to make local variables: let
; Try:
;   (let
;       (
;        [msg1 "Hello!"]
;        [msg2 " there!"]
;        )
;     (display (string-append msg1 msg2 "\n"))
;     )

; echo-line
; Read a line and print it, with prompt, explanation.
(define (echo-line)
  (begin
    (display "Type something: ")
    (let (
          [line (read-line)]
          )
      (begin
        (display "Here is what you typed: ")
        (display line)
        (newline)
        )
      )
    )
  )

; Try:
;   (echo-line)

; We can give a "let" a name.
;   (let NAME ...
; Then, locally, NAME binds to a procedure, which calls the "let". The
; variables defined by the "let" are set as usual the first time
; through. When the "let" is called, they are set to the arguments of
; the procedure.

; running-total
; Repeatly read a number and print a running total. Exit on blank line.
; Uses named "let".
(define (running-total)
  (begin
    (display "Running Total Computation")
    (newline)
    (newline)
    (let loop
      ([total 0])
      (begin
        (display "Type a number (blank line to end): ")
        (let
            ([line (read-line)])
          (if (string=? line "")
              (void)
              (let
                  ([val (string->number line)])
                (if val
                    (begin
                      (display "Running total: ")
                      (display (+ total val))
                      (newline)
                      (newline)
                      (loop (+ total val))
                      )
                    (begin
                      (display "That is not a number! Try again.")
                      (newline)
                      (loop total)
                      )
                    )
                )
              )
          )
        )
      )
    )
  )

; Try:
;   (running-total)

