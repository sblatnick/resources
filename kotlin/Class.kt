class Customer

class Contact(val id: Int, var email: String)

class Example(val name: String)
{
  //body
}

fun main() {
  val customer = Customer()

  val contact = Contact(1, "mary@gmail.com")

  println(contact.id)
  contact.email = "jane@gmail.com"
}


//Generics:
  //Class:
  class MutableStack<E>(vararg items: E) {

    private val elements = items.toMutableList()

    fun push(element: E) = elements.add(element)

    fun peek(): E = elements.last()

    fun pop(): E = elements.removeAt(elements.size - 1)

    fun isEmpty() = elements.isEmpty()

    fun size() = elements.size

    override fun toString() = "MutableStack(${elements.joinToString()})"
  }

  //Utility generic function:
  fun <E> mutableStackOf(vararg elements: E) = MutableStack(*elements)

  fun main() {
    val stack = mutableStackOf(0.62, 3.14, 2.7)
    println(stack)
  }

//Inheritance:
  open class Dog {
    open fun sayHello() {
      println("wow wow!")
    }
  }

  class Yorkshire : Dog() {
    override fun sayHello() {
      println("wif wif!")
    }
  }

  fun main() {
    val dog: Dog = Yorkshire()
    dog.sayHello()
  }

  //Parameterization:
  open class Tiger(val origin: String) {
    fun sayHello() {
      println("A tiger from $origin says: grrhhh!")
    }
  }

  class SiberianTiger : Tiger("Siberia")

  fun main() {
    val tiger: Tiger = SiberianTiger()
    tiger.sayHello()
  }

  //Superclass parameter passing:
  open class Lion(val name: String, val origin: String) {
    fun sayHello() {
      println("$name, the lion from $origin says: graoh!")
    }
  }

  class Asiatic(name: String) : Lion(name = name, origin = "India")

  fun main() {
    val lion: Lion = Asiatic("Rufo")
    lion.sayHello()
  }

//Common Class Interfaces:
  //Data Classes:
    data class User(val name: String, val id: Int) {
      override fun equals(other: Any?) =
        other is User && other.id == this.id
    }
    //Requires in primary constructor:
    // >=1 parameter
    // val/var declarations
    //Cannot be abstract, open, sealed, or inner

    //Implements:
    equals()
    hashCode()
    toString() //"Class(param=Value)"
    //Not overridable:
    componentN()
    copy()

  //Enum:
    enum class State {
      IDLE, RUNNING, FINISHED
    }
    //Usage:
    fun main() {
      val state = State.RUNNING
      val message = when (state) {
        State.IDLE -> "It's idle"
        State.RUNNING -> "It's running"
        State.FINISHED -> "It's finished"
      }
      println(message)
    }

    //Functions:
    enum class Color(val rgb: Int) {
      WHITE(0xFFFFFF),
      RED(0xFF0000),
      GREEN(0x00FF00),
      BLUE(0x0000FF),
      YELLOW(0xFFFF00);

      fun containsRed() = (this.rgb and 0xFF0000 != 0)

      companion object {
        //Access from java/jsp without calling Companion:
        @JvmStatic fun descending():Array<Color> = values().reversedArray()

        fun fromOptionalColor(color: Int?): Color? = if (color == null) null else values().firstOrNull { c -> color == c.rgb }
        fun fromColor(color: Int, defaultColor: Color = WHITE): Color = fromOptionalColor(color) ?: defaultColor
      }
    }

    fun main() {
      val red = Color.RED
      println(red)
      println(red.containsRed())
      println(Color.BLUE.containsRed())
      println(Color.YELLOW.containsRed())
    }

  //Sealed: all subclasses presented in package
    sealed class Mammal(val name: String)

  //Object keyword:
    //expression:
      val dayRates = object {
        var standard: Int = 30 * standardDays
        var festivity: Int = 50 * festivityDays
        var special: Int = 100 * specialDays
      }
      //Usage:
      println(dayRates.standard)

    //static/singleton classes:
      object DoAuth { 
        fun takeParams(username: String, password: String) { 
          println("input Auth parameters = $username:$password")
        }
      }

      //Usage:
      fun main(){
        DoAuth.takeParams("foo", "qwerty")
      }

    //companion objects: static methods
      class Example {
        companion object Friend {
          fun method() {

      //Usage:
      Example.method()

  //Extensions: defined outside of class
    data class Item(val name: String, val price: Float)
    data class Order(val items: Collection<Item>)
    //Functions:
      fun Order.maxPricedItemValue(): Float = this.items.maxByOrNull { it.price }?.price ?: 0F
    //Properties:
      val Order.commaDelimitedItemNames: String
        get() = items.map { it.name }.joinToString()

