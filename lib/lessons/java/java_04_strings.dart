import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson04 = Lesson(
  language: 'Java',
  title: 'Strings',
  content: """
🎯 METAPHOR:
A Java String is like a message carved in stone —
immutable once created. When you "change" a String in Java,
you're not chiseling the old stone tablet — you're
commissioning a BRAND NEW tablet and throwing the old one
away. This immutability is a feature: it makes Strings
safe to share between threads and as map keys. But it
means repeated String modification in a loop is wasteful —
each "change" creates a whole new stone tablet.
That's why StringBuilder exists: it's the clay tablet
you sculpt freely, only converting to stone at the end.

📖 EXPLANATION:
String is one of the most-used types in Java.
Unlike the 8 primitive types, String is a CLASS —
it lives on the heap and has methods you can call on it.

─────────────────────────────────────
CREATING STRINGS:
─────────────────────────────────────
  String greeting = "Hello, World!";
  String empty = "";
  String multiWord = "Java is fun";

  // String() constructor (rare, prefer literals):
  String s = new String("hello");

  // Text block (Java 13+ — multi-line string):
  String json = \"\"\"
      {
          "name": "Terry",
          "age": 30
      }
      \"\"\";

─────────────────────────────────────
STRING IMMUTABILITY:
─────────────────────────────────────
  String s = "Hello";
  s = s + " World";   // ← NOT modifying "Hello"
                      //   creating a NEW String "Hello World"
                      //   and reassigning s to it
  // "Hello" is still in memory until garbage collected

─────────────────────────────────────
STRING POOL — Java's optimization:
─────────────────────────────────────
  String a = "Java";
  String b = "Java";
  // Both point to the SAME object in the String pool!
  System.out.println(a == b);      // true (same reference)
  System.out.println(a.equals(b)); // true (same content)

  String c = new String("Java");
  System.out.println(a == c);      // false (different object)
  System.out.println(a.equals(c)); // true (same content)

  ⭐ ALWAYS use .equals() to compare String content.
     Never use == for String comparison.

─────────────────────────────────────
ESSENTIAL STRING METHODS:
─────────────────────────────────────
  Method                          Returns
  ──────────────────────────────────────────────────
  s.length()                      number of characters
  s.charAt(i)                     char at index i
  s.indexOf("sub")                index of first match (-1 if none)
  s.lastIndexOf("sub")            index of last match
  s.substring(start)              from start to end
  s.substring(start, end)         from start to end (exclusive)
  s.toUpperCase()                 new uppercase String
  s.toLowerCase()                 new lowercase String
  s.trim()                        remove leading/trailing spaces
  s.strip()                       like trim(), Unicode-aware (Java 11)
  s.replace("old", "new")         replace all occurrences
  s.contains("sub")               true if substring exists
  s.startsWith("prefix")          true if starts with prefix
  s.endsWith("suffix")            true if ends with suffix
  s.split(",")                    String[] split by delimiter
  s.isEmpty()                     true if length == 0
  s.isBlank()                     true if empty or whitespace (Java 11)
  s.equals(other)                 content equality ✅
  s.equalsIgnoreCase(other)       case-insensitive equality
  s.compareTo(other)              lexicographic comparison
  s.format(template, args)        printf-style formatting
  String.valueOf(42)              convert anything to String
  s.chars()                       IntStream of character codes
  s.repeat(3)                     repeat n times (Java 11)

─────────────────────────────────────
STRING FORMATTING:
─────────────────────────────────────
  // Concatenation (simple but slow in loops):
  String name = "Terry";
  int age = 30;
  String msg = "Name: " + name + ", Age: " + age;

  // String.format() — printf style:
  String msg2 = String.format("Name: %s, Age: %d", name, age);

  // formatted() shorthand (Java 15+):
  String msg3 = "Name: %s, Age: %d".formatted(name, age);

  // printf — format AND print:
  System.out.printf("Name: %-10s Age: %3d%n", name, age);

─────────────────────────────────────
StringBuilder — MUTABLE STRING BUILDER:
─────────────────────────────────────
  StringBuilder sb = new StringBuilder();
  sb.append("Hello");
  sb.append(", ");
  sb.append("World");
  sb.append("!");
  String result = sb.toString();   // "Hello, World!"

  // Other StringBuilder methods:
  sb.insert(5, " there");          // insert at index
  sb.delete(5, 11);                // delete range
  sb.reverse();                    // reverse in place
  sb.length();                     // current length

  Use StringBuilder when building strings in a loop.
  + in a loop creates a new String on EVERY iteration — slow.

💻 CODE:
public class Strings {
    public static void main(String[] args) {

        // ─── BASICS ──────────────────────────────────────
        System.out.println("=== String Basics ===");
        String name = "Java Programming";
        System.out.println("Value  : " + name);
        System.out.println("Length : " + name.length());
        System.out.println("Upper  : " + name.toUpperCase());
        System.out.println("Lower  : " + name.toLowerCase());
        System.out.println("Trim   : " + "  hello  ".strip());

        // ─── INDEXING ─────────────────────────────────────
        System.out.println("\n=== Indexing ===");
        //   J  a  v  a     P  r  o  g  r  a  m  m  i  n  g
        //   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
        System.out.println("charAt(0)      : " + name.charAt(0));   // J
        System.out.println("charAt(5)      : " + name.charAt(5));   // P
        System.out.println("indexOf('a')   : " + name.indexOf('a')); // 1
        System.out.println("lastIndexOf('a'): " + name.lastIndexOf('a')); // 10
        System.out.println("indexOf(\"Pro\") : " + name.indexOf("Pro")); // 5

        // ─── SUBSTRINGS ───────────────────────────────────
        System.out.println("\n=== Substrings ===");
        System.out.println("substring(5)   : " + name.substring(5));      // Programming
        System.out.println("substring(0,4) : " + name.substring(0, 4));   // Java

        // ─── SEARCHING ────────────────────────────────────
        System.out.println("\n=== Searching ===");
        System.out.println("contains('Java') : " + name.contains("Java"));
        System.out.println("startsWith('Java'): " + name.startsWith("Java"));
        System.out.println("endsWith('ing')  : " + name.endsWith("ing"));

        // ─── COMPARISON ──────────────────────────────────
        System.out.println("\n=== Comparison (ALWAYS use equals!) ===");
        String a = "hello";
        String b = "hello";
        String c = new String("hello");
        System.out.println("a == b       : " + (a == b));       // true (pool)
        System.out.println("a == c       : " + (a == c));       // false (new obj)
        System.out.println("a.equals(b)  : " + a.equals(b));   // true ✅
        System.out.println("a.equals(c)  : " + a.equals(c));   // true ✅
        System.out.println("equalsIgnoreCase: " + "HELLO".equalsIgnoreCase("hello"));

        // ─── SPLITTING & JOINING ──────────────────────────
        System.out.println("\n=== Split & Join ===");
        String csv = "apple,banana,cherry,date";
        String[] fruits = csv.split(",");
        for (String fruit : fruits) {
            System.out.println("  • " + fruit);
        }
        String joined = String.join(" | ", fruits);
        System.out.println("Joined: " + joined);

        // ─── FORMATTING ───────────────────────────────────
        System.out.println("\n=== Formatting ===");
        String formatted = String.format(
            "%-12s %5d  %8.2f", "Terry", 30, 95.5
        );
        System.out.println(formatted);
        System.out.printf("  %-12s %5d  %8.2f%n", "Sam",   25, 88.0);
        System.out.printf("  %-12s %5d  %8.2f%n", "Alice", 28, 92.3);

        // ─── CONVERSION ───────────────────────────────────
        System.out.println("\n=== Type Conversion ===");
        int num = 42;
        String fromInt = String.valueOf(num);      // int → String
        int backToInt = Integer.parseInt(fromInt); // String → int
        double fromDouble = Double.parseDouble("3.14");
        System.out.println("int → String: " + fromInt);
        System.out.println("String → int: " + backToInt);
        System.out.println("String → double: " + fromDouble);

        // ─── StringBuilder ────────────────────────────────
        System.out.println("\n=== StringBuilder ===");
        StringBuilder sb = new StringBuilder();
        String[] words = {"The", "quick", "brown", "fox"};
        for (String word : words) {
            if (sb.length() > 0) sb.append(" ");
            sb.append(word);
        }
        System.out.println("Built: " + sb.toString());
        System.out.println("Reversed: " + sb.reverse().toString());

        // ─── TEXT BLOCKS (Java 13+) ───────────────────────
        System.out.println("\n=== Text Block ===");
        String sql = """
                SELECT name, email
                FROM   users
                WHERE  active = true
                ORDER BY name
                """;
        System.out.println(sql);

        // ─── USEFUL CHECKS ────────────────────────────────
        System.out.println("=== Checks ===");
        System.out.println("isEmpty('')  : " + "".isEmpty());
        System.out.println("isBlank('  '): " + "   ".isBlank());
        System.out.println("repeat:        " + "ab".repeat(4));
        System.out.println("chars sum:     " + "Java".chars().sum());
    }
}

📝 KEY POINTS:
✅ Strings are IMMUTABLE — every "modification" creates a new String
✅ ALWAYS use .equals() to compare String content — never ==
✅ String literals are pooled — "hello" == "hello" is often true but unreliable
✅ Use StringBuilder when building strings in loops — much faster
✅ String.format() / .formatted() for clean readable formatting
✅ split() returns String[] — an array of parts
✅ String.valueOf() converts any type to String
✅ Text blocks (""") preserve formatting and avoid escape sequences
✅ strip() is Unicode-aware; trim() is legacy — prefer strip()
❌ Don't use + in a loop to concatenate — use StringBuilder
❌ Never use == to compare String values — it checks reference identity
❌ parseInt() throws NumberFormatException on invalid input — handle it
❌ charAt() throws StringIndexOutOfBoundsException if index is out of range
""",
  quiz: [
    Quiz(question: 'Why should you always use .equals() instead of == to compare Strings in Java?', options: [
      QuizOption(text: '== compares object references, not content — two equal Strings can be different objects', correct: true),
      QuizOption(text: '.equals() is faster than == for String comparison', correct: false),
      QuizOption(text: '== only works for primitive types, not objects', correct: false),
      QuizOption(text: '.equals() checks both content and case; == only checks content', correct: false),
    ]),
    Quiz(question: 'What does String immutability mean in Java?', options: [
      QuizOption(text: 'Once created, a String\'s content cannot be changed — operations return new String objects', correct: true),
      QuizOption(text: 'Strings cannot be passed as method parameters', correct: false),
      QuizOption(text: 'String variables declared with final cannot be reassigned', correct: false),
      QuizOption(text: 'Strings stored in the pool cannot be garbage collected', correct: false),
    ]),
    Quiz(question: 'When should you use StringBuilder instead of String concatenation with +?', options: [
      QuizOption(text: 'When building strings in a loop — + creates a new String object on every iteration', correct: true),
      QuizOption(text: 'Only when the String contains special characters like quotes', correct: false),
      QuizOption(text: 'StringBuilder is only needed for strings longer than 100 characters', correct: false),
      QuizOption(text: 'StringBuilder should always be used — + concatenation is deprecated', correct: false),
    ]),
  ],
);
