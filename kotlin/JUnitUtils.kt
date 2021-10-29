package com.test

import java.io.File
import kotlin.test.*

fun assertAnalyzerBin(name: String, interpreter: String? = null) {
    var file: File? = null
    if(name.contains(File.separatorChar)) { //full path given
        file = File(name)
        assertTrue(file.exists(),"$name does not exist in the specified path")
    }
    else {
        val paths = System.getenv("PATH")
        paths.split(":").forEach {
            var current = File("$it${File.separatorChar}$name")
            if(current.exists()) {
                file = current
                return@forEach
            }
        }
        assertNotNull(file, "$name not found in PATH")
    }

    var shebang = file?.useLines { it.firstOrNull() }
    if(interpreter == null) {
        shebang?.matches("""^[\w#!/\s]*$""".toRegex())?.let { assertFalse(it, "$name is ASCII but expecting a binary: '$shebang'") }
    }
    else {
        assertNotNull(shebang, "$name is not a script file")
        shebang?.startsWith("#!")?.let { assertTrue(it, "No shebang line in script $name") }
        shebang?.contains(interpreter)?.let { assertTrue(it, "$name does not match expected interpreter") }
    }
}

fun assertCommandOutput(command: String, matcher: Regex) {
    println("command: '$command'")
    var output = command.run()
    println("output: '$output'")
    assertNotNull(output, "'$command' failed")

    val matches = "\n".toRegex().split(output).filter { it.matches(matcher) }
    assertTrue(matches.isNotEmpty(), "'$command' output did not match '$matcher'")
    println(matches)
}
