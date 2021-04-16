% fibo.pl
% Glenn G. Chappell
% 2021-04-16
%
% For CS F331 / CSCE A331 Spring 2021
% Compute Fibonacci Numbers


% The Fibonacci number F(n), for n >= 0, is defined by F(0) = 0,
% F(1) = 1, and for n >= 2, F(n) = F(n-2) + F(n-1).


% advance([+a, ?b], [?c, ?d]).
% [a, b] is a pair of consecutive Fibonacci numbers. [c, d] in the next
% such pair. At least one of b, c must be specified.
%
% For example, advance([5, 8], [8, 13]) succeeds.
advance([A, B], [C, D]) :- C = B, D is A + B.


% fibopair(+n, [?a, ?b])
% n is a nonnegative integer. [a, b] is the pair of consecutive
% Fibonacci numbers, starting with the nth, that is, [F(n), F(n+1)].
fibopair(0, [0, 1]).
fibopair(N, [X, Y]) :-
    N > 0,
    N1 is N-1,
    fibopair(N1, [A, B]),
    advance([A, B], [X, Y]).


% fibo(+n, ?f)
% n is a nonnegative integer. f is the nth Fibonacci number: F(n).
fibo(N, F) :- N >= 0, fibopair(N, [F, _]).


% displayfibos(+start, +end)
% Nicely displays Fibonacci numbers from F(start) to F(end-1), each on a
% separate line. Always succeeds.
displayfibos(START, END) :-
    END1 is END-1,
    between(START, END1, I),
        fibo(I, F),
        write('F('),
        write(I),
        write(') = '),
        write(F),
        nl,
    fail.
displayfibos(_, _).


% main/0
% Main program
% Print some Fibonacci numbers
main :-
    How_many_to_print = 20,
    write('Fibonacci Numbers'),
    nl,
    displayfibos(0, How_many_to_print),
    nl.

