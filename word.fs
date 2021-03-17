\ word.fs
\ Glenn G. Chappell
\ 2021-03-17
\
\ For CS F331 / CSCE A331 Spring 2021
\ Code from 3/17 - Forth: Words


cr cr
." This file contains sample code from March 17, 2021," cr
." for the topic 'Forth: Words'." cr
." It will execute, but it is not intended to do anything" cr
." useful. See the source." cr
cr


\ ***** Quick Review *****


\ Backslash begins single-line comment
( Multiline
  comment
  in parentheses )

\ Words are case-insentitive: dup is the same as DUP

\ A number (as a word) pushes that number (as a value) on the stack.
\ .s shows the stack, top on the right.
\ clearstack clears the stack.

\ Try:
\   10 .s
\   1 2 3 .s
\   clearstack .s

\ . pops an integer off the stack and prints it, followed by a blank.

\ Try:
\   42 .
\   2 .s . .s
\   1 2 3 . . .

\ Popping with an empty stack is an error.

\ Try:
\   clearstack .

\ Stack-effect notation: ( STACK-BEFORE -- STACK-AFTER )
\ Examples:
\   3  ( -- 3 )
\   .  ( k -- )
\   +  ( a b -- a+b )

\ Standard stack-manipulation words:
\   drop  ( a -- )
\   dup   ( a -- a a )
\   swap  ( a b -- b a )
\   rot   ( a b c -- b c a )
\   -rot  ( a b c -- c a b )
\   nip   ( a b -- b )
\   tuck  ( a b -- b a b )
\   over  ( a b -- a b a )

\ Note that there is no general principle behind rot & -rot -- these are
\ just two different words. They happen to be defined to have an
\ opposite effect.

\ Try:
\   1 2 3 drop .s
\   4 5 6 dup .s
\   7 8 9 swap .s
\ Etc.

\ Stack-manipulation words for dealing with pairs:
\   2drop  ( a1 a2 -- )
\   2dup   ( a1 a2 -- a1 a2  a1 a2 )
\   2swap  ( a1 a2  b1 b2 -- b1 b2  a1 a2 )
\   2rot   ( a1 a2  b1 b2  c1 c2 -- b1 b2  c1 c2  a1 a2 )
\   2nip   ( a1 a2  b1 b2 -- b1 b2 )
\   2tuck  ( a1 a2  b1 b2 -- b1 b2  a1 a2  b1 b2 )
\   2over  ( a1 a2  b1 b2 -- a1 a2  b1 b2  a1 a2 )

\ There is also no general principle behind drop vs. 2drop, etc. These
\ are just two different words whose effects happen to be related.

\ Try:
\   clearstack 1 2 3 4 2drop .s
\ Etc.

\ Arithmetic operators ( +, -, *, / ) pop two stack items, operate on
\ them, and push the result.

\ Try:
\   1 2 + .
\   3 5 + 9 2 - * 2 * .  \ (3+5)*(9-2)*2 = 112

\ Forth needs no parentheses!

\ Define a word using
\   : WORD DEFINITION... ;
\ Stack-effect notation is a common comment.

\ dubl (version 1)
\ Multiplies by 2
: dubl  ( x -- 2x )
  2 *
;

\ Try:
\   5 dubl .

\ We can redefine words. Interactive calls use the latest version.

: w 2 ;
: w 3 ;

\ Try:
\   w .

\ Make named parameters using stack-effect notation, but changing the
\ parentheses ( ... ) to braces { ... }.

: myswap  { a b -- b a }
  b a
;

\ Try:
\   5 7 myswap .s

\ A standard way to represent a string is with two ints. The first is a
\ pointer to the start of the string. The second is the number of
\ characters in it.

\ Create such a string with "s followed by a single blank, then the
\ string and a final double quote
\  "s ..."  ( addr len -- )

\ Try:
\   s" Hello!" .s

\ To print a string:
\   type  ( add len -- )

\ Try:
\   s" Hello!" type

\ To print a newline:
\   cr  ( -- )

\ Try:
\   cr cr cr cr
\   cr s"   Hello!" type cr

: hello-world  ( -- )
  cr cr
  s" Hello, world!"
  type
  cr cr
;

\ Try:
\   hello-world

\ Combine s" and type with ."

\ Try:
\   ." Hello!"

\ Selection:
\   COND if ... else ... endif

: collatz-step  { n -- number_after_n_in_Collatz_sequence }
  n 2 mod 0 = if  \ Is n even?
    n 2 /
  else
    n 3 * 1 +
  endif
;

\ Try:
\   16 collatz-step .
\   21 collatz-step .

\ General Iteration:
\   begin ... COND while ... repeat

\ Note. To do anything useful with the above loop, we need either
\ modifiable variables or input. So an example will have to wait until
\ later in this file.


\ ***** More Flow of Control *****


\ Flow-of-control words are only legal inside a compiled word
\ definition.

\ Try:
\   1 if ." abc" endif

\ Counted loop: PAST_END START ?do ... loop
\ Much like C++: for (int i = START; i < PAST_END; ++i)

\ In a counted loop, get the loop counter with "i".

\ print1to10
\ Print the numbers 1 through 10 on a single line, blank-separated.
: print1to10  ( -- )
  cr
  10 0 ?do
    i 1 + .
  loop
  cr
;

\ Try:
\   print1to10

\ ***** Logical & Bitwise Operations *****


\ Boolean operations are bitwise: and, or, invert.

\ Try:
\   -1 -1 and .
\   -1 0 and .
\   0 -1 and .
\   6 3 and .
\   0 -1 or .
\   6 3 or .
\   0 invert .
\   3 invert .

\ Can use 0= as logical NOT.

\ Try:
\   0 0= .
\   -1 0= .
\   3 0= .


\ ***** Local Variables *****


\ The named-parameter variation on stack-effect notation can be used
\ without the "--". Use it at any point in compiled code, to create a
\ local variable.

\ Change the value of a local variable with "to".

\ print-howdy
\ Prints "Howdy!" a given number of times, each on a separate line.
: print-howdy  { n -- }
  0 { counter }
  cr
  begin
    counter n < while
    ." Howdy!" cr
    n 1 - to n
  repeat
;

\ Try:
\   5 print-howdy


\ ***** The Dictionary and Calling *****


\ The *dictionary*: internal Forth data structure holding all defined
\ words, in the order they were defined.

\ Calling a word interactively: does backward search through dictionary
\ to find the most recent definition.

\ Calling a word in compiled code: does the same search at compile time,
\ placing a reference to the definition found into the compiled code.

: f 5 ;
: g f 2 * ;
: f 88 ;

\ Try:
\   f .
\   g .

\ See the definition of a word with "see".

\ Try:
\   see hello-world
\   see collatz-step

\ Recurse with "recurse".

\ fact
\ Compute the factorial of the given number by the usual recursive
\ method, and return this. The given number must be nonnegative.
: fact  { n -- n! }
  n 0 = if
    1
  else
    n 1 - recurse { prevfact }
    n prevfact *
  endif
;

\ Try:
\   7 fact .   \ Should be 5040
\   0 fact .   \ Should be 1

