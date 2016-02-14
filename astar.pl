goal(N, Target) :- 0 is N mod Target.

arc(N, M, Seed, ParentCost, Cost, Target, H) :- M is N * Seed, Cost is 1 + ParentCost, h(M, H, Target).
arc(N, M, Seed, ParentCost, Cost, Target, H) :- M is N * Seed + 1, Cost is 2 + ParentCost, h(M, H, Target).

h(N, Hvalue, Target) :- goal(N, Target), !, Hvalue is 0;
                        Hvalue is 1 / N.

search([[Node, _, _]|_], _, Target, Node) :- goal(Node, Target).
search([[Node, ParentCost, _]|FRest], Seed, Target, F) :- setof([X, Cost, H], arc(Node, X, Seed, ParentCost, Cost, Target, H), FNode),
                                                          addtofrontier(FNode, FRest, FNew),
                                                          search(FNew, Seed, Target, F).

addtofrontier(FNode, FRest, FNew) :- append(FNode, FRest, Appended),
                                     insert_sort(Appended, FNew).

insert_sort(List, Sorted) :- i_sort(List, [], Sorted).
i_sort([], Acc, Acc).
i_sort([H|T], Acc, Sorted) :- insert(H, Acc, NAcc), i_sort(T, NAcc, Sorted).
insert(X, [Y|T], [Y|NT]) :- lessthan(Y, X), insert(X, T, NT).
insert(X, [Y|T], [X, Y|T]) :- lessthan(X, Y).
insert(X, [], [X]).

lessthan([_, Cost1, H1], [_, Cost2, H2]) :- F1 is Cost1 + H1, F2 is Cost2 + H2,
                                            F1 =< F2.

astar(Start, Seed, Target, Found) :- search([[Start, 0, 0]], Seed, Target, Found).
