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
is used as represeantion for **background knowledge**, **examples**
and **hypothesis**.

This term ILP for the first time was introduced at Stephen Muggleton
by 1991.

Common resolver are PROGOL and GOLEM.

Formal Definition
-----------------------------
The background knowledge $B$ has the form of **Horn clauses**
(a disjunction with at most one positive literal).

For instance:

$(p \wedge q \wedge t) \to u$

Which can be converted to a disjunction as following:

$\lnot p \vee \lnot q \vee \lnot t \vee u$

The Prolog notation for this purpose is:

```prolog
u :- p, q, t
```

The examples are splitted in two subgroups. Positive $E^{+}$
and negative $E^{-}$ examples composed of only unnegated
and negated ground literals respectively.

A correct hyptothesis $H$ is a logic propostion satisfying
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
This algorithm was the basic of GOLEM. It was invented by Plotkin[@plotkin1970note].

Algorithm:

1. Build for each positive example $E'$ an implication
   with $B \to E'$

2. Convert each implication to clause normalform: $\neg B \vee E'$

3. Build the *lgg* of each compatible pair of literals

4. Delete all negated literals containing variables that don't occur in a positive literal

5. Convert final clause back to Horn form.

#### Inductive Generalization
The *rlgg* algorithm depends heavily on Plotkins generalization of literals (*lgg*).

The notation is as following: $P$ is a predicate, $g,f$ are symbols and $z$ is a variable.
A word $W$ is a term or a variable.

The lgg algorithm is defined as followed:

1. Choose two compatible words $V_1$ and $V_2$.
2. Try to find terms $t_1,t_2$ such that $t_1 \neq t_2$
and both have the same position in $V_1$ and $V_2$. The terms
$t_{1}$ and $t_2$ either needs to start with different function
letters or else at least one of them is a variable.
3. When no such $t_1$ and $t_2$ are existing, the algorithm terminates.
4. Choose a variable $x$ which is free in $V_1$ and $V_2$ and replace each
$t_1$ in $V_1$ respectively $t_2$ in $V_2$ with $x$, if they occur in the **same** place.
5. Add to substitution list $\theta_1$ the subsitution $\{t_1 | x\}$ and to
 $\theta_2$ respectively $\{t_2 | x\}$.
6. Goto 2.

Let use this algorithm to finde the *least general generalisation* of the terms
$V\_1 = P(f(x), g(z))$ and $V\_2 = P(f(g(z)), g(z))$:

We take:
$t\_1 = f(x); t\_2= g(z)$ and $v$ as new variable.

$V\_1 = P(f(v), g(z))$ and $V\_2 = P(f(v), g(z))$:

with: $\epsilon\_1 = \{x | v\}$ and $\epsilon\_2 = \{g(z) | v\}$


### Inverse Entailment and Inverse Subsumption
Another approach has been introduced by Stephen Muggleton in his
resolver named PROGOL. It is called **Inverse Entailment**.
The motivation layed in the following problems by the **rlgg** approach[@muggleton1995inverse]:

1. If the background knowledge $B$ is an unrestricted definite clause there may
be no finite $rlgg_B(E)$.

2. The new hypotheses $H$ may grow exponentialy. Assume $B$ has $n$ and $E$
$m$  ground literals. Than $rlgg_B(E)$ may consist of $(n + 1)^m$ ground literals.

3. Concepts with multiple hypothesis can not be learned since
$rlgg_B(E)$. is a single clause.

The general idea is to find a *bridge hypothesis* $F$ [@yamamoto2010inverse]. But from the beginning:
We need to find an hyptothesis such that Sufficiency, Necessity, Weak and Strong
consistency holds.
Those requirements leeds to $B \wedge \neg E \vDash \neg H$. This equivalency
means that $H$ can be computed by deducing its negation $\neg H$ from $B$ and
$\neg E$ as follows:

\begin{align}
B \wedge \neg E \vDash F_1 \vDash \ldots \vDash F_i \vDash \neg H
\end{align}

At next the negation of the bridge theory $F_i$ can be generalizised into
the hypothesis $H$ with inverse relation of entailment.

\begin{align}
\neg(B \wedge  \neg E) \Dashv \neg F_i \Dashv \ldots \Dashv \neg F_i \Dashv
\ldots \Dashv \neg F_n \Dashv H
\end{align}

The tricky part about inverse entailment is that many different operaters can be
applied with many choice-points. The reason for this is, that it's general
undecidable wheter one definite clause implies another.

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
#References
