family_tree = open("family_tree.ged", "r", encoding="utf-8-sig")
rules = open("facts.pl", "w", encoding="utf-8-sig")
rules.write(":- encoding(utf8).\n\n")  # to understand russian language
females = []  # we'll separate male() rules and female() ones, so we'll print males and remember females
people = {}  # match people with their ids
children = {}  # match children with a "set" of their parents

line = family_tree.readline().split()
while line:
    if int(line[0]) != 0 or len(line) < 3:  # skipping a useless line :(
        line = family_tree.readline().split()
        continue

    if line[2] == "INDI":  # found a person
        person_id = line[1][2:-1]
        while line[1] != "NAME":  # searching for name
            line = family_tree.readline().split()
        person_name = ' '.join(line[2:5])
        people[person_id] = "'" + person_name + "'"

        while line[1] != "SEX":  # searching for sex
            line = family_tree.readline().split()
        if line[2] == "F":
            females.append(people[person_id])
        else:
            rules.write("male(" + people[person_id] + ").\n")

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

    line = family_tree.readline().split()

rules.write("\n")
for female in females:
    rules.write("female(" + female + ").\n")
rules.write("\n")

rules.write("% child(child, parent)\n")
for child, parents in children.items():  # child(child, parent).
    for parent in parents:
        rules.write("child(" + child + ", " + parent + ").\n")
rules.write("\n")

family_tree.close()
rules.close()
