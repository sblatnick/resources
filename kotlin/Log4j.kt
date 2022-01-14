

import org.slf4j.LoggerFactory
import ch.qos.logback.classic.Level
import ch.qos.logback.classic.Logger

//Programatically set root level:
val rootLogger: Logger = LoggerFactory.getLogger(org.slf4j.Logger.ROOT_LOGGER_NAME) as Logger
rootLogger.setLevel(Level.DEBUG)

//Or:
(LoggerFactory.getLogger(org.slf4j.Logger.ROOT_LOGGER_NAME) as Logger).level = Level.DEBUG

//Write to log using DEBUG level:
log.debug("""${this.javaClass}.createJiraIssue(id: $id) jira: "$jiraIssue"""")