package com.test

import ch.qos.logback.classic.spi.ILoggingEvent
import ch.qos.logback.core.AppenderBase

class ListeningAppender : AppenderBase<ILoggingEvent>() {
    private val events: MutableList<ILoggingEvent> = mutableListOf()

    fun lastLoggedEvent() = events.lastOrNull()

    override fun append(eventObject: ILoggingEvent) {
        events.add(eventObject)
    }
}
