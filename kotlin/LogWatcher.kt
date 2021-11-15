package com.test

import kotlin.test.assertEquals
import org.slf4j.Logger
import org.slf4j.LoggerFactory

object LogWatcher {
    private lateinit var appender: ListeningAppender
    private lateinit var logger: ch.qos.logback.classic.Logger
    private lateinit var cls: Class<*>

    fun getLogger(cls: Class<*>): Logger {
        appender = ListeningAppender()
        this.cls = cls
        logger = LoggerFactory.getLogger(this.cls) as ch.qos.logback.classic.Logger
        logger.addAppender(appender)
        appender.start()
        return logger
    }

    fun assertLog(message: String?) {
        val event = appender.lastLoggedEvent()
        assertEquals(message, event?.message, "LogWatcher mismatch")
    }
}
