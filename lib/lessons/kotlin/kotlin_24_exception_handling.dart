import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson24 = Lesson(
  language: 'Kotlin',
  title: 'Exception Handling',
  content: """
🎯 METAPHOR:
Exception handling is like the safety systems on a modern
car. Normal driving is the try block — everything works as
expected. The airbag is the catch block — when something
goes wrong (a crash), it deploys to handle the situation.
The seatbelt is the finally block — it's ALWAYS buckled,
whether you crash or not, for every single trip.
Without these systems, any unexpected event (a null,
a missing file, a network timeout) crashes the entire
program — the car careens off the road with no recovery.

📖 EXPLANATION:
Exceptions are events that disrupt normal program flow.
Kotlin handles them with try/catch/finally — and like if,
try is an EXPRESSION in Kotlin (it can return a value).

─────────────────────────────────────
BASIC TRY/CATCH:
─────────────────────────────────────
  try {
      // code that might throw
  } catch (e: ExceptionType) {
      // handle the exception
  } finally {
      // always runs, whether exception or not
  }

─────────────────────────────────────
TRY AS AN EXPRESSION:
─────────────────────────────────────
  val result = try {
      "42".toInt()
  } catch (e: NumberFormatException) {
      -1    // returned if parse fails
  }

This is idiomatic Kotlin — assign the result of a
try block directly to a variable.

─────────────────────────────────────
EXCEPTION HIERARCHY:
─────────────────────────────────────
  Throwable
  ├── Error          (JVM errors — don't catch these)
  └── Exception
      ├── RuntimeException
      │   ├── NullPointerException
      │   ├── IllegalArgumentException
      │   ├── IllegalStateException
      │   ├── IndexOutOfBoundsException
      │   └── ArithmeticException
      └── IOException
          └── FileNotFoundException

─────────────────────────────────────
THROWING EXCEPTIONS:
─────────────────────────────────────
  throw IllegalArgumentException("Value must be positive")
  throw IllegalStateException("Not initialized")
  throw UnsupportedOperationException("Not implemented")

Helper functions (return Nothing):
  require(condition) { "message" }   // throws IllegalArgumentException
  check(condition) { "message" }     // throws IllegalStateException
  error("message")                   // throws IllegalStateException

These are idiomatic Kotlin — prefer them over throw directly.

─────────────────────────────────────
MULTIPLE CATCH BLOCKS:
─────────────────────────────────────
  try {
      // ...
  } catch (e: NumberFormatException) {
      println("Bad number format")
  } catch (e: IOException) {
      println("IO problem")
  } catch (e: Exception) {
      println("Something else: \${e.message}")
  }

Catch from MOST specific to LEAST specific.

─────────────────────────────────────
CUSTOM EXCEPTIONS:
─────────────────────────────────────
  class ValidationException(
      message: String,
      val field: String
  ) : Exception(message)

  class InsufficientFundsException(
      val amount: Double,
      val balance: Double
  ) : Exception("Cannot withdraw \$amount — balance is \$balance")

─────────────────────────────────────
NO CHECKED EXCEPTIONS IN KOTLIN:
─────────────────────────────────────
Java forces you to declare checked exceptions with throws.
Kotlin has NO checked exceptions — you handle them when
you want to, not because the compiler forces you.
This reduces boilerplate while requiring more discipline.

─────────────────────────────────────
runCatching — functional exception handling:
─────────────────────────────────────
  val result = runCatching { "abc".toInt() }
  result.onSuccess { println("Got: \$it") }
  result.onFailure { println("Failed: \${it.message}") }
  val value = result.getOrDefault(-1)
  val value2 = result.getOrElse { -1 }

runCatching returns a Result<T> — a success or failure
wrapped in a value, like a lightweight sealed class.

💻 CODE:
import java.io.IOException

class ValidationException(message: String, val field: String) : Exception(message)

class BankAccount(val owner: String, initialBalance: Double) {
    var balance = initialBalance
        private set

    fun withdraw(amount: Double) {
        require(amount > 0) { "Withdrawal amount must be positive, got \$amount" }
        check(balance >= amount) { "Insufficient funds: need \$amount, have \$balance" }
        balance -= amount
        println("Withdrew \$amount. New balance: \$balance")
    }

    fun deposit(amount: Double) {
        require(amount > 0) { "Deposit must be positive" }
        balance += amount
    }
}

fun parseAndDouble(input: String): Int {
    val number = input.toIntOrNull()
        ?: throw NumberFormatException("'\$input' is not a valid integer")
    return number * 2
}

fun validateUser(name: String, age: Int) {
    if (name.isBlank()) throw ValidationException("Name cannot be blank", "name")
    if (age < 0 || age > 150) throw ValidationException("Age must be 0-150", "age")
}

fun riskyOperation(input: String): String {
    return when (input) {
        "null"  -> throw NullPointerException("Got a null!")
        "io"    -> throw IOException("Disk read failed")
        "arg"   -> throw IllegalArgumentException("Bad argument: \$input")
        else    -> "Processed: \$input"
    }
}

fun main() {
    // Basic try/catch/finally
    try {
        val result = 10 / 0
        println(result)
    } catch (e: ArithmeticException) {
        println("Cannot divide by zero: \${e.message}")
    } finally {
        println("This always runs")
    }

    // try as expression
    val parsed = try {
        "123".toInt()
    } catch (e: NumberFormatException) {
        -1
    }
    println("Parsed: \$parsed")   // 123

    val failed = try {
        "abc".toInt()
    } catch (e: NumberFormatException) {
        -1
    }
    println("Failed parse: \$failed")   // -1

    // require and check
    val account = BankAccount("Terry", 500.0)
    account.deposit(100.0)
    account.withdraw(200.0)

    try {
        account.withdraw(1000.0)   // will throw IllegalStateException
    } catch (e: IllegalStateException) {
        println("Caught: \${e.message}")
    }

    try {
        account.withdraw(-50.0)    // will throw IllegalArgumentException
    } catch (e: IllegalArgumentException) {
        println("Caught: \${e.message}")
    }

    // Custom exception
    try {
        validateUser("", 25)
    } catch (e: ValidationException) {
        println("Validation failed on field '\${e.field}': \${e.message}")
    }

    // Multiple catch blocks
    val inputs = listOf("hello", "null", "io", "arg", "world")
    for (input in inputs) {
        try {
            println(riskyOperation(input))
        } catch (e: NullPointerException) {
            println("NPE: \${e.message}")
        } catch (e: IOException) {
            println("IO error: \${e.message}")
        } catch (e: IllegalArgumentException) {
            println("Arg error: \${e.message}")
        }
    }

    // runCatching — functional style
    println("\\n--- runCatching ---")
    val results = listOf("42", "bad", "100", "nope").map { input ->
        runCatching { input.toInt() }
    }

    results.forEach { result ->
        result
            .onSuccess { println("Success: \$it") }
            .onFailure { println("Failed: \${it.message}") }
    }

    val values = results.map { it.getOrDefault(0) }
    println("Values with defaults: \$values")   // [42, 0, 100, 0]
}

📝 KEY POINTS:
✅ try is an expression in Kotlin — assign its result to a variable
✅ finally always runs — use for cleanup (closing files, etc.)
✅ Use require() for argument validation — throws IllegalArgumentException
✅ Use check() for state validation — throws IllegalStateException
✅ Kotlin has NO checked exceptions — handle when appropriate
✅ runCatching wraps exceptions in Result<T> for functional handling
✅ Custom exceptions extend Exception (or a subclass)
✅ Catch from most specific to most general
❌ Don't catch Exception or Throwable broadly unless necessary
❌ Don't use exceptions for normal control flow — they're expensive
❌ Never swallow exceptions silently: catch(e) { } is a bug
❌ Don't use toInt() on untrusted input — use toIntOrNull() instead
""",
  quiz: [
    Quiz(question: 'What is unique about try in Kotlin compared to Java?', options: [
      QuizOption(text: 'In Kotlin, try is an expression and can return a value', correct: true),
      QuizOption(text: 'Kotlin\'s try does not require a catch block', correct: false),
      QuizOption(text: 'Kotlin\'s try automatically retries the block on failure', correct: false),
      QuizOption(text: 'In Kotlin, try catches all exceptions automatically', correct: false),
    ]),
    Quiz(question: 'What does require(condition) { "message" } do?', options: [
      QuizOption(text: 'Throws IllegalArgumentException with the message if the condition is false', correct: true),
      QuizOption(text: 'Throws IllegalStateException with the message if the condition is false', correct: false),
      QuizOption(text: 'Returns the message string if the condition is false', correct: false),
      QuizOption(text: 'Logs a warning if the condition is false but continues execution', correct: false),
    ]),
    Quiz(question: 'What does runCatching { } return?', options: [
      QuizOption(text: 'A Result<T> containing either a success value or the caught exception', correct: true),
      QuizOption(text: 'A Boolean indicating whether the block succeeded', correct: false),
      QuizOption(text: 'The return value of the block, or null if an exception was thrown', correct: false),
      QuizOption(text: 'A sealed class with Success and Failure subtypes that you define', correct: false),
    ]),
  ],
);
