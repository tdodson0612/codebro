import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson47 = Lesson(
  language: 'Kotlin',
  title: 'Bitwise Operators and String Formatting',
  content: """
🎯 METAPHOR:
Bitwise operators work at the level of individual light
switches (bits). A number like 42 is not "forty-two" at
the hardware level — it's a row of switches: 0 0 1 0 1 0 1 0.
AND is like requiring BOTH switches to be ON. OR is like
requiring EITHER switch to be ON. XOR (exclusive-or) is like
a picky switch that's ON only when the two inputs DIFFER.
Shifts move all the switches left or right — shifting left
by one is like multiplying by 2, shifting right by one
is like dividing by 2. These are the operations your
CPU performs millions of times per second, and sometimes
you need direct access to them.

String formatting is like a mail merge template.
"Dear %s, your order #%d totals \$%.2f" — the placeholders
get filled in with actual values at print time, with precise
control over padding, decimals, and alignment.

📖 EXPLANATION:

─────────────────────────────────────
BITWISE OPERATORS IN KOTLIN:
─────────────────────────────────────
Kotlin uses NAMED functions for bitwise operations
(not symbols like &, |, ^). This makes them readable
and avoids confusion with logical && and ||.

  Operation    Kotlin      Java equivalent
  ────────────────────────────────────────
  AND          and         &
  OR           or          |
  XOR          xor         ^
  NOT          inv()       ~
  Shift left   shl(n)      << n
  Shift right  shr(n)      >> n  (signed)
  Unsigned shr ushr(n)     >>> n (unsigned)

  val a = 0b1010   // 10 in binary
  val b = 0b1100   // 12 in binary

  a and b    → 0b1000 = 8    (both bits must be 1)
  a or b     → 0b1110 = 14   (either bit must be 1)
  a xor b    → 0b0110 = 6    (bits differ)
  a.inv()    → ...flips all bits (bitwise NOT)
  a shl 1    → 0b10100 = 20  (multiply by 2)
  a shr 1    → 0b0101 = 5    (divide by 2)

─────────────────────────────────────
COMMON BITWISE USE CASES:
─────────────────────────────────────
  // FLAGS — store multiple boolean states in one Int:
  const val FLAG_READ    = 0b0001  // 1
  const val FLAG_WRITE   = 0b0010  // 2
  const val FLAG_EXECUTE = 0b0100  // 4

  var permissions = FLAG_READ or FLAG_WRITE   // 3 (both)

  // Check if flag is set:
  val canRead = permissions and FLAG_READ != 0   // true

  // Add a flag:
  permissions = permissions or FLAG_EXECUTE

  // Remove a flag:
  permissions = permissions and FLAG_EXECUTE.inv()

  // Toggle a flag:
  permissions = permissions xor FLAG_WRITE

  // Efficient multiply/divide by powers of 2:
  val times8 = value shl 3     // value * 8
  val div4 = value shr 2       // value / 4

─────────────────────────────────────
STRING FORMATTING:
─────────────────────────────────────
Kotlin has several ways to format strings:

1. String templates (idiomatic, for simple cases):
   val name = "Terry"
   println("Hello, \$name!")

2. String.format() (printf-style):
   String.format("Hello, %s! You are %d years old.", name, age)
   "%s scored %.1f%%".format(name, score)

3. buildString (for complex construction):
   val s = buildString {
       append("Name: ")
       appendLine(name)
       append("Score: ")
       append(score)
   }

4. padStart / padEnd (alignment):
   "42".padStart(6, '0')    → "000042"
   "done".padEnd(10, '.')   → "done......"

─────────────────────────────────────
FORMAT SPECIFIERS (printf-style):
─────────────────────────────────────
  %s    → String
  %d    → Integer (decimal)
  %f    → Floating point
  %e    → Scientific notation
  %b    → Boolean
  %c    → Character
  %x    → Hexadecimal (lowercase)
  %X    → Hexadecimal (uppercase)
  %o    → Octal
  %n    → Newline (platform-specific)
  %%    → Literal %

WIDTH AND PRECISION:
  %10s       → right-align in 10 chars
  %-10s      → left-align in 10 chars
  %10.2f     → 10 wide, 2 decimal places
  %05d       → pad with zeros, 5 wide
  %+d        → always show sign (+42 or -42)
  %,d        → thousands separator (1,000,000)

─────────────────────────────────────
KOTLIN'S trimMargin AND trimIndent:
─────────────────────────────────────
  val sql = ''' 
      |SELECT id, name
      |FROM users
      |WHERE active = true
      |ORDER BY name
  '''.trimMargin()   // removes | and leading whitespace

  val html = '''
      <div>
          <p>Hello</p>
      </div>
  '''.trimIndent()   // removes common leading whitespace

💻 CODE:
// ─── BITWISE OPERATORS ───────────────────────────────

fun bitwiseDemo() {
    println("=== Bitwise operators ===")

    val a = 0b1010_1010   // 170
    val b = 0b1100_1100   // 204

    println("a = \$a (binary:\${
a.toString(2).padStart(8, '0')})")
    println("b = \$b (binary:\${
b.toString(2).padStart(8, '0')})")
    println()
    println("a AND b =\${
a and b}  (binary:\${
(a and b).toString(2).padStart(8, '0')})")
    println("a OR  b =\${
a or b}  (binary:\${
(a or b).toString(2).padStart(8, '0')})")
    println("a XOR b =\${
a xor b}  (binary:\${
(a xor b).toString(2).padStart(8, '0')})")
    println("a INV   =\${
a.inv()} (binary:\${
a.inv().toString(2).padStart(8, '0')})")
    println()
    println("a SHL 1 =\${
a shl 1} (\${
a} * 2 =\${
a * 2})")
    println("a SHR 1 =\${
a shr 1} (\${
a} / 2 =\${
a / 2})")
    println("a SHL 3 =\${
a shl 3} (\${
a} * 8 =\${
a * 8})")
}

fun flagsDemo() {
    println("\\n=== Permission flags ===")

    // Unix-style permission flags
    const val READ    = 0b100   // 4
    const val WRITE   = 0b010   // 2
    const val EXECUTE = 0b001   // 1

    fun describePermissions(perms: Int): String {
        val r = if (perms and READ != 0) "r" else "-"
        val w = if (perms and WRITE != 0) "w" else "-"
        val x = if (perms and EXECUTE != 0) "x" else "-"
        return "\$r\$w\$x"
    }

    var myPerms = READ or WRITE       // rw-
    println("Initial:\${
describePermissions(myPerms)} (\$myPerms)")

    myPerms = myPerms or EXECUTE      // add execute → rwx
    println("After +x:\${
describePermissions(myPerms)} (\$myPerms)")

    myPerms = myPerms and WRITE.inv() // remove write → r-x
    println("After -w:\${
describePermissions(myPerms)} (\$myPerms)")

    myPerms = myPerms xor READ        // toggle read → --x
    println("Toggle r:\${
describePermissions(myPerms)} (\$myPerms)")

    // Powers of 2 via shifts
    println("\\n=== Shifts as multiplication ===")
    val base = 1
    (0..7).forEach { shift ->
        println("1 shl \$shift =\${
base shl shift}")
    }
}

// ─── STRING FORMATTING ───────────────────────────────

data class Product(val name: String, val price: Double, val quantity: Int, val inStock: Boolean)

fun formattingDemo() {
    println("\\n=== String formatting ===")

    val name = "Terry"
    val score = 92.5
    val count = 1_000_000

    // String templates (idiomatic)
    println("Hello, \$name! Score:\${
"%.1f".format(score)}%")

    // format() with specifiers
    println(String.format("Name: %-15s Score: %6.2f%%", name, score))
    println(String.format("Count: %,d", count))
    println(String.format("Hex: %X  Oct: %o  Sci: %e", 255, 255, score))

    // Padding and alignment
    println("\\n=== Table formatting ===")
    val products = listOf(
        Product("Keyboard", 79.99, 15, true),
        Product("Mouse", 29.99, 42, true),
        Product("Monitor", 299.99, 3, false),
        Product("Headphones", 149.99, 8, true),
        Product("Webcam", 89.99, 0, false)
    )

    // Header
    println(String.format("%-15s %10s %8s %8s", "Product", "Price", "Qty", "Status"))
    println("-".repeat(45))

    products.forEach { p ->
        val status = if (p.inStock) "✅ In" else "❌ Out"
        println(String.format("%-15s %10s %8d %8s",
            p.name,
            "\$\${
"%.2f".format(p.price)}",
            p.quantity,
            status
        ))
    }

    println("-".repeat(45))
    val total = products.sumOf { it.price * it.quantity }
    println(String.format("%-15s %10s", "TOTAL VALUE:", "\$\${
",.2f".format(total)}"))

    // trimMargin — raw string with alignment
    println("\\n=== trimMargin ===")
    val sql = '''
        |SELECT u.name, u.email, COUNT(o.id) as order_count
        |FROM users u
        |LEFT JOIN orders o ON u.id = o.user_id
        |WHERE u.active = true
        |GROUP BY u.id
        |ORDER BY order_count DESC
        |LIMIT 10
    '''.trimMargin()
    println(sql)

    // Number formatting
    println("\\n=== Number formatting ===")
    val pi = kotlin.math.PI
    println("Pi (2dp):\${
"%.2f".format(pi)}")
    println("Pi (5dp):\${
"%.5f".format(pi)}")
    println("Pi (sci):\${
"%.3e".format(pi)}")
    println("Large:   \${
"%,.0f".format(1_234_567.89)}")
    println("Padded:  \${
"%-10.2f".format(pi)}|")
    println("Zero-pad:\${
"%010.3f".format(pi)}")
    println("Signed:  \${
"%+.2f".format(pi)}")

    // Hex and binary
    println("\\n=== Radix conversion ===")
    val n = 255
    println("Decimal: \$n")
    println("Binary: \${
n.toString(2)}")
    println("Octal:  \${
n.toString(8)}")
    println("Hex:    \${
n.toString(16).uppercase()}")
    println("Hex fmt:\${
String.format("%X", n)}")
}

fun main() {
    bitwiseDemo()
    flagsDemo()
    formattingDemo()
}

📝 KEY POINTS:
✅ Kotlin uses named functions for bitwise ops: and, or, xor, inv(), shl, shr
✅ Use 0b prefix for binary literals: 0b1010
✅ Use Int.toString(radix) to print in binary(2), octal(8), hex(16)
✅ Flags pattern: store multiple booleans in one Int using or/and/inv()
✅ shl n = multiply by 2^n; shr n = divide by 2^n (signed)
✅ String.format() supports printf-style specifiers: %s, %d, %.2f, %,d
✅ "%.2f".format(value) is idiomatic Kotlin shorthand for String.format
✅ trimMargin() strips | and leading whitespace from triple-quoted strings
✅ trimIndent() strips common leading whitespace from triple-quoted strings
❌ Kotlin has no &, |, ^ symbols for bitwise — use named functions only
❌ Don't use bitwise AND (and) where you mean logical AND (&&)
❌ shr is signed (preserves sign bit); ushr is unsigned (fills with 0)
❌ %n in format strings is platform-dependent newline — use \\n explicitly
""",
  quiz: [
    Quiz(question: 'How do you perform a bitwise AND operation in Kotlin?', options: [
      QuizOption(text: 'Using the named function: a and b', correct: true),
      QuizOption(text: 'Using the & symbol: a & b', correct: false),
      QuizOption(text: 'Using the && operator: a && b', correct: false),
      QuizOption(text: 'Using bitwiseAnd(a, b) from kotlin.math', correct: false),
    ]),
    Quiz(question: 'What does the shl operator do?', options: [
      QuizOption(text: 'Shifts bits to the left, effectively multiplying by a power of 2', correct: true),
      QuizOption(text: 'Shifts bits to the right, effectively dividing by a power of 2', correct: false),
      QuizOption(text: 'Performs a signed left rotation of bits', correct: false),
      QuizOption(text: 'shl is an alias for shr — they produce the same result', correct: false),
    ]),
    Quiz(question: 'What format specifier produces a number with thousands separators like 1,000,000?', options: [
      QuizOption(text: '%,d', correct: true),
      QuizOption(text: '%.d', correct: false),
      QuizOption(text: '%_d', correct: false),
      QuizOption(text: '%td', correct: false),
    ]),
  ],
);
