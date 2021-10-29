

fun String.run(): String? {
    var output: String? = null
    try {
        val proc = ProcessBuilder(*(this.split("""\s+""".toRegex())).toTypedArray())
            .redirectOutput(ProcessBuilder.Redirect.PIPE)
            .redirectError(ProcessBuilder.Redirect.PIPE)
            .start()
        proc.waitFor(10, TimeUnit.SECONDS)
        output = proc.inputStream.bufferedReader().readText()
    } catch(e: IOException) {}
    return output
}

//Usage:
println("echo 'hello world'".run())
