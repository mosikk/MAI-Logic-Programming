% Task 2: Relational Data

% Data: grade(group, surname, subject, grade).

% The line below imports the data
:- ['two.pl'].

% list of subjects
subjects(List) :- setof(Subject, A^B^C^grade(A, B, Subject, C), List).

% sum(list, sum_of_elements).
sum([], 0).
sum([Head|Tail], Sum) :- sum(Tail, Sum1), Sum is Sum1 + Head.

% average(list, average_value_of_elements).
average(List, Average) :- sum(List, Sum), length(List, Length), Average is Sum / Length.

% get_average_grade(subject, average_grade). - counts average grade for a subject
get_average_grade(Subject, Number) :- findall(Mark, grade(_, _, Subject, Mark), List), 
                                      average(List, Number).

% print average grades for every subject
print_average_grades(Subject, Average) :- subjects(Subjects), member(Subject, Subjects), 
                                          get_average_grade(Subject, Average).



% failed_exam(group, number_of_students_that_didn't_pass_exams).
print_failed_exam(Group, Number) :- setof(Student, A^grade(Group, Student, A, 2), List), 
                                    length(List, Number).



% failed_subject(subject, number_of_students_that_failed_subject_exam).
failed_subject(Subject, Number) :- findall(Student, grade(_, Student, Subject, 2), List), 
                                   length(List, Number).

% print subjects and number of students who failed it
print_failed_subject(Subject, Number) :- subjects(Subjects), member(Subject, Subjects), 
                                                  failed_subject(Subject, Number).