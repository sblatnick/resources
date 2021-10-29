package com.test.example

import com.test.*
import org.junit.jupiter.api.Test

class ExampleTest {
    @Test
    fun testTrivy() {
        assertAnalyzerBin("trivy")
        assertCommandOutput("trivy -v", """^Version: [\d\.]+$""".toRegex())
    }
}
