import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson44 = Lesson(
  language: 'Kotlin',
  title: 'Design Patterns in Kotlin',
  content: """
🎯 METAPHOR:
Design patterns are like architectural blueprints for
buildings. You don't reinvent how to build a staircase
every time you build one — you follow the proven pattern
for staircases. Structural patterns (how pieces fit together),
behavioral patterns (how pieces communicate), and creational
patterns (how objects are made) are the architectural
vocabulary of software. Kotlin doesn't just support these
patterns — it often makes them trivial. What Java needs 30
lines of boilerplate to express, Kotlin does in 3.

📖 EXPLANATION:
The classic Gang of Four patterns remain relevant, but
Kotlin's language features often provide cleaner, more
concise implementations than Java. Some patterns (Singleton,
Builder) are so well supported that they're almost built in.

─────────────────────────────────────
CREATIONAL PATTERNS:
─────────────────────────────────────

SINGLETON — object declaration:
  object AppConfig {
      var theme = "Light"
  }
  // Done. Thread-safe, lazy, no boilerplate.

BUILDER — apply or named parameters:
  // Named params replace builder pattern in most cases:
  val request = HttpRequest(
      url = "https://api.example.com",
      method = "GET",
      timeout = 30
  )

  // Or with apply for mutation-based building:
  val config = ServerConfig().apply {
      host = "localhost"
      port = 8080
  }

FACTORY — companion object:
  class Shape private constructor(val type: String) {
      companion object {
          fun circle() = Shape("circle")
          fun square() = Shape("square")
      }
  }

PROTOTYPE — data class copy():
  val original = User(1, "Terry", "terry@email.com")
  val modified = original.copy(email = "new@email.com")

─────────────────────────────────────
STRUCTURAL PATTERNS:
─────────────────────────────────────

DECORATOR — extension functions:
  fun String.highlight() = "**\$this**"
  fun String.truncated(max: Int) = if (length > max) take(max) + "..." else this
  "Hello World".highlight().truncated(10)

ADAPTER — extension functions or wrapper class:
  // Make Java's Date work like Kotlin's LocalDate style
  fun java.util.Date.toFormattedString(): String = ...

FACADE — simple function wrapping complex operations:
  fun sendWelcomeEmail(user: User) {
      val content = EmailBuilder().build(user)
      val encrypted = Encryptor.encrypt(content)
      EmailSender.send(user.email, encrypted)
  }

PROXY — delegation with by:
  class LoggingRepository(private val real: UserRepository)
      : UserRepository by real {
      override fun getUser(id: Int): User? {
          println("Getting user \$id")
          return real.getUser(id)
      }
  }

─────────────────────────────────────
BEHAVIORAL PATTERNS:
─────────────────────────────────────

OBSERVER — Flow/StateFlow:
  val _state = MutableStateFlow(initialState)
  val state: StateFlow<State> = _state
  // Observers collect the flow

STRATEGY — higher-order functions:
  // Instead of a Strategy interface hierarchy:
  fun sort(list: List<Int>, comparator: (Int, Int) -> Int) =
      list.sortedWith { a, b -> comparator(a, b) }

  sort(list) { a, b -> a - b }    // ascending
  sort(list) { a, b -> b - a }    // descending

COMMAND — lambdas or sealed classes:
  val commands = mutableListOf<() -> Unit>()
  commands.add { println("Do task 1") }
  commands.add { println("Do task 2") }
  commands.forEach { it() }

TEMPLATE METHOD — abstract class with hook:
  abstract class DataProcessor {
      fun process() {
          readData()
          transform()    // abstract — subclass defines
          writeData()
      }
      abstract fun transform()
      open fun readData() { println("Reading...") }
      open fun writeData() { println("Writing...") }
  }

CHAIN OF RESPONSIBILITY — function chain:
  typealias Handler<T> = (T) -> T?

  fun <T> chain(vararg handlers: Handler<T>): Handler<T> = { input ->
      var result: T? = input
      for (handler in handlers) {
          result = result?.let { handler(it) } ?: break
      }
      result
  }

💻 CODE:
// ─── OBSERVER pattern with callbacks and sealed state ─

sealed class AppState {
    object Loading : AppState()
    data class Success(val data: List<String>) : AppState()
    data class Error(val message: String) : AppState()
}

class ViewModel {
    private val observers = mutableListOf<(AppState) -> Unit>()
    var state: AppState = AppState.Loading
        private set(value) {
            field = value
            observers.forEach { it(value) }
        }

    fun addObserver(observer: (AppState) -> Unit) = observers.add(observer)

    fun loadData() {
        state = AppState.Loading
        // simulate work
        state = AppState.Success(listOf("Item 1", "Item 2", "Item 3"))
    }

    fun simulateError() {
        state = AppState.Error("Network timeout")
    }
}

// ─── STRATEGY pattern ─────────────────────────────────

data class Order(val id: Int, val total: Double, val items: Int)

class OrderSorter(private val strategy: Comparator<Order>) {
    fun sort(orders: List<Order>) = orders.sortedWith(strategy)
}

// Strategies as companion functions or lambdas
object OrderStrategies {
    val byTotal: Comparator<Order> = compareBy { it.total }
    val byTotalDesc: Comparator<Order> = compareByDescending { it.total }
    val byItems: Comparator<Order> = compareBy { it.items }
    val byValue: Comparator<Order> = compareByDescending { it.total / it.items }
}

// ─── DECORATOR via extension functions ─────────────────

fun String.bold() = "**\$this**"
fun String.italic() = "_\${this}_"
fun String.code() = "`\${this}`"
fun String.truncate(max: Int, ellipsis: String = "...") =
    if (length <= max) this else take(max - ellipsis.length) + ellipsis

// ─── PROXY with delegation ────────────────────────────

interface Cache<K, V> {
    fun get(key: K): V?
    fun put(key: K, value: V)
    fun remove(key: K)
    fun clear()
}

class InMemoryCache<K, V> : Cache<K, V> {
    private val map = mutableMapOf<K, V>()
    override fun get(key: K) = map[key]
    override fun put(key: K, value: V) { map[key] = value }
    override fun remove(key: K) { map.remove(key) }
    override fun clear() = map.clear()
}

class LoggingCache<K, V>(private val delegate: Cache<K, V>) : Cache<K, V> by delegate {
    private var hits = 0
    private var misses = 0

    override fun get(key: K): V? {
        val value = delegate.get(key)
        if (value != null) { hits++; println("  CACHE HIT: \$key") }
        else { misses++; println("  CACHE MISS: \$key") }
        return value
    }

    override fun put(key: K, value: V) {
        println("  CACHE PUT: \$key")
        delegate.put(key, value)
    }

    fun stats() = "Hits: \$hits, Misses: \$misses, Hit rate: \${"%.0f".format(if (hits + misses > 0) hits * 100.0 / (hits + misses) else 0.0)}%"
}

// ─── CHAIN OF RESPONSIBILITY ──────────────────────────

data class Request(
    val body: String,
    var authenticated: Boolean = false,
    var sanitized: Boolean = false,
    var validated: Boolean = false
)

typealias Middleware = (Request) -> Request?

val authMiddleware: Middleware = { req ->
    println("  Auth check...")
    if (req.body.contains("token")) req.copy(authenticated = true)
    else { println("  Auth FAILED"); null }
}

val sanitizeMiddleware: Middleware = { req ->
    println("  Sanitizing...")
    req.copy(body = req.body.replace("<script>", ""), sanitized = true)
}

val validateMiddleware: Middleware = { req ->
    println("  Validating...")
    if (req.body.length in 1..1000) req.copy(validated = true)
    else { println("  Validation FAILED"); null }
}

fun processRequest(request: Request, vararg middlewares: Middleware): Request? {
    return middlewares.fold(request as Request?) { req, middleware ->
        req?.let { middleware(it) }
    }
}

fun main() {
    // Observer
    println("=== Observer Pattern ===")
    val vm = ViewModel()
    vm.addObserver { state ->
        when (state) {
            is AppState.Loading -> println("  UI: Showing spinner...")
            is AppState.Success -> println("  UI: Showing \${state.data.size} items")
            is AppState.Error   -> println("  UI: Error — \${state.message}")
        }
    }
    vm.loadData()
    vm.simulateError()

    // Strategy
    println("\\n=== Strategy Pattern ===")
    val orders = listOf(
        Order(1, 150.0, 3),
        Order(2, 50.0, 10),
        Order(3, 300.0, 2),
        Order(4, 75.0, 5)
    )
    val sorter = OrderSorter(OrderStrategies.byTotalDesc)
    println("By total (desc): \${sorter.sort(orders).map { "\${it.id}:\$\${it.total}" }}")

    val bySorter = OrderSorter(OrderStrategies.byValue)
    println("By value/item:   \${bySorter.sort(orders).map { "\${it.id}:\${"%.1f".format(it.total/it.items)}" }}")

    // Decorator (extension functions)
    println("\\n=== Decorator Pattern ===")
    val text = "Hello, Kotlin!"
    println(text.bold())
    println(text.italic())
    println(text.bold().italic())
    println(text.code().truncate(10))

    // Proxy with logging cache
    println("\\n=== Proxy/Logging Cache ===")
    val cache = LoggingCache(InMemoryCache<String, Int>())
    cache.put("users", 42)
    cache.put("products", 150)
    cache.get("users")       // hit
    cache.get("users")       // hit
    cache.get("orders")      // miss
    println(cache.stats())

    // Chain of responsibility
    println("\\n=== Chain of Responsibility ===")
    val goodRequest = Request("token: abc123 Hello Kotlin!")
    val badAuth = Request("No token here")
    val tooLong = Request("token: valid " + "x".repeat(1100))

    println("Good request:")
    val r1 = processRequest(goodRequest, authMiddleware, sanitizeMiddleware, validateMiddleware)
    println("  Result: \${if (r1 != null) "Processed ✅" else "Rejected ❌"}")

    println("Bad auth:")
    val r2 = processRequest(badAuth, authMiddleware, sanitizeMiddleware, validateMiddleware)
    println("  Result: \${if (r2 != null) "Processed ✅" else "Rejected ❌"}")

    println("Too long:")
    val r3 = processRequest(tooLong, authMiddleware, sanitizeMiddleware, validateMiddleware)
    println("  Result: \${if (r3 != null) "Processed ✅" else "Rejected ❌"}")
}

📝 KEY POINTS:
✅ Singleton → object declaration (thread-safe, built-in)
✅ Builder → named parameters + default values (usually sufficient)
✅ Prototype → data class copy() (zero boilerplate)
✅ Decorator → extension functions (add behavior externally)
✅ Proxy → class delegation with by (delegate and override selectively)
✅ Strategy → higher-order function parameters (lambdas)
✅ Observer → StateFlow/SharedFlow or callback lists
✅ Chain of responsibility → fold over a list of middleware functions
❌ Don't reach for a pattern before you need it — YAGNI
❌ Kotlin often makes patterns trivial — don't over-engineer
❌ Factory pattern needs private constructors to enforce control
❌ Observer callbacks lists need management — prefer Flow in coroutine code
""",
  quiz: [
    Quiz(question: 'How does Kotlin\'s data class copy() implement the Prototype pattern?', options: [
      QuizOption(text: 'It creates a new instance with selectively modified properties — the original is unchanged', correct: true),
      QuizOption(text: 'It performs a deep clone of all nested objects recursively', correct: false),
      QuizOption(text: 'It returns a mutable version of an immutable data class', correct: false),
      QuizOption(text: 'It serializes the object to JSON and deserializes it as a new instance', correct: false),
    ]),
    Quiz(question: 'How does class delegation (by keyword) implement the Proxy pattern?', options: [
      QuizOption(text: 'It forwards all interface calls to a delegate object, allowing selective overrides for logging or modification', correct: true),
      QuizOption(text: 'It creates a virtual proxy that initializes the real object lazily on first use', correct: false),
      QuizOption(text: 'It intercepts all method calls and routes them through a central dispatcher', correct: false),
      QuizOption(text: 'It wraps the delegate in a thread-safe synchronized block automatically', correct: false),
    ]),
    Quiz(question: 'What replaces the Strategy pattern most naturally in Kotlin?', options: [
      QuizOption(text: 'Higher-order functions and lambdas passed as parameters', correct: true),
      QuizOption(text: 'Sealed classes with a single abstract execute() method', correct: false),
      QuizOption(text: 'Extension functions defined on the context class', correct: false),
      QuizOption(text: 'Companion object factory methods that select the correct implementation', correct: false),
    ]),
  ],
);
