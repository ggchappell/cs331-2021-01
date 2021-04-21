% list.pl
% Glenn G. Chappell
% 2021-04-21
%
% For CS F331 / CSCE A331 Spring 2021
% Code from 4/21 - Prolog: Lists


% ***** Preliminaries *****


% "_" matches anything, and indicates that the value will not be used.
% This avoids "singleton variable" warnings.

% threeThings/3
% Takes three arguments. Always succeeds.
threeThings(_, _, _).

% Test whether a term is a free variable: var
% Its opposite: nonvar
% Try:
%   ?- var(X).
%   ?- nonvar(X).
%   ?- var(5).
%   ?- nonvar(5).
%   ?- X = 5, var(X).
%   ?- var(X), X = 5.

% threeMore(?x, ?y)
% At least one of x, y must be given.
% y = x+3
threeMore(X, Y) :- nonvar(X), Y is X+3.
threeMore(X, Y) :- var(X), X is Y-3.

% Try:
%   ?- threeMore(1, 4).
%   ?- threeMore(1, 5).
%   ?- threeMore(9, A).
%   ?- threeMore(A, 9).

% aBitMore(?x, ?y)
% At least one of x, y must be given.
% y = x+1 or y = x+2.
aBitMore(X, Y) :- nonvar(X), Y is X+1.
aBitMore(X, Y) :- nonvar(X), Y is X+2.
aBitMore(X, Y) :- var(X), X is Y-1.
aBitMore(X, Y) :- var(X), X is Y-2.

% Try:
%   ?- aBitMore(5, A).

% We can pass predicates as parameters. To call them: call
% Try:
%   ?- call(aBitMore, 5, A).


% ***** Lists & Tuples *****


% Basic syntax for Prolog lists is like that for Haskell.

% Try:
%   ?- X = [2,3,5].
%   ?- [A,3,5] = [2,3,B].

% Being a dynamically-typed language, Prolog supports lists containing
% different types.

% Try:
%   ?- [A,3,5] = [xyz,3,B].

% Prolog has the equivalent of Scheme pair notation:
% Scheme          Prolog
% (1 2 3)         [1,2,3]
% ()              []
% (1 (2 3))       [1,[2,3]]
% (1 . 2)         [1 | 2]
% (1 2 3 . 4)     [1,2,3 | 4]
% (1 . (2 . ()))  [1 | [2 | []]]

% All of the above can be used as "patterns"; unification works on them.

% head/2
% head(+x, ?y)
% x is a nonempty list, and y is its head.
head([H|_], H).

% tail/2
% As above.
tail([_|T], T).

% Prolog also has tuples: comma-separated lists. They do not need to be
% enclosed in parentheses, except when precedence requires it. There is
% no pair notation for tuples.

% Try:
%   ?- X = (2, 5).
%   ?- X = [(1,2),(3,4,5)].


% ***** Lists & Recursion *****


% len(+list, ?length)
% length is the number of items in list.
len([], 0).
len([_|T], N) :- len(T, NN), N is NN+1.

% Try:
%   ?- len([1,2,3], 3).
%   ?- len([1,2,3], 4).
%   ?- len([1,2,3], N).

% concat/3
% List concatenation. Third argument is concatenation of first two.
concat([], L2, L2).
concat([H|T], L2, [H|T3]) :- concat(T, L2, T3).

% Try:
%   ?- concat([1,2,3], [4,5,6], X).
%   ?- concat(X, [4,5,6], [1,2,3,4,5,6]).
%   ?- concat(X, Y, [1,2,3,4,5,6]).


% ***** Lists & Encapsulated Loops *****


% map(+f, ?list1, ?list2)
% At least one of list1, list2 must be given.
% Given a "function" implemented as a 2-parameter predicate, list2 is
% the result of mapping f, itemwise, to list1. Like Haskell, Scheme
% "map".
map(_, [], []).
map(F, [H|T], [FH|FT]) :- call(F, H, FH), map(F, T, FT).

% sq(+x, ?y)
% Our usual square function: y = x*x.
sq(X, Y) :- Y is X*X.

% Try:
%   ?- map(sq, [1,5,7], [1,25,49]).
%   ?- map(sq, [1,5,7], [1,25]).
%   ?- map(sq, [1,5,7], X).

% filter/2
filter(_, [], []).
filter(P, [H|T], L) :- call(P, H), filter(P, T, PT), L = [H|PT].
filter(P, [H|T], L) :- \+ call(P, H), filter(P, T, L).

% isBig(?x).
% Succeeds if x > 20.
isBig(X) :- X > 20.

% Try:
%   ?- filter(isBig, [1,30,2,45,19,100,120,-7,0,35], X).

% zip/3
zip([], _, []).
zip([_|_], [], []).
zip([H1|T1], [H2|T2], [(H1,H2) | X]) :- zip(T1, T2, X).

% Try:
%   ?- zip([2,5,8,11,14], [1,4,9,16,25,36,49], X).

% Our map/3, above, works with generalized functions.

% Try:
%   ?- map(threeMore, [1,5,7], X).
%   ?- map(threeMore, X, [1,5,7]).
%   ?- map(aBitMore, [1,5], X).
%   ?- map(aBitMore, X, [1,5]).

