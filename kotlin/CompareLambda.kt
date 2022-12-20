//Bug in semantic version differences
//May as well just compare strings
//Look at Version.kt instead
//Keeping this example to show extending String and using lambdas

    @Test
    fun testVersions() {
        val check = { left: String, right: String, expected: String ->
            val cmp = when(left.compareVersions(right)) {
                -1 -> "<"
                0 -> "=="
                1 -> ">"
                else -> "?"
            }
            assertEquals(expected, cmp, "found: '$left' $cmp '$right'")
        }
        check("v1.9", "v1.10", "<")
        check("v1.9", "v2.0", "<")
        check("v2.8", "v1.9", ">")
        check("filename_something-12.0.12.tar.gz", "filename_something-12.0.01.tar.gz", ">")
        check("filename_something-12.0.12a.tar.gz", "filename_something-12.0.12b.tar.gz", "<")
        check("1.9-1", "1.9-2", "<")
        check("1.9-a", "1.9-b", "<")
        check("02", "01", ">")
        check("abc", "abc", "==")
        check("2", "2", "==")
        //last expression in a lambda is the return value
    }
    fun String.compareVersions(that: String): Int {
        val delimiter = "[._-]".toRegex()
        val parts = this.split(delimiter).zip(that.split(delimiter)).toMap()
        parts.forEach { (left, right) ->
            val imp = (left.toIntOrNull()?: 0).compareTo(right.toIntOrNull()?: 0)
            if (imp == 0) {
                val cmp = left.compareTo(right)
                if (cmp != 0) {
                    println("str $cmp ($left vs $right)")
                    return cmp
                }
            } else {
                println("int $imp ($left vs $right)")
                return imp
            }
        }
        println("eql 0 ($this vs $that)")
        return 0
    }

//Output:
int -1 (9 vs 10)
str -1 (v1 vs v2)
str 1 (v2 vs v1)
int 1 (12 vs 01)
str -1 (12a vs 12b)
int -1 (1 vs 2)
str -1 (a vs b)
int 1 (02 vs 01)
eql 0 (abc vs abc)
eql 0 (2 vs 2)


//compareValuesBy Examples:
  //vararg:
  fun compareLengthThenString(a: String, b: String): Int =
    compareValuesBy(a, b, { it.length }, { it })

  //table sorting by column selected:
  data class Row(val table: Example, val orderColumn: Int) : Comparable<Row> {
        override fun compareTo(other: Row) = compareValuesBy(this, other) { row ->
            with(row) {
                when(orderColumn) {
                    0 -> table.identifier
                    1 -> table.title
                    2 -> table.source
                    3 -> table.project
                    else -> throw IllegalArgumentException("Not a valid sort column: $orderColumn")
                }
            }
        }
    }