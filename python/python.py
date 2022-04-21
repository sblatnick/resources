


#Hackerrank Challenge
#Given five positive integers, find the minimum and maximum values 
#that can be calculated by summing exactly four of the five integers.


def miniMaxSum(arr):
    arr.sort()
    print(sum(arr[:4]), sum(arr[1:]))

def miniMaxSum(arr):
    print(sum(arr)-max(arr),end=" ")
    print(sum(arr)-min(arr))
    
arr=list(map(int ,input().rstrip().split()))    
miniMaxSum(arr)

#Hackerrank Challenge
#given list of integers, give ratio of parities
summary = {
    "pos" : 0,
    "neg" : 0,
    "nil" : 0
}

def parity(i):
    if i < 0:
        summary["neg"] += 1
    elif i > 0:
        summary["pos"] += 1
    else:
        summary["nil"] += 1

def plusMinus(arr):
    for i in arr:
        parity(i)
    print("%0.6f" % (summary["pos"] / len(arr)))
    print("%0.6f" % (summary["neg"] / len(arr)))
    print("%0.6f" % (summary["nil"] / len(arr)))

#Hackerrank Challenge
#convert AM/PM to military time
def timeConversion(s):
    s = re.sub("AM$", "", s)
    (s, i) = re.subn("PM$", "", s)
    if i > 0:
        hour = int(s[0:2]) + 12
        if hour < 24:
            s = re.sub("^\d\d", str(hour), s)
    else:
        s = re.sub("^12", "00", s)
    return s

#Hackerrank Challenge: offset k characters

# The function accepts following parameters:
#  1. STRING s
#  2. INTEGER k
#

# a = 97, z = 122
# A = 65, Z = 90

def caesarCipher(s, k):
    offset = (k % 26)
    result = ""
    print(ord("Z"))
    for l in s:
        if l.isalpha():
            i = ord(l)
            if i < 91:
                z = 90
            else:
                z = 122
            i += offset
            if i > z:
                i -= 26
            result += chr(i)
        else:
            result += l
    return result
#If k == 1, a -> b and Z -> A

#JSON
  #compact
  print(json.dumps(result, separators=(',', ':')))

#Help below derived from https://www.w3schools.com/python/default.asp

#Collection   ordered   changeable  duplicates
#List         y         y           y
#Dictionary   y         y           n
#Tuple        y         n           y
#Set          n         n           n

#Lists
  #Initialize:
  list1 = ["apple", "banana", "cherry"]
  #get
  list1[-1] #last
  #change
  list1[1] = "pair"
  list1[1:3] = ["blackcurrant", "watermelon"] #range
  #actions
  list1.append("pair")
  list1.insert(0, "pair")
  list1.extend(others) #append onto list1
  list1.remove("pair")
  list1.pop(0)
  del list1[0]
  list1.clear()
  del list1 #delete

  #loops
  for x in list1:
    print(x)
  for i in range(len(list1)):
    print(list1[i])
  i = 0
  while i < len(thislist):
    print(thislist[i])
    i = i + 1
  #loop with List Comprehension
  [print(x) for x in thislist]

    #long way:
    for x in fruits:
      if "a" in x:
        newlist.append(x)
    #list comprehension:
    newlist = [x for x in fruits if "a" in x]

  #sorting
  list1.sort()
  list1.sort(reverse = True)
  list1.sort(key = myfunc)
  #case insensitive:
  list1.sort(key = str.lower)

  list1.reverse()

  #copy
  list1.copy()
  newlist = list(list1)

  #join
  list3 = list1 + list2
  list1.update(list2)

  #count matches
  list1.count("apple")

  #range(i) creates list from 0 to < i
  #range(start, stop, step)
  x = range(6)
  for n in x:
    print(n)
    #0, 1, 2, 3, 4, 5

#Dictionaries
  #initialize
  thisdict = {
    "brand": "Ford",
    "model": "Mustang",
    "year": 1964
  }

  #get
  thisdict["brand"]
  thisdict.get("brand")
  #ordered as of 3.7

  #keys
  thisdict.keys()
  #loop on keys
  for x in thisdict:
    print(x)

  #values
  thisdict.values()
  #loop on values
  for x in thisdict.values():
    print(x)

  #key/value pairs
  thisdict.items()
  #loop
  for x, y in thisdict.items():
    print(x, y)

  #test key
  "model" in thisdict

  #modify
    #if key new, add
    #if key present, change value
  thisdict["year"] = 2018
  thisdict.update({"year": 2020})

  #remove
  thisdict.pop("model")
  del thisdict["model"]

  #clear
  thisdict.clear()

  #copy
  mydict = thisdict.copy()
  mydict = dict(thisdict)

  #nested (multi-dimensional)
  myfamily = {
    "child1" : {
      "name" : "Emil",
      "year" : 2004
    },
    "child2" : {
      "name" : "Tobias",
      "year" : 2007
    },
    "child3" : {
      "name" : "Linus",
      "year" : 2011
    }
  }

  #misc
  fromkeys()   #Returns a dictionary with the specified keys and value
  popitem()    #Removes the last inserted key-value pair
  setdefault() #Returns the value of the specified key. If the key does not exist: insert the key, with the specified value


  #lambda = anonymous function = macro
  x = lambda a, b : a * b
  print(x(5, 6))
  # 5 * 6

#Regex
  import re

  txt = "The rain in Spain"
  x = re.search("^The.*Spain$", txt)

  findall #Returns a list containing all matches
  search  #Returns a Match object if there is a match anywhere in the string
  split   #Returns a list where the string has been split at each match
  sub     #Replaces one or many matches with a string

#Exceptions
  try:
    print(x)
  except:
    print("An exception occurred")

#Less used data structures
  #Tuples
    #initialize:
    tuple1 = (1, 1, 5, 7, 9, 3)

    #get
    tuple1[0]
    #unpack
    (green, yellow, red) = fruits

    #work around to modify by casting into a list
    y = list(x)
    y[1] = "kiwi"
    x = tuple(y)

    #loops
    for x in thistuple:
      print(x)
    for i in range(len(thistuple)):
      print(thistuple[i])
    i = 0
    while i < len(thistuple):
      print(thistuple[i])
      i = i + 1

    #join
    tuple3 = tuple1 + tuple2
    tuple1.update(tuple2)

    #multiply
    mytuple = fruits * 2

    #count matches
    mytuple.count("apple")
    #find first index of value (exception if not found)
    mytuple.index("apple")

  #Sets
    #initialize
    myset = {"apple", "banana", "cherry"}
    #order not preserved
    #duplicates ignored
    #mixed types:
    set1 = {"abc", 34, True, 40, "male"}

    #test:
    "abc" in set1

    #loop:
    for x in thisset:
      print(x)

    #add
    thisset.add("orange")

    #remove
    thisset.remove("orange") #error if not present
    thisset.discard("orange") #no error

    #remove last
    thisset.pop() #no order, so you don't know which

    #join
    thisset.update(tropical)
    set3 = set1.union(set2)

    #intersection
    z = x.intersection_update(y)

    #non-intersection
    z = x.symmetric_difference(y)

    #clear
    thisset.clear()

    #delete
    del thisset

    #misc
    copy()
    difference()
    difference_update()
    isdisjoint()
    issubset()
    issuperset()
    symmetric_difference_update()



#__init__.py attempts to modify scope of imports:

  #!/usr/bin/env python
  import os, sys, importlib

  base = os.path.dirname(__file__)
  sys.path.append(base)

  for script in os.listdir(base):
    if script == '__init__.py' or script[-3:] != '.py':
      continue
    print("importing %s" % script[:-3])
    module = importlib.import_module(script[:-3])
    base = importlib.import_module(base.split("/")[-1])
    #from script[:-3] import *
    symbols = [name for name in module.__dict__ if not name.startswith('_')]
    for symbol in symbols:
      print("  %s" % symbol)
      attr = getattr(module, symbol)
      print(attr)
      #setattr(base, symbol, getattr(module, symbol))
      globals()[symbol] = attr
    #globals().update({name: module.__dict__[name] for name in symbols})
    #__import__(script[:-3], locals(), globals())
    #__import__(script[:-3], fromlist=symbols)
  del module