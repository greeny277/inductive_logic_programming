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

positives(daughter(mary,helen), daughter(eve, tom)).

rlgg(Background, PositiveExamples, R) :-
	Background =.. [_|PredEx],
	PositiveExamples =.. [_|PredPos],
	generatePairs(PredEx, PredEx, [], PairsBack),
	generatePairs(PredPos, PredPos, [], PairsPosEx),
	antiUnifyAll(PairsPosEx, PosAU),
	antiUnifyAll(PairsBack, BackAU),
	parseAtoms(PosAU, Atoms),
	searchBackground(BackAU, Atoms, R).

searchBackground([H|T], Atoms, NewRule) :-
	parseAtoms([H], BackAtoms),
	isSublist(BackAtoms, Atoms),
	searchBackground(T, Atoms, R),
	append([H], R, NewRule).
searchBackground([_|T], Atoms, NewRule) :-
	searchBackground(T, Atoms, NewRule).
searchBackground(_, _, []).

isSublist([H1|T1], L2) :-
	memberchk(H1, L2),
	isSublist(T1, L2).
isSublist([],_).


parseAtoms([H|T], Atoms) :-
	H =.. [_|HAtom],
	parseAtoms(T, R),
	append(HAtom, R, Atoms).
parseAtoms([], []).


antiUnifyAll([H|T], AUPairs) :-
	antiUnify(H, AUPair),
	antiUnifyAll(T, R),
	addHeader(AUPair, R, AUPairs).
antiUnifyAll([], []).

antiUnify(Pair, AUPair) :-
	arg(1,Pair,ContP1),
	arg(2,Pair,ContP2),
	ContP1 =.. [P1Func|P1Args],
	ContP2 =.. [_|P2Args],
	concateHelper(P1Args, P2Args, [], Foo),
	AUPair =.. [P1Func|Foo].

concateHelper([H1|T1], [H2|T2], Akk, R) :-
	msort([H1,H2|[]], [HS1,HS2|_]),
	atom_concat(HS1, '_', Tmp),
	atom_concat(Tmp, HS2, Hr),
	concateHelper(T1, T2, [Hr|Akk], R).
concateHelper(_, _, Akk, R) :- reverse(Akk, R).


generatePairs([H|T], FullList, Akk, R) :-
	findPair(H, FullList, [], Pairs),
	generatePairs(T, FullList, [Pairs|Akk], R_tmp),
	flatten(R_tmp, R_tmp2),
	deletePermutedPairs(R_tmp2, R).
generatePairs(_,_,Pairs, Pairs).

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
