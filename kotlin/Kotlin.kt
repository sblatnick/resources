
package example

class Kotlin {

  //Source: https://play.kotlinlang.org/byExample/01_introduction/01_Hello%20world

  //Functions:
    //parameter of type String and returns Unit (no return value).
    fun printMessage(message: String): Unit {
      println(message)
    }

    //second optional parameter with default value "Info"
    //return type is omitted, meanings Unit
    fun printMessageWithPrefix(message: String, prefix: String = "Info") {
      println("[$prefix] $message")
    }

    fun sum(x: Int, y: Int): Int {
      return x + y
    }

    //A single-expression function that returns an integer (inferred).
    fun multiply(x: Int, y: Int) = x * y

  //Function Usage:

    fun main() {
      println("Hello, World!")

      //Calls the first function with the argument Hello.
      printMessage("Hello")
      //Calls the function with two parameters, passing values for both of them.
      printMessageWithPrefix("Hello", "Log")
      //Calls the same function omitting the second one. The default value Info is used.
      printMessageWithPrefix("Hello")
      //Calls the same function using named arguments and changing the order of the arguments.
      printMessageWithPrefix(prefix = "Log", message = "Hello")
      //Prints the result of the sum function call.
      println(sum(1, 2))
      //Prints the result of the multiply function call.
      println(multiply(2, 4))
    }

  //Functions as parameters: combine()
    fun <T, R> Collection<T>.fold(
      initial: R,
      combine: (acc: R, nextElement: T) -> R
    ): R {
      var accumulator: R = initial
      for (element: T in this) {
        accumulator = combine(accumulator, element)
      }
      return accumulator
    }
  //Lambda:
  items.fold(0, { 
    //parameters ->
    acc: Int, i: Int ->
    //contents
    print("acc = $acc, i = $i, ") 
    val result = acc + i
    println("result = $result")
    //last expression in a lambda is the return value:
    result
  })


  //Infix = member functions on single parameter, without . and ()
    fun main() {

      //extension to Int
      infix fun Int.times(str: String) = str.repeat(this)
      //Calls the infix function.
      println(2 times "Bye ")

      //Creates a Pair by calling the infix function to from the standard library
      //("to" can also be used for mapping)
      val pair = "Ferrari" to "Katrina"
      println(pair)

      //Here's your own implementation of to creatively called onto.
      infix fun String.onto(other: String) = Pair(this, other)
      val myPair = "McLaren" onto "Lucas"
      println(myPair)

      val sophia = Person("Sophia")
      val claudia = Person("Claudia")
      //Infix notation also works on members functions (methods).
      sophia likes claudia
    }

    class Person(val name: String) {
      val likedPeople = mutableListOf<Person>()
      //The containing class becomes the first parameter.
      infix fun likes(other: Person) { likedPeople.add(other) }
    }

  //Operator = Infix with symbols
    //Summary:
      //Unary:
        +x         x.unaryPlus()
        -x         x.unaryMinus()
        !x         x.not()

        //must return a value, not mutate object:
        x++        x.inc() //Increment
        x--        x.dec() //Decrement

      //Binary:
        a + b      a.plus(b)
        a - b      a.minus(b)
        a * b      a.times(b)
        a / b      a.div(b)
        a % b      a.rem(b)
        a..b       a.rangeTo(b)

        a in b     b.contains(a)
        a !in b    !b.contains(a)

      //Indexed:
        a[i]       a.get(i)
        a[i,j]     a.get(i,j)
        a[i,j,k]   a.get(i,j,k)

        a[i] = b   a.set(i,b)
        a[i,j] = b a.set(i,j,b)
        //etc...

      //Invoke
        a()        a.invoke()
        a(i)       a.invoke(i)
        a(i,j)     a.invoke(i,j)
        //etc...

      //Augmented
        a += b     a.plusAssign(b)
        a -= b     a.minusAssign(b)
        a *= b     a.timesAssign(b)
        a /= b     a.divAssign(b)
        a %= b     a.remAssign(b)

      //Comparitors
        a == b     a?.equals(b) ?: (b === null)
        a != b     !(a?.equals(b) ?: (b === null))
        //not available: ===, !==
        //== screens for nulls
          //null == null is always true
          //x == null is always false and won't invoke x.equals()

        a > b      a.compareTo(b) > 0
        a < b      a.compareTo(b) < 0
        a >= b     a.compareTo(b) >= 0
        a <= b     a.compareTo(b) <= 0

      //Property Delegation
        provideDelegate
        getValue
        setValue

    //Examples:
      //"infix" replaced with "operator":
      operator fun Int.times(str: String) = str.repeat(this)
      //usage:
      println(2 * "Bye ")

      //An operator function allows easy range access on strings.
      operator fun String.get(range: IntRange) = substring(range)
      val str = "Always forgive your enemies; nothing annoys them so much."
      //The get() operator enables bracket-access syntax
      println(str[0..14]) //Always forgive


  //Delegated Properties:

    //read-only:
    //- thisRef same or supertype of the owning class
    //- property must be KProperty<*> or supertype
    //mutable:
    //- setValue(thisRef: Owner, property: KProperty<*>, value: Any?)

    //Define:
    class Example {
      var p: String by Delegate()
    }

    import kotlin.reflect.KProperty

    class Delegate {
      operator fun getValue(thisRef: Any?, property: KProperty<*>): String {
        return "$thisRef, thank you for delegating '${property.name}' to me!"
      }

      operator fun setValue(thisRef: Any?, property: KProperty<*>, value: String) {
        println("$value has been assigned to '${property.name}' in $thisRef.")
      }
    }

    //Usage:
    val e = Example()
    println(e.p) //getter: "Example@33a17727, thank you for delegating ‘p’ to me!"
    e.p = "NEW"  //setter: "NEW has been assigned to ‘p’ in Example@33a17727."

    //Pre-defined delegates (Instead of implementing like above)
      //lazy = initialized once
        val lazyValue: String by lazy {
          println("computed!") //like static/final, only calculculated once
          "Hello"
        }
        //Usage:
        println(lazyValue)
          computed!
          Hello
        println(lazyValue)
          Hello
      //lazy variable = only executed at most once if the variable is accessed
        val memoizedFoo by lazy(computeFoo)
      //observable = handler callback after update
        import kotlin.properties.Delegates

        class User {
            var name: String by Delegates.observable("<no name>") {
                prop, old, new ->
                println("$old -> $new")
            }
        }

        fun main() {
            val user = User()
            user.name = "first"
            user.name = "second"
        }
      //vetoable = handler callback before update
    //Map to another property
      var delegatedToMember: Int by this::memberInt
      var delegatedToTopLevel: Int by ::topLevelInt
      val delegatedToAnotherClass: Int by anotherClassInstance::anotherClassInt
    //Map storage
      class User(val map: Map<String, Any?>) {
        val name: String by map
        val age: Int     by map
      }
      val user = User(mapOf(
        "name" to "John Doe",
        "age"  to 25
      ))
      println(user.name) // Prints "John Doe"
      println(user.age)  // Prints 25
    //Extension interface:
      //check the consistency of the property upon its initialization:
      provideDelegate(thisRef: Example, prop: KProperty<*>): ReadOnlyProperty<Example, T>
}

