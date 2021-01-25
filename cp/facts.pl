:- encoding(utf8).

male('Moiseenkov Ilya Pavlovich').
male('Moiseenkov Pavel Nikolayevich').
male('Polyakov Alexander Nikolayevich').
male('Kremnev Ivan Abramovich').
male('Kachurin Tikhon Danilovich').
male('Polyakov Nikolay Ivanovich').
male('Polyakov Ivan Pavlovich').
male('Matveev Ivan Dmitrievich').
male('Kremnev Vladimir Ivanovich').
male('Polyakov Vasiliy Nikolayevich').
male('Polyakov Stanislav Alexandrovich').
male('Moiseenkov Nikolay Alexeevich').
male('Danenkov Gerasim Dorofeevich').
male('Moiseenkov Sergey Nikolayevich').
male('Danenkov Dorofey Azarovich').
male('Kondrashov Arkhip Ilich').
male('Moiseenkov Alexey Osipovich').
male('Moiseenkov Sergey Alexeevich').
male('Strelkov Vladimir Dmitrievich').

female('Moiseenkova Svetlana Alexandrovna').
female('Moiseenkova Emiliya Gerasimovna').
female('Polyakova Zinaida Ivanovna').
female('Kremneva Antonina Tihonovna').
female('Kachurina Anna Timofeevna').
female('Kremneva Evgeniya Ermolovna').
female('Polyakova Nina Ivanovna').
female('Polyakova Fyokla Maksimovna').
female('Matveeva Tatyana Ivanovna').
female('Ignatieva Yuliana Stanislavovna').
female('Ignatieva Tamara Pavlovna').
female('Ignatieva Mariana Stanislavovna').
female('Strelkova Anna Gerasimovna').
female('Kondrashova Pelageya Arkhipovna').
female('Danenkova Natalya Kuzminichna').
female('Kondrashova Zinaida Evdokimovna').
female('Moiseenkova Pelageya Sergeevna').
female('Moiseenkova Tatyana Alexeevna').
female('Moiseenkova Agnessa Sergeevna').
female('Dudina Olga Vladimirovna').

% child(child, parent)
child('Moiseenkov Ilya Pavlovich', 'Moiseenkova Svetlana Alexandrovna').
child('Moiseenkov Ilya Pavlovich', 'Moiseenkov Pavel Nikolayevich').
child('Moiseenkov Pavel Nikolayevich', 'Moiseenkov Nikolay Alexeevich').
child('Moiseenkov Pavel Nikolayevich', 'Moiseenkova Emiliya Gerasimovna').
child('Moiseenkov Sergey Nikolayevich', 'Moiseenkov Nikolay Alexeevich').
child('Moiseenkov Sergey Nikolayevich', 'Moiseenkova Emiliya Gerasimovna').
child('Moiseenkova Svetlana Alexandrovna', 'Polyakova Zinaida Ivanovna').
child('Moiseenkova Svetlana Alexandrovna', 'Polyakov Alexander Nikolayevich').
child('Polyakov Stanislav Alexandrovich', 'Polyakova Zinaida Ivanovna').
child('Polyakov Stanislav Alexandrovich', 'Polyakov Alexander Nikolayevich').
child('Kremnev Vladimir Ivanovich', 'Kremneva Antonina Tihonovna').
child('Kremnev Vladimir Ivanovich', 'Kremnev Ivan Abramovich').
child('Polyakova Zinaida Ivanovna', 'Kremneva Antonina Tihonovna').
child('Polyakova Zinaida Ivanovna', 'Kremnev Ivan Abramovich').
child('Kremneva Antonina Tihonovna', 'Kachurina Anna Timofeevna').
child('Kremneva Antonina Tihonovna', 'Kachurin Tikhon Danilovich').
child('Kremnev Ivan Abramovich', 'Kremneva Evgeniya Ermolovna').
child('Polyakov Alexander Nikolayevich', 'Polyakova Nina Ivanovna').
child('Polyakov Alexander Nikolayevich', 'Polyakov Nikolay Ivanovich').
child('Polyakov Vasiliy Nikolayevich', 'Polyakova Nina Ivanovna').
child('Polyakov Vasiliy Nikolayevich', 'Polyakov Nikolay Ivanovich').
child('Polyakov Nikolay Ivanovich', 'Polyakova Fyokla Maksimovna').
child('Polyakov Nikolay Ivanovich', 'Polyakov Ivan Pavlovich').
child('Polyakova Nina Ivanovna', 'Matveeva Tatyana Ivanovna').
child('Polyakova Nina Ivanovna', 'Matveev Ivan Dmitrievich').
child('Ignatieva Yuliana Stanislavovna', 'Polyakov Stanislav Alexandrovich').
child('Ignatieva Yuliana Stanislavovna', 'Ignatieva Tamara Pavlovna').
child('Ignatieva Mariana Stanislavovna', 'Polyakov Stanislav Alexandrovich').
child('Ignatieva Mariana Stanislavovna', 'Ignatieva Tamara Pavlovna').
child('Strelkova Anna Gerasimovna', 'Danenkov Gerasim Dorofeevich').
child('Strelkova Anna Gerasimovna', 'Kondrashova Pelageya Arkhipovna').
child('Moiseenkova Emiliya Gerasimovna', 'Danenkov Gerasim Dorofeevich').
child('Moiseenkova Emiliya Gerasimovna', 'Kondrashova Pelageya Arkhipovna').
child('Danenkov Gerasim Dorofeevich', 'Danenkova Natalya Kuzminichna').
child('Danenkov Gerasim Dorofeevich', 'Danenkov Dorofey Azarovich').
child('Kondrashova Pelageya Arkhipovna', 'Kondrashov Arkhip Ilich').
child('Kondrashova Pelageya Arkhipovna', 'Kondrashova Zinaida Evdokimovna').
child('Moiseenkov Nikolay Alexeevich', 'Moiseenkov Alexey Osipovich').
child('Moiseenkov Nikolay Alexeevich', 'Moiseenkova Pelageya Sergeevna').
child('Moiseenkov Sergey Alexeevich', 'Moiseenkov Alexey Osipovich').
child('Moiseenkov Sergey Alexeevich', 'Moiseenkova Pelageya Sergeevna').
child('Moiseenkova Tatyana Alexeevna', 'Moiseenkov Alexey Osipovich').
child('Moiseenkova Tatyana Alexeevna', 'Moiseenkova Pelageya Sergeevna').
child('Moiseenkova Agnessa Sergeevna', 'Moiseenkov Sergey Nikolayevich').
child('Dudina Olga Vladimirovna', 'Strelkova Anna Gerasimovna').
child('Dudina Olga Vladimirovna', 'Strelkov Vladimir Dmitrievich').

