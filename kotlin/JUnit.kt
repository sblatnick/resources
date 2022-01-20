package com.test.example

import com.test.*
import org.junit.jupiter.api.Test
import io.mockk.every
import io.mockk.mockk
import kotlin.test.assertFailsWith

class ExampleTest {
    @Test
    fun testTrivy() {
        assertAnalyzerBin("trivy")
        assertCommandOutput("trivy -v", """^Version: [\d\.]+$""".toRegex())
        assertFailsWith<IOException>("no IOException thrown", block = { example.start() })
    }
    fun testLog() {
        val example = Example()
        LogWatcher.getLogger(example.javaClass)
        LogWatcher.assertLog("Text in log4j")
    }

    // Simplify a complex object by returning something for every field:
    val example = mockk<ComplexObjectExample>(relaxed = true) {
        every { identifier } returns "1"
    }
    // Don't initialize anything:
    val example2 = mockk<ComplexObjectExample>(relaxed = true) {}

    @Nested
    inner class NestedExample {
        @Test
        fun `Complex name for a test`() {
            assertEquals(example.property, "1")
        }
    }

}
