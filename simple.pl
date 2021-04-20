% simple.pl
% Glenn G. Chappell
% 2021-04-19
%
% For CS F331 / CSCE A331 Spring 2021
% Code from 4/19 - Prolog: Simple Programming


% ***** Syntax *****


% Single-line comment

/* Multi-line
   comment */

% Prolog syntax is free-form.
is_bit(0).
is_bit(  % No space allowed before left parenthesis
    1
    )
    .

% Try ("?-" is the prompt):
%   ?- is_bit(1).
%   ?- 'is_bit'(0).
%   ?- is_bit(2).
%   ?- is_bit(X).

@:$(10).
'q q q'(20).
'q q q'(21).

% Try:
%   ?- @:$(X).
%   ?- '@:$'(X).
%   ?- 'q q q'(X).


% ***** Facts, Queries, Rules, Goals *****


% Some facts:
child(bill, zeke).
child(jill, zeke).
child(will, zeke).
child(alice, bill).
child(bob, bill).
child(carol, bill).
child(xavier, jill).

% Try some queries:
%   ?- child(bill, zeke).
%   ?- child(zeke, bill).
%   ?- child(bill, jill).
%   ?- child(bill, X).
%   ?- child(X, zeke).
%   ?- child(X, Y).

% Queries may include multiple terms, separated by commas.
% Any variable that is bound in a term remains bound to the same value
% in all later terms.

% Try fancier queries:
%   ?- child(alice, X), child(X, zeke).
%   ?- child(X, zeke), child(Y, X).

% Some rules:

% parent(?a, ?b)
parent(A, B) :- child(B, A).

% grandchild(?a, ?b)
grandchild(A, B) :- child(A, X), child(X, B).

% grandparent(?a, ?b)
grandparent(A, B) :- grandchild(B, A).

% sibling(?a, ?b)
sibling(A, B) :-
    child(A, X),
    child(B, X),
    A \= B.

% Try:
%   ?- sibling(alice, X).
%   ?- sibling(X, Y).


% ***** Conventions *****


% sq/2 means that sq is a predicate that takes two arguments.
% Arguments can be marked:
%   + input only; argument cannot be free variable
%   - output only; qrgument must be free variable
%   ? input or output
% See comments before various predicates in this file for examples of
% how these may be used.

% sq/2
% sq(+x, ?y) - y is the square of x.
sq(X, Y) :- Y is X*X.

% Try:
%   ?- sq(3, 9).
%   ?- sq(3, 5).
%   ?- sq(4, X).
%   ?- sq(X, 16).
% The last line above should result in an error.


% ***** Negation *****


% Starting the name of a predicate with "\" typically means *not* (this
% is a convention, not a rule of the PL).

% \+ is a 1-argument predicate that can be used as a prefix operator. It
% succeeds if its argument fails. So it means *negation*.

% cousin(?a, ?b)
% Succeeds when values are first cousins, based on child facts.
cousin(A, B) :-
    grandchild(A, X),
    grandchild(B, X),
    \+ sibling(A, B),
    A \= B.

% Try:
%   ?- cousin(xavier, X).
%   ?- cousin(X, Y).


% ***** Numerical Computation *****


% Try:
%   ?- X = (1+sqrt(5))/2.
%   ?- is(X, (1+sqrt(5))/2).
%   ?- X is (1+sqrt(5))/2.
%   ?- X = (1+sqrt(5))/2, Y = X*X, Z is Y.
%   ?- X is 7/2.
%   ?- X is 7//2.
%   ?- X is 7.5//2.
% The last line above should result in an error.

% gcd(+a, +b, ?c)
% gcd(A, B, C) means the gcd of A and B is C. A, B should be nonnegative
% integers. C should be a nonnegative integer or a free variable.
gcd(0, B, B).
gcd(A, B, C) :- A > 0, X is B mod A, gcd(X, A, C).

% Note. The fact above:
%   gcd(0, B, B).
% has the same effect that either of the following rules would have:
%   gcd(0, B, C) :- B = C.
%   gcd(0, B, B) :- true.

% Try:
%   ?- gcd(30, 105, X).
%   ?- gcd(30, 105, 15).
%   ?- gcd(30, 105, 14).
%   ?- gcd(X, 105, 15).
% The last line above should result in an error.

