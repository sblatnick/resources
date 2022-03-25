package com.example

class Version(val value: String) {
  val number = "^\\d+$".toRegex()
  val delimiter = "[._-]".toRegex()
  val prefix = "^\\D+\\d".toRegex()
  val suffix = "\\d\\D+$".toRegex()
  val empty = "^$".toRegex()

  override fun equals(that: Any?): Boolean {
    return when(that) {
      is Version -> this.compareTo(that) == 0
      is String -> this.compareTo(Version(that)) == 0
      else -> this.compareTo(Version(that.toString())) == 0
    }
  }
  operator fun compareTo(that: Version): Int {
    println("COMPARE (${this.value} vs ${that.value})")

    val parts = value.split(delimiter).zipAll(that.value.split(delimiter)).toMap()
    parts.forEach { (l, r) ->
      var left = l?:""
      var right = r?:""
      println("  RAW ($left vs $right)")
      val cmp = left.compareTo(right)
      val imp = (left.int()).compareTo(right.int())
      println("  INT (${left.int()} vs ${right.int()})")
      val segments = listOf(left, right)

      if(cmp == 0) return@forEach
      println("    cmp $cmp imp $imp")
      when {
        segments.all { it.matches(number) } -> when { //Integers
          imp != 0 -> return imp
          else -> Unit //continue
        }
        segments.any { it.matches(empty) } -> return cmp * -1 //Empty String
        segments.all { prefix.containsMatchIn(it) } -> return cmp //prefixed Integers
        segments.any { prefix.containsMatchIn(it) } -> when { //1 prefixed Integer
          imp != 0 -> return imp
          else -> cmp //alphabetical
        }
        segments.all { suffix.containsMatchIn(it) } -> return cmp //suffixed Integers
        segments.any { suffix.containsMatchIn(it) } -> return when { //1 suffixed Integer
          imp != 0 -> imp
          else -> cmp //alphabetical
        }
        else -> return when { //alphabetic
          cmp < -1 -> 1
          cmp > 1 -> -1
          else -> cmp
        }
      }
    }
    println("equal 0")
    return 0
  }
  companion object {
    fun compare(expression: String): Boolean {
      val (left, comparator, right) = expression.split(" ")
      val result = left.toVersion().compareTo(right.toVersion())
      println("RESULT  $result")
      val match = when {
        result < 0 -> "<"
        result > 0 -> ">"
        else -> "="
      }
      return comparator.contains(match)
    }
    fun String.toVersion(): Version {
      return Version(this)
    }

    //Source: https://dev.to/sip3/java-iterators-are-dead-long-live-kotlin-iterators-4ffh
    fun <T> Iterator<T>.nextOrNull(): T? {
      return if (hasNext()) next() else null
    }
    //Source: https://stackoverflow.com/questions/38232767/kotlin-zipall-alternative
    fun <T1: Any?, T2: Any?> List<T1>.zipAll(other: List<T2>): List<Pair<T1?, T2?>> {
      val i1 = this.iterator()
      val i2 = other.iterator()
      return generateSequence {
        if (i1.hasNext() || i2.hasNext()) {
          Pair(i1.nextOrNull(), i2.nextOrNull())
        } else {
          null
        }
      }.toList()
    }
    fun String.int(): Int {
      return "\\D".toRegex().replace(this, "").toIntOrNull()?: 0
    }
  }
}

//Testing:
import com.example.Version
import com.example.Version.Companion.toVersion
import kotlin.test.assertTrue
import kotlin.test.assertEquals

class VersionTest {
  @Test
  fun testVersions() {
    //assertTrue(Version.compare("1.1.1m > 1.0.5a"))
    assertTrue(Version.compare("1.1.1m > 1.1.1l"))
    assertTrue(Version.compare("1.1.1m == 1.1.1m"))
    assertTrue(Version.compare("1.1.1-0ubuntu2 >= 1.1.1-0ubuntu1"))
    assertTrue(Version.compare("1.1.1-1ubuntu1 > 1.1.1-0ubuntu1"))
    assertTrue(Version.compare("21.7.0rc2 > 21.7.0rc1"))
    assertTrue(Version.compare("21.7.0 > 21.7.0rc1"))
    assertTrue(Version.compare("2021.12.17 > 2020.12.17"))
    assertTrue(Version.compare("2021.01.01 > 2020.12.17"))
    assertTrue(Version.compare("1.0.0-alpha < 1.0.0"))
    assertTrue(Version.compare("1.0.0-rc1 < 1.0.0"))
    assertTrue(Version.compare("v1.0.0 == 1.0.0"))

    assertTrue("v1a".toVersion() < "v1b".toVersion())
    assertTrue("a1x".toVersion() < "b1x".toVersion())
    assertTrue("a1x".toVersion() < "b0x".toVersion())
    assertTrue("v1.9".toVersion() < "v1.10".toVersion())
    assertTrue("v1.9".toVersion() < "v2.0".toVersion())
    assertTrue("v2.8".toVersion() > "v1.9".toVersion())
    assertTrue("filename_something-12.0.12.tar.gz".toVersion() > "filename_something-12.0.01.tar.gz".toVersion())
    assertTrue("filename_something-12.0.12a.tar.gz".toVersion() < "filename_something-12.0.12b.tar.gz".toVersion())
    assertTrue("0.12a.tar.gz".toVersion() > "0.12.tar.gz".toVersion())
    assertTrue("1.9-1".toVersion() < "1.9-2".toVersion())
    assertTrue("1.9-a".toVersion() < "1.9-b".toVersion())
    assertTrue("02".toVersion() > "01".toVersion())
    assertTrue("abc".toVersion() <= "abc".toVersion())
    assertTrue("2".toVersion() <= "v2".toVersion())
    assertTrue("2".toVersion() == "v2".toVersion())
    assertEquals("2".toVersion(), "v2".toVersion())
  }
}

//Output:
COMPARE (1.1.1m vs 1.1.1l)
  RAW (1 vs 1)
  INT (1 vs 1)
  RAW (1m vs 1l)
  INT (1 vs 1)
    cmp 1 imp 0
RESULT  1
COMPARE (1.1.1m vs 1.1.1m)
  RAW (1 vs 1)
  INT (1 vs 1)
  RAW (1m vs 1m)
  INT (1 vs 1)
equal 0
RESULT  0
COMPARE (1.1.1-0ubuntu2 vs 1.1.1-0ubuntu1)
  RAW (1 vs 1)
  INT (1 vs 1)
  RAW (0ubuntu2 vs 0ubuntu1)
  INT (2 vs 1)
    cmp 1 imp 1
RESULT  1
COMPARE (1.1.1-1ubuntu1 vs 1.1.1-0ubuntu1)
  RAW (1 vs 1)
  INT (1 vs 1)
  RAW (1ubuntu1 vs 0ubuntu1)
  INT (11 vs 1)
    cmp 1 imp 1
RESULT  1
COMPARE (21.7.0rc2 vs 21.7.0rc1)
  RAW (21 vs 21)
  INT (21 vs 21)
  RAW (7 vs 7)
  INT (7 vs 7)
  RAW (0rc2 vs 0rc1)
  INT (2 vs 1)
    cmp 1 imp 1
RESULT  1
COMPARE (21.7.0 vs 21.7.0rc1)
  RAW (21 vs 21)
  INT (21 vs 21)
  RAW (7 vs 7)
  INT (7 vs 7)
  RAW (0 vs 0rc1)
  INT (0 vs 1)
    cmp -3 imp -1
RESULT  1
COMPARE (2021.12.17 vs 2020.12.17)
  RAW (2021 vs 2020)
  INT (2021 vs 2020)
    cmp 1 imp 1
RESULT  1
COMPARE (2021.01.01 vs 2020.12.17)
  RAW (2021 vs 2020)
  INT (2021 vs 2020)
    cmp 1 imp 1
RESULT  1
COMPARE (1.0.0-alpha vs 1.0.0)
  RAW (1 vs 1)
  INT (1 vs 1)
  RAW (0 vs 0)
  INT (0 vs 0)
  RAW (alpha vs )
  INT (0 vs 0)
    cmp 5 imp 0
RESULT  -5
COMPARE (1.0.0-rc1 vs 1.0.0)
  RAW (1 vs 1)
  INT (1 vs 1)
  RAW (0 vs 0)
  INT (0 vs 0)
  RAW (rc1 vs )
  INT (1 vs 0)
    cmp 3 imp 1
RESULT  -3
COMPARE (v1.0.0 vs 1.0.0)
  RAW (v1 vs 1)
  INT (1 vs 1)
    cmp 69 imp 0
  RAW (0 vs 0)
  INT (0 vs 0)
equal 0
RESULT  0
COMPARE (v1a vs v1b)
  RAW (v1a vs v1b)
  INT (1 vs 1)
    cmp -1 imp 0
COMPARE (a1x vs b1x)
  RAW (a1x vs b1x)
  INT (1 vs 1)
    cmp -1 imp 0
COMPARE (a1x vs b0x)
  RAW (a1x vs b0x)
  INT (1 vs 0)
    cmp -1 imp 1
COMPARE (v1.9 vs v1.10)
  RAW (v1 vs v1)
  INT (1 vs 1)
  RAW (9 vs 10)
  INT (9 vs 10)
    cmp 8 imp -1
COMPARE (v1.9 vs v2.0)
  RAW (v1 vs v2)
  INT (1 vs 2)
    cmp -1 imp -1
COMPARE (v2.8 vs v1.9)
  RAW (v2 vs v1)
  INT (2 vs 1)
    cmp 1 imp 1
COMPARE (filename_something-12.0.12.tar.gz vs filename_something-12.0.01.tar.gz)
  RAW (filename vs filename)
  INT (0 vs 0)
  RAW (something vs something)
  INT (0 vs 0)
  RAW (12 vs 01)
  INT (12 vs 1)
    cmp 1 imp 1
COMPARE (filename_something-12.0.12a.tar.gz vs filename_something-12.0.12b.tar.gz)
  RAW (filename vs filename)
  INT (0 vs 0)
  RAW (something vs something)
  INT (0 vs 0)
  RAW (12 vs 12)
  INT (12 vs 12)
  RAW (0 vs 0)
  INT (0 vs 0)
  RAW (12a vs 12b)
  INT (12 vs 12)
    cmp -1 imp 0
COMPARE (0.12a.tar.gz vs 0.12.tar.gz)
  RAW (0 vs 0)
  INT (0 vs 0)
  RAW (12a vs 12)
  INT (12 vs 12)
    cmp 1 imp 0
COMPARE (1.9-1 vs 1.9-2)
  RAW (1 vs 2)
  INT (1 vs 2)
    cmp -1 imp -1
COMPARE (1.9-a vs 1.9-b)
  RAW (1 vs 1)
  INT (1 vs 1)
  RAW (9 vs 9)
  INT (9 vs 9)
  RAW (a vs b)
  INT (0 vs 0)
    cmp -1 imp 0
COMPARE (02 vs 01)
  RAW (02 vs 01)
  INT (2 vs 1)
    cmp 1 imp 1
COMPARE (abc vs abc)
  RAW (abc vs abc)
  INT (0 vs 0)
equal 0
COMPARE (2 vs v2)
  RAW (2 vs v2)
  INT (2 vs 2)
    cmp -68 imp 0
equal 0
COMPARE (2 vs v2)
  RAW (2 vs v2)
  INT (2 vs 2)
    cmp -68 imp 0
equal 0
COMPARE (2 vs v2)
  RAW (2 vs v2)
  INT (2 vs 2)
    cmp -68 imp 0
equal 0

Process finished with exit code 0