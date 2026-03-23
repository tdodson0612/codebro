import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson03 = Lesson(
  language: 'Java',
  title: 'Variables and Primitive Types',
  content: """
🎯 METAPHOR:
Variables in Java are like labeled, typed storage boxes in
a warehouse. Each box has a TYPE STAMP on it — this box
holds INTEGERS ONLY, that box holds DECIMALS ONLY.
You cannot put a word in the integers box.
Java inspects every box at the factory (compile time)
and rejects anything that doesn't fit its type.
This strictness prevents an entire class of bugs that
languages like Python — where any box can hold anything
— suffer from constantly. The strictness IS the feature.

📖 EXPLANATION:
Java has TWO categories of types: primitives and objects.
Primitives are the bedrock — the eight fundamental types
built directly into the language. Everything else is built
on top of them.

─────────────────────────────────────
THE 8 PRIMITIVE TYPES:
─────────────────────────────────────
  Type      Size     Range                    Use
  ──────────────────────────────────────────────────────
  byte      8-bit    -128 to 127              small integers
  short     16-bit   -32,768 to 32,767        medium integers
  int       32-bit   -2.1B to 2.1B            ← default integer
  long      64-bit   -9.2 quintillion to 9.2Q big integers
  float     32-bit   ~7 decimal digits        less precise decimal
  double    64-bit   ~15 decimal digits       ← default decimal
  char      16-bit   0 to 65,535 (Unicode)    single character
  boolean   1-bit    true or false            flags/conditions

  → Default for whole numbers: int
  → Default for decimals:      double
  → These two cover 95% of cases.

─────────────────────────────────────
DECLARING AND INITIALIZING:
─────────────────────────────────────
  type variableName = value;

  int age = 25;
  double price = 9.99;
  boolean isLoggedIn = false;
  char grade = 'A';           // note: single quotes for char

  // Must declare type — Java is statically typed
  // int score;  → declared but not initialized
  // System.out.println(score);  // ❌ ERROR — must initialize first

─────────────────────────────────────
LITERALS — how you write values:
─────────────────────────────────────
  int million = 1_000_000;     // underscores for readability ✅
  long big = 9_999_999_999L;   // L suffix for long
  float pi = 3.14f;            // f suffix for float
  double e = 2.71828;          // double is the default
  char letter = 'K';           // single quotes — one character
  boolean flag = true;         // true or false (lowercase)

  // Hex, binary, octal literals:
  int hex    = 0xFF;           // hexadecimal (255)
  int binary = 0b1010;         // binary (10)
  int octal  = 0777;           // octal — starts with 0!

─────────────────────────────────────
TYPE LIMITS — overflow:
─────────────────────────────────────
  Java does NOT throw when you overflow — it wraps around!

  int max = Integer.MAX_VALUE;   // 2,147,483,647
  System.out.println(max + 1);   // -2,147,483,648 (!!)

  This is called integer overflow — a classic silent bug.
  Use long when numbers might get very large.

─────────────────────────────────────
TYPE CONVERSION:
─────────────────────────────────────
  Widening (automatic — safe):
    byte → short → int → long → float → double
    int x = 42;
    long y = x;       // ✅ automatic — int fits in long
    double z = x;     // ✅ automatic

  Narrowing (manual cast — potential data loss):
    double pi = 3.14;
    int truncated = (int) pi;   // → 3  (decimal dropped!)

    int big = 300;
    byte small = (byte) big;    // → 44 (overflow wraps)

─────────────────────────────────────
var — LOCAL TYPE INFERENCE (Java 10+):
─────────────────────────────────────
  var name = "Terry";     // compiler infers String
  var count = 42;         // compiler infers int
  var price = 9.99;       // compiler infers double

  var only works for LOCAL variables (inside methods).
  The type is still fixed at compile time — just inferred.

─────────────────────────────────────
WRAPPER CLASSES:
─────────────────────────────────────
  Every primitive has an object wrapper class:
  int → Integer,  double → Double,  boolean → Boolean
  char → Character, long → Long, etc.

  These are needed for collections and generics:
  List<Integer> list = new ArrayList<>();  // not List<int>!

  Autoboxing converts automatically:
  Integer boxed = 42;     // int → Integer (autoboxing)
  int unboxed = boxed;    // Integer → int (unboxing)

💻 CODE:
public class PrimitiveTypes {
    public static void main(String[] args) {

        // ─── THE 8 PRIMITIVE TYPES ──────────────────────
        System.out.println("=== Primitive Types ===");

        byte  b = 127;
        short s = 32_000;
        int   i = 2_147_483_647;         // Integer.MAX_VALUE
        long  l = 9_223_372_036_854L;    // needs L suffix
        float f = 3.14f;                 // needs f suffix
        double d = 3.141592653589793;    // default decimal
        char  c = 'J';
        boolean flag = true;

        System.out.println("byte    : " + b);
        System.out.println("short   : " + s);
        System.out.println("int     : " + i);
        System.out.println("long    : " + l);
        System.out.println("float   : " + f);
        System.out.println("double  : " + d);
        System.out.println("char    : " + c);
        System.out.println("boolean : " + flag);

        // ─── TYPE LIMITS ─────────────────────────────────
        System.out.println("\n=== Type Limits ===");
        System.out.println("Integer.MAX_VALUE  = " + Integer.MAX_VALUE);
        System.out.println("Integer.MIN_VALUE  = " + Integer.MIN_VALUE);
        System.out.println("Long.MAX_VALUE     = " + Long.MAX_VALUE);
        System.out.println("Double.MAX_VALUE   = " + Double.MAX_VALUE);

        // Overflow — wraps silently!
        int overflow = Integer.MAX_VALUE + 1;
        System.out.println("MAX_VALUE + 1 = " + overflow + " ⚠️ overflow!");

        // ─── TYPE CONVERSION ─────────────────────────────
        System.out.println("\n=== Type Conversion ===");

        // Widening — automatic
        int count = 100;
        long bigCount = count;       // int → long (safe)
        double decimal = count;      // int → double (safe)
        System.out.println("int  → long  : " + bigCount);
        System.out.println("int  → double: " + decimal);

        // Narrowing — requires explicit cast
        double pi = 3.14159;
        int truncated = (int) pi;    // 3.14159 → 3
        System.out.println("double → int : " + pi + " → " + truncated);

        long bigNum = 1_000_000_000_000L;
        int clamped = (int) bigNum;  // data loss!
        System.out.println("long → int  : " + bigNum + " → " + clamped + " ⚠️");

        // ─── ARITHMETIC ──────────────────────────────────
        System.out.println("\n=== Arithmetic ===");
        int a = 17, bb = 5;
        System.out.println(a + " + " + bb + " = " + (a + bb));
        System.out.println(a + " - " + bb + " = " + (a - bb));
        System.out.println(a + " * " + bb + " = " + (a * bb));
        System.out.println(a + " / " + bb + " = " + (a / bb) + " (integer division)");
        System.out.println(a + " % " + bb + " = " + (a % bb) + " (remainder)");

        // Integer division vs decimal division
        System.out.println("17 / 5   = " + (17 / 5));           // 3
        System.out.println("17.0 / 5 = " + (17.0 / 5));         // 3.4
        System.out.println("(double)17 / 5 = " + ((double)17 / 5)); // 3.4

        // ─── WRAPPER CLASSES & AUTOBOXING ────────────────
        System.out.println("\n=== Wrappers & Autoboxing ===");
        Integer boxed = 42;          // autoboxing: int → Integer
        int unboxed = boxed;         // unboxing: Integer → int
        System.out.println("Boxed  : " + boxed.getClass().getName());
        System.out.println("Unboxed: " + unboxed);

        // Useful wrapper methods
        System.out.println("parseInt: " + Integer.parseInt("123"));
        System.out.println("toBinaryString: " + Integer.toBinaryString(255));
        System.out.println("toHexString: " + Integer.toHexString(255));
        System.out.println("max: " + Integer.max(10, 20));

        // ─── var (Java 10+) ───────────────────────────────
        System.out.println("\n=== var type inference ===");
        var name = "Java";
        var version = 21;
        var isLTS = true;
        System.out.println(name + " " + version + " LTS: " + isLTS);

        // Special values
        System.out.println("\n=== Special Values ===");
        System.out.println("Max double: " + Double.MAX_VALUE);
        System.out.println("Infinity  : " + (1.0 / 0.0));
        System.out.println("NaN       : " + (0.0 / 0.0));
        System.out.println("Is NaN?   : " + Double.isNaN(0.0 / 0.0));
    }
}

📝 KEY POINTS:
✅ Java has 8 primitive types: byte, short, int, long, float, double, char, boolean
✅ int is the default for integers; double is the default for decimals
✅ Long literals need L suffix: 9_999L; float literals need f: 3.14f
✅ Use underscores in large numbers for readability: 1_000_000
✅ Widening conversions are automatic; narrowing requires explicit cast
✅ Integer overflow wraps silently — use long for large numbers
✅ var infers the type locally (Java 10+) — type is still fixed at compile time
✅ Every primitive has a wrapper class: int → Integer, double → Double
❌ char uses single quotes ('A'); String uses double quotes ("A") — not interchangeable
❌ Don't use float for financial calculations — use double or BigDecimal
❌ Comparing Integer objects with == checks reference, not value — use .equals()
❌ 1/3 in integer division gives 0, not 0.333 — cast to double if needed
""",
  quiz: [
    Quiz(question: 'What is the default type for a whole number literal like 42 in Java?', options: [
      QuizOption(text: 'int', correct: true),
      QuizOption(text: 'long', correct: false),
      QuizOption(text: 'short', correct: false),
      QuizOption(text: 'byte', correct: false),
    ]),
    Quiz(question: 'What happens when an int value overflows its maximum value in Java?', options: [
      QuizOption(text: 'It wraps around silently to the minimum value — no exception is thrown', correct: true),
      QuizOption(text: 'Java throws an ArithmeticException automatically', correct: false),
      QuizOption(text: 'The value is clamped to Integer.MAX_VALUE', correct: false),
      QuizOption(text: 'The variable is automatically promoted to long', correct: false),
    ]),
    Quiz(question: 'What suffix is required to declare a long literal?', options: [
      QuizOption(text: 'L — for example: 9_999_999_999L', correct: true),
      QuizOption(text: 'l (lowercase) — for example: 9999l', correct: false),
      QuizOption(text: 'lng — for example: 9999lng', correct: false),
      QuizOption(text: 'No suffix — Java infers long for large numbers automatically', correct: false),
    ]),
  ],
);
