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

Programs which are using an ILP-based approach do proceed as displayed in the following flow-graph:

![alt text](doc/images/process2cut.pdf)


Under `doc/` you can find my elaboration about this topic.

Implementation
----

Under `src` I implemented the *rlgg* algorithm by using [Prolog](http://www.swi-prolog.org/).

To test some code, I recommend installing the Prolog interpreter [swipl](http://www.swi-prolog.org/Download.html):

```
>>> swipl src/base_of_knowledge.pl
?- test_1(X).
X = [parent(x_helen_tom, x_eve_mary), female(x_eve_mary)]
```
