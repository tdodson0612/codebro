import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson35 = Lesson(
  language: 'Kotlin',
  title: 'DSL Building with Kotlin',
  content: """
🎯 METAPHOR:
A DSL (Domain Specific Language) is like a specialized form
filled out in your industry's own terminology. A medical
chart uses medical terms, laid out the way doctors think.
A legal contract uses legal structure and phrasing. Both
are filled out in plain written language, but each is
shaped for its domain. Kotlin DSLs let you write code that
READS like the domain it models. Instead of general-purpose
function calls, you write something that looks like a
configuration or specification — so natural that a
non-programmer could almost understand it.

📖 EXPLANATION:
Kotlin's DSL (Domain Specific Language) support is built
on a combination of lambda receivers, extension functions,
and operator overloading. The Kotlin standard library and
many frameworks (Gradle, Ktor, Anko, Jetpack Compose) are
built as DSLs.

─────────────────────────────────────
LAMBDA WITH RECEIVER:
─────────────────────────────────────
The foundation of Kotlin DSLs. A lambda where 'this'
is set to a specific object inside the block.

  fun buildString(block: StringBuilder.() -> Unit): String {
      val sb = StringBuilder()
      sb.block()    // 'this' inside block = sb
      return sb.toString()
  }

  val result = buildString {
      append("Hello")    // this.append(...)
      append(", ")
      append("World!")
  }

─────────────────────────────────────
APPLY is the simplest DSL:
─────────────────────────────────────
  val list = mutableListOf<Int>().apply {
      add(1)
      add(2)
      add(3)
  }

This IS a DSL — apply provides a lambda receiver context
where 'this' is the list.

─────────────────────────────────────
BUILDING A CUSTOM DSL:
─────────────────────────────────────
  // HTML builder DSL (simplified):

  class Tag(val name: String) {
      val children = mutableListOf<Tag>()
      var text: String = ""

      fun tag(name: String, block: Tag.() -> Unit): Tag {
          val child = Tag(name)
          child.block()
          children.add(child)
          return child
      }

      fun render(indent: Int = 0): String {
          val pad = "  ".repeat(indent)
          return buildString {
              appendLine("\$pad<\$name>")
              if (text.isNotBlank()) appendLine("\$pad  \$text")
              children.forEach { append(it.render(indent + 1)) }
              appendLine("\$pad</\$name>")
          }
      }
  }

  fun html(block: Tag.() -> Unit) = Tag("html").also { it.block() }

─────────────────────────────────────
@DslMarker — preventing scope leaks:
─────────────────────────────────────
Without @DslMarker, nested DSL lambdas can accidentally
call methods from an OUTER context — a confusing bug.

  @DslMarker
  annotation class HtmlDslMarker

  @HtmlDslMarker
  class HtmlTag { ... }

  // Now: calling outer.div {} inside inner.span {} is an error

─────────────────────────────────────
INFIX FUNCTIONS — readable DSLs:
─────────────────────────────────────
  infix fun String.shouldEqual(other: String): Boolean {
      return this == other
  }

  "hello" shouldEqual "hello"   // reads like English
  
  // Kotlin's built-in infix: to, and, or, in
  val pair = "key" to "value"
  val range = 1..10

─────────────────────────────────────
REAL-WORLD DSL EXAMPLES:
─────────────────────────────────────
  // Gradle Kotlin DSL:
  dependencies {
      implementation("org.jetbrains.kotlin:kotlin-stdlib")
      testImplementation("junit:junit:4.13")
  }

  // Ktor routing DSL:
  routing {
      get("/users") { call.respond(users) }
      post("/users") { ... }
  }

  // Jetpack Compose:
  Column {
      Text("Hello")
      Button(onClick = { }) { Text("Click me") }
  }

All of these are just Kotlin functions and lambdas
with receivers — no special compiler magic needed.

💻 CODE:
// ─── HTML DSL ───────────────────────────────────────

@DslMarker
annotation class HtmlDsl

@HtmlDsl
class HtmlElement(val tag: String) {
    private val attributes = mutableMapOf<String, String>()
    private val children = mutableListOf<HtmlElement>()
    private var text: String = ""

    fun attr(key: String, value: String) { attributes[key] = value }
    fun text(content: String) { text = content }

    fun element(tag: String, block: HtmlElement.() -> Unit = {}): HtmlElement {
        val child = HtmlElement(tag)
        child.block()
        children.add(child)
        return child
    }

    fun h1(block: HtmlElement.() -> Unit) = element("h1", block)
    fun h2(block: HtmlElement.() -> Unit) = element("h2", block)
    fun p(block: HtmlElement.() -> Unit) = element("p", block)
    fun div(block: HtmlElement.() -> Unit) = element("div", block)
    fun ul(block: HtmlElement.() -> Unit) = element("ul", block)
    fun li(block: HtmlElement.() -> Unit) = element("li", block)
    fun a(href: String, block: HtmlElement.() -> Unit) = element("a") {
        attr("href", href)
        block()
    }

    fun render(indent: Int = 0): String {
        val pad = "  ".repeat(indent)
        val attrs = if (attributes.isEmpty()) ""
            else " " + attributes.map { "\${it.key}=\\"\${it.value}\\"" }.joinToString(" ")
        return buildString {
            if (text.isNotBlank()) {
                appendLine("\$pad<\$tag\$attrs>\$text</\$tag>")
            } else if (children.isEmpty()) {
                appendLine("\$pad<\$tag\$attrs/>")
            } else {
                appendLine("\$pad<\$tag\$attrs>")
                children.forEach { append(it.render(indent + 1)) }
                appendLine("\$pad</\$tag>")
            }
        }
    }
}

fun html(block: HtmlElement.() -> Unit): HtmlElement =
    HtmlElement("html").also { it.block() }

// ─── SQL QUERY DSL ───────────────────────────────────

class QueryBuilder {
    private var table: String = ""
    private val conditions = mutableListOf<String>()
    private val columns = mutableListOf<String>()
    private var orderBy: String? = null
    private var limit: Int? = null

    fun from(table: String) = apply { this.table = table }
    fun select(vararg cols: String) = apply { columns.addAll(cols) }
    fun where(condition: String) = apply { conditions.add(condition) }
    fun orderBy(column: String) = apply { this.orderBy = column }
    fun limit(n: Int) = apply { this.limit = n }

    fun build(): String {
        val cols = if (columns.isEmpty()) "*" else columns.joinToString(", ")
        val whereClause = if (conditions.isEmpty()) ""
            else "\\n  WHERE " + conditions.joinToString(" AND ")
        val orderClause = orderBy?.let { "\\n  ORDER BY \$it" } ?: ""
        val limitClause = limit?.let { "\\n  LIMIT \$it" } ?: ""
        return "SELECT \$cols\\n  FROM \$table\$whereClause\$orderClause\$limitClause"
    }
}

fun query(block: QueryBuilder.() -> Unit): String =
    QueryBuilder().apply(block).build()

// ─── TEST ASSERTION DSL ──────────────────────────────

class AssertionScope(val actual: Any?) {
    infix fun shouldBe(expected: Any?) {
        if (actual != expected) throw AssertionError("Expected \$expected but got \$actual")
        println("✅ \$actual == \$expected")
    }

    infix fun shouldNotBe(expected: Any?) {
        if (actual == expected) throw AssertionError("Expected NOT \$expected")
        println("✅ \$actual != \$expected")
    }

    infix fun shouldContain(value: Any?) {
        val list = actual as? Collection<*> ?: throw AssertionError("Not a collection")
        if (value !in list) throw AssertionError("\$value not in \$actual")
        println("✅ \$actual contains \$value")
    }
}

fun expect(value: Any?) = AssertionScope(value)

fun main() {
    // HTML DSL
    println("=== HTML DSL ===")
    val page = html {
        div {
            attr("class", "container")
            h1 { text("Welcome to Kotlin DSLs") }
            p { text("DSLs make code readable and expressive.") }
            ul {
                li { text("Readable code") }
                li { text("Type-safe") }
                li { text("Extensible") }
            }
            a("https://kotlinlang.org") {
                text("Learn More")
            }
        }
    }
    println(page.render())

    // SQL Query DSL
    println("=== SQL DSL ===")
    val q1 = query {
        select("id", "name", "email")
        from("users")
        where("age > 18")
        where("active = true")
        orderBy("name")
        limit(10)
    }
    println(q1)
    println()

    val q2 = query {
        from("products")
        where("price < 100")
        orderBy("price")
    }
    println(q2)

    // Test assertion DSL
    println("\\n=== Test assertion DSL ===")
    expect(2 + 2) shouldBe 4
    expect("Kotlin") shouldNotBe "Java"
    expect(listOf(1, 2, 3)) shouldContain 2
    expect("hello".uppercase()) shouldBe "HELLO"
    expect(10 * 10) shouldBe 100

    // buildString DSL (from stdlib)
    println("\\n=== buildString DSL ===")
    val report = buildString {
        appendLine("=".repeat(30))
        appendLine("REPORT")
        appendLine("=".repeat(30))
        for (i in 1..5) {
            appendLine("Item \$i: value = \${i * i}")
        }
        appendLine("=".repeat(30))
    }
    println(report)
}

📝 KEY POINTS:
✅ DSLs are built with lambda receivers — 'this' becomes the context object
✅ Extension functions with lambda receivers are the DSL building block
✅ @DslMarker prevents accidentally calling outer scope methods inside DSL
✅ infix functions make DSLs read like natural language
✅ apply, buildString, buildList are all mini-DSLs from the stdlib
✅ Gradle KTS, Ktor, and Compose are all Kotlin DSLs in production
✅ DSLs give you compile-time type safety unlike XML or JSON configs
❌ Don't build a DSL for one-off use — DSLs add complexity
❌ Without @DslMarker, nested contexts can produce subtle bugs
❌ DSL builders must handle state carefully — avoid shared mutable state
❌ DSLs don't need special syntax — they're just functions and lambdas
""",
  quiz: [
    Quiz(question: 'What Kotlin feature is the foundation of DSL building?', options: [
      QuizOption(text: 'Lambda with receiver — a lambda where this refers to a specified context object', correct: true),
      QuizOption(text: 'Operator overloading — redefining symbols for domain objects', correct: false),
      QuizOption(text: 'Sealed classes — providing a closed set of valid DSL elements', correct: false),
      QuizOption(text: 'Companion objects — providing static factory methods for DSL entry points', correct: false),
    ]),
    Quiz(question: 'What does @DslMarker do?', options: [
      QuizOption(text: 'Prevents DSL lambdas from accidentally calling methods of an outer scope context', correct: true),
      QuizOption(text: 'Marks a class as the entry point of a DSL for IDE tooling', correct: false),
      QuizOption(text: 'Makes all functions inside the annotated class behave as infix functions', correct: false),
      QuizOption(text: 'Enforces that DSL functions are only called inside designated DSL blocks', correct: false),
    ]),
    Quiz(question: 'What makes an infix function useful in DSL building?', options: [
      QuizOption(text: 'It allows calling the function without a dot or parentheses, making code read like natural language', correct: true),
      QuizOption(text: 'It makes the function run before the outer lambda, giving it priority', correct: false),
      QuizOption(text: 'It automatically provides a this context for the second argument', correct: false),
      QuizOption(text: 'Infix functions are optimized by the compiler and run faster than regular calls', correct: false),
    ]),
  ],
);