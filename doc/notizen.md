---
title: "Inductive Logic Programming"
author: Christian Bay
bibliography: ref.bib
---

Inductive Logic Programming
=============================

Introduction
-----------------------------
*Inductive logic programming* is a subfield of *machine learning* with components of
logic based programming and knowledge representation.

Programs which are using an ILP-based approach do proceed as is displayed
by Figure \ref{fig:flowchart}. In the beginning the environment which does include every
necessary information, needs to be formalised in some kind of logic (see Subsection \ref{ssec:fol}).


\begin{figure}[h]
	\begin{center}
		\includegraphics[scale=0.4]{images/process2cut.pdf}
	\end{center}
	\caption{Flowchart of an ILP-based program}
	\label{fig:flowchart}
\end{figure}

The resulting set of formulas is called *background knowlegde* which
consists of a bunch of different facts and rules. The main task of the
system is to generate new and  hopefully very general rules for the
background knowledge. Therefore the program gets feed with positive and
negative examples of a certain matter. Afterwards the program tries to
deduce the most general rule which fulfills all positive and no
negative example. Subsequently the generated rule, what is called *hypothesis*
is added to the background knowledge.

Hypotheses are classified by two factors: *complete* and *consistent*. The first
one indicated that the hypothesis fulfills each positive example, while
the second factor displays that no negative example is fulfilled.
In Figure \ref{fig:hypo} the four classes are shown.

\begin{figure}[h]
	\begin{center}
		\includegraphics[scale=0.3]{images/hypothesis.png}
	\end{center}
	\caption{Shown is the classification of hypotheses, where the denotation is as follows: background knowlegde is
	$B$, positive examples $E^+$, negative examples $E^-$ and the hypothesis is $H$.}
	\label{fig:hypo}
\end{figure}

A good hyptothesis $H$ is a logic proposition satisfying
following requirements:

* Necessity:          $B \nvDash E^{+}$

     Forbids gerneration of hypothesis as long as positive facts
     can be explained without it.

* Sufficiency:        $B \wedge H \vDash E^{+}$

     The hypothesis $h$ need to entail all positive
     examples in $E^{+}$.

* Weak consistency:   $B \wedge H \nvDash false$

     $H$ is not allow to contradict the background knowledge $B$.

* Strong consistency: $B \wedge H \wedge E^{-} \nvDash false$

     $H$ is not allow to contradict the negative examples $E^{-}$ either.



First order logic (FOL)
--------------------------

\label{ssec:fol}

Popular ILP-engines have in common that each of them are  using *first order logic*
to represent the environment. Therefore its syntax and semantic is briefly
introduced here to give a basic understanding.

### Syntax


#### Terms

In FOL terms denote objects in the world. They are inductively defined as:
\begin{itemize}
	\item Every variable and constant is a term
	\item Every expression $f(t_1, \ldots, t_n)$ is a term
\end{itemize}
The grammar for terms does look as follows:
\begin{align}
	Term := c \mid v \mid f(Term_1, Term_2, \ldots, Term_n) \hspace{1cm} \text{where } v \in Var, c \in
	C, f \in F
\end{align}
\begin{itemize}
	\item $C$ is the set of constant symbols with arity $= 0$
	\item $F$ is the set of function symbols with arity $\geq 0$
	\item $Var$ is the set of all variable symbols $v_0, \ldots, v_n$
\end{itemize}

Terms without variables are denoted as *ground terms*. Each function
symbol $f/n$ maps $n$ objects to another single object in the world.

#### Atoms and Literals

An atom or literal is the smallest expression to which a truth value can
be assigned to.

\begin{itemize}
	\item $p(Term_1, \ldots, Term_n) \text{ where } p \in P$
	\item $Term_1 = Term_2$ \hspace{1cm}\text{(equality relation)}
\end{itemize}
$P$ is the set of predicate symbols with arity $\geq 0$.

Literals are (negated) atoms.

We call $\Sigma$ a signature a tuple of the three sets $(C,F,P)$.

### Semantic

The defined syntax is just a series of symbols without any meaning. Therefore
a structure $\mathfrak{A}$ on $\Sigma=(C,F,P)$ is defined. It contains a nonempty set $D$
together with:
\begin{itemize}
	\item an element $c^{\mathfrak{A}} \in D$ for each  $c \in  \Sigma$
	\item a function $f^{\mathfrak{A}} : D^n \rightarrow D$ for each $f/n \in \Sigma$
	\item a predicate $p^{\mathfrak{A}} \subseteq D^n$ for each $p/n \in \Sigma$
\end{itemize}

An interpetation $\mathfrak{I}$ is a pair $\mathfrak{I} = (\mathfrak{A}, \beta)$ with
$\beta : \{v \mid v \in Var\} \rightarrow D$.

Terms get interpreted as follows:

\begin{align}
	\mathfrak{I}(v) &:= \beta(v), v \in Var\\
	\mathfrak{I}(c) &:= c^\mathfrak{A}, c \in \Sigma\\
	\mathfrak{I}(f(t_1, \ldots, t_n) &:= f^\mathfrak{A}(\mathfrak{I}(t_1), \ldots, \mathfrak{I}(t_n), f/n \in \Sigma
\end{align}

A model $\mathfrak{M}$ is an interpetaion $\mathfrak{I}$ for a $\Sigma$ expression $\varphi$,
written $\mathfrak{M} \vDash \varphi$ when the following rules hold: Each interpretation
$\mathfrak{I}$ that fulfills all formulas in $\Sigma$, also fulfills $\varphi$.


General tools
---------

### Horn clauses

A *horn clauses* is a disjunction of clauses with at most one positive literal. Furthermore
definite program clauses are horn clauses with exactly one positive literal.

For instance:

\begin{align}
	\lnot p \vee \lnot q \vee \lnot t \vee u
\end{align}

Which can be converted to an implication as following:

\begin{align}
	(p \wedge q \wedge t) \to u
\end{align}

The programming language *Prolog* is using logic as programming paradigma
because facts and rules can be represented as implications, which can be
proven by *breadth-first search*.
An example rule is given in Equation \ref{al:ex1}. To show that
someone is a daughter  is done by checking if the person is female and has parents.
\begin{align}
	\label{al:ex1}
	daugther(X, Y) \Leftarrow female(X) \wedge parent(Y,X)
\end{align}

### Subsumption

A huge difficulty by finding good hypothesis is the enormous size of search space it can
exists in. Therefore subsumption helps to find some boundaries.

\begin{definition}
Subsumption for literals.

Let $L_1$ and $L_2$ be literals. $L_1$ subsumes $L_2$ iff there exists a $\theta$
such that $L_1\theta = L_2$, also written $L_1 \succeq L_2$.

For instance:
\begin{align}
	p(f(x), X) \succeq p(f(a),a)\\
	\theta=\{X | a\}.
\end{align}
\end{definition}

\begin{definition}
Subsumption for clauses.

Let $C$ and $D$ be clauses. $C$ subsumes $D$ iff there exists a $\theta$
such that $C\theta \subseteq D$, also written $C \succeq D$.

For instance:
\begin{align}
	p(a, X) \vee p(b,Z) \succeq p(a,c)\\
	\theta=\{X | c\}.
\end{align}
\end{definition}

The most important property in the context of ILP is the following theorem.

\begin{thm}
$C_1 \preceq C_2 \rightarrow C_1 \vDash C_2$
\end{thm}
Therefore a subsumption relation between two clauses implies their logical consequence.

Now a partial ordered set (POSET) $(X, \preceq)$ is defined, where $X$ is a set of literals. One
literal is greater than each other literal it subsumes.
POSETs have in general two special members $\top, \bot$. $\top$ is greater and $\bot$ is lower than
each other member in $X$. With a given set of predicates the POSET constructs a lattice of atomic formulas (see Example
\ref{fig:poset_atomic}).

\begin{bsp}
Given is a binary predicate $p$, a constant $a$ and an unlimited set
of variables.

\begin{figure}[H]
	\begin{center}
		\begin{tikzpicture}
			\node (G) at (1.5,2) {$\top$};
			\node (A) at (1.5,1) {$p(X,Y)$};
			\node (B) at (-1,-1) {$p(X,a)$};
			\node (C) at (1.5,-1) {$p(X,X)$};
			\node (D) at (4,-1) {$p(a,Y)$};
			\node (E) at (1.5,-3) {$p(a,a)$};
			\node (F) at (1.5,-4) {$\bot$};

			\path [-] (A) edge node[left] {} (G);
			\path [-] (A) edge node[left] {} (B);
			\path [-] (A) edge node[left] {} (C);
			\path [-] (A) edge node[left] {} (D);
			\path [-] (B) edge node[left] {} (E);
			\path [-] (C) edge node[left] {} (E);
			\path [-] (D) edge node[left] {} (E);
			\path [-] (F) edge node[left] {} (E);
		\end{tikzpicture}
	\end{center}
	\caption{Example for POSET of atomic formulas}
	\label{fig:poset_atomic}
\end{figure}
\end{bsp}


Algorithms for hypothesis search
---------------------------------

### Relative least general generalization (rlgg)

This algorithm was the basic of GOLEM and invented by @plotkin1970note.
As mentioned earlier an hypothesis is searched that together with the
background knowledge entails the positive examples but not any negative
one: $B \wedge h \vDash E^+$. This formula can be converted to
$h \vDash B \rightarrow E^+$. This kind of entailment can't be computed because
it is an undecidable problem, but subsumption can be used as a very good
approximation.

Algorithm:

<!-- TODO: Introduce \theta_{1,2} -->
1. Build for each positive example $E'$ an implication
   with $B \to E'$ <!-- TODO: Mentioning/Defining Saturation! -->

2. Convert each implication to clause normalform: $\neg B \vee E'$

3. Build the *least genereal generalization* of each compatible pair of literals

4. Delete all negated literals containing variables that don't occur in a positive literal

5. Convert final clause back to Horn form.

Figure \ref{fig:poset_atomic} shows  on the basis of a little example how the POSET $(X, \preceq)$
extends to a lattice of clauses. Therefore a clause subsumes each clause other which is below itself
and in reverse gets subsumed by each clause above.

\begin{definition}
The lowest upper bound of two formulas is their least general generalization.
\end{definition}

Plotkin introduced an algorithm for determining the *least generalization* for two given terms or literals.
The notation is as following: $P$ is a predicate, $g,f$ are symbols and $z$ is a variable.
A word $W$ is a term or a variable.

The lgg-algorithm for terms is defined as followed:

<!-- TODOS: Use algorithm package. What does "compatible" mean? Begins with same predicate, function
symbol or variable? -->

\begin{algorithm}[H]
	\KwIn{Terms $t_1$ and $t_2$}
	\KwData{$\varphi$ is a bijection from pairs of terms to variables
	which do not appear in $t_1$ or $t_2$.}
	\KwResult{Least generalization lgg$(t_1, t_2)$}
		\eIf{$t_1 = f(u_1, \ldots, u_n) \&\& t_2 = f(s_1, \ldots, s_n)$}{
			return $f(\text{lgg}(u_1, s_1), \ldots, \text{lgg}(u_n, s_n))$\;
		}{
			return $\varphi(t_1, t_2)$\;
		}
	\caption{lgg-algorithm for terms}
\end{algorithm}

For literals the algorithm proceeds very similar:

\begin{algorithm}[H]
	\KwIn{Literals $L_1$ and $L_2$}
	\KwResult{Least generalization lgg$(t_1, t_2)$}
		\If{$L_1 = p(u_1, \ldots, u_n) \&\& L_2 = p(s_1, \ldots, s_n)$}{
			return $p(\text{lgg}(u_1, s_1), \ldots, \text{lgg}(u_n, s_n))$\;
		}
	\caption{lgg-algorithm for literals}
\end{algorithm}




\begin{bsp}
Determine the lgg of $V_1 = P(f(x), g(z))$ and $V_2 = P(f(g(z)), g(z))$:

\begin{enumerate}
	\item $lgg(V_1, V_2)$
	\item $P(lgg(f(x), f(g(z)), lgg(g(z), g(z)))$
	\item $P(f(lgg(x, g(z)), g(z))$
	\item $P(f(\varphi(x, g(z)), g(z))$
	\item $P(f(v), g(z))$
\end{enumerate}
$\Rightarrow \epsilon_1 = \{x | v\}$ and $\epsilon_2 = \{g(z) | v\}$
\end{bsp}

The last missing step to receive the searched hypothesis $h$ is to lift this
POSET construct towards clauses.
Because the searched hypothesis is a formula, that each
clauses of kind $\neg B \vee E$ can be generalized to, where $E$ is any any positive
example and $B$ the background knowlegde.

The least generalization for clauses works as follows:
\begin{algorithm}[H]
	\KwIn{Clauses $C_1 = l_{1,1} \vee \ldots \vee l_{1,n}$ and $C_2 = l_{2,1} \vee \ldots \vee l_{2,m}$}
	\KwResult{Least generalization lgg$(C_1, C_2)$}
		result $= \{\}$\;
		\ForEach{$((l_{1,i}, l_{2,j}) \mid i \leftarrow (1 .. n), j \leftarrow (1 ..m))$}{
			lgg\_tmp $= lgg(l_{1,i}, l_{2,j})$\;
			\If{lgg\_tmp $\neq \top$)}{
				result $\cup $ lgg\_tmp\;
			}
		}
		return result\;
	\caption{lgg-algorithm for clauses}
\end{algorithm}

\begin{bsp}
Given the following two clasues: $C_1 = p(a, f(a)) \vee p(b,b) \vee \neg p(b, f(b))$
$C_2 = p(f(a), f(a)) \vee p(f(a),b) \vee \neg p(a, f(a))$:

\begin{align}
	lgg(C_1, C_2) = p(X, f(a)) \vee p(X, Y) \vee p(Z, Z) \vee p(Z, b) \vee \neg p(U, f(U))
\end{align}
\end{bsp}

Now it is possible to create a POSET of clauses $(X, \succeq)$ where $X$ contains all variants
of a starting clause and $\top$ and $\bot$.

\begin{bsp}
TODO: Example of clause lattice
\label{poset_clause}
\end{bsp}

### Saturation
The saturation step takes all horn clauses of the positive examples
with the form $a \leftarrow b_1 \ldots b_n$ and uses the background knowledge
to get all possible entailments. In the appendix a concrete algorithm for
saturation is presented \ref{app_saturation}.

\begin{bsp}
Insert Circle Example here
\end{bsp}

\begin{algorithm}[H]
	\KwIn{Background-Knowledge $B$\\Positive Examples $E^+$\\Negative Examples $E^-$.}
	\KwResult{Matching hypothesis $H$}
		saturatedExamples $= \{\}$\;
		\ForEach{$e^+$ in $E^+$}{
			saturatedExample.pushBack(saturate$(e^+)$)\;
		}
		\While{saturatedExamples.size() != 1}{
			\tcc{Just take the first two clauses. Alternatively they can be chosen at random.}
			(e1, e2) = saturatedExample.popFrontPair()\;
			lggE12 = lgg(e1,e2)\;
			\ForEach{$e^-$ in $E^-$}{
				\tcc{Check if the new clause subsumes any negative example}
				\If{doesSubsume(lggE12, $e^-$)}{
					return \{\};
				}
			}
			saturatedExample.pushBack(lggE12)\;
		}
		\tcc{The last remaining clause is our hypothesis}
		return result\;
	\caption{Bottom-up approach using lgg}
\end{algorithm}

Inverse Entailment and Inverse Subsumption
------

Another approach has been introduced by Stephen Muggleton in his
resolver named PROGOL. It is called **Inverse Entailment**.
The motivation laid in the following problems by the **rlgg** approach[@muggleton1995inverse]:

1. If the background knowledge $B$ is an unrestricted definite clause there may
be no finite $rlgg_B(E)$.

2. The new hypotheses $H$ may grow exponentially. Assume $B$ has $n$ and $E$
$m$  ground literals. Than $rlgg_B(E)$ may consist of $(n + 1)^m$ ground literals.

3. Concepts with multiple hypothesis can not be learned since
$rlgg_B(E)$. is a single clause.


<!--The general idea is to find a later called *bridge hypothesis* $F$ [@yamamoto2010inverse].-->
We need to find an hypothesis such that Sufficiency, Necessity, Weak and Strong
consistency holds. The *deduction theorem* in first order logic proofs that
$B \wedge H \vDash E$ is logically equivalent to $B \wedge \neg E \vDash \neg H$.
This equivalency means that $H$ can be computed by deducing its negation $\neg H$
from $B$ and $\neg E$ as follows:

\begin{align}
B \wedge \neg E \vDash \neg H
\end{align}

Now let $\neg \bot$ the potential infinit conjunction of all ground literals
wich are true in all models of $B \wedge \neg E$. Since $\neg H$ is true in every model
of $B \wedge \neg E$ it have to contain a subset of the ground literals in $\neg \bot$.

Therefore:
\begin{align}
B \wedge \neg E \vDash \neg \bot \vDash \neg H
\end{align}

What leads to:
\begin{align}
H \vDash \bot
\end{align}

To clarify what this means consider another POSET like in \ref{poset_clause}
which starts with the predicate from which the examples are constructed from
and ends up in $\bot$. Anywhere in bewtween the searched hypothesis $H$ has
to exist.

### Inverse Subsumption

#### Refinement Operators
This section shows how an hypothesis can $H$ derived from the starting predicate.

@shapiro1983algorithmic introduced a concept of **refinement operators**
to search from general to more specific clauses (one it subsumes).

The refinement operator $\rho$ is in the context of PROGOL defined as:
\begin{align}
\forall D \in \rho(C). C \succeq D
\end{align}

Common refinement operators are:

1. Substitute for one variable a term built from a functor of
arity $n$ and $n$ distinct and not in the clause existing variables:
$\theta=\{X | f(Y_1, \ldots, Y_n)\}$

2. Substitute for one variable another variable already in the clause:
$\theta=\{X | Y\}$

3. Add a literal $l_k = p(u_1, \ldots, u_m)$, which is the $k$-th literal of $F_i$, where each
	$u_j$ with $1 \leq j \leq m$ is substituted by $\{v_j|u_j\} \in \theta$ or
	$\theta' = \theta \cup \{v_j|u_j\}$.
<!-- TODO Das stimmt so nicht. Siehe Muggleton S.265 -->

The figure \ref{fig:refinement_operator} shows a refinement graph with some operators.
The numeration of the operators is referring to the enumeration above.
\begin{figure}[H]
	\begin{center}
		\begin{tikzpicture}
			\node (A) at (1.5,1) {$p(X,Y)$};
			\node (B) at (-3,-1) {$p(X,X)$};
			\node (C) at (0,-1) {$p(f(Z_1,Z_2), Y)$};
			\node (D) at (3,-1) {$p(X,f(Z_1,Z_2))$};
			\node (E) at (7,-1) {$p(X,Y) \leftarrow q(Z_1, Z_2)$};

			\path [->] (A) edge node[left] {op2} (B);
			\path [->] (A) edge node[left] {op1} (C);
			\path [->] (A) edge node[left] {op1} (D);
			\path [->] (A) edge node[left] {op3} (E);
		\end{tikzpicture}
	\end{center}
	\caption{Example for applied refinement operators}
	\label{fig:refinement_operator}
\end{figure}

Such operators should fulfill the following properties:

1. **Completeness**: Creating each possible subsumed clause.
2. **Finiteness**: The cardinality of $\rho(C)$ is finite.
3. **Non-redundancy**: Only one sequence of operators to get from a clause to
a subsumed one.

Regarding to @van1993subsumption not all three properties can be fulfilled at the same time.
Therefore the third one is not considered.
The set of operators shown in \ref{fig:refinement_operator} is finite and complete but
redundant (see Figure \ref{fig:prop_refinment_op}).

\begin{figure}[H]
	\begin{center}
		\begin{tikzpicture}
			\node (A) at (1.5,1) {$p(X,Y)$};
			\node (B) at (0,-1) {$p(X,Y)\leftarrow q(U) $};
			\node (C) at (3,-1) {$p(X,Y)\leftarrow r(V)$};
			\node (D) at (1.5,-3) {$p(X,Y) \leftarrow q(U), r(V)$};

			\path [->] (A) edge node[left] {} (B);
			\path [->] (A) edge node[left] {} (C);
			\path [->] (B) edge node[left] {} (D);
			\path [->] (C) edge node[left] {} (D);
		\end{tikzpicture}
	\end{center}
	\caption{Example for non-redundancy in refinement operator $\rho$}
	\label{fig:prop_refinment_op}
\end{figure}


Appendix
------

## Saturation Algorithm in PROGOL
\label{app_saturation}

### The Definite Mode Language
@muggleton1995inverse introduces for the purpose of saturating positive examples
the **definite mode language**.

The definite mode language is made up of two forms: modeh$(n, \text{atom})$ and modeb$(n, \text{atom})$.
Where $n$ is either an integer with $n \geq 1$ or '\*'.
$n$ is called *recall* represents the number of alternative solutions for instantiating
the atom, where '\*' means all solutions.
The atom is a ground atom, where the terms are either place markers or normal terms
with function symbols with own terms or constants. The place markers can have the the forms
$+$type, $-$type or #type, where type is a concrete type like int, float or any customized one.
$+$types are the input of the function, where $-$type specifies outputs. #types are
constants.
As earlier mentioned, does the background knowledge
and the given examples consist of a set of Horn clauses with form $C = a \leftarrow b_1 \ldots b_n$.
Let $M$ be the set of mode declarations. The clause $C$ is in the definite mode language
$\mathscr{L}(M)$ iff

1. $a$ is the atom of a modeh declaration in $M$ with every place marker with $+$type and $-$type
is replaced by a variable and each #type is replaced by a ground term.
2. Every atom $b_i$ is the atom of a modeb declaration in $M$ with every place marker with $+$type and $-$type
is replaced by a variable and each #type is replaced by a ground term.
3. Every variable of $+$type in any atom $b_i$ is either of $+$type in $a$ or of $-type$ in some
   atom $b_j, 1 \leq j < i$.


Some examples to visualize mode declarations.
Assume the following statement which represents the equation $A+B=C$.
\begin{align}
\text{plus}(A,B,C).
\end{align}
Transformed into mode language leads to:
\begin{align}
	\text{modeh}(1, plus(+int, +int, -int))
\end{align}

This declaration demonstrates a relation between different atoms. Moreover
it is now possible deducing relations from atoms of positive examples.



The saturation step takes all horn clauses of the positive examples
with the form $a \leftarrow b_1 \ldots b_n$ and with the mode declarations
of the background knowledge and $a$. Then PROGOL takes the variables,
which replace the $+$type in $a$ and let Prolog deduce each possible term
by the background knowledge.

#References
