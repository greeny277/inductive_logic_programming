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
Invented by Plotkin.

Algorithm:

1. Build for each positive example $e$ an implication
   with $B \to e$

2. Convert each implication to clause normalform: $\neg B \vee e$

3. *Anti-unify* each compatible pair of literals
