/* vim: set filetype=prolog */

% A naive implementation of the
% rlgg algorithm
rlgg(Background, PositiveExamples, R) :-
	Background =.. [_|PredEx],
	PositiveExamples =.. [_|PredPos],

	% Generate pairs of complex terms having
	% the same outer-most functor
	generatePairs(PredEx, PredEx, [], PairsBack),
	generatePairs(PredPos, PredPos, [], PairsPosEx),

	% Anti-Unify the pairs
	antiUnifyAll(PairsPosEx, PosAU),
	antiUnifyAll(PairsBack, BackAU),

	%TODO Get variables of PosAU
	%
	%
	% Parse the positive examples
	parseAtoms(PosAU, Atoms),

	%TODO Delete background literals
	%
	% Delete all background literals that uses
	% other anti-unified variables than the positive
	% ones.
	searchBackground(BackAU, Atoms, R).

searchBackground([H|T], Atoms, NewRule) :-
	parseAtoms([H], BackAtoms),
	isSublist(BackAtoms, Atoms),
	searchBackground(T, Atoms, R),
	append([H], R, NewRule).
searchBackground([_|T], Atoms, NewRule) :-
	searchBackground(T, Atoms, NewRule).
searchBackground([], _, []).

% Checks if L1 a sublist of L2.
isSublist([H1|T1], L2) :-
	memberchk(H1, L2),
	isSublist(T1, L2).
isSublist([],_).

% Relates a list of complex terms to a list of
% their arguments.
% TODO Traverse recursivly
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
	%TODO: Use here antiUnifyTermsMaster
	antiUnifyTermsMaster(ContP1, ContP2, AUPair).
%ContP1 =.. [P1Func|P1Args],
%	ContP2 =.. [_|P2Args],
%	concateHelper(P1Args, P2Args, [], Foo),
%	AUPair =.. [P1Func|Foo].
%
concateHelper([H1|T1], [H2|T2], Akk, R) :-
	msort([H1,H2|[]], [HS1,HS2|_]),
	%TODO for complex terms using term_string from prolog extension 7
	atom_concat(HS1, '_', Tmp),
	atom_concat(Tmp, HS2, Hr),
	concateHelper(T1, T2, [Hr|Akk], R).
concateHelper(_, _, Akk, R) :- reverse(Akk, R).

antiUnifyTermsMaster(T, T, T).
antiUnifyTermsMaster(T1, T2, LGG) :-
	antiUnifyTerms(T1, T2, New_Variable, SubstitutedTermT1, SubstitutedTermT2),
	substitute(T1, T2, SubstitutedTermT1, SubstitutedTermT2, New_Variable, SubT1, SubT2),
	antiUnifyTermsMaster(SubT1, SubT2, LGG).

antiUnifyTerms(T1, T2, New_Variable, SubstitutedTermT1, SubstitutedTermT2) :-
	T1 \= T2,
	isComplexTerm(T1), isComplexTerm(T2),
	sameFunctor(T1,T2),
	T1 =.. [_|T1Args],
	T2 =.. [_|T2Args],
	antiUnifyTerms2(T1Args, T2Args, New_Variable, SubstitutedTermT1, SubstitutedTermT2).
antiUnifyTerms(T1, T2, New_Variable, SubstitutedTermT1, SubstitutedTermT2) :-
	antiUnifyTerms2([T1], [T2], New_Variable, SubstitutedTermT1, SubstitutedTermT2).

antiUnifyTerms2([H1|T1], [H2|T2], New_Variable, SubstitutedTermT1, SubstitutedTermT2) :-
	H1 == H2,
	antiUnifyTerms2(T1, T2, New_Variable, SubstitutedTermT1, SubstitutedTermT2).
antiUnifyTerms2([H1|T1], [H2|T2], New_Variable, SubstitutedTermT1, SubstitutedTermT2) :-
	isComplexTerm(H1), isComplexTerm(H2),
	sameFunctor(H1,H2),
	antiUnifyTerms2(T1, T2, New_Variable, SubstitutedTermT1, SubstitutedTermT2).
antiUnifyTerms2([H1|_], [H2|_], New_Variable, SubstitutedTermT1, SubstitutedTermT2) :-
	term_string(H1, H1_s),
	term_string(H2, H2_s),
	msort([H1_s,H2_s|[]],L), %TODO Does msort/2 delete any information?
	ins('_',L, 2, L2),
	string_concat(x, '_', Tmp),
	addHeader(Tmp, L2, Tmp2),
	atomic_list_concat(Tmp2, New_Variable),
	id(H2,SubstitutedTermT2),
	id(H1,SubstitutedTermT1).

substitute(T1, T2, From1, From2, To, SubstitutedTermT1, SubstitutedTermT2) :-
	T1 == From1, T2 == From2,
	id(To, SubstitutedTermT1),
	id(To, SubstitutedTermT2).
substitute(T1, T2, From1, From2, To, SubstitutedTermT1, SubstitutedTermT2) :-
	isComplexTerm(T1), isComplexTerm(T2),
	T1 =.. [Func1|L1],
	T2 =.. [Func2|L2],
	substituteHelper(L1, L2, From1, From2, To, SubT1, SubT2),
	SubstitutedTermT1 =.. [Func1|SubT1],
	SubstitutedTermT2 =.. [Func2|SubT2].
%substitute(_, _, From1, From2, _, From1, From2).

substituteHelper([H1|T1], [H2|T2], From1, From2, To, SubstitutedTerm1, SubstitutedTerm2) :-
	H1 == From1, H2 == From2,
	substituteHelper(T1, T2, From1, From2, To, S1, S2),
	id([To|S1], SubstitutedTerm1),
	id([To|S2], SubstitutedTerm2).
substituteHelper([H1|T1], [H2|T2], From1, From2, To, SubstitutedTerm1, SubstitutedTerm2) :-
	H1 == H2,
	substituteHelper(T1, T2, From1, From2, To, S1, S2),
	addHeader(H1, S1, SubstitutedTerm1),
	addHeader(H2, S2, SubstitutedTerm2).
substituteHelper([H1|T1], [H2|T2], From1, From2, To, SubstitutedTerm1, SubstitutedTerm2) :-
	isComplexTerm(H1), isComplexTerm(H2),
	H1 =.. [H1Func|H1List],
	H2 =.. [H2Func|H2List],
	substituteHelper(H1List, H2List, From1, From2, To, S1Tmp, S2Tmp),
	H1Sub =.. [H1Func|S1Tmp],
	H2Sub =.. [H2Func|S2Tmp],
	substituteHelper(T1, T2, From1, From2, To, S1TmpTmp, S2TmpTmp),
	id([H1Sub|S1TmpTmp], SubstitutedTerm1),
	id([H2Sub|S2TmpTmp], SubstitutedTerm2).
substituteHelper([H1|T1], [H2|T2], From1, From2, To, SubstitutedTerm1, SubstitutedTerm2) :-
	substituteHelper(T1, T2, From1, From2, To, S1Tmp, S2Tmp),
	addHeader(H1, S1Tmp, SubstitutedTerm1),
	addHeader(H2, S2Tmp, SubstitutedTerm2).
substituteHelper([], T2, _, _, _, [], T2).
substituteHelper(T1, [], _, _, _, T1, []).

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

% Are two pairs the same, with a switched order respectivly.
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

id(X,X).

ins(Val,[H|List],Pos,[H|Res]):-
	Pos > 1, !,
	Pos1 is Pos - 1, ins(Val,List,Pos1,Res).
ins(Val, List, 1, [Val|List]).

%%%%%%%%%%%%%%% Family Example %%%%%%%%%%%%%%%%%%%%%%%%

% background family
female(nancy).
female(helen).
female(eve).
female(mary).

parent(helen, mary).
parent(helen, tom).
parent(george, mary).

parent(tom, eve).
parent(nancy, eve).

background_family(female(nancy),female(helen),female(eve),female(mary),parent(helen,mary),parent(helen,tom),parent(george,mary),parent(tom,eve),parent(nancy,eve)).

% positive examples
positives_family(daughter(mary,helen), daughter(eve, tom)).

% testcase
test_1(X) :-
	rlgg(background_family(female(nancy),female(helen),female(eve),female(mary),parent(helen,mary),parent(helen,tom),parent(george,mary),parent(tom,eve),parent(nancy,eve)), positives(daughter(mary,helen), daughter(eve, tom)), X).

%What we expect after the rlgg algorithm
%daughter(X, Y) :- female(X),parent(Y,X).
%
test_substitute(X,Y) :-
	substitute(p(f(a, g(y)), x, g(y)), p(h(a,g(x)),x,g(x)), f(a, g(y)), h(a, g(x)),
	'x_f(a, g(y)), h(a, g(x))', X, Y).

test_AU(New_Variable, SubstitutedTermT1, SubstitutedTermT2) :-
	antiUnifyTerms(p(x(f(a, g(y)), h(a, g(x))), x, g(y)), p(x(f(a, g(y)), h(a, g(x))), x, g(x)), New_Variable, SubstitutedTermT1, SubstitutedTermT2).

test_substitute2(X,Y) :-
	test_AU(New_Variable, Sub1, Sub2),
	substitute(p('x_f(a, g(y))', h(a, g(x)), x, g(y)), p('x_f(a, g(y))', h(a, g(x)), x, g(x)), Sub1, Sub2, New_Variable, X, Y).
