:- consult('facts.pl').

% TASK 3
% PREDICATES TO FIND RELATIVES

% mother(child, mother)
mother(X, Y) :- female(Y), child(X, Y).

% father(child, father)
father(X, Y) :- male(Y), child(X, Y).

% grandmother(person, grandmother)
grandmother(X, Y) :- child(X, Z), mother(Z, Y).

% grandfather(person, grandfather)
grandfather(X, Y) :- child(X, Z), father(Z, Y).

% son(parent, son)
son(X, Y) :- male(Y), child(Y, X).

% daughter(parent, daughter)
daughter(X, Y) :- female(Y), child(Y, X).

% brother(person, brother).
brother(X, Y) :- male(Y), child(Y, Z), child(X, Z), X \= Y.

% sister(person, sister).
sister(X, Y) :- female(Y), child(Y, Z), child(X, Z), X \= Y.

% wife(husband, wife)
wife(X, Y) :-  male(X), female(Y), child(Z, X), child(Z, Y).

% husband(wife, husband)
husband(X, Y) :- wife(Y, X).

% uncle(person, uncle)
uncle(X, Y) :- child(X, Z), brother(Z, Y).

% aunt(person, aunt)
aunt(X, Y) :- child(X, Z), sister(Z, Y).

% mother_in_law(man, his mother in law)
mother_in_law(X, Y) :- male(X), female(Y), wife(X, Z), child(Z, Y).

% cousin(person, cousin)
cousin(X, Y) :- uncle(X, Z), child(Y, Z).
cousin(X, Y) :- aunt(X, Z), child(Y, Z).


% TASK 4
% PREDICATES FOR SEARCHING RELATIONSHIPS

% Examples:
% relative('Moiseenkov Ilya Pavlovich', 'Polyakova Zinaida Ivanovna').
% relative('Moiseenkov Ilya Pavlovich', 'Ignatieva Yuliana Stanislavovna').
% relative('Moiseenkov Ilya Pavlovich', 'Moiseenkov Sergey Nikolayevich').
% relative('Moiseenkov Ilya Pavlovich', 'Moiseenkova Svetlana Alexandrovna').
% relative('Moiseenkov Pavel Nikolayevich', 'Moiseenkov Sergey Nikolayevich').

% Search with iterative deepening
relative(X, Y) :- for(Cur_Depth, 1, 2), iter(X, Y, Path, Cur_Depth), print_path(Path).

% searching for the path with length = DepthLimit
iter(Start, Finish, Path, DepthLimit) :- path_iter([Start], Finish, Path, DepthLimit).

% found the result at the depth of current DepthLimit
path_iter([Finish | Path], Finish, [Finish | Path], 0).

% prolonging Cur_Path and continue our search
path_iter(Cur_Path, Finish, Path, Depth) :- Depth > 0, prolong(Cur_Path, New_Path),
                                                        New_Depth is Depth - 1,
                                                        path_iter(New_Path, Finish, Path, New_Depth).

% prolonging our path to New_Pos
prolong([Cur_Pos | Tail], [New_Pos, Cur_Pos | Tail]) :- move(Cur_Pos, New_Pos, _), 
                                                    not(member(New_Pos, [Cur_Pos | Tail])).

for(A, A, _).
for(X, A, B) :- A < B, A1 is A + 1, for(X, A1, B).

% describing all possible moves
move(Cur, Next, mother) :- mother(Cur, Next).
move(Cur, Next, father) :- father(Cur, Next).
move(Cur, Next, grandmother) :- grandmother(Cur, Next).
move(Cur, Next, grandfather) :- grandfather(Cur, Next).
move(Cur, Next, son) :- son(Cur, Next).
move(Cur, Next, daughter) :- daughter(Cur, Next).
move(Cur, Next, brother) :- brother(Cur, Next).
move(Cur, Next, sister) :- sister(Cur, Next).
move(Cur, Next, wife) :- wife(Cur, Next).
move(Cur, Next, husband) :- husband(Cur, Next).
move(Cur, Next, uncle) :- uncle(Cur, Next).
move(Cur, Next, aunt) :- aunt(Cur, Next).
move(Cur, Next, mother_in_law) :- mother_in_law(Cur, Next).
move(Cur, Next, cousin) :- cousin(Cur, Next).

% prints result 
print_path([Head1, Head2]) :- move(Head2, Head1, Relationship), !, write(Relationship), nl.
print_path([Head1, Head2 | Tail]) :- move(Head2, Head1, Relationship), !, write(Relationship), write(' of '),
                                        print_path([Head2 | Tail]).


% TASK 5
% PREDICATES FOR PARCING QUESTIONS

% Examples:
% ask(['Who is', 'Moiseenkov Ilya Pavlovich', "'s", 'beautiful', 'mother', '?'], X).
% ask(['How many', 'daughters', 'does', 'Polyakov Stanislav Alexandrovich', 'have', '?'], X).
% ask(['Is', 'Moiseenkova Svetlana Alexandrovna', 'Moiseenkov Ilya Pavlovich', "'s", 'mother', '?'], X).

% split a list into 2 or 3 parts
split(List, Part1, Part2) :- append(Part1, Part2, List), not(length(Part1, 0)), not(length(Part2, 0)).
split(List, Part1, Part2, Part3) :- append(Part1, TMP, List), append(Part2, Part3, TMP),
                                    not(length(Part1, 0)), not(length(Part2, 0)), not(length(Part3, 0)).


% dictionaries
questions_list(['How many', 'Who is', 'Is', 'how many', 'who is', 'is']).

% plural to single
plural('brothers', 'brother').
plural('sisters', 'sister').
plural('sons', 'son').
plural('daughters', 'daughter').

% name should be in database
check_name(Name) :- male(Name).
check_name(Name) :- female(Name).

check_relative(Relationship) :- move(_, _, Relationship), !.
check_question(Question) :- questions_list(List), member(Question, List).

% phrase -> question + semantic group
check_phrase([Question | Other], X) :- check_question(Question), check_semantic_part(Other, X).

% semantic group -> relative + ... + name + ... ("How much" question)
check_semantic_part([Head | Tail], X) :- plural(Head, Head1), check_relative(Head1), split(Tail, _, [Part2 | _]),
                                            check_name(Part2), !, append([Head1], [Part2], X).

% semantic group -> name + name + "'s" + ... + relative + ... ("Is" question)
check_semantic_part([Head | Tail], X) :- check_name(Head), split(Tail, [Part1, "'s" | _], [Part2 | _]),
                                        check_name(Part1), check_relative(Part2), !,
                                        append([Head], [Part1], Tmp), append(Tmp, [Part2], X).

% semantic group -> name + ... + relative + ... ("Who is" question)
check_semantic_part([Head | Tail], X) :- check_name(Head), split(Tail, _, [Part2 | _]), check_relative(Part2),
                                            !, append([Head], [Part2], X).

ask(X, Y) :- check_phrase(X, DS), analyze(DS, Y).

check(Relationship, Name1, Name2) :- move(Name2, Name1, Relationship).

% "Is" question
analyze(DS, _) :- DS = [Name1, Name2, Relative], check(Relative, Name1, Name2).

% "Who is" question
analyze(DS, Y) :- DS = [Name, Relationship], check_name(Name), check_relative(Relationship),
                    check(Relationship, Y, Name).

% "How many" question
analyze(DS, Y) :- DS = [Relationship, Name], check_name(Name), check_relative(Relationship),
                setof(X, check(Relationship, X, Name), List), length(List, Y).
