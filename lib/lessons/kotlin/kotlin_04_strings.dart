import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson04 = Lesson(
  language: 'Kotlin',
  title: 'Strings and String Templates',
  content: """
🎯 METAPHOR:
A Kotlin String template is like a fill-in-the-blank form
letter. Instead of writing the same letter over and over
with different names, you write it once with blanks:
"Dear [NAME], your order [ORDER_ID] is ready."
Then you hand it variables and it fills itself in.
No scissors, no paste, no string concatenation with + signs.
Just drop your variable name after a \$ and Kotlin handles it.

📖 EXPLANATION:
Strings in Kotlin are sequences of characters enclosed
in double quotes. They are immutable — once created,
the content cannot change (a new String is created instead).

─────────────────────────────────────
STRING TEMPLATES:
─────────────────────────────────────
The killer feature of Kotlin strings. Embed variables
and expressions directly inside a string literal.

  val name = "Terry"
  println("Hello, \$name!")           // simple variable
  println("2 + 2 = ${
2 + 2}")       // expression in ${
}

Rule: use \$ for simple variable names.
      use ${
} for any expression.

─────────────────────────────────────
RAW STRINGS (triple-quoted):
─────────────────────────────────────
Use triple quotes ''' for multi-line strings.
No escape sequences needed inside them.

  val poem = '''
      Roses are red,
      Violets are blue,
      Kotlin is awesome,
      And Java is too.
  '''.trimIndent()

.trimIndent() removes the common leading whitespace
from all lines — keeps the code readable.

─────────────────────────────────────
COMMON STRING OPERATIONS:
─────────────────────────────────────
  Operation           Example
  ──────────────────────────────────
  Length              "hello".length        → 5
  Uppercase           "hello".uppercase()   → "HELLO"
  Lowercase           "HELLO".lowercase()   → "hello"
  Trim whitespace     "  hi  ".trim()       → "hi"
  Contains            "hello".contains("ell") → true
  Starts with         "hello".startsWith("he") → true
  Ends with           "hello".endsWith("lo") → true
  Replace             "hello".replace("l","r") → "herro"
  Substring           "hello".substring(1,3) → "el"
  Split               "a,b,c".split(",")    → [a, b, c]
  Is empty            "".isEmpty()          → true
  Is blank            "   ".isBlank()       → true
  First/Last char     "hello"[0]            → 'h'

─────────────────────────────────────
STRING COMPARISON:
─────────────────────────────────────
In Kotlin, == compares content (not memory address).
This is different from Java!

  val a = "hello"
  val b = "hello"
  println(a == b)      // true — content equal ✅
  println(a === b)     // checks reference identity

In Java you'd need .equals() for content comparison.
In Kotlin, == always compares content. Use === for
reference identity (rarely needed).

─────────────────────────────────────
CHAR vs STRING:
─────────────────────────────────────
  'A'    → Char    (single character, single quotes)
  "A"    → String  (text, double quotes — even one char)

💻 CODE:
fun main() {
    val firstName = "Terry"
    val lastName = "Smith"
    val age = 30

    // String templates
    println("Name: \$firstName \$lastName")
    println("Age: \$age")
    println("In 10 years: ${
age + 10}")
    println("Uppercase: ${
firstName.uppercase()}")

    // Multi-line raw string
    val bio = '''
        Name: \$firstName \$lastName
        Age:  \$age
        Job:  Developer
    '''.trimIndent()
    println(bio)

    // String operations
    val sentence = "  Kotlin is fun!  "
    println(sentence.trim())                   // "Kotlin is fun!"
    println(sentence.trim().length)            // 15
    println(sentence.contains("fun"))          // true
    println(sentence.trim().replace("fun","great")) // "Kotlin is great!"

    // Split and join
    val csv = "apple,banana,cherry"
    val fruits = csv.split(",")
    println(fruits)                           // [apple, banana, cherry]
    println(fruits.joinToString(" | "))      // apple | banana | cherry

    // Checking strings
    val empty = ""
    val blank = "   "
    println(empty.isEmpty())    // true
    println(blank.isEmpty())    // false — has spaces
    println(blank.isBlank())    // true — only whitespace

    // Char access
    val word = "Kotlin"
    println(word[0])            // K
    println(word.first())       // K
    println(word.last())        // n

    // String to number conversions
    val numStr = "42"
    val num = numStr.toInt()
    println(num + 8)            // 50
}

📝 KEY POINTS:
✅ Use \$ for simple variable names in templates
✅ Use ${
} for expressions: ${
a + b}, ${
obj.method()}
✅ Triple quotes ''' create raw multi-line strings
✅ .trimIndent() cleans up indentation in triple-quoted strings
✅ == compares content in Kotlin (unlike Java)
✅ isEmpty() checks for zero length; isBlank() checks whitespace
✅ Strings are immutable — operations return new strings
❌ Don't use + to concatenate in loops — use StringBuilder
❌ Don't confuse Char ('A') with String ("A")
❌ Don't use Java's .equals() — use == in Kotlin
❌ toInt() throws an exception on invalid input —
   use toIntOrNull() for safe conversion
""",
  quiz: [
    Quiz(question: 'How do you embed an expression (not just a variable) in a Kotlin string template?', options: [
      QuizOption(text: 'Wrap it in ${
} like ${
a + b}', correct: true),
      QuizOption(text: 'Use \$() like \$(a + b)', correct: false),
      QuizOption(text: 'Use % like %(a + b)', correct: false),
      QuizOption(text: 'Use #{} like #{a + b}', correct: false),
    ]),
    Quiz(question: 'What does == do in Kotlin when comparing two Strings?', options: [
      QuizOption(text: 'Compares the content of the strings', correct: true),
      QuizOption(text: 'Compares the memory addresses of the strings', correct: false),
      QuizOption(text: 'Always returns true for non-null strings', correct: false),
      QuizOption(text: 'It is not valid — you must use .equals()', correct: false),
    ]),
    Quiz(question: 'What is the difference between isEmpty() and isBlank()?', options: [
      QuizOption(text: 'isEmpty() checks for zero length; isBlank() also returns true for whitespace-only strings', correct: true),
      QuizOption(text: 'They are identical — both check for zero length', correct: false),
      QuizOption(text: 'isBlank() checks for zero length; isEmpty() checks for whitespace', correct: false),
      QuizOption(text: 'isEmpty() works on any type; isBlank() only works on String', correct: false),
    ]),
  ],
);
