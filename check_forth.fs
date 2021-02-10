\ check_forth.fs
\ Glenn G. Chappell
\ 2021-02-09
\
\ For CS F331 / CSCE A331 Spring 2021
\ A Forth Program to Run
\ Used in Assignment 3, Exercise 1


999 constant end-mark  \ End marker for pushed data


\ push-data
\ Push our data, end-mark first.
: push-data ( -- end-mark <lots of numbers> )
  end-mark
  88 -2 14 -85 76 dup 60 - -7 18
  -83 73 1 -62 76 dup 60 - 2 dup 2/
  -37 dup 3 + 73 7 16 -80 93 -20
  -16 dup 4 * 1 +
;


\ do-stuff
\ Given a number, do ... whatever operations we are supposed to do.
\ (Pretty mysterious, eh?)
: do-stuff ( end-mark <lots of numbers> -- )
  10 { n }
  begin
    dup end-mark <> while
    n swap - 1
    dup + dup + swap + dup emit to n
  repeat
  drop
;


\ Now do it all: print the secret message
cr
." Secret message #3:" cr cr
push-data do-stuff cr
cr

