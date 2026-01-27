

//Lists: ordered
  //mutable:
    //Create:
    val systemUsers: MutableList<Int> = mutableListOf(1, 2, 3)
    //Add:
    systemUsers.add(newUser)

  List
  //immutable:
    //Create:
    val sudoers: List<Int> = listOf(1, 2, 3)
    val sudoers: List<Int> = systemUsers

//Set: unordered, no duplicates
  //mutable:
    //Create:
    mutableSetOf()
    //Add returns Boolean if added or failed because already present:
    return example.add(element)
  //immutable:
    //Create:
    setOf()

//Map: key/value pairs
  mutableMapOf(key to value, key2 to value2)
  mapOf()
    map.containsKey(key)

    map.forEach {
        k, v -> println("key $k: value $v")
    }
    map.withDefault { k -> k.length }

    val value = map["key"] //or null if key doesn't exist
    map.getValue("key")    //or default, which is 3, or without defaults NoSuchElementException

  //transform to Map<id, name>:
    .map { Object(it) }
    .groupBy({ it.id }, { it.name })

//Unique Map by Merge:
   companion object {
      fun merge(objects: List<Object>): Object {
        require(objects.isNotEmpty()) { "Cannot merge empty list." }

        val id = objects[0].id
        val property = objects[0].property
        val last = objects.maxOf { it.timestamp }
        val urls = objects.flatMap { it.urls }.distinct()
        //... etc
        return Object(id, property, last, urls)
      }
  }
  val unique = objects.groupBy { it.id }.map { Object.merge(it.value) }

//Collection Functions
  //filter:
    val numbers = listOf(1, -2, 3, -4, 5, -6)

    val positives = numbers.filter { x -> x > 0 }
    val negatives = numbers.filter { it < 0 } //"it" is shorthand for x -> x

  //map:
    val numbers = listOf(1, -2, 3, -4, 5, -6)

    val doubled = numbers.map { x -> x * 2 }
    val tripled = numbers.map { it * 3 }

  //convert list to map:
    private val ages by lazy {
        userNames.map {
            it to getAge(it)
        }.toMap()
    }
    //alternatively:
    private val ages by lazy {
        userNames.associateWith {
            getAge(it)
        }.toMap()
    }

  //associate:
    /*
     * json.properties: List<String>
     * returns Map<String,String>
     */
    json.properties.associateWith { json.getString(it) }
    //Same as:
    json.properties.associate {
        it to json.getString(it)
    }

  //matchers:
    //any: true if at least one element matches
      numbers.any{ it < 0 }
    //all: true if all match
      numbers.all { it % 2 == 0 }
    //none: true if none match
      numbers.none { it > 6 }

    //find: first match or null
      words.find { it.startsWith("some") }
    //findLast: last match or null
      words.findLast { it.contains("nothing") }

    //first: first match or NoSuchElementException
      numbers.first()
      numbers.first { it % 2 == 0 }
    //last: last match or NoSuchElementException
      numbers.last()
      numbers.last { it % 2 != 0 }

    //firstOrNull: first match or null
    //lastOrNull: last match or null

  //Aggregates:
    numbers.count()
    numbers.count { it % 2 == 0 } //even numbers

    //associateBy = last match
      people.associateBy { it.phone } //key: phone, value: Person object
      people.associateBy(Person::phone, Person::city)
    //groupBy = list
      people.groupBy(Person::city, Person::name)

  //partition:
    val evenOdd = numbers.partition { it % 2 == 0 } //Pair
    val (positives, negatives) = numbers.partition { it > 0 }

  //flatMap: flattens list values to having their own keys:
    val fruitsBag = listOf("apple","orange","banana","grapes")
    val clothesBag = listOf("shirts","pants","jeans")

    // fruitsBag, clothesBag
    val cart = listOf(fruitsBag, clothesBag)
    // [[apple, orange, banana, grapes], [shirts, pants, jeans]]
    val mapBag = cart.map { it }
    // [apple, orange, banana, grapes, shirts, pants, jeans]
    val flatMapBag = cart.flatMap { it }

  //minOrNull, maxOrNull
    numbers.maxOrNull()
    numbers.minOrNull()

  //sorting:
    val natural = list.sorted()
    val inverted = list.sortedBy { -it }
    val descending = shuffled.sortedDescending()
    val descendingBy = shuffled.sortedByDescending { abs(it)  }

  //sorting by map key occurance:
    val sortedByCount = myMap.groupingBy { it.first() }.eachCount().let { counts ->
      myMap.sortedByDescending { counts[it.first()] }
    }

  //zip = merging
    val A = listOf("a", "b", "c")
    val B = listOf(1, 2, 3, 4)

    // (a, 1), (b, 2), (c, 3)
    val pairs = A zip B
    // a1, b2, c3
    val strings = A.zip(B) { a, b -> "$a$b" }

  //getOrElse
    list.getOrElse(10) { 42 } //returns index 10 or default of 42
    map.getOrElse("key") { 42 } //returns value of "key" or default of 42


