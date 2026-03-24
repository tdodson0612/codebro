import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson64 = Lesson(
  language: 'Java',
  title: 'Logging: java.util.logging and SLF4J',
  content: """
🎯 METAPHOR:
Logging is like the flight recorder on an airplane. You
don't know when or why you'll need it — but when something
goes wrong, the black box is the difference between
understanding what happened and total mystery. Good logging
is the flight recorder of your application: timestamped
events at the right level of detail, stored where you
can find them, structured so tools can parse them.
Bad logging is either silence (nothing useful when you
need it) or noise (every tiny detail drowning out the
signal). The art of logging is calibrating the levels:
DEBUG for development, INFO for production events,
WARN for concerning behavior, ERROR for failures.

📖 EXPLANATION:
Java has several logging frameworks. java.util.logging (JUL)
is built-in. SLF4J is the standard facade. Logback and Log4j2
are the most popular implementations.

─────────────────────────────────────
LOGGING LEVELS (low → high severity):
─────────────────────────────────────
  JUL levels:         SLF4J / Logback:
  FINEST            → TRACE
  FINER             → TRACE
  FINE              → DEBUG
  CONFIG            → DEBUG
  INFO              → INFO   ← default threshold in production
  WARNING           → WARN
  SEVERE            → ERROR

  Messages below the configured threshold are not logged.
  In production: usually INFO or WARN.
  In development: DEBUG or TRACE.

─────────────────────────────────────
java.util.logging (JUL) — built-in:
─────────────────────────────────────
  import java.util.logging.*;
  Logger logger = Logger.getLogger(MyClass.class.getName());

  logger.info("Application started");
  logger.warning("Low memory: " + free + " bytes remaining");
  logger.severe("Database connection failed: " + e.getMessage());
  logger.fine("Debug: processing item " + item);

  // Check level before expensive string building:
  if (logger.isLoggable(Level.FINE)) {
      logger.fine("Debug: " + expensiveToString());
  }

  // Log with exception:
  try { ... }
  catch (Exception e) {
      logger.log(Level.SEVERE, "Failed to process", e);
  }

─────────────────────────────────────
JUL CONFIGURATION (logging.properties):
─────────────────────────────────────
  handlers = java.util.logging.ConsoleHandler
  .level = INFO

  java.util.logging.ConsoleHandler.level = ALL
  java.util.logging.ConsoleHandler.formatter = java.util.logging.SimpleFormatter

  com.myapp.level = FINE   # package-level override

─────────────────────────────────────
SLF4J — THE STANDARD FACADE:
─────────────────────────────────────
  SLF4J is an API — not an implementation.
  Your code calls SLF4J, which delegates to a backend.
  Swap backends (Logback, Log4j2, JUL) by changing the JAR.

  import org.slf4j.Logger;
  import org.slf4j.LoggerFactory;

  // In each class:
  private static final Logger log = LoggerFactory.getLogger(MyClass.class);

  log.trace("Very detailed debug info");
  log.debug("Processing item: {}", item);        // {} = placeholder
  log.info("Server started on port {}", port);
  log.warn("Retry attempt {} of {}", retry, max);
  log.error("Request failed: {}", url);
  log.error("Exception in handler:", exception); // last param = Throwable

  // Conditional check (not needed with {} — already lazy):
  log.debug("Item: {}", item);   // item.toString() only called if DEBUG enabled

─────────────────────────────────────
SLF4J STRUCTURED LOGGING:
─────────────────────────────────────
  // {} placeholders — no string concatenation needed:
  log.info("User {} logged in from {}", userId, ipAddress);
  log.error("Failed to process order {} for user {}: {}", orderId, userId, e.getMessage());

  // MDC — Mapped Diagnostic Context (per-thread context):
  MDC.put("requestId", UUID.randomUUID().toString());
  MDC.put("userId", "alice123");
  log.info("Processing payment");  // log includes requestId + userId automatically
  MDC.clear();  // clean up

─────────────────────────────────────
LOGBACK CONFIGURATION (logback.xml):
─────────────────────────────────────
  <configuration>
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
      <encoder>
        <pattern>%d{HH:mm:ss} %-5level %logger{36} - %msg%n</pattern>
      </encoder>
    </appender>
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
      <file>logs/app.log</file>
      <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
        <fileNamePattern>logs/app.%d{yyyy-MM-dd}.log</fileNamePattern>
        <maxHistory>30</maxHistory>
      </rollingPolicy>
      <encoder>
        <pattern>%d{yyyy-MM-dd HH:mm:ss} %-5level [%thread] %logger{36} - %msg%n</pattern>
      </encoder>
    </appender>
    <root level="INFO">
      <appender-ref ref="CONSOLE"/>
      <appender-ref ref="FILE"/>
    </root>
    <logger name="com.myapp" level="DEBUG"/>
  </configuration>

─────────────────────────────────────
LOMBOK @Slf4j — zero boilerplate:
─────────────────────────────────────
  @Slf4j  // Lombok annotation
  public class MyService {
      public void doWork() {
          log.info("Working...");   // 'log' is auto-generated
      }
  }
  // Equivalent to: private static final Logger log = LoggerFactory.getLogger(MyService.class);

─────────────────────────────────────
LOGGING BEST PRACTICES:
─────────────────────────────────────
  ✅ Use {} placeholders — not string concatenation
  ✅ Log exceptions with the full stack trace
  ✅ Use MDC for request-scoped context (request ID, user ID)
  ✅ Include enough context to diagnose without reading source
  ✅ Use appropriate levels (DEBUG in dev, INFO in prod)
  ✅ Don't log passwords, tokens, or PII
  ✅ Use structured logging (JSON) in production for log aggregation

  ❌ log.debug("Value: " + expensive())  // always computed — use {}
  ❌ catch (Exception e) { log.error("Error"); }  // missing stack trace!
  ❌ Logging inside a tight loop at INFO/DEBUG level  // performance killer

💻 CODE:
import java.util.logging.*;
import java.util.*;

public class LoggingDemo {
    // java.util.logging (built-in — no dependencies)
    private static final Logger julLog = Logger.getLogger(LoggingDemo.class.getName());

    public static void main(String[] args) {

        // ─── java.util.logging ────────────────────────────
        System.out.println("=== java.util.logging (JUL) ===");

        // Configure programmatically (usually done via config file)
        Logger rootLogger = Logger.getLogger("");
        rootLogger.setLevel(Level.ALL);
        Handler[] handlers = rootLogger.getHandlers();
        for (Handler h : handlers) {
            h.setLevel(Level.ALL);
            h.setFormatter(new SimpleFormatter() {
                @Override
                public String format(LogRecord r) {
                    return String.format("[%-7s] %s: %s%n",
                        r.getLevel(), r.getLoggerName().replaceAll(".*\\.", ""),
                        r.getMessage());
                }
            });
        }

        julLog.setLevel(Level.ALL);

        // Log at various levels
        julLog.finest("FINEST: Very verbose detail");
        julLog.fine("FINE: Debug information");
        julLog.info("INFO: Server started on port 8080");
        julLog.warning("WARNING: High memory usage: 85%");
        julLog.severe("SEVERE: Database connection failed");

        // Log with exception
        try {
            int result = 10 / 0;
        } catch (ArithmeticException e) {
            julLog.log(Level.SEVERE, "Division failed", e);
        }

        // Check level before building expensive message
        if (julLog.isLoggable(Level.FINE)) {
            julLog.fine("Fine log: items=" + List.of(1, 2, 3));  // only built if FINE enabled
        }

        // ─── SLF4J PATTERN DEMO (without library) ─────────
        System.out.println("\n=== SLF4J Usage Pattern (conceptual) ===");
        System.out.println('''
          // pom.xml:
          <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>2.0.9</version>
          </dependency>
          <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-classic</artifactId>
            <version>1.4.11</version>
          </dependency>

          // In each class (best practice):
          private static final Logger log = LoggerFactory.getLogger(MyClass.class);

          // Logging calls:
          log.debug("Processing user: {}", userId);       // {} is placeholder
          log.info("Order {} created for user {}", orderId, userId);
          log.warn("Retry {}/{} for endpoint {}", attempt, max, url);
          log.error("Failed to process payment:", exception);  // full stack trace

          // MDC (Mapped Diagnostic Context):
          MDC.put("requestId", requestId);
          MDC.put("userId", userId);
          try {
              log.info("Handling request");   // all logs include requestId+userId
              processRequest();
          } finally {
              MDC.clear();
          }
          ''');

        // ─── LOGGING LEVELS REFERENCE ────────────────────
        System.out.println("=== Log Level Reference ===");
        String[][] levels = {
            { "TRACE / FINEST", "Very verbose debug — method entry/exit, every variable" },
            { "DEBUG / FINE",   "Development debugging — algorithm steps, intermediate values" },
            { "INFO",           "Production events — startup, shutdown, business milestones" },
            { "WARN / WARNING", "Concerning but not failing — low resources, deprecated API" },
            { "ERROR / SEVERE", "Failures that need attention — exceptions, data loss risk" },
        };
        for (String[] level : levels) {
            System.out.printf("  %-18s → %s%n", level[0], level[1]);
        }

        // ─── BEST PRACTICES ───────────────────────────────
        System.out.println("\n=== Logging Best Practices ===");
        System.out.println("  ✅ log.debug(\"User: {}\", userId)       — lazy evaluation");
        System.out.println("  ❌ log.debug(\"User: \" + userId)        — always evaluated");
        System.out.println("  ✅ log.error(\"Failed:\", exception)     — full stack trace");
        System.out.println("  ❌ log.error(e.getMessage())            — loses stack trace");
        System.out.println("  ✅ Include enough context to diagnose without reading code");
        System.out.println("  ✅ Use MDC for correlation IDs in distributed systems");
        System.out.println("  ✅ Use structured/JSON logging in production");
        System.out.println("  ❌ Never log passwords, tokens, credit cards, or PII");

        // ─── STRUCTURED LOG SIMULATION ────────────────────
        System.out.println("\n=== Structured Log Entry (JSON format) ===");
        // This is what logback with JsonLayout produces:
        String jsonLog = '''
                {
                  "timestamp": "2024-01-15T14:30:00Z",
                  "level": "INFO",
                  "thread": "http-nio-8080-exec-1",
                  "logger": "com.myapp.PaymentService",
                  "message": "Payment processed",
                  "userId": "user-42",
                  "orderId": "ORD-1234",
                  "amount": 99.99,
                  "requestId": "req-abc123",
                  "duration_ms": 145
                }
                ''';
        System.out.println(jsonLog);
    }
}

📝 KEY POINTS:
✅ Use SLF4J + Logback in production — not System.out.println or JUL directly
✅ {} placeholders in SLF4J are lazy — toString() only called if that level is enabled
✅ Always pass exceptions as the last argument to capture full stack trace
✅ MDC stores per-thread context (requestId, userId) included in all log lines
✅ Configure logging via logback.xml (Logback) or log4j2.xml (Log4j2) — not code
✅ Rolling file appender prevents unbounded log file growth
✅ Lombok @Slf4j eliminates the boilerplate Logger declaration
✅ Use structured/JSON logging in production for easy log aggregation (ELK, Splunk)
❌ Never use string concatenation in log calls — use {} placeholders
❌ Don't log sensitive data (passwords, tokens, PII) even at DEBUG level
❌ Don't log inside tight loops at INFO/DEBUG — it will destroy performance
❌ catch (Exception e) { log.error("Error"); } loses the stack trace entirely
""",
  quiz: [
    Quiz(question: 'Why should you use log.debug("Value: {}", obj) instead of log.debug("Value: " + obj)?', options: [
      QuizOption(text: 'With {}, toString() is only called if DEBUG level is enabled — avoiding wasted computation when logging is off', correct: true),
      QuizOption(text: '{} format strings are faster at runtime due to bytecode optimization', correct: false),
      QuizOption(text: 'String concatenation with + is deprecated in logging calls', correct: false),
      QuizOption(text: '{} handles null values safely while + would throw NullPointerException', correct: false),
    ]),
    Quiz(question: 'What does MDC (Mapped Diagnostic Context) do in SLF4J?', options: [
      QuizOption(text: 'Stores per-thread key-value data (like requestId) that is automatically included in all log entries on that thread', correct: true),
      QuizOption(text: 'Maps log levels to different output destinations based on context', correct: false),
      QuizOption(text: 'Provides a diagnostic mode that logs every method call automatically', correct: false),
      QuizOption(text: 'Converts log messages to multiple languages based on the server locale', correct: false),
    ]),
    Quiz(question: 'What is the role of SLF4J in Java logging?', options: [
      QuizOption(text: 'It is a logging facade/API — your code calls SLF4J, and a backend (Logback, Log4j2) does the actual logging', correct: true),
      QuizOption(text: 'SLF4J is a complete logging framework including file handlers and formatters', correct: false),
      QuizOption(text: 'SLF4J replaces java.util.logging entirely and is now bundled in the JDK', correct: false),
      QuizOption(text: 'SLF4J is only used for testing — Logback is used in production', correct: false),
    ]),
  ],
);
