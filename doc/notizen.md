---
title: "Inductive Logic Programming"
author: Christian Bay
date: \today
geometry: true
numbersections: true
links-as-notes: true

---

Inductive Logic Programming
=============================

Introduction
-----------------------------
*Inductive logic programming* is a sub-field of *machine learning* with components of
logic based programming and knowledge representation.

Programs which are using an ILP-based approach do proceed as is displayed
by Figure \ref{fig:flowchart}. In the beginning the environment which does include every
necessary information, needs to be formalised in some kind of logic (see \secref{ssec:fol}).


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
deduce the most general rule which fulfils all positive and no
negative example. Subsequently the generated rule, what is called *hypothesis*
is added to the background knowledge.

Hypotheses are classified by two factors: *complete* and *consistent*. The first
one indicated that the hypothesis fulfils each positive example, while
the second factor displays that no negative example is fulfilled.
In Figure \ref{fig:hypo} the four classes are shown.

\begin{figure}[h]
	\begin{center}
		\includegraphics[scale=0.3]{images/hypothesis.png}
	\end{center}
	\caption{Shown is the classification of hypotheses, where the denotation is as follows: background knowlegde is
		$B$, positive examples $\mathcal{E}^+$, negative examples $\mathcal{E}^-$ and the hypothesis is $\mathcal{H}$.}
	\label{fig:hypo}
\end{figure}

Represented in a logical manner an hypothesis $\mathcal{H}$ has to satisfy
following requirements:

* Necessity:          $\mathcal{B} \nvDash \mathcal{E}^{+}$

     A new hypthesis should only be generated when the background-knowledge alone can't
	 explaine all positive examples.

 * Sufficiency:        $\mathcal{B} \land \mathcal{H} \vDash \mathcal{E}^{+}$

     The hypothesis $\mathcal{H}$ needs to entail all positive examples $\mathcal{E}^{+}$.

* Weak consistency:   $\mathcal{B} \land \mathcal{H} \nvDash false$

     $\mathcal{H}$ is not allow to contradict the background knowledge $\mathcal{B}$.

 * Strong consistency: $\mathcal{B} \land \mathcal{H} \land \mathcal{E}^{-} \nvDash false$

	 $\mathcal{H}$ is not allow to contradict the negative examples $\mathcal{E}^{-}$ either.



First order logic (FOL) {#ssec:fol}
------
Popular ILP-engines have in common that each of them are  using *first order logic*
to represent the environment. Therefore its syntax and semantic is briefly
introduced here to give a basic understanding.

### Syntax

The syntax of FOL does consist out of two different parts, which are
*terms* and *literals*.


#### Terms

In FOL terms denote objects in the world. They are inductively defined as:
\begin{itemize}
	\item Every variable and constant is a term.
	\item Every expression $f(t_1, \ldots, t_n)$ is a term.
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
be assigned to. The grammar of atoms looks as follows:

\begin{align*}
	Atom := p(Term_1, \ldots, Term_n) \mid Term_1 = Term_2  \hspace{1cm} \text{ where } p \in P
\end{align*}
- $P$ is the set of predicate symbols with arity $\geq 0$.

Literals are atoms, which can be negated too.


### Semantic

The defined syntax is just a series of symbols without any meaning. Therefore
a structure $\mathfrak{A}$ on $\Sigma=(C,F,P)$ is defined. It contains a non-empty set $D$
together with:
\begin{itemize}
	\item an element $c^{\mathfrak{A}} \in D$ for each  $c \in  \Sigma$
	\item a function $f^{\mathfrak{A}} : D^n \rightarrow D$ for each $f/n \in \Sigma$
	\item a predicate $p^{\mathfrak{A}} \subseteq D^n$ for each $p/n \in \Sigma$
\end{itemize}

An interpretation $\mathfrak{I}$ is a pair $\mathfrak{I} = (\mathfrak{A}, \beta)$ with
$\beta : \{v \mid v \in Var\} \rightarrow D$.

Terms get interpreted as follows:

\begin{align}
	\mathfrak{I}(v) &:= \beta(v), v \in Var\\
	\mathfrak{I}(c) &:= c^\mathfrak{A}, c \in \Sigma\\
	\mathfrak{I}(f(t_1, \ldots, t_n) &:= f^\mathfrak{A}(\mathfrak{I}(t_1), \ldots, \mathfrak{I}(t_n), f/n \in \Sigma
\end{align}

A model $\mathfrak{M}$ is an interpetaion $\mathfrak{I}$ for a $\Sigma$ expression $\varphi$,
written $\mathfrak{M} \vDash \varphi$, if each interpretation
$\mathfrak{I}$ which does fulfil all formulas in $\Sigma$, in addition fulfils $\varphi$.


General tools
---------

### Horn clauses

A *horn clauses* is a disjunction of clauses with at most one positive literal. Furthermore
definite program clauses are horn clauses with exactly one positive literal.

For instance:

\begin{align}
	\lnot p \lor \lnot q \lor \lnot t \lor u
\end{align}

Which can be converted to an implication as following:

\begin{align}
	(p \land q \land t) \to u
\end{align}

The programming language *Prolog* has a logic-based programming paradigm
and represents facts and statements as horn clauses because they can be checked by *breadth-first
search*. The statement in Equation \ref{al:ex1} says that someone is a daughter,
when the statements that the person is female and has parents become true.
\begin{align}
	\label{al:ex1}
	daugther(X, Y) \leftarrow female(X) \land parent(Y,X)\\
	\Leftrightarrow daugther(X, Y) \lor \neg female(X) \lor \neg parent(Y,X)
\end{align}

### Subsumption

A huge difficulty by finding good hypothesis is the enormous size of search space it can
exist in. Therefore subsumption helps to find some boundaries.

\begin{definition}
Subsumption for literals.

Let $L_1$ and $L_2$ be literals. $L_1$ subsumes $L_2$ iff there exists a $\theta$
such that $L_1\theta = L_2$, also written $L_1 \preceq L_2$.

For instance:
\begin{align}
	p(f(x), X) \preceq p(f(a),a)\\
	\theta=\{X | a\}.
\end{align}
\end{definition}

\begin{definition}
Subsumption for clauses.

Let $C$ and $D$ be clauses. $C$ subsumes $D$ iff there exists a $\theta$
such that $C\theta \subseteq D$, also written $C \preceq D$.

For instance:
\begin{align}
	p(a, X) \lor p(b,Z) \preceq p(a,c)\\
	\theta=\{X | c\}.
\end{align}
\end{definition}

The most important property in the context of ILP is the following theorem.

\begin{thm}
	\label{thm:subs}
	$C_1 \preceq C_2 \rightarrow C_1 \vDash C_2$
\end{thm}
Therefore a subsumption relation between two clauses implies their logical consequence.

Now a partial ordered set (POSET) $(X, \preceq)$ is defined, where $X$ is a set of literals. One
literal is greater than each other literal it subsumes.
POSETs have in general two special members $\top, \bot$. $\top$ is greater and $\bot$ is lower than
each other member in $X$. With a given set of predicates the POSET constructs a lattice of atomic
formulas (see Example \ref{ex:poset_atomic}).

\begin{bsp}
Given is a binary predicate $p$, a constant $a$ and an unlimited set
of variables.

	\begin{figure}[h]
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
	\label{ex:poset_atomic}
\end{bsp}



Algorithms for hypothesis search
---------------------------------

This chapter presents two main strategies to obtain a new hypothesis $\mathcal{H}$. Both are using
the introduced subsumption technique. The *rlgg* algorithm searches the hypothesis space in a bottom-up
manner using generalization. On the other hand a specialization technique is shown using
refinement graphs [see @dzeroski1994inductive pp. 39-42, 53-57].

### Bottomoup -- Relative least general generalization (rlgg)

The ILP-solver GOLEM is based on this algorithm invented by @plotkin1970note.
As mentioned earlier an hypothesis is searched which entails the positive examples
but not any negative one by using the background knowledge:
$\mathcal{B} \land \mathcal{H} \vDash \mathcal{E}^+$. This formula can be converted to
$\mathcal{H} \vDash \mathcal{B} \rightarrow \mathcal{E}^+$.

By Theorem \ref{thm:subs} it is known that an adequate hypothesis $\mathcal{H}$ subsumes $\mathcal{B}
\rightarrow \mathcal{E}^+$ for each positive example in $\mathcal{E}^+$.
Figure \ref{fig:poset_atomic} shows  on the basis of a little example how the POSET $(X, \preceq)$
extends to a lattice of clauses. Therefore a clause subsumes each clause which is below itself
and in reverse gets subsumed by each clause above.

\begin{definition}
	Least general generalization.

	The lowest upper bound of two formulas is called their least general generalization.
\end{definition}

\begin{definition}
	Relative least general generalization.

	Given two positive examples $e_1$ and $e_2$ and a conjecture $\mathcal{K}$ of the background knowledge
	consisting of ground facts the rlgg is defined as:
	\begin{align}
		rlgg(e_1, e_2) = lgg((e_1 \leftarrow K), (e_2 \leftarrow K))
	\end{align}
\end{definition}


@plotkin1970note introduced an algorithm for determining the *least generalization* for two given terms or literals.
The lgg-algorithm for terms is defined as follows:

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
$lgg(p(f(x), g(z)), p(f(g(z)), g(z))$:

\begin{align}
	&lgg(p(f(x), g(z)), p(f(g(z)), g(z))\\
	&= p(lgg(f(x), f(g(z)), lgg(g(z), g(z)))\\
	&= p(f(lgg(x, g(z)), g(z))\\
	&= p(f(\varphi(x, g(z)), g(z))\\
	&= p(f(v), g(z))\\
\end{align}
$\Rightarrow \epsilon_1 = \{x | v\}$ and $\epsilon_2 = \{g(z) | v\}$
\end{bsp}
<!--
The last missing step to receive the searched hypothesis $h$ is to lift this
POSET construct towards clauses.
Because the searched hypothesis is a formula, that each
clauses of kind $\neg B \lor E$ can be generalized to, where $E$ is any any positive
example and $B$ the background knowlegde.
-->

The least generalization for clauses computes the $lgg$ for each pair of the two clauses
and builds a new clause out of the results excluding $\top$.
\begin{algorithm}[H]
	\KwIn{Clauses $C_1 = l_{1,1} \lor \ldots \lor l_{1,n}$ and $C_2 = l_{2,1} \lor \ldots \lor l_{2,m}$}
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
Compute the $lgg$ of two clauses:
\begin{align}
C_1 &= p(a, f(a)) \lor p(b,b) \lor \neg p(b, f(b))\\
C_2 &= p(f(a), f(a)) \lor p(f(a),b) \lor \neg p(a, f(a))
\end{align}

\begin{align}
	lgg(C_1, C_2) = p(X, f(a)) \lor p(X, Y) \lor p(Z, Z) \lor p(Z, b) \lor \neg p(U, f(U))
\end{align}
\end{bsp}

The hypothesis $\mathcal{H}$ is obtained in a tournament based way as shown in Figure
\ref{fig:rlgg}.

\pgfdeclarelayer{background}
	\begin{figure}[H]
		\begin{center}
		\pgfsetlayers{background,main}
		\tikzstyle{vertex}=[rectangle,fill=black!25,minimum size=20pt,inner sep=0pt]
		\tikzstyle{selected vertex} = [vertex, fill=red!24]
		\tikzstyle{edge} = [draw,thick,-]
		\tikzstyle{weight} = [font=\small]
		\tikzstyle{selected edge} = [draw,line width=5pt,-,red!50]
		\begin{tikzpicture}[scale=1.0, auto,swap]
		\node[vertex] (a) at (0,0) {$A = e_1 \leftarrow K$};
		\node[vertex] (b) at (2.5,0) {$B = e_2 \leftarrow K$};
		\node[vertex] (c) at (5,0) {$C = e_3 \leftarrow K$};
		\node[vertex] (d) at (7.5,0) {$D = e_4 \leftarrow K$};
		\node[vertex] (e) at (1.25,2) {$C' = lgg(A, B)$};
		\node[vertex] (f) at (6.25,2) {$C''= lgg(C, D)$};
		\node[vertex] (g) at (3.75,4) {$\mathcal{H} = lgg(C', C'')$};
		\begin{pgfonlayer}{background}
			\path[selected edge] (a.center) -- (e.center);
			\path[selected edge] (b.center) -- (e.center);
			\path[selected edge] (c.center) -- (f.center);
			\path[selected edge] (d.center) -- (f.center);
			\path[selected edge] (e.center) -- (g.center);
			\path[selected edge] (f.center) -- (g.center);
		\end{pgfonlayer}
		\end{tikzpicture}
		\end{center}
		\caption{The $rlgg$-alogrithm to obtain a new hypothesis $\mathcal{H}$.}
		\label{fig:rlgg}
	\end{figure}
Now it is possible to create a POSET of clauses $(X, \preceq)$ where $X$ contains all variants
of a starting clause and $\top$ and $\bot$.


\begin{bsp}
	In Figure \ref{fig:fam_rel} an easy family relation is given and the algorithm has to
	derive a rule for if someone is a daughter.

	\begin{figure}[H]
		\begin{center}
			\begin{tikzpicture}[scale=0.6]
				\node (A) at (0, 2)  {\color{blue}georg};
				\node (B) at (2,0)   {\color{red}mary};
				\node (C) at (4, 2)   {\color{red}ann};
				\node (D) at (6,0)   {\color{blue}tom};
				\node (E) at (8, -2) {\color{red}eve};

				\path [->] (A) edge node[above] {} (B);
				\path [<-] (B) edge node[above] {} (C);
				\path [->] (C) edge node[above] {} (D);
				\path [->] (D) edge node[above] {} (E);
			\end{tikzpicture}
		\end{center}
		\caption{A simple family relation.}
		\label{fig:fam_rel}
	\end{figure}

	The background knowledge consists only of ground terms of
	the two predicates $parent (p)$ and  $female (f)$.
	The positive examples are both existing daughters Eve and Mary.
	The formulas are using only the first letter of each name as abbrevations.

	\begin{align}
		K   &= p(a,m), p(a,t), p(t,e),\\ &p(t,i), f(a), f(m), f(e)\\
		e_1 &= daughter(m, a)\\
		e_2 &= daughter(e, t)
	\end{align}

	Applying the $rlgg$ algorithm ends up as a huge equation (see Equation \ref{eq:fam}) where only
	the underlined parts are relevant for the result.

	\begin{gather}
		\begin{split}
			\underline{d(V_{m,e}, V_{a,t})} \leftarrow &\; p(a,m), p(a,t), p(t,e), p(t,i), f(a), f(m), f(e),\\
			&\; p(a, V_{m,t}), \underline{p(V_{a,t}, V_{m,e})}, p(V_{a,t}, V_{m,i}), p(V_{a,t}, V_{t,e}),\\
			&\; p(V_{a,t}, V_{t,i}) ,p(t, V_{e,i}), f(V_a, m), f(V_{a,e}), \underline{f(V_{m,e})}
		\end{split}
		\label{eq:fam}
	\end{gather}
\end{bsp}

The $rlgg$ algorithm has a few disadvantages:

1. The algorithm ends up with only one clause. Hypothesis containing multiple clauses can't be
   found.

2. The combination of the $lgg$ pairs determine the quality of the resulting hypothesis.

3. $\mathcal{H}$ becomes very huge even for small problems.


###Top-Down -- Refinement graph

Another way of getting a new hypothesis is to start with the targeting
predicate and step by step building a clause lattice. The ILP-solver PROGOL
which was invented by @muggleton1995inverse is using the algorithm.

Therefore @shapiro1983algorithmic introduced a concept of *refinement operators*
to create more specific clauses, which still get subsumed by the former one.

#### Refinement Operators

The refinement operator $\rho$ is defined as follows:
\begin{align}
\forall D \in \rho(C). C \preceq D
\end{align}

Common refinement operators are (see @muggleton1995inverse page 265):

1. Substitute for one variable a term built from a functor of
arity $n$ and $n$ distinct and not in the clause existing variables:
$\theta=\{X | f(Y_1, \ldots, Y_n)\}$.

2. Substitute for one variable another variable already in the clause:
$\theta=\{X | Y\}$.

3. Add a literal $l_k = p(u_1, \ldots, u_m)$, which is the $k$-th literal of $F_i$, where each
	$u_j$ with $1 \leq j \leq m$ is substituted by $\{v_j|u_j\} \in \theta$ or
	$\theta' = \theta \cup \{v_j|u_j\}$.
<!-- TODO Das stimmt so nicht. Siehe Muggleton S.265 -->

Figure \ref{fig:refinement_operator} shows a refinement graph with some operators.
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
The set of operators shown in Figure \ref{fig:refinement_operator} is finite and complete but
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

#### Search algorithm

There are two common ways to search through a refinement graph. The complete
version takes every possible path and returns the best most specific complete and consistent
clause. A much faster but incomplete way is to follow paths which fulfil the most
positive examples. In return an incomplete and/or inconsistent hypothesis might be returned.
So there is always some kind of trade-off to be made.

Another way to decrease the search-space is to use one positive example as seed and search
between this and the starting point as displayed in Figure \ref{fig:seed}. Theorem
\ref{thm:subs} guarantees that the searched hypothesis has to exist in this area.
\begin{figure}[H]
	\begin{center}
		\begin{tikzpicture}
			\node[font=\tiny] (A) at (1.5,1) {$p(X,Y)$};
				\node[font=\tiny] (B) at (-1,0) {$p(X,X)$};
				\node[font=\tiny] (C) at (0.55,0) {$p(X,Y) \leftarrow r(U)$};
				\node[font=\tiny] (D) at (2.6,0) {$p(X,Y) \leftarrow q(V)$};
				\node[font=\tiny] (E) at (1.5,-2) {$p(X,Y) \leftarrow r(X), q(X), q(Y)$};
				\node[font=\tiny] (X) at (1.75, 0.5) {$\ldots$};
				\node[font=\tiny] (Y) at (0.6, 0.5) {$\ldots$};
				\node[font=\tiny] (B2) at (0.3,-1.3)  {};
				\node[font=\tiny] (C2) at (1.5,-1) {};
				\node[font=\tiny] (D2) at (3,-1.3) {};
				\node[font=\tiny] (B3) at (-1,-1.5) {\ldots};
				\node[font=\tiny] (D3) at (4,-1.5) {\ldots};
				\node[font=\tiny] (X2) at (1, -1.25) {$\ldots$};
				\node[font=\tiny] (Y2) at (2, -1.25) {$\ldots$};
	
				\path [->] (A) edge node[left] {} (B);
				\path [->] (A) edge node[left] {} (C);
				\path [->] (A) edge node[left] {} (D);
				\path [->] (B2) edge node[left] {} (E);
				\path [->] (C2) edge node[left] {} (E);
				\path [->] (D2) edge node[left] {} (E);
			\begin{scope}[label distance=0mm,]
				\coordinate  (aux1) at ([yshift=-15pt]A);
				\coordinate  (aux2) at ([yshift=+10pt]E);
				\node[regular polygon,regular polygon sides=5,draw, red,fit={(aux1) (aux2)},label=right:{\color{red}\small{Scope of the seed}}] {};
			\end{scope}
		\end{tikzpicture}
	\end{center}
	\caption{Refinement graph using a seed}
	\label{fig:seed}
\end{figure}


\begin{bsp}
	An example of the Top-Down approach:
	
	
	\begin{figure}[H]
		\begin{center}
			\begin{tikzpicture}[scale=1.5]
				\node[font=\tiny] (A) at (1.5,1) {$daughter(X,Y)\leftarrow$};
				\node[font=\tiny] (B) at (-1,0) {$daughter(X,Y) \leftarrow X = Y$};
				\node[font=\tiny] (C) at (0,-1) {$daughter(X,Y) \leftarrow female(X)$};
				\node[font=\tiny] (D) at (2.5,-0.5) {$daughter(X,Y) \leftarrow parent(Y,X)$};
				\node[font=\tiny] (E) at (4.5,0) {$daughter(X,Y) \leftarrow parent(X, Z)$};
				\node[font=\tiny] (F) at (-2,-1.75) {$daughter(X,Y)\leftarrow female(X), female(Y)$};
				\node[font=\tiny] (G) at (2.75, -1.75) {$daughter(X,Y) \leftarrow female(X), parent(Y,X)$};
				\node[font=\tiny] (X) at (1.35, -0) {$\ldots$};
				\node[font=\tiny] (Y) at (0.3, -1.5) {$\ldots$};
	
				\path [->] (A) edge node[left] {} (B);
				\path [->] (A) edge node[left] {} (C);
				\path [->] (A) edge node[left] {} (D);
				\path [->] (A) edge node[left] {} (E);
				\path [->] (C) edge node[left] {} (F);
				\path [->] (C) edge node[left] {} (G);
			\end{tikzpicture}
		\end{center}
		\caption{Part of the refinementgraph for the family constellation}
		\label{ex:refinement_operator}
	\end{figure}
\end{bsp}

Example -- Quantitative structure-activity relationship
====

It is a common task in the field of pharmacy to manipulate drugs with
a certain biological activity to improve their effect in some ways. For instance
to create better antidepressant drugs.
Therefore it is tried to predict the biological activity of molecules to save
money and time. Molecules like in Figure \ref{fig:qsar} can be manipulated at
some positions by substituting rest-groups with so called functional-groups.
Each of those functional-groups have physico-chemical properties like: polarity, size,
flexibility, hydrogen-bond donor, hydrogen-bond acceptor etc.

\begin{figure}[h]
	\begin{center}
		\includegraphics[scale=0.3]{images/qsar.png}
	\end{center}
	\caption{The structure of molecule Trimethoprim with three substitution positions on the phenyl
	ring.}
	\label{fig:qsar}
\end{figure}

Trimethoprim has three positions that can be substituted by 24 functional-groups each.
The standard procedure by *Hansch* formulates a linear equation system based on the physico-chemical
properties of the corresponding properties.

The ILP approach doesn't try to predict the activity of the unknown molecule only by its
properties [see @dzeroski1994inductive pp. 247-252], instead the following background knowledge
does exist:

1. The relation $struc(Drug, R_n, \ldots, R_1)$ states a drug an its substitutions at
each position.

2. A predicate for each chemical property of the substitutes, like $polar(subs, value)$.

3. Basic arithmetical knowledge.

The target relation $great(drugX, drugY)$ denotes that $drugX$ has a higher biological activity
than $drugY$. Positive examples are those where $drugX$ has an higher activity. Pairs where
$drugX$ has a lower activity are denoted as negative examples. Drugs with the same biological
activity are discarded.

The ILP system is able to derive rules like in Example \ref{ex:qsar} where an higher biological
activity is predicted if drug $B$ has no substitutions at position $3$ and $5$ and the
substituent $D$ in drug $A$ has specific properties.
\begin{bsp}
	\label{ex:qsar}
	\begin{lstlisting}[language=prolog]
		great(A,B) $\leftarrow$ struc(A,D,E,F), struc(B,h,C,h), flex(D,G),
		less_4_flex(G), h_donor(D, h_don_0), pi(D, po_don_1).
	\end{lstlisting}
\end{bsp}

The Table \ref{tab:correlation} shows how well ILP and Hansch performs for
a set of training data and unknown compounds. The correlation of drug
activity order predicted by the ILP approach is for the training set 0.92
and test set 0.46 up to 0.54 (depending on the used ILP engine). The method
by Hansch has 0.79 and 0.42, respectively.
\begin{center}
	\begin{tabular}{|c|c|c|}
		\hline
		& ILP & Hansch\\
		\hline
		Correlation training & 0.92 & 0.79\\
		\hline
		Correlation test     & 0.46 -- 0.54 & 0.42\\
		\hline
	\end{tabular}
	\captionof{table}{Correlationstable for QSAR}
	\label{tab:correlation}
\end{center}

It was stated that the complexity of the compounds has a massive influence
on the success of the ILP method. Other ILP-based real-world applications that
are worth being mentioned are for instance the prediction of protein secondary structures or learning
rules for early diagnosis of rheumatic diseases [see @dzeroski1994inductive pp. 243-246, 199-214].

Summary
====

This work gave a little overview about the topic *inductively logic programming* in the
context of machine learning. The general idea of developing new knowledge with a set of examples
and existing background knowledge was demonstrated by the two standard algorithms.
Furthermore a real-world application in the field of pharmacy has been presented. Nowadays different
engines are using various algorithms in combination to achieve better results and are able
to deal with imperfect data[see @dzeroski1994inductive pp. 67-80, 153-168]. It is also worth to
mention that ILP is still a topic in Computer-Science (for instance, see the work @yamamoto2010inverse),
because new insights in first-order logic can improve existing algorithms.


<!--
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
-->

#References
