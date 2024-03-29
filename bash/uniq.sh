

group_a=(one two)
group_b=(one three)

#INTERSECTION
  uniq -d #only print duplicates

  echo ${group_a[@]} ${group_b[@]} | tr ' ' $'\n' | sort | uniq -d
    one

#UNION/JOIN
  uniq #join both

  echo ${group_a[@]} ${group_b[@]} | tr ' ' $'\n' | sort | uniq
    one
    three
    two

#!INTERSECTION (SUBTRACT/INVERSE)
  uniq -u #only print uniques

  echo ${group_a[@]} ${group_b[@]} | tr ' ' $'\n' | sort | uniq -u
    three
    two

#ONLY IN GROUP B USING MULTILINE STRINGS (!INTERSECTION && !A)
  echo "${group_a}"$'\n'"${group_a}"$'\n'"${group_b}" | sort | uniq -u

#Count DESC Unique
  sort | uniq -c | sort -nr
