---
title: "Inductive Logic Programming"
author: Christian Bay
bibliography: ref.bib
---

Inductive Logic Programming
=============================

General
-----------------------------
ILP is a subfield of **machine learning**. The logic programming
is used as representation for **background knowledge**, **examples**
and **hypothesis**.

This term ILP for the first time was introduced at Stephen Muggleton
by 1991.

Common resolver are PROGOL and GOLEM.

First order logic
--------------------------

For a better understanding of how *Inductive logic programming* with its
algorithms works it is necessary to know the syntax and semantics of
*first order logic* (FOL).

### Syntax

\begin{align*}
\varphi ::= E \mid p(E_1, \ldots , E_n) \mid | \neg \varphi \mid \varphi_1 \wedge \varphi_2 \mid
\forall X.\varphi \hfill(X \in Var, p/n \in \Sigma)\\
E ::= X \mid f(E_1, \ldots, E_n) \hfill (f/n \in \Sigma)
\end{align*}

Where $\Sigma$ is a signature with a tuple $(C,F,P)$ of sets with
\begin{itemize}
	\item $C$ is the set of constant symbols with arity $= 0$
	\item $F$ is the set of function symbols with arity $\geq 0$
	\item $P$ is the set of predicate symbols with arity $\geq 0$
\end{itemize}

$Var$ contains all variable symbols $v_0, \ldots, v_n$.

#### Terms

Terms are inductively defined as:
\begin{itemize}
	\item Every variable and constant is a term
	\item Every expression $f(t_1, \ldots, t_n)$ is a term
\end{itemize}

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
	\mathfrak{I}(v) := \beta(v), v \in Var\\
	\mathfrak{I}(c) := c^\mathfrak{A}, c \in \Sigma\\
	\mathfrak{I}(f(t_1, \ldots, t_n) := f^\mathfrak{A}(\mathfrak{I}(t_1), \ldots, \mathfrak{I}(t_n), f/n \in \Sigma
\end{align}

A model $\mathfrak{M}$ is an interpetaion $\mathfrak{I}$ for a $\Sigma$ expression $\varphi$,
written $\mathfrak{M} \vDash \varphi$ when the following rules hold:

TODO


Formal Definition
-----------------------------



The background knowledge $B$ has the form of **Horn clauses**
(a disjunction with at most one positive literal).

For instance:

$\lnot p \vee \lnot q \vee \lnot t \vee u$

Which can be converted to an implication as following:

$(p \wedge q \wedge t) \to u$

The Prolog notation for this purpose is:

```prolog
u :- p, q, t
```

The examples are split in two subgroups. Positive $E^{+}$
and negative $E^{-}$ examples composed of only non-negated
and negated ground literals respectively.

A correct hyptothesis $H$ is a logic proposition satisfying
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

Algorithms for hypothesis search
---------------------------------
### Relative least general generalization (rlgg)
This algorithm was the basic of GOLEM. It was invented by @plotkin1970note.

Algorithm:

<!-- TODO: Introduce \theta_{1,2} -->
1. Build for each positive example $E'$ an implication
   with $B \to E'$ <!-- TODO: Mentioning/Defining Saturation! -->

2. Convert each implication to clause normalform: $\neg B \vee E'$

3. Build the *lgg* of each compatible pair of literals

4. Delete all negated literals containing variables that don't occur in a positive literal

5. Convert final clause back to Horn form.

#### Inductive Generalization
The *rlgg* algorithm depends heavily on Plotkins generalization of literals (*lgg*).

The notation is as following: $P$ is a predicate, $g,f$ are symbols and $z$ is a variable.
A word $W$ is a term or a variable.

The lgg algorithm is defined as followed:

<!-- TODOS: Use algorithm package. What does "compatible" mean? Begins with same predicate, function
symbol or variable? -->

1. Choose two compatible words $V_1$ and $V_2$.
2. Try to find terms $t_1,t_2$ such that $t_1 \neq t_2$
and both have the same position in $V_1$ and $V_2$. The terms
$t_1$ and $t_2$ either needs to start with different function
letters or else at least one of them is a variable.
3. When no such $t_1$ and $t_2$ are existing, the algorithm terminates.
4. Choose a variable $x$ which is free in $V_1$ and $V_2$ and replace each
$t_1$ in $V_1$ respectively $t_2$ in $V_2$ with $x$, if they occur in the **same** place.
5. Add to substitution list $\theta_1$ the substitution $\{t_1 | x\}$ and to
 $\theta_2$ respectively $\{t_2 | x\}$.
6. Goto 2.

Let us use this algorithm to find the *least general generalisation* of the terms
$V_1 = P(f(x), g(z))$ and $V_2 = P(f(g(z)), g(z))$:

We take:
$t_1 = f(x); t_2= g(z)$ and $v$ as new variable.

$V_1 = P(f(v), g(z))$ and $V_2 = P(f(v), g(z))$:

With: $\epsilon_1 = \{x | v\}$ and $\epsilon_2 = \{g(z) | v\}$


### Inverse Entailment and Inverse Subsumption
Another approach has been introduced by Stephen Muggleton in his
resolver named PROGOL. It is called **Inverse Entailment**.
The motivation laid in the following problems by the **rlgg** approach[@muggleton1995inverse]:

1. If the background knowledge $B$ is an unrestricted definite clause there may
be no finite $rlgg_B(E)$.

2. The new hypotheses $H$ may grow exponentially. Assume $B$ has $n$ and $E$
$m$  ground literals. Than $rlgg_B(E)$ may consist of $(n + 1)^m$ ground literals.

3. Concepts with multiple hypothesis can not be learned since
$rlgg_B(E)$. is a single clause.

The general idea is to find a *bridge hypothesis* $F$ [@yamamoto2010inverse]. But from the beginning:
We need to find an hypothesis such that Sufficiency, Necessity, Weak and Strong
consistency holds. The *deduction theorem* in first order logic proofs that
$B \wedge H \vDash E$ is logically equivalent to $B \wedge \neg E \vDash \neg H$.
This equivalency means that $H$ can be computed by deducing its negation $\neg H$
from $B$ and $\neg E$ as follows:

\begin{align}
B \wedge \neg E \vDash F_1 \vDash \ldots \vDash F_i \vDash \neg H
\end{align}

At next the negation of the bridge theory $F_i$ can be generalized into
the hypothesis $H$ with inverse relation of entailment.

\begin{align}
\neg(B \wedge  \neg E) \Dashv \neg F_1 \Dashv \ldots \Dashv \neg F_i \Dashv
\ldots \Dashv \neg F_n \Dashv H
\end{align}

The tricky part about inverse entailment is that many different operators need to be
applied to it until a result will be found. In addition it takes a huge
amount of search space.
<!-- The reason for this is, that it's general
undecidable whether one definite clause implies another.
 Wie genau hängen Inverse Entailment und die
Unentscheidbarkeit der Implikation von Klauseln zusammen? -->

#### Subsumption
Therefore PROGOL[@muggleton1995inverse] uses subsumption due to computational
efficiency.

#####Definiton:
Let $C$ and $D$ be clauses. $C$ subsumes $D$ if there exists a $\theta$
such that $C\theta \subseteq D$, also written $C \succeq D$.

For instance:
\begin{align}
	p(a, X) \vee p(b,Z) \succeq p(a,c)\\
	\theta=\{X | c\}.
\end{align}

In @yamamoto2010inverse work it has been shown that inverse subsumption
is an alternative generalization method to inverse entailment.
Thus the searched hypothesis $H$ can be found through the following relations:

\begin{align}
\neg(B \wedge  \neg E) \Dashv \neg F_1 \Dashv \ldots \Dashv \neg F_i \preceq
\ldots \preceq \neg F_n \preceq H
\end{align}

In conclusion $H$ subsumes the clause $\neg F_i$ as well as $\neg(B \wedge  \neg E)$.

A solver like PROGOL has two different tasks to solve for generating the final hypothesis $H$:

1. Obtain $\neg F_i$ from $\neg(B \wedge  \neg E)$ by inverse entailment.
2. Obtain $H$ from $\neg F_i$  by inverse subsumption.

The following sections are explaining both procedures.

#### Inverse Entailment

##### The Definite Mode Language
@muggleton1995inverse introduces for the purpose of obtaining $\neg F_i$
the definite mode language. 
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

##### Saturation
The saturation step takes all horn clauses of the positive examples
with the form $a \leftarrow b_1 \ldots b_n$ and with the mode declarations
of the background knowledge and $a$. Then PROGOL takes the variables,
which replace the $+$type in $a$ and let Prolog deduce each possible term
upon the background knowledge.

The concrete specification of the algorithm is a bit complex and not that
important. A little example with some notes shows how it in general works:


#### Inverse Subsumption
##### Refinement Operators
After the clause $\neg F_i$ has been evaluated,
this section shows how an hypothesis can $H$ derived from $\neg F_i$.

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

The example \ref{fig:refinement_operator} shows a refinement graph with some operators.
The numeration of the operators is referring to the enumeration above.
\begin{figure}[h]
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

\begin{figure}[h]
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

<!-- TODO: Beispiel Graph der zeigt wie mit Subsumption
           allgemeinste klausel gefunden wird.  -->

$H$ has an upper and lower border:

\begin{align}
\Box \succeq H \succeq F_i
\end{align}
Where $\Box$ is the empty clause.


#References
