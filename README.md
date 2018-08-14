Seminar: Machine Learning
====

Participation during Winter Term 2016/2017

Author
---

Christian Bay (christian.bay@fau.de)

What is it all about
-----

*Inductive logic programming* is a sub-field of *machine learning* with components of
logic based programming and knowledge representation.

The basic algorithm for an ILP-based approach is displayed in ![this](doc/images/process2cut.pdf)
flow graph.

The background knowledge consists of a bunch of different facts and rules.
The main task of the system is to generate new and  hopefully very general rules for the
background knowledge. Therefore the program gets feed with positive and
negative examples of a certain matter. Afterwards the program tries to
deduce the most general rule which fulfils all positive and no
negative example. Subsequently the generated rule, what is called *hypothesis*
is added to the background knowledge.

The underlying logic and basic algorithms are described in my elaboration and can be found under `doc/`.

Implementation
----

Under `src` I implemented the *rlgg* algorithm by using [Prolog](http://www.swi-prolog.org/).

To test some code, I recommend installing the Prolog interpreter [swipl](http://www.swi-prolog.org/Download.html):

```
>>> swipl src/base_of_knowledge.pl
?- test_1(X).
X = [parent(x_helen_tom, x_eve_mary), female(x_eve_mary)]
```
