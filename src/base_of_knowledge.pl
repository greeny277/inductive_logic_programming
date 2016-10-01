/* vim: set filetype=prolog */

female(nancy).
female(helen).
female(eve).
female(mary).

parent(helen, mary).
parent(helen, tom).
parent(george, mary).

parent(tom, eve).
parent(nancy, eve).

daughter(X, Y) :- female(X),parent(Y,X).

background(female(nancy),female(helen),female(eve),female(mary),parent(helen,mary),parent(helen,tom),parent(george,mary),parent(tom,eve),parent(nancy,eve)).

rlgg(Background, R) :-
	Background =.. [_|Predicates],
	antiUnify(Predicates, Predicates, [], R).

antiUnify([H|T], FullList, Akk, R) :-
	findPair(H, FullList, [], Pairs),
	antiUnify(T, FullList, [Pairs|Akk], R_tmp),
	flatten(R_tmp, R_tmp2),
	deletePermutedPairs(R_tmp2, R).
antiUnify(_,_,Pairs, Pairs).

findPair(Current, [Current|T], Akk, R) :-
	findPair(Current, T, Akk, R).
findPair(Current, [H|T], Akk, R) :-
	sameFunctor(Current, H), findPair(Current, T, [pair(Current,H)|Akk], R).
findPair(Current, [_|T], Akk, R) :-
	findPair(Current, T, Akk, R).
findPair(_, _, Akk, Akk).

deletePermutedPairs([H|T], R) :-
	deletePermutedPairs2(H, T, [], Tr),
	deletePermutedPairs(Tr, R_tmp),
	addHeader(H, R_tmp, R).
deletePermutedPairs(R,R).

addHeader(H, T, [H|T]).

deletePermutedPairs2(Pair, [H|T], Akk, R) :-
	isPermuted(Pair, H), deletePermutedPairs2(Pair,T, Akk, R).
deletePermutedPairs2(Pair, [H|T], Akk, R) :-
	deletePermutedPairs2(Pair,T, [H|Akk], R).
deletePermutedPairs2(_,_,Akk,R) :- reverse(Akk,R).

isPermuted(X,Y) :-
	functor(X, pair,2),
	functor(Y, pair,2),
	X =.. [_|Tx],
	Y =.. [_|Ty],
	reverse(Tx,Ty).


sameFunctor(X,Y) :-
	isComplexTerm(X), isComplexTerm(Y),
	functor(X, Nx, Ax), functor(Y, Ny, Ay),
	Nx == Ny, Ax == Ay.

isComplexTerm(X) :-
	nonvar(X),
	functor(X,_,A),
	A > 0.

attribute(Subject, Object,Fact) :-
	  Fact =.. [Object, Subject].
