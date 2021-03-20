\ alloc.fs
\ Glenn G. Chappell
\ 2021-03-19
\
\ For CS F331 / CSCE A331 Spring 2021
\ Code from 3/19 - Forth: Variables & Allocation


cr cr
." This file contains sample code from March 19, 2021," cr
." for the topic 'Forth: Variables & Allocation'." cr
." It will execute, but it is not intended to do anything" cr
." useful. See the source." cr
cr


\ ***** Dynamic Allocation: Simple Variables *****


\ To allocate space for an int and create a word that pushes a pointer
\ to it:
\   variable ID

variable p

\ The above is more or less equivalent to the following C++:
\   int * p = new int;

\ Try:
\   variable p
\   p .
\ Remember that p pushes a pointer.

\ To get the value stored at an address - fetch:
\   @  ( addr -- value )

\ To change the value stored at an address - store:
\   !  ( value addr -- )

\ Try:
\   23 34 + p !

\ The above is more or less equivalent to the following C++:
\  (*p) = 23 + 34;

\ Try:
\   p @ .

\ The above is more or less equivalent to the following C++:
\  cout << (*p) << " ";

\ Below is a fast fibo with variables.


variable a
variable b
: advance2  ( a b -- b a+b )
  b ! a !  \ Store parameters in memory pointed to by a, b
  b @
  a @ b @ +
;

variable n
: fibofast2  ( n -- F[n] )
  n !  \ Store parameter in memory pointed to by n
  0 1
  n @ 0 ?do
    advance2
  loop
  drop
;

\ Try:
\   30 fibofast2 .


\ ***** Dynamic Allocation: Arrays *****


\ Allocate a block of memory:
\   allocate  ( len -- addr fail? )
\ Above, "fail? is an error code. It will be zero if the memory was
\ successfully allocated. The name "fail?" uses the convention that a
\ boolean value has a name ending with a question mark. This is common
\ in PLs that allow it.

\ We can treat a block of memory as an array of integers. In Forth, an
\ integer takes up either 4 or 8 bytes, depending on whether the 32-bit
\ or 64-bit version is used. (I will assume an integer is 8 bytes. On
\ 32-bit Forth, this will produce code that works, but wastes space.)

\ IMPORTANT: len is number of BYTES, not number of integers!

\ To free memory allocated with "allocate", use "free":
\   free ( addr -- fail? )
\ The parameter above should be the address of a block allocated with
\ "allocate".

\ intsize
\ Assumed size of integer (bytes)
: intsize 8 ;


variable arr                \ Will hold pointer to array
intsize 10 * allocate drop  \ No error check; I'm a bad, bad person. :-(
arr !                       \ Now arr holds a pointer to an array of ten
                            \  integers

\ We can access individual array items using set & fetch.

\ arr@ - fetch from above array
: arr@  { index -- value }
  arr @             \ Address of array
  index intsize *   \ Byte index of desired item
  +                 \ Stack: address-of-item
  @
;

\ arr! - store in above array
: arr!  { value index -- }
  arr @             \ Address of array
  index intsize *   \ Byte index of desired item
  +                 \ Stack: address-of-item
  value swap        \ Stack: value address-of-item
  !
;

\ Try:
\   25 5 arr!
\   36 6 arr!
\   5 arr@ .
\   6 arr@ .


\ Note: the s" syntax is for constant strings. Do not use it to allocate
\ memory whose contents you wish to modify.

\ Free the memory allocated above:
arr @ free drop    \ Ignore possible errors


\ ***** Characters & Input *****


\ Forth stores a character as a number holding the ASCII code.
\ A character literal is enclosed in single quotes: 'A'

\ Try:
\   'A' .

\ To print a character, use emit:
\   emit ( char -- )

\ Try:
\   'A' emit

\ To print a new line, use cr:
\   cr ( -- )

\ Try:
\   cr cr cr cr cr

\ To fetch/store a single byte (think: character) use c@ and c! -- these
\ otherwise work just like @ and !. We can then treat a block of memory
\ as a character array. Note that, while a character is a number, just
\ like an integer, a character in an array takes up just one byte.

\ Here is a word to print a string backward.

\ backtype - given a string (addr, len) print it backward.
: backtype  { addr len -- }
  begin
    len 0 > while
    len 1 - to len
    addr len + c@ emit
  repeat
;

\ Try:
\   cr s" Hello there!" backtype cr

\ To input a line of text, use "accept". This takes the address and
\ length of a buffer. The length here will be the maximum length of the
\ string that is input. It returns the length of the input: the actual
\ number of characters read. The ending newline is not included.
\   accept  ( addr max-len -- len )

\ The buffer for "accept" should be allocated using "allocate". Do not
\ use the s" ..." syntax for this!

\ Here is a word that inputs a line and prints it forward and backward.

: printrev  ( -- )
  100 { buf-size }                            \ Size of our buffer
  buf-size allocate { buf-addr alloc-fail? }  \ Allocate buffer
  alloc-fail? if
    cr cr
    ." ERROR: could not allocate buffer"      \ Error checking!
    cr cr
  else
    cr cr
    ." Type something: "                      \ Prompt
    buf-addr buf-size accept { inputlen }     \ Input a line
    cr cr
    ." Here is what you typed:  "
    buf-addr inputlen type                    \ Print the line
    cr cr
    ." And here it is backward: "
    buf-addr inputlen backtype                \ Print the line backward
    cr cr
    buf-addr free { free-fail? }
  endif
;

\ Note the style used in the above code. At the beginning of each line,
\ the stack is empty. To perform an operation, we push any necessary
\ values and call a word. If the word returns a value that we will need
\ later, then we save this value in a named local variable, using the
\ { ... } syntax.

\ Try:
\   printrev


\ ***** Examples *****


\ Here are words that allocate integer arrays, set and print their
\ items, and sort them, using Merge Sort.

\ sizeb is always a size in bytes, while sizei is always a size in
\ integers, which are assumed to be intsize bytes long.

\ Errors are indicated by throwing exceptions:
\   - exception 1: allocation failure
\   - exception 2: invalid parameters


\ alloc-array
\ Allocates an array holding the given number of integers. Throws
\ exception 1 on allocation fail.
: alloc-array  { sizei -- addr }
  sizei intsize * allocate { addr fail? }
  fail? if
    1 throw \ Throw exception 1 on allocation fail
  endif
  addr      \ Return our array
;


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


\ Try:
\   20 alloc-array
\   dup 10 3 rot 20 set-array
\   cr 20 print-array


\ copy
\ Utility memory-copy word. Like C++ std::copy. Copies memory starting
\ at first1, with last1 pointing to just past end. Copies to memory
\ starting at first2, which must point to sufficient allocated memory.
\ The two ranges must not overlap.
: copy  { first1 last1 first2 -- }
  first1 { in }
  first2 { out }
  begin
    in last1 < while
    in @ out !
    in intsize + to in
    out intsize + to out
  repeat
;


\ stable-merge
\ Stable merge of two sorted ranges of integers. First range in
\ [first, middle), second range in [middle, last). On return,
\ [first, last) is sorted. Throws exception 1 on allocation fail.
: stable-merge  { first middle last -- }
  first { in1 }
  middle { in2 }
  last first - { sizeb }
  sizeb allocate { buffer alloc-fail? }
  alloc-fail? if
    1 throw  \ Throw exception 1 on allocation fail
  endif
  buffer { out }
  begin
    in1 middle < in2 last < and while
    in2 @ in1 @ < if
      in2 @ out !
      in2 intsize + to in2
    else
      in1 @ out !
      in1 intsize + to in1
    endif
    out intsize + to out
  repeat

  in1 middle out copy  \ Copy remainder of values to buffer
  in2 last out copy    \  (one of these two lines does nothing)

  buffer buffer sizeb + first copy
                       \ Copy buffer back to original memory
;


\ merge-sort-recurse
\ Workhorse function for Merge Sort. Sorted range of integers in
\ [first, last). Throws exception 1 on allocation fail.
: merge-sort-recurse  { first last -- }
  last first - intsize / { sizei }
  sizei 1 > if  \ Base case (nothing to do) if sizei <= 1
    sizei 2 / intsize * first + { middle }
                                    \ Get ptr to middle of range
    first middle recurse            \ Sort 1st half
    middle last recurse             \ Sort 2nd half
    first middle last stable-merge  \ Merge the halves
  endif
;


\ merge-sort
\ Sorts array of integers starting at addr, holding sizei items.
\ Throws exception 1 on allocation fail. Throws exception 2 on bad array
\ size.
: merge-sort  { addr sizei -- }
  sizei 0 < if
    2 throw  \ Throw exception 2 on negative array size
  endif
  sizei intsize * addr + { last }
  addr last merge-sort-recurse
;


\ user-pause
\ Wait for ENTER.
: user-pause  ( -- )
  10 { buffsizeb }
  buffsizeb allocate { buff alloc-fail? }
  alloc-fail? if
    1 throw  \ Throw exception 1 on allocation fail
  endif
  buff buffsizeb accept { len }
  ;


\ try-merge-sort
\ Try out word merge-sort. Prints initial array, sorts, waits for user,
\ prints sorted array.
: try-merge-sort  { sizei -- }
  cr cr ." Array size: " sizei . cr
  sizei alloc-array { arr }
  sizei 2 / -2 arr sizei 2 / set-array
  sizei 2 / 1 + -2 arr sizei 2 / intsize * + sizei sizei 2 / - set-array
  cr ." Values before sort:" cr
  arr sizei print-array
  cr ." Press ENTER to continue " user-pause cr
  cr ." Sorting (Merge Sort) ... "
  stdout flush-file { flush-fail? }  \ Flush standard output
  arr sizei merge-sort
  ." DONE" cr
  cr ." Values after sort:" cr
  arr sizei print-array
  arr free { free-fail? }
;

\ Try:
\   20 try-merge-sort
\   2000000 try-merge-sort

