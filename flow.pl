% flow.pl
% Glenn G. Chappell
% 2021-04-23
%
% For CS F331 / CSCE A331 Spring 2021
% Code from 4/23 - Prolog: Flow of Control


% ***** Preliminaries *****


% Output atom (think: string): write(ATOM)
% Output newline: nl
% Both always succeed.

% hello_world/0
% Print hello-world message.
hello_world :- write('Hello, world!'), nl.

% Try:
%   ?- hello_world.

% read/1 reads a Prolog term (which must end with a period!) from the
% standard input and unifies it with the argument. Output from write/1
% that is done before read/1 may not appear unless the standard output
% is flushed. This can be done with flush/0.

% Try:
%   ?- write('Type a number followed by dot: '), flush, read(X).

% true/0 - always succeeds
% fail/0 - never succeeds

% Try:
%   ?- true.
%   ?- fail.


% ***** Basic Repetition *****


% print_squares/2
% print_squares(A, B) prints a message indicating the squares of
% integers A, A+1, ... up to B, each on a separate line.
print_squares(A, B) :- A =< B, S is A*A,
                       write(A), write(' squared is '), write(S), nl,
                       A1 is A+1, print_squares(A1, B).

% Try:
%   ?- print_squares(2, 8).


% ***** Encapsulated Flow *****


% We can also encapsulate the recursion in a predicate.

% myfor/3
% If X is bound, succeed if A <= X <= B.
% If X is free, succeed with X = N for each N with A <= B <= B.
myfor(A, B, X) :- A =< B, X = A.
myfor(A, B, X) :- A =< B, A1 is A+1, myfor(A1, B, X).

% So "myfor" starts a loop. How do we end it?
% One answer: fail.
% "fail" never succeeds; so it always backtracks.

% Try:
%   ?- myfor(1, 5, 3).
%   ?- myfor(1, 5, 7).
%   ?- myfor(1, 5, X).
%   ?- myfor(1, 5, X), write(X), nl.
%   ?- myfor(1, 5, X), write(X), nl, fail.

% print_squares2/2
print_squares2(A, B) :-
    myfor(A, B, X),
        S is X*X,
        write(X),
        write(' squared is '),
        write(S),
        nl,
    fail.

% Try:
%   ?- print_squares2(2, 8).

% SWI-Prolog includes "myfor", in the form of "between".


% ***** Cut *****


% "!" (read as "cut")
% - Always succeeds.
% - Once a cut has been done:
%   - Backtracking past the cut is not allowed, for the current goal.
%   - Included in this: use of another definition for the current goal
%     is not allowed.

% Cut can be used as something like a "break".

% print_near_sqrt/1
% For A > 0. print_near_sqrt(A) prints largest integer whose square is
% at most A.
near_sqrt(A) :-
    for(X, 1, A),
        X2 is X*X,
        X2 > A, !,
        X1 is X-1,
        write(X1),
        nl.

% Try:
%   near_sqrt(105).

% Cut can do if ... else.

% Consider the following C++ code.
%
%   void test_big(int n)
%   {
%       if (n > 20)
%           cout << n << " IS A BIG NUMBER!" << endl;
%       else
%           cout << n << " is not a big number." << endl;
%   }
%
% Here it is in Prolog:

% test_big/1
% test_big(+n) prints a message indicating whether n > 6.
test_big(N) :- N > 20, !, write(N), write(' IS A BIG NUMBER!'), nl.
test_big(N) :- write(N), write(' is not a big number.'), nl.

% Try:
%   ?- test_big(100).
%   ?- test_big(2).

% More generally, cut can be used to ensure that only one definition of
% a predicate is used.

% Here is our "gcd" predicate from simple.pl:
gcd(0, B, B).
gcd(A, B, C) :- A > 0, X is B mod A, gcd(X, A, C).

% And here is a rewritten version, using cut:

% gcd2(+a, +b, ?c)
% gcd2(A, B, C) means the GCD of A and B is C. A, B should be
% nonnegative integers. C should be a nonnegative integer or a free
% variable.
gcd2(0, B, C) :- !, B = C.
gcd2(A, B, C) :- X is B mod A, gcd2(X, A, C).

% Try:
%   ?- gcd(30, 105, X).
%   ?- gcd2(30, 105, X).
%   ?- gcd2(30, 105, 15).
%   ?- gcd2(30, 105, 14).

% With cut, we can write "not".

% not/1
% Given a zero-argument predicate or compound term. Succeeds if the
% given term fails.
not(T) :- call(T), !, fail.
not(_).

% SWI-Prolog includes "not", in the form of "\+".


% ***** Other Loops *****


% true/0 always succeeds, but only once.

% myrepeat/0 succeeds an unlimited number of times.
myrepeat.
myrepeat :- myrepeat.

% SWI-Prolog includes "myrepeat", in the form of "repeat".

% We can use myrepeat to do something like a while-true-break loop.

squares_interact :-
    myrepeat,
        write('Type a number (0 to quit) followed by dot: '),
        flush,
        read(X),
        nl,
        write('You typed: '), write(X), nl,
        X2 is X*X,
        write('Its square: '), write(X2), nl,
        nl,
    X = 0,
    write('Bye!'), nl.

% Try:
%   ?- squares_interact.

% ";" is OR, just as "," is AND. The precedence of ";" is lower than
% that of ",".

% To deal with precedence issues, and to restrict the effect of a cut,
% use parentheses, as below.

% Here is squares_interact rewritten to do its "break" in the middle of
% the loop.

squares_interact2 :-
    repeat,
        write('Type a number (0 to quit) followed by dot: '),
        flush,
        read(X),
        nl,
        (X = 0, !
        ;write('You typed: '), write(X), nl,
        X2 is X*X,
        write('Its square: '), write(X2), nl,
        nl, fail),
    write('Bye!'), nl.

% Try:
%   ?- squares_interact2.

