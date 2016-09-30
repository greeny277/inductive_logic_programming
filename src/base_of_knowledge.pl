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

antiUnfiy().

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
