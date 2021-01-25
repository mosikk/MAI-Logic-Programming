# Отчет по курсовому проекту
## по курсу "Логическое программирование"

### студент: Моисеенков И.П.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |        5       |
| Левинская М.А.|              |               |

> *Хорошая реализация 5 задания*

## Введение

Помимо привычного всем императивного программирования существует еще много непохожих друг на друга парадигм: логическое программирование, функциональное программирование и др. Для каждой парадигмы были придуманы особые языки и правила для программирования. В рамках этого курсового проекта я познакомлюсь с парадигмой логического программирования: изучу механизмы и принципы работы первого декларативного языка Prolog, изучу основы построения фактов, предикатов и запросов в данном языке программирования и на примере приведенного ниже задания продемонстрирую изученные навыки программирования на декларативном языке.

## Задание

 1. Создать родословное дерево своего рода на несколько поколений (3-4) назад в стандартном формате GEDCOM с использованием сервиса MyHeritage.com 
 2. Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog, используя следующее представление: `child(ребенок, родитель)`, `male(человек)`, `female(человек)` 
 3. Реализовать предикат проверки/поиска тёщи.
 4. Реализовать программу на языке Prolog, которая позволит определять степень родства двух произвольных индивидуумов в дереве.
 5. [На оценки хорошо и отлично] Реализовать естественно-языковый интерфейс к системе, позволяющий задавать вопросы относительно степеней родства, и получать осмысленные ответы. 

## Получение родословного дерева

Для составления родословного дерева я воспользовался сервисом MyHeritage.com. При помощи родственников я собрал данные о своих предках до 4 поколения и ввел полученную информацию в онлайн-сервисе. Итоговое дерево включает в себя 39 человек. Оно содержит в себе информацию не только о предках, но и о двоюродных родственниках. Полученное дерево я экспортировал в формате .ged и изучил спецификацию данного формата для расшифровки содержимого данного файла и выполнения следующего задания.

## Конвертация родословного дерева

Для конвертации .ged файла в факты языка Prolog я воспользовался языком Python. Я выбрал этот язык из-за его возможности быстро и просто работать с файлами и строками.
В соответствии с вариантом мне нужно было отдельно выводить факты о женщинах, мужчинах и детях. Поэтому при обработке .ged файла выводились только факты male(), а остальные факты запоминались в словарях и списках и выводились отдельно после обработки файла.

Условно .ged файл можно поделить на две части: информация об отдельных людях и информация о семьях. Поэтому при обработке файла программа обращает внимание на ключевые слова: "INDI" свидетельствует о начале описания человека, "FAM" - о начале описания семьи. Чтобы было проще ориентироваться в файле, при обработке учитывается уровень "вложенности" информации, который указывается в начале каждой строки файла.

Если встретилось описание человека, то мы запоминаем его ID и продолжаем чтение файла для поиска имени человека и определения его пола. Строка с именем помечается ключевым словом "NAME", строка с полом - "SEX". Если мы нашли мужчину, то выводится соответствующий факт. Если же найдена женщина, то ее имя добавляется в список, который позже будет преобразован в правила вида female().

    if line[2] == "INDI":  # found a person
        person_id = line[1][2:-1]
        while line[1] != "NAME":  # searching for name
            line = family_tree.readline().split()
        person_name = '_'.join(line[2:5])
        people[person_id] = person_name.lower()

        while line[1] != "SEX":  # searching for sex
            line = family_tree.readline().split()
        if line[2] == "F":
            females.append(people[person_id])
        else:
            rules.write("male(" + people[person_id] + ").\n")
           
Если встретилось описание семьи, то первым делом мы определяем мужа и жену (они помечены как "HUSB" и "WIFE" соответственно). Из-за возможной неполноты моего дерева некоторые данные о супругах могут отсутствовать. В таком случае их имена помечаются пустыми строками, и в дальнейшем они обрабатываться не будут. Продолжая чтение файла, необходимо найти ключевые слова "CHIL" для определения детей данной пары. Учитывается, что у родителей может быть сколько угодно детей. Информация о детях запоминается в словаре, где имени ребенка сопоставляется "множество" (set) его родителей. Соответствующие факты будут записаны в прологовский файл после обработки файла.

    if line[2] == "FAM":  # found a family
        father_id = 0
        mother_id = 0

        while line[1] != "HUSB" and line[1] != "WIFE":  # searching for mum and dad for next children
            line = family_tree.readline().split()

        if line[1] == "HUSB":
            father_id = line[2][2:-1]
            line = family_tree.readline().split()
        if line[1] == "WIFE":
            mother_id = line[2][2:-1]

        while line[1] != "_UID":  # scanning to the end of the family description
            if line[1] == "CHIL":  # found a child
                child_id = line[2][2:-1]
                children[people[child_id]] = set()
                if father_id != 0:  # if there's no info about a father, we won't write it
                    children[people[child_id]].add(people[father_id])
                if mother_id != 0:  # same for mother
                    children[people[child_id]].add(people[mother_id])
            line = family_tree.readline().split()

            
В результате работы программы получим файл rules.pl со всеми фактами, необходимыми для дальнейшей обработки этого дерева в языке Prolog. Теперь можно присоединить этот файл при помощи предиката `consult` в файл relatives.pl и продолжить работу там.

## Предикат поиска родственника

По заданию требовалось реализовать предикат поиска тёщи. Как известно, тёща - это мать жены человека. Для начала опишем предикат поиска жены.
Женщина Y является женой мужчины X, если у них есть общий ребёнок Z.

```
wife(X, Y) :-  male(X), female(Y), child(Z, X), child(Z, Y).
```

Теперь несложно реализовать предикат поиска тёщи. Женщина Y является тёщей для мужчины X, если у X есть жена Z, которая также является ребёнком Y.

```
mother_in_law(X, Y) :- male(X), female(Y), wife(X, Z), child(Z, Y).
```

Проверим работу предиката.

```
2 ?- mother_in_law(X, Y).
X = 'Moiseenkov Pavel Nikolayevich',
Y = 'Polyakova Zinaida Ivanovna' ;
X = 'Polyakov Alexander Nikolayevich',
Y = 'Kremneva Antonina Tihonovna' ;
X = 'Polyakov Alexander Nikolayevich',
Y = 'Kremneva Antonina Tihonovna' ;
X = 'Kremnev Ivan Abramovich',
Y = 'Kachurina Anna Timofeevna' ;
X = 'Kremnev Ivan Abramovich',
Y = 'Kachurina Anna Timofeevna' ;
X = 'Polyakov Nikolay Ivanovich',
Y = 'Matveeva Tatyana Ivanovna' ;
X = 'Polyakov Nikolay Ivanovich',
Y = 'Matveeva Tatyana Ivanovna' ;
X = 'Moiseenkov Nikolay Alexeevich',
Y = 'Kondrashova Pelageya Arkhipovna' ;
X = 'Moiseenkov Nikolay Alexeevich',
Y = 'Kondrashova Pelageya Arkhipovna' ;
X = 'Danenkov Gerasim Dorofeevich',
Y = 'Kondrashova Zinaida Evdokimovna' ;
X = 'Danenkov Gerasim Dorofeevich',
Y = 'Kondrashova Zinaida Evdokimovna' ;
X = 'Strelkov Vladimir Dmitrievich',
Y = 'Kondrashova Pelageya Arkhipovna' ;
false.
```
Пролог вывел верные результаты, значит предикат mother_in_law построен правильно.

## Определение степени родства

Для определения степени родства двух произвольных человек в дереве я применил технику поиска в пространстве состояний. Родословное дерево можно представить как граф, где вершинами (состояниями) являются люди, а рёбрами (переходами) - их родственные связи. 
В одной из лабораторных работ я установил, что поиск с итерационным заглублением является самым быстрым, поэтому я взял его в качестве основы для своего алгоритма.

Ниже приведен алгоритм поиска:
```
% Search with iterative deepening
relative(X, Y) :- for(Cur_Depth, 1, 5), iter(X, Y, Path, Cur_Depth), print_path(Path).

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
```

Глубина поиска ограничена числом 2, чтобы избежать чересчур запутанных связей. Если данной глубины будет недостаточно, то следует увеличить соответствующее значение в алгоритме поиска.

Для корректной работы алгоритма осталось формализовать правила перехода между состояниями. Выше упомянуто, что для перехода нужна некая родственная связь между двумя людьми. Значит при переходе мы будем выбирать одного из ближайших родственников "текущего" человека и продолжать поиск. Для простоты я определил несколько дополнительных предикатов проверки родства:
* Мама
* Папа
* Бабушка
* Дедушка
* Брат
* Сестра
* Сын
* Дочь
* Дядя
* Тётя
* Двоюродный брат/сестра

Итак, предикат `move` выглядит следующим образом:
```
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
```

Однако при таком поиске мы не получаем ответа на поставленную задачу: мы получим лишь список людей, через которых мы достигли финального состояния. Поэтому необходимо ещё раз пройтись по полученному списку и определить степени родства для каждой пары "соседей" в списке и вывести на экран итоговый ответ. Для этого я реализовал предикат `print_path`, который использует третий аргумент предиката `move`.
```
print_path([Head1, Head2]) :- move(Head2, Head1, Relationship), !, write(Relationship), nl.
print_path([Head1, Head2 | Tail]) :- move(Head2, Head1, Relationship), !, write(Relationship), write(' of '),
                                        print_path([Head2 | Tail]).
```

Видно, что `print_path` - рекурсивный предикат, крайний случай для которого - список из двух человек. Я решил сделать именно этот случай крайним для получения ответа в более "красивом" виде.

```
2 ?- relative('Moiseenkov Ilya Pavlovich', 'Moiseenkova Svetlana Alexandrovna').
mother
true ;
wife of father
true ;
daughter of grandmother
true ;
daughter of grandfather
true ;
sister of uncle
true ;
sister of uncle
true ;
sister of uncle
true ;
sister of uncle
true ;
aunt of cousin
true ;
aunt of cousin
true ;
aunt of cousin
true ;
aunt of cousin
true ;
aunt of cousin
true ;
aunt of cousin
true ;
aunt of cousin
true ;
aunt of cousin
true ;
false.

3 ?- relative('Moiseenkov Ilya Pavlovich', 'Polyakova Zinaida Ivanovna').
grandmother
true ;
mother of mother
true ;
mother_in_law of father
true ;
wife of grandfather
true ;
wife of grandfather
true ;
mother of uncle
true ;
mother of uncle
true ;
grandmother of cousin
true ;
grandmother of cousin
true ;
grandmother of cousin
true ;
grandmother of cousin
true ;
false.

4 ?- relative('Moiseenkov Ilya Pavlovich', 'Ignatieva Yuliana Stanislavovna').
cousin
true ;
cousin
true ;
daughter of uncle
true ;
daughter of uncle
true ;
sister of cousin
true ;
sister of cousin
true ;
sister of cousin
true ;
sister of cousin
true ;
false.

5 ?- relative('Moiseenkov Ilya Pavlovich', 'Moiseenkov Sergey Nikolayevich').
uncle
true ;
uncle
true ;
brother of father
true ;
brother of father
true ;
son of grandmother
true ;
son of grandfather
true ;
father of cousin
true ;
father of cousin
true ;
false.

6 ?- relative('Moiseenkov Pavel Nikolayevich', 'Moiseenkov Sergey Nikolayevich').
brother
true ;
brother
true ;
son of mother
true ;
son of father
true ;
uncle of son
true ;
uncle of son
true ;
cousin of cousin
true ;
cousin of cousin
true ;
cousin of cousin
true ;
cousin of cousin
true ;
false.
```

Проверив результаты программы, я убедился в корректности составленных предикатов.

## Естественно-языковый интерфейс

Программа поддерживает три типа вопросов:
1) How many ... (Например, How many sisters does Ilya have?)
2) Who is ... (Например, Who is Ilya's cousin?)
3) Is ... (Например, Is Yuliana Ilya's cousin?)

Сначала необходимо построить грамматику для обработки таких запросов. Данная грамматика составлена не очень подробно (из-за нехватки времени), но при желании её можно легко расширить.

```
VT = {слова из словарей, имена, родственные связи, "does", "have", " 's"}
VN = {ВОПРОС, ВОПРОСИТЕЛЬНОЕ СЛОВО, СМЫСЛОВАЯ ЧАСТЬ, РОДСТВЕННИК, ИМЯ}
S = ВОПРОС
P:
ВОПРОС -> ВОПРОСИТЕЛЬНОЕ СЛОВО + СМЫСЛОВАЯ ЧАСТЬ
СМЫСЛОВАЯ ЧАСТЬ -> РОДСТВЕННИК + ... + ИМЯ + ... | ИМЯ + " 's" + ... + РОДСТВЕННИК | ИМЯ + ИМЯ + " 's" + ... + РОДСТВЕННИК
ВОПРОСИТЕЛЬНОЕ СЛОВО -> "How many", "Who is", "Is"
РОДСТВЕННИК -> "brother", "mother", "grandmother", "aunt", и т.д.
ИМЯ -> "Moiseenkov Ilya Pavlovich", "Moiseenkova Svetlana Alexandrovna", и т.д.
```

Примечание: вместо многоточий можно вставить дополнительные слова (например, прилагательные), на обработку фразы это не повлияет.

Обработка вопроса выполняется по описанной выше грамматике. Во время обработки выделяются список из его ключевых фраз. На основе данного списка и будет производиться поиск ответа. Для 1 типа вопросов этот список имеет вид `[Родственная связь, Имя]`, для 2 типа - `[Имя, Родственная связь]`, для 3 типа - `[Имя1, Имя2, Родственная связь]`.

```
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
```

`split/2, split/3` - вспомогательные предикаты, которые производят разделение одного списка на 2 или 3 непустых списков соответственно.

После получения списка ключевых слов его нужно обработать и вывести ответ. 
```
ask(X, Y) :- check_phrase(X, DS), analyze(DS, Y).

% "Is" question
analyze(DS, _) :- DS = [Name1, Name2, Relative], check(Relative, Name1, Name2).

% "Who is" question
analyze(DS, Y) :- DS = [Name, Relationship], check_name(Name), check_relative(Relationship),
                    check(Relationship, Y, Name).

% "How many" question
analyze(DS, Y) :- DS = [Relationship, Name], check_name(Name), check_relative(Relationship),
                setof(X, check(Relationship, X, Name), List), length(List, Y).
                
check(Relationship, Name1, Name2) :- move(Name2, Name1, Relationship).
```

Для получения ответа на вопрос 1 типа используется предикат setof, который позволяет создать упорядоченное множество всех подходящих ответов. Ответ на вопрос - длина этого списка. Из-за особенности реализации предиката в случае получения пустого множества выводится ответ 'false', а не '0'.

Примечание: бессмысленные вопросы типа "Сколько матерей у Пети?" не поддерживаются.

Проверим корректность работы программы:
```
2 ?- ask(['Who is', 'Moiseenkov Ilya Pavlovich', "'s", 'beautiful', 'mother', '?'], X).
X = 'Moiseenkova Svetlana Alexandrovna' ;
false.

3 ?- ask(['Who is', 'Moiseenkov Ilya Pavlovich', "'s", 'father', '?'], X).              
X = 'Moiseenkov Pavel Nikolayevich' ;
false.

4 ?- ask(['Who is', 'Moiseenkov Ilya Pavlovich', "'s", 'sister', '?'], X). 
false.

5 ?- ask(['Who is', 'Moiseenkov Ilya Pavlovich', "'s", 'cousin', '?'], X). 
X = 'Ignatieva Yuliana Stanislavovna' ;
X = 'Ignatieva Mariana Stanislavovna' ;
X = 'Ignatieva Yuliana Stanislavovna' ;
X = 'Ignatieva Mariana Stanislavovna' ;
X = 'Moiseenkova Agnessa Sergeevna' ;
X = 'Moiseenkova Agnessa Sergeevna' ;
false.

6 ?- ask(['How many', 'daughters', 'does', 'Polyakov Stanislav Alexandrovich', 'have', '?'], X).
X = 2 ;
false.

7 ?- ask(['How many', 'sisters', 'does', 'Polyakov Stanislav Alexandrovich', 'have', '?'], X).   
X = 1 ;
false.

8 ?- ask(['How many', 'brothers', 'does', 'Polyakov Stanislav Alexandrovich', 'have', '?'], X). 
false.

9 ?- ask(['Is', 'Moiseenkova Svetlana Alexandrovna', 'Moiseenkov Ilya Pavlovich', "'s", 'mother', '?'], X).
true ;
false.

10 ?- ask(['Is', 'Moiseenkova Svetlana Alexandrovna', 'Moiseenkov Ilya Pavlovich', "'s", 'father', '?'], X). 
false.
```

Программа выдала верные ответы на все запросы.

## Выводы

Прежде всего, данный курсовой проект дал мне понять, что я знаю не так много информации о своих предках. Я сам не смог вспомнить имена даже некоторых своих прабабушек и прадедушек. У меня появилось желание собрать всю имеющуюся информацию обо всех своих родственниках и создать максимально подробное генеалогическое древо.

Но, возвращаясь к сути данного проекта, хочу отметить, что я смог достичь всех целей, которые я определил для себя во введении: я изучил принцип работы языка Пролог, познал суть логического программирования и научился писать работающие программы с использованием данной парадигмы. В начале выполнения работы я учился писать лишь простые предикаты, а уже ближе к концу я использовал более сложные и полезные алгоритмы: алгоритм поиска и алгоритм обработки естественно-языковых предложений.

Как известно, современные программисты используют Пролог крайне редко. В осовном он используется для проектирования каких-либо заготовок, для обработки простейших естественно-языковых запросов и для поиска в пространстве некоторых состояний. Всё это было проделано и мной в рамках данной работы. Можно сказать, что в данной работе я выполнил те задачи, для которых Пролог используется чаще всего. Я уверен, что данные навыки пригодятся мне в будущем.
