Inductive Logic Programming
=============================

General
-----------------------------
ILP is a subfield of **machine learning**. The logic programming
is used as represeantion for **background knowledge**, **examples**
and **hypothesis**.

This term ILP for the first time was introduced at Stephen Muggleton
by 1991.

Common resolver are PROLOG and GOLEM.

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

A correct hyptothesis $h$ is a logic propostion satisfying
following requirements:

* Necessity:          $B \nvDash E^{+}$

     Forbids gerneration of hypothesis as long as positive facts
     can be explained without it.

* Sufficiency:        $B \wedge h \vDash E^{+}$

     The hypothesis $h$ need to entail all positive
     examples in $E^{+}$.

* Weak consistency:   $B \wedge h \nvDash false$

     $h$ is not allow to contradict the background knowledge $B$.

* Strong consistency: $B \wedge h \wedge E^{-} \nvDash false$

     $h$ is not allow to contradict the negative examples $E^{-}$ either.

Algorithms for hypothesis search
---------------------------------
### Relative least general generalization (rlgg)
This algorithm was the basic of GOLEM. It was invented by Plotkin.

Algorithm:

1. Build for each positive example $e$ an implication
   with $B \to e$

2. Convert each implication to clause normalform: $\neg B \vee e$

3. *Anti-unify* each compatible pair of literals

4. Delete all negated literals containing variables that don't occur in a positive literal

5. Convert final clause back to Horn form.

#### Inductive Generalization
The *rlgg* algorithm depends heavily on Plotkins generalization of literals.

The notation is as following: $P$ is a predicate, $g,f$ are symbols and $z$ is a variable.
A word $W$ is a term or a variable.

The algorithm lgg algorithm:

1. Choose two compatible words $V1$ and $V2$.
2. Try to find terms $t\_1,t\_2$ such that $t\_1 \neq t\_2$
and both have the same position in $V\_1$ and $V\_2$. Either
$t\_{1}$ and $t\_{2} either needs to start with different function
letters or else at least one of them is a variable.
different function letters.
3. When no such $t\_{1,2}$ exist, the algorithm terminates.
4. Choose a free variable $x$ and replace each
$t\_{1,2}$ in $V\_{1,2}$ with $x$, if they occur in the **same** place.
5. Add to substitution list
6. Goto 2.

Let use this algorithm to finde the *least general generalisation* of the terms
$V\_1 = P(f(x), g(z))$ and $V\_2 = P(f(g(z)), g(z))$:

We take:
$t\_1 = f(x); t\_2= g(z)$ and $v$ as new variable.

$V\_1 = P(f(v), g(z))$ and $V\_2 = P(f(v), g(z))$:

with: $\epsilon\_1 = \{x | v\}$ and $\epsilon\_2 = \{g(z) | v\}$
