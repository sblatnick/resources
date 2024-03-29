
//Switch logic:
  when (obj) {   
    1 -> println("One")
    "Hello" -> println("Greeting")
    is Long -> println("Long")
    !is String -> println("Not a string")
    else -> println("Unknown")
  }

  //Assignment:
  val result = when (obj) {
    1 -> "one"
    "Hello" -> 1
    is Long -> false
    else -> 42
  }

  //Example:
  trackedSeverities.forEach { severity ->
      val count = currentTracked.count { it.severity == severity }
      when (severity) {
          Severity.HIGH -> high = count
          Severity.MEDIUM -> medium = count
          Severity.LOW -> low = count
          Severity.UNKNOWN -> unknown = count
      }
  }
  //Example normalize params:
    import org.slf4j.Logger
    import org.slf4j.LoggerFactory

    class GitBranch(val id: String?, val sha: String?, val author: String?, isMaster: Boolean?) {
      companion object {
        val log: Logger = LoggerFactory.getLogger(javaClass)

        fun parse(value: Object): GitBranch {
          val properties = listOf("id", "sha", "author", "isMaster")
          var found = mutableListOf<Any>()
          properties.forEach { property ->
              val current = when (property) {
                  "isMaster" -> value.getBoolean(property)
                  else -> value.getString(property)?.ifEmpty { null }
              }
              if(current == null) {
                  log.warn("No $property property ${value.toString()}")
              }
              else {
                  found.add(current)
              }
          }
          return GitBranch(found[0] as String, found[1] as String, found[2] as String, found[3] as Boolean)
        }
      }
    }

//Loops:
  //for
    val cakes = listOf("carrot", "cheese", "chocolate")
    for (cake in cakes) {
        println("Yummy, it's a $cake cake!")
    }
    //map key/value:
    for ((name, age) in map) {
      println("$name is $age years old")
    }

  //forEach:
    map.forEach {
        k, v -> println("key $k: value $v")
    }
    "1,2,3".split(",").forEach {
      println("$it")
    }

  //while
    while (cakesEaten < 5) {
      eatACake()
      cakesEaten ++
    }

  //do-while
    do {
      bakeACake()
      cakesBaked++
    } while (cakesBaked < cakesEaten)

  //Iterators:
    class Animal(val name: String)

    class Zoo(val animals: List<Animal>) {
      operator fun iterator(): Iterator<Animal> {
        return animals.iterator()
      }
    }

    fun main() {
      val zoo = Zoo(listOf(Animal("zebra"), Animal("lion")))

      for (animal in zoo) {
        println("Watch out, it's a ${animal.name}")
      }
    }

  //Ranges:
    for(i in 0..3) {
    for(i in 0 until 3) {
    for(i in 2..8 step 2) {
    for (i in 3 downTo 0) {

    for (c in 'a'..'d') {
    for (c in 'z' downTo 's' step 2) {

  //Conditional Ranges:
    if (x in 1..5) {
    if (x !in 6..10) {

//Equality
  //Structural:
  a == b //compiles to: if (a == null) b == null else a.equals(b)
  //Referential:
  a === b

  //Example:
  val authors = setOf("Shakespeare", "Hemingway", "Twain")
  val writers = setOf("Twain", "Shakespeare", "Hemingway")

  println(authors == writers)   // true (sets ignore order)
  println(authors === writers)  // false (distinct references)

//Conditional expression (one-liner, no Ternary operator)
  if (a > b) a else b




