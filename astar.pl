goal(N, Target) :- 0 is N mod Target.

arc(N, M, Seed, ParentCost, Cost, Target, H) :- M is N * Seed, Cost is 1 + ParentCost, h(M, H, Target).
arc(N, M, Seed, ParentCost, Cost, Target, H) :- M is N * Seed + 1, Cost is 2 + ParentCost, h(M, H, Target).

h(N, Hvalue, Target) :- goal(N, Target), !, Hvalue is 0;
                        Hvalue is 1 / N.

search(Nodes, _, Target, Node) :- min(Nodes, [[Node, _, _]|_]), goal(Node, Target).
search(Nodes, Seed, Target, F) :- min(Nodes, [[Node, ParentCost, _]|FRest]),
                                  setof([X, Cost, H], arc(Node, X, Seed, ParentCost, Cost, Target, H), FNode),
                                  append(FNode, FRest, FNew),
                                  search(FNew, Seed, Target, F).

min([H|T], Result) :- hdMin(H, [], T, Result).
hdMin(H, S, [], [H|S]).
hdMin(C, S, [H|T], Result) :- lessthan(C, H), !, hdMin(C, [H|S], T, Result);
                              hdMin(H, [C|S], T, Result).

lessthan([_, Cost1, H1], [_, Cost2, H2]) :- F1 is Cost1 + H1, F2 is Cost2 + H2,
                                            F1 =< F2.

astar(Start, Seed, Target, Found) :- search([[Start, 0, 0]], Seed, Target, Found).
