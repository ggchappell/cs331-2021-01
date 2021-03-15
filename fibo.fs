\ fibo.fs
\ Glenn G. Chappell
\ 2021-03-15
\
\ For CS F331 / CSCE A331 Spring 2021
\ Compute Fibonacci Numbers


\ The Fibonacci number F[n], for n >= 0, is defined by F[0] = 0,
\ F[1] = 1, and for n >= 2, F[n] = F[n-2] + F[n-1].


\ fibo
\ Given n >= 0, return Fibonacci number F[n].
\ Gives correct results:
\ - On 32-bit systems, for n = 0 .. 46
\ - On 64-bit systems, for n = 0 .. 92
: fibo  { n -- F[n] }
  0 { currfib }
  1 { nextfib }

  \ Advance currfib, nextfib as many times as needed
  n 0 ?do   \ Counted loop: n times
    nextfib currfib nextfib + to nextfib to currfib
  loop

  \ Return currfib
  currfib
;


\ printfibos
\ Print i & Fibonacci number i in a nice format, for i = 0..k-1, each on
\ a separate line.
: printfibos  { k -- }
  k 0 ?do     \ Counted loop: k times
    ." F("
    i 1 .r    \ Output loop counter with no trailing blank
    ." ) = "
    i fibo .
    cr
  loop
;


\ Main program
\ Print the first few Fibonacci numbers.
20 constant how_many_to_print
cr
." Fibonacci Numbers"
cr
how_many_to_print printfibos
cr

