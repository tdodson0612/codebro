import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson33 = Lesson(
  language: 'Kotlin',
  title: 'Annotations and Reflection',
  content: """
🎯 METAPHOR:
Annotations are like sticky labels on equipment in a lab.
The equipment (your code) still works whether it has labels
or not. But the labels give instructions to specific people
who read them: "FRAGILE — handle with care" (for movers),
"DO NOT AUTOCLAVE" (for sterilization staff), "CALIBRATED:
Jan 2024" (for inspectors). Each label is ignored by people
who don't care about it, and acted upon by those who do.
Annotations give metadata to the compiler, frameworks, and
tools — without changing what the code actually does.

📖 EXPLANATION:
Annotations attach metadata to code elements (classes,
functions, properties, parameters). Reflection lets you
inspect that metadata at runtime.

─────────────────────────────────────
BUILT-IN KOTLIN ANNOTATIONS:
─────────────────────────────────────
  @Override      → marks function as overriding parent
  @Deprecated    → marks something as deprecated
  @JvmStatic     → exposes companion function as Java static
  @JvmField      → exposes property as Java public field
  @JvmOverloads  → generates Java overloads for default params
  @Suppress      → suppresses specific warnings
  @Transient     → exclude from serialization
  @Volatile      → mark field as volatile (thread visibility)
  @Synchronized  → add synchronized monitor to function

─────────────────────────────────────
CREATING CUSTOM ANNOTATIONS:
─────────────────────────────────────
  annotation class MyAnnotation

  // With parameters:
  annotation class Validate(
      val minLength: Int = 0,
      val maxLength: Int = Int.MAX_VALUE,
      val pattern: String = ".*"
  )

  @Validate(minLength = 3, maxLength = 50)
  val username: String = ""

─────────────────────────────────────
ANNOTATION TARGETS:
─────────────────────────────────────
Use @Target to specify where an annotation can be placed:

  @Target(AnnotationTarget.CLASS,
          AnnotationTarget.FUNCTION,
          AnnotationTarget.PROPERTY)
  @Retention(AnnotationRetention.RUNTIME)
  annotation class MyAnnotation

  AnnotationTarget options:
    CLASS, FUNCTION, PROPERTY, FIELD,
    VALUE_PARAMETER, CONSTRUCTOR,
    LOCAL_VARIABLE, EXPRESSION

─────────────────────────────────────
RETENTION:
─────────────────────────────────────
  SOURCE  → only in source code, discarded at compile time
  BINARY  → in .class files but not available at runtime
  RUNTIME → available at runtime via reflection (default)

─────────────────────────────────────
REFLECTION — inspecting code at runtime:
─────────────────────────────────────
Reflection lets you examine and interact with classes,
functions, and properties at runtime — even if you don't
know their types at compile time.

  // Class reference
  val kClass = String::class
  println(kClass.simpleName)    // String
  println(kClass.memberFunctions.count())

  // Function reference
  val fn: (String) -> Int = String::length

  // Property reference
  val prop = Person::name
  println(prop.get(person))

─────────────────────────────────────
KClass — the runtime class descriptor:
─────────────────────────────────────
  obj::class           // KClass of the object's runtime type
  MyClass::class       // KClass of the compile-time type

  kClass.simpleName        // "MyClass"
  kClass.qualifiedName     // "com.example.MyClass"
  kClass.isAbstract        // is it abstract?
  kClass.isData            // is it a data class?
  kClass.primaryConstructor // primary constructor
  kClass.memberProperties  // all properties
  kClass.memberFunctions   // all functions
  kClass.annotations       // list of annotations

─────────────────────────────────────
PRACTICAL USE CASES:
─────────────────────────────────────
  → Dependency injection frameworks (Koin, Hilt)
  → Serialization frameworks (kotlinx.serialization)
  → Testing frameworks (JUnit, MockK)
  → ORM frameworks (Exposed, Room)
  → Validation libraries

💻 CODE:
import kotlin.reflect.full.*

// Custom annotations
@Target(AnnotationTarget.CLASS)
@Retention(AnnotationRetention.RUNTIME)
annotation class Entity(val tableName: String)

@Target(AnnotationTarget.PROPERTY)
@Retention(AnnotationRetention.RUNTIME)
annotation class Column(val name: String, val primaryKey: Boolean = false)

@Target(AnnotationTarget.PROPERTY)
@Retention(AnnotationRetention.RUNTIME)
annotation class NotNull

@Target(AnnotationTarget.FUNCTION)
@Retention(AnnotationRetention.RUNTIME)
annotation class LogCall(val level: String = "INFO")

// Annotated classes
@Entity(tableName = "users")
data class User(
    @Column(name = "id", primaryKey = true) val id: Int,
    @Column(name = "username") @NotNull val username: String,
    @Column(name = "email") val email: String?,
    @Column(name = "age") val age: Int
)

@Entity(tableName = "products")
data class Product(
    @Column(name = "product_id", primaryKey = true) val id: String,
    @Column(name = "name") @NotNull val name: String,
    @Column(name = "price") val price: Double
)

// Reflection-based utilities
fun inspectClass(kClass: kotlin.reflect.KClass<*>) {
    println("\\n=== Inspecting: \${kClass.simpleName} ===")

    // Check for @Entity annotation
    val entityAnnotation = kClass.annotations.filterIsInstance<Entity>().firstOrNull()
    if (entityAnnotation != null) {
        println("Table name: '\${entityAnnotation.tableName}'")
    }

    println("Is data class: \${kClass.isData}")
    println("Is abstract: \${kClass.isAbstract}")

    println("Properties:")
    kClass.memberProperties.forEach { prop ->
        val columnAnn = prop.annotations.filterIsInstance<Column>().firstOrNull()
        val notNullAnn = prop.annotations.filterIsInstance<NotNull>().firstOrNull()

        val colName = columnAnn?.name ?: prop.name
        val pk = if (columnAnn?.primaryKey == true) " [PK]" else ""
        val nn = if (notNullAnn != null) " [NOT NULL]" else ""
        val type = prop.returnType

        println("  \${prop.name} → column '\$colName'\$pk\$nn (\$type)")
    }
}

// Simple SQL generator using reflection
fun generateCreateTable(kClass: kotlin.reflect.KClass<*>): String {
    val entity = kClass.annotations.filterIsInstance<Entity>().firstOrNull()
        ?: return "-- No @Entity annotation found"

    val columns = kClass.memberProperties.mapNotNull { prop ->
        val column = prop.annotations.filterIsInstance<Column>().firstOrNull()
            ?: return@mapNotNull null
        val typeSql = when (prop.returnType.toString().removePrefix("kotlin.")) {
            "Int"     -> "INTEGER"
            "Long"    -> "BIGINT"
            "String"  -> "VARCHAR(255)"
            "String?" -> "VARCHAR(255)"
            "Double"  -> "REAL"
            "Boolean" -> "BOOLEAN"
            else      -> "TEXT"
        }
        val pk = if (column.primaryKey) " PRIMARY KEY" else ""
        "  \${column.name} \$typeSql\$pk"
    }

    return "CREATE TABLE \${entity.tableName} (\\n\${columns.joinToString(",\\n")}\\n);"
}

// Built-in annotations
@Deprecated("Use newFunction() instead", ReplaceWith("newFunction()"))
fun oldFunction() = println("Old!")

fun newFunction() = println("New!")

@Suppress("UNUSED_VARIABLE")
fun suppressExample() {
    val unused = "This won't warn"
}

fun main() {
    // Inspect annotated classes
    inspectClass(User::class)
    inspectClass(Product::class)

    // Generate SQL from annotations
    println("\\n=== SQL Generation ===")
    println(generateCreateTable(User::class))
    println()
    println(generateCreateTable(Product::class))

    // Reflection: function references
    println("\\n=== Function references ===")
    val lengths = listOf("hello", "kotlin", "world").map(String::length)
    println("Lengths: \$lengths")

    val numbers = listOf("1", "2", "abc", "4", "xyz")
    val parsed = numbers.mapNotNull(String::toIntOrNull)
    println("Parsed: \$parsed")

    // KClass info
    println("\\n=== KClass inspection ===")
    val userClass = User::class
    println("Name: \${userClass.simpleName}")
    println("Qualified: \${userClass.qualifiedName}")
    println("Is data: \${userClass.isData}")
    println("Constructor params: \${userClass.primaryConstructor?.parameters?.map { it.name }}")
    println("Supertypes: \${userClass.supertypes.map { it.toString() }}")

    // Create instance via reflection
    val ctor = User::class.primaryConstructor
    val user = ctor?.call(1, "terry99", "terry@example.com", 30)
    println("\\nCreated via reflection: \$user")

    // Deprecated annotation example
    @Suppress("DEPRECATION")
    oldFunction()
    newFunction()
}

📝 KEY POINTS:
✅ Annotations attach metadata to code without changing behavior
✅ @Target controls where an annotation can be used
✅ @Retention(RUNTIME) makes annotations readable at runtime via reflection
✅ KClass (::class) is Kotlin's reflection class descriptor
✅ memberProperties and memberFunctions expose class structure
✅ Function references (String::length) are a form of reflection
✅ Annotations power frameworks: DI, ORM, serialization, testing
✅ primaryConstructor?.call(...) can create instances via reflection
❌ Reflection has a runtime performance cost — avoid in hot loops
❌ Reflection bypasses compile-time type safety — use with care
❌ Not all platforms support full reflection (Kotlin/Native has limits)
❌ @Suppress is for suppressing warnings only — don't use it to hide bugs
""",
  quiz: [
    Quiz(question: 'What does @Retention(AnnotationRetention.RUNTIME) do?', options: [
      QuizOption(text: 'Makes the annotation available for inspection at runtime via reflection', correct: true),
      QuizOption(text: 'Causes the annotation to persist across application restarts', correct: false),
      QuizOption(text: 'Makes the annotation apply to all runtime instances of a class', correct: false),
      QuizOption(text: 'Prevents the annotation from being inherited by subclasses', correct: false),
    ]),
    Quiz(question: 'What does MyClass::class give you in Kotlin?', options: [
      QuizOption(text: 'A KClass object representing MyClass, giving access to its structure via reflection', correct: true),
      QuizOption(text: 'A new instance of MyClass created with default parameters', correct: false),
      QuizOption(text: 'The Java Class object (not the Kotlin KClass)', correct: false),
      QuizOption(text: 'A reference to the companion object of MyClass', correct: false),
    ]),
    Quiz(question: 'Which built-in Kotlin annotation generates Java-compatible overloads for functions with default parameters?', options: [
      QuizOption(text: '@JvmOverloads', correct: true),
      QuizOption(text: '@JvmDefault', correct: false),
      QuizOption(text: '@JavaInterop', correct: false),
      QuizOption(text: '@DefaultParams', correct: false),
    ]),
  ],
);
