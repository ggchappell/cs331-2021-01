\ adv.fs  UNFINISHED
\ Glenn G. Chappell
\ 2021-03-22
\
\ For CS F331 / CSCE A331 Spring 2021
\ Code from 3/22 - Forth: Advanced Flow


cr cr
." This file contains sample code from March 22, 2021," cr
." for the topic 'Forth: Advanced Flow'." cr
." It will execute, but it is not intended to do anything" cr
." useful. See the source." cr
cr


\ hello
\ Simple example word. Prints newline, a greeting, and another newline.
: hello  ( -- )
  cr
  ." Hello there!" cr
;


\ print-hello-xt
\ Prints execution token for word "hello".
: print-hello-xt  ( -- )
  cr
  ['] hello . cr
;


\ apply-to-5-7
\ Takes an execution token, which is popped. Executes the corresponding
\ code with 5 7 on the data stack. The "in1 ... inm" in the stack effect
\ below represent any other parameters the code to be executed might
\ have. The "out1 ... outn" are its results.
: apply-to-5-7  ( in1 ... inm xt -- out1 ... outn )
  { xt }
  5 7 xt execute
;


\ intsize
\ Assumed size of integer (bytes)
: intsize 8 ;


\ print-array
\ Prints items in given integer array, all on one line, blank-separated,
\ ending with newline.
: print-array  { addr sizei -- }
  sizei 0 ?do
      i intsize * addr + @ .
  loop
  cr
;


\ set-array
\ Sets values in given array. Array starts at addr and holds sizei
\ integers. Item 0 is set to start, item 1 to start+step, item 2 to
\ start+2*step, etc.
: set-array  { start step addr sizei -- }
  start { val }
  sizei 0 ?do
    val i intsize * addr + !
    val step + to val
  loop
;


\ map-array
\ Given an integer array, represented as pointer + number of items, and
\ an execution token for code whose effect is of the form ( a -- b ).
\ Does an in-place map, using the execution token as a function. That
\ is, for each item in the array, passes the item to this function,
\ replacing the array item with the result. Throws on bad array size.
: map-array { arr sizei xt -- }
  \ TO DO: WRITE THIS!!!
;


\ square
\ Returns the square of its parameter. Example for use with map-array.
: square  { x -- x**2 }
  x x *
;

\ call-map
\ Creates an integer array holding the given number of items, filling it
\ with data, and calls map-array, passing "square", on this array. The
\ array items are printed before and after the map. Throws on failed
\ allocate/deallocate.
: call-map  { sizei -- }
  sizei intsize * allocate throw { arr }
                           \ Throw on failed allocate (see NOTE above)
  1 1 arr sizei set-array  \ Fill array: 1, 2, 3, ...
  cr
  ." Doing map-array with square" cr
  ." Values before map: " arr sizei print-array
  arr sizei ['] square map-array
  ." Values after map: " arr sizei print-array
  arr free throw           \ Throw on failed deallocate (see NOTE above)
;


\ mysqrt
\ Given an integer, returns the floor of its square root. Throws on a
\ negative parameter.
: mysqrt  { x -- sqrt(x) }
  x 0 < if
    s" mysqrt: parameter is negative" exception throw
  endif
  0 { i }
  begin
    i i * x <= while
    i 1 + to i
  repeat
  i 1 -
;


\ call-mysqrt
\ Pass the given value to "mysqrt", catching any exception thrown and
\ printing the results (exception or not).
: call-mysqrt  { x -- }
  cr
  ." Passing " x . ." to mysqrt" cr
  x ['] mysqrt catch { exception-code }
  exception-code if
    \ An exception was thrown
    { dummy1 }  \ This line bascially functions as a "drop". "dummy1"
                \  corresponds to x, which was on the stack before
                \  "catch" (remember that, if an exception is thrown,
                \  then the stack depth after "catch" is the same as it
                \  was before "catch").
    ." Exception thrown; code: " exception-code . cr
    nothrow     \ Reset error handling (does not affect the stack)
                \ Do this if we do NOT re-throw
  else
    \ No exception was thrown
    { result }
    ." No exception thrown" cr
    ." Result: " result . cr
  endif
;


\ call-mysqrt2
\ Pass the given value to mysqrt inside try/restore/endtry. If an
\ exception is thrown, re-throw it after the ENDTRY. Print various
\ messages to indicate what is happening.
: call-mysqrt2  { x -- }
  cr
  try
    ." Passing " x . ." to mysqrt" cr
    x mysqrt { result }  \ If exception, push code and skip to RESTORE
    ." Code just after call to mysqrt" cr
    0         \ So we have something to test in the RESTORE section
    \ Continue to RESTORE
  restore
    { exception-code }
    ." In RESTORE section" cr
    exception-code if
      ." Exception thrown; cleaning up" cr
    else
      ." No exception thrown; not cleaning up?" cr
    endif
    \ An exception thrown here (e.g., user presses ctrl-C) restarts the
    \ RESTORE section. If code here always throws, then infinite loop!
  endtry
  exception-code throw  \ Re-throw same exception (so no "nothrow")
  ." Result: " result . cr
;

