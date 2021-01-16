% Первая часть задания - предикаты работы со списками

% length1(list, list_length).
length1([], 0).
length1([_|Tail], Length) :- length(Tail, Length1), Length is Length1 + 1.

% member1(element, list).
member1(Element, [Element|_]).
member1(Element, [_|Tail]) :- member1(Element, Tail).

% append1(list1, list2, list1 + list2).
append1([], List, List).
append1([Head|Tail], List2, [Head|ResList2]) :- append1(Tail, List2, ResList2).

% remove(element, list, list_without_element).
remove(Element, [Element|Tail], Tail).
remove(Element, [Head|Tail], [Head|Tail2]) :- remove(Element, Tail, Tail2).

% permute(list, permutation).
permute([], []).
permute(List, [Head|Tail]) :- remove(Head, List, Result), permute(Result, Tail).

% sublist(sublist, list).
sublist(Sublist, List) :- append(_, List1, List), append(Sublist, _, List1).

% remove_last(initial_list, list_without_last_element).
remove_last(List, ListNew) :- append1(ListNew, [_], List).

remove_last1([_], []).
remove_last1([Head|Tail], [Head|Res1]) :- remove_last1(Tail, Res1).

% count_evens(list, number_of_even_numbers).
count_evens([], 0).
count_evens([Head|Tail], Number) :- count_evens(Tail, Number1), Number is Number1 + (Head + 1) mod 2.

count_evens1([], 0).
count_evens1([Head|Tail], Number) :- remove(Head, [Head|Tail], ListNew), 
                                     count_evens1(ListNew, Number1), 
                                     Number is Number1 + (Head + 1) mod 2.

% palindrome(list).
palindrome([]).
palindrome([_]).
palindrome([Head|Tail]) :- remove_last(Tail, TailNew), 
                           append(TailNew, [Element], Tail), 
                           Element == Head, palindrome(TailNew).