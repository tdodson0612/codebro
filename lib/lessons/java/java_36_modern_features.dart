import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson36 = Lesson(
  language: 'Java',
  title: 'var, Text Blocks, and Modern Java Features',
  content: """
🎯 METAPHOR:
Modern Java features are like QoL (Quality of Life) upgrades
in a video game. The old mechanics still work — you can still
play the game with ancient controls. But the new features
make common tasks dramatically less tedious without changing
the fundamentals. var is like auto-complete for types —
you don't have to write "HashMap<String, List<Integer>>"
when the compiler already knows from context. Text blocks
are like copy-paste from Notepad instead of struggling
with escape sequences. These aren't new concepts —
they're polish on existing ones that removes friction.

📖 EXPLANATION:
Java has been evolving rapidly since Java 8. This lesson
covers the most impactful improvements from Java 10–21.

─────────────────────────────────────
var — LOCAL TYPE INFERENCE (Java 10):
─────────────────────────────────────
  var x = 42;                    // int
  var name = "Terry";            // String
  var list = new ArrayList<>();  // ArrayList<Object>
  var map = new HashMap<String, List<Integer>>();

  Rules:
  ✅ Only for LOCAL VARIABLES (inside methods)
  ✅ Must be initialized at declaration
  ✅ Type is FIXED at compile time — not dynamic
  ❌ Cannot be used for fields, parameters, or return types
  ❌ Cannot be null: var x = null;  // error — can't infer type
  ❌ Cannot be used without initialization

  Best practices:
  ✅ Use when the type is obvious from the right side
  ✅ Use with complex generic types to reduce noise
  ❌ Don't use when it obscures the type: var x = getUser();

─────────────────────────────────────
TEXT BLOCKS (Java 13 preview, Java 15 stable):
─────────────────────────────────────
  // Old style — escaped characters everywhere:
  String json = "{\\"name\\": \\"Terry\\",\\"age\\": 30}";
  String html = "<html>\\n  <body>\\n    Hello\\n  </body>\\n</html>";

  // Text block — formatted naturally:
  String json = \"\"\"
          {
              "name": "Terry",
              "age": 30
          }
          \"\"\";

  String html = \"\"\"
          <html>
            <body>
              Hello
            </body>
          </html>
          \"\"\";

  Rules:
  • Opening \"\"\" must be on its own line (with code after it)
  • Indentation is stripped based on leftmost content
  • Closing \"\"\" controls indentation — aligning it left keeps it
  • Template: %s formatters still work with .formatted()

─────────────────────────────────────
SWITCH EXPRESSIONS (Java 14 stable):
─────────────────────────────────────
  String result = switch (day) {
      case MONDAY, TUESDAY -> "Early week";
      case WEDNESDAY -> "Midweek";
      case THURSDAY, FRIDAY -> {
          System.out.println("Almost there!");
          yield "Late week";
      }
      case SATURDAY, SUNDAY -> "Weekend!";
  };

─────────────────────────────────────
ENHANCED instanceof (Java 16):
─────────────────────────────────────
  // Old:
  if (obj instanceof String) {
      String s = (String) obj;
      System.out.println(s.length());
  }

  // New — pattern matching:
  if (obj instanceof String s) {
      System.out.println(s.length());  // s already cast!
  }

  // In switch (Java 21):
  switch (obj) {
      case Integer i -> System.out.println("Int: " + i);
      case String s  -> System.out.println("String: " + s);
      case null      -> System.out.println("null!");
      default        -> System.out.println("Other");
  }

─────────────────────────────────────
HELPFUL NULLPOINTEREXCEPTION (Java 14):
─────────────────────────────────────
  // Old NPE: "NullPointerException"
  // New NPE: "Cannot invoke String.length() because the return
  //          value of User.getName() is null"

─────────────────────────────────────
COLLECTION FACTORY METHODS (Java 9):
─────────────────────────────────────
  List.of("a", "b", "c")          // immutable
  Set.of(1, 2, 3)                 // immutable, no dups
  Map.of("k1", 1, "k2", 2)       // immutable, up to 10 pairs
  Map.ofEntries(
      Map.entry("k1", 1),
      Map.entry("k2", 2)
  )                               // for > 10 pairs

─────────────────────────────────────
String IMPROVEMENTS (Java 11, 12, 15):
─────────────────────────────────────
  Java 11:
  "  hello  ".strip()            → "hello" (Unicode-aware)
  "  hello  ".stripLeading()     → "hello  "
  "  hello  ".stripTrailing()    → "  hello"
  "".isBlank()                   → true
  "hello\nworld".lines()         → Stream<String>
  "ha".repeat(3)                 → "hahaha"

  Java 12:
  str.indent(4)                  → indent each line by 4
  str.transform(fn)              → apply function to string

  Java 15+:
  "Name: %s, Age: %d".formatted("Terry", 30) → formatted String

─────────────────────────────────────
Optional IMPROVEMENTS (Java 9-11):
─────────────────────────────────────
  Java 9:
  opt.ifPresentOrElse(consumer, runnable)
  opt.or(Supplier<Optional>)
  opt.stream()

  Java 10:
  opt.orElseThrow()   // throws NoSuchElementException (no arg)

─────────────────────────────────────
VIRTUAL THREADS (Java 21):
─────────────────────────────────────
  Lightweight, millions possible — great for I/O-heavy apps.
  Thread.ofVirtual().start(() -> { ... });
  Executors.newVirtualThreadPerTaskExecutor()

💻 CODE:
import java.util.*;
import java.util.stream.*;
import java.util.function.*;

public class ModernJava {
    public static void main(String[] args) {

        // ─── var ──────────────────────────────────────────
        System.out.println("=== var — Type Inference ===");

        // Simple types — var shows its value
        var count  = 42;
        var name   = "Terry";
        var pi     = 3.14159;
        var active = true;

        System.out.printf("  count=%d  name=%s  pi=%.2f  active=%b%n",
            count, name, pi, active);

        // Complex generics — var shines here
        var employees = new ArrayList<Map<String, Object>>();
        var scoreMap = new HashMap<String, List<Integer>>();

        // var in for-each
        var fruits = List.of("apple", "banana", "cherry");
        for (var fruit : fruits) {
            System.out.println("  " + fruit.toUpperCase()); // fruit is String
        }

        // var in try-with-resources
        try (var scanner = new java.util.Scanner(System.in)) {
            // scanner is Scanner
        }

        // ─── TEXT BLOCKS ──────────────────────────────────
        System.out.println("\n=== Text Blocks ===");

        var json = """
                {
                    "name": "Terry",
                    "age": 30,
                    "active": true,
                    "scores": [95, 87, 92]
                }
                """;
        System.out.println("JSON text block:");
        System.out.println(json);

        var sql = """
                SELECT u.name, u.email, COUNT(o.id) AS order_count
                FROM   users u
                LEFT JOIN orders o ON u.id = o.user_id
                WHERE  u.active = true
                GROUP BY u.id
                ORDER BY order_count DESC
                LIMIT 10
                """;
        System.out.println("SQL text block:");
        System.out.println(sql);

        // Text block with .formatted()
        String template = """
                Dear %s,
                Your order #%d has been shipped.
                Total:\$%.2f
                Thank you!
                """;
        String letter = template.formatted("Alice", 12345, 99.95);
        System.out.println("Formatted text block:");
        System.out.println(letter);

        // ─── MODERN switch ────────────────────────────────
        System.out.println("=== Modern switch Expression ===");
        int[] testScores = {95, 82, 71, 58, 42};

        for (int score : testScores) {
            String grade = switch (score / 10) {
                case 10, 9 -> "A";
                case 8     -> "B";
                case 7     -> "C";
                case 6     -> "D";
                default    -> "F";
            };

            String feedback = switch (grade) {
                case "A" -> "Excellent! 🌟";
                case "B" -> "Good job! 👍";
                case "C" -> {
                    System.out.print("  [Average — ");
                    yield "Keep working. 📚]";
                }
                default -> "Needs improvement. 💪";
            };

            System.out.printf("  Score %3d → %s — %s%n", score, grade, feedback);
        }

        // ─── PATTERN MATCHING instanceof ──────────────────
        System.out.println("\n=== Pattern Matching instanceof ===");
        Object[] items = { "hello", 42, 3.14, List.of(1,2,3), null, true };

        for (Object item : items) {
            String desc = switch (item) {
                case String s  -> "String(%d): '%s'".formatted(s.length(), s);
                case Integer i -> "Integer: %d (squared: %d)".formatted(i, i*i);
                case Double d  -> "Double: %.3f".formatted(d);
                case List<?> l -> "List of %d items".formatted(l.size());
                case null      -> "null!";
                default        -> "Unknown: " + item.getClass().getSimpleName();
            };
            System.out.println("  " + desc);
        }

        // ─── COLLECTION FACTORY METHODS ───────────────────
        System.out.println("\n=== Collection Factory Methods ===");
        var immutableList = List.of("a", "b", "c", "d");
        var immutableSet  = Set.of(1, 2, 3, 4, 5);
        var immutableMap  = Map.of("one", 1, "two", 2, "three", 3);

        System.out.println("  List.of: " + immutableList);
        System.out.println("  Set.of:  " + immutableSet);
        System.out.println("  Map.of:  " + new TreeMap<>(immutableMap));

        // For larger maps:
        var bigMap = Map.ofEntries(
            Map.entry("USA", "Washington D.C."),
            Map.entry("UK",  "London"),
            Map.entry("France", "Paris"),
            Map.entry("Japan",  "Tokyo")
        );
        System.out.println("  Map.ofEntries: " + new TreeMap<>(bigMap));

        // ─── STRING IMPROVEMENTS ──────────────────────────
        System.out.println("\n=== String Improvements (Java 11+) ===");
        var messy = "  \t Hello World \n  ";
        System.out.println("  strip():         '" + messy.strip() + "'");
        System.out.println("  stripLeading():  '" + messy.stripLeading() + "'");
        System.out.println("  stripTrailing(): '" + messy.stripTrailing() + "'");
        System.out.println("  isBlank():        " + "  ".isBlank());
        System.out.println("  isBlank():        " + "hi".isBlank());
        System.out.println("  repeat(3):        " + "ha".repeat(3));

        // lines() — Stream<String>
        var multiline = "line1\nline2\nline3\nline4";
        var lineList  = multiline.lines().collect(Collectors.toList());
        System.out.println("  lines(): " + lineList);

        // indent()
        System.out.println("\n  indent(4):");
        System.out.print("alpha\nbeta\ngamma".indent(4));

        // ─── Optional IMPROVEMENTS ────────────────────────
        System.out.println("=== Optional Improvements ===");
        var opt1 = Optional.of("Hello");
        var opt2 = Optional.<String>empty();

        opt1.ifPresentOrElse(
            v -> System.out.println("  opt1 present: " + v),
            () -> System.out.println("  opt1 empty")
        );

        var result = opt2
            .or(() -> Optional.of("fallback"))
            .orElseThrow();
        System.out.println("  opt2.or(): " + result);

        // Stream from Optional
        List<Optional<String>> optList = List.of(
            Optional.of("a"), Optional.empty(),
            Optional.of("b"), Optional.empty(), Optional.of("c"));

        var present = optList.stream()
            .flatMap(Optional::stream)
            .collect(Collectors.toList());
        System.out.println("  Non-empty opts: " + present);
    }
}

📝 KEY POINTS:
✅ var infers local variable types — only works for local variables with initialization
✅ Text blocks use triple quotes, strip indentation, and avoid escape hell
✅ .formatted() on text blocks replaces String.format() for cleaner templates
✅ Modern switch expressions use -> and yield, no fall-through, can return a value
✅ Pattern matching instanceof: if (obj instanceof String s) avoids manual cast
✅ List.of(), Set.of(), Map.of() create immutable collections concisely
✅ strip() is the Unicode-aware replacement for trim()
✅ repeat(), isBlank(), lines(), indent(), transform() are Java 11-12 String additions
✅ Virtual threads (Java 21) enable millions of lightweight concurrent tasks
❌ var cannot be used for fields, parameters, or return types
❌ var without initialization fails: var x = null fails to compile
❌ Text blocks are not raw strings — \n and \t still work inside them
❌ List.of() throws UnsupportedOperationException on add()/remove()
""",
  quiz: [
    Quiz(question: 'Where can var be used in Java?', options: [
      QuizOption(text: 'Only for local variables inside methods — not for fields, parameters, or return types', correct: true),
      QuizOption(text: 'Anywhere a type declaration appears — fields, parameters, and local variables', correct: false),
      QuizOption(text: 'Only inside lambda expressions and anonymous classes', correct: false),
      QuizOption(text: 'For method return types and local variables only', correct: false),
    ]),
    Quiz(question: 'What does a text block\'s indentation stripping depend on?', options: [
      QuizOption(text: 'The position of the closing triple-quote on its own line determines how much indentation is stripped', correct: true),
      QuizOption(text: 'All leading whitespace is stripped from every line regardless of the closing quote position', correct: false),
      QuizOption(text: 'The indentation of the opening triple-quote determines stripping', correct: false),
      QuizOption(text: 'Indentation is never stripped — text blocks preserve all whitespace exactly', correct: false),
    ]),
    Quiz(question: 'What is the advantage of pattern matching instanceof (Java 16)?', options: [
      QuizOption(text: 'It combines the type check and cast in one step — no explicit cast needed after the check', correct: true),
      QuizOption(text: 'It is faster than traditional instanceof at runtime', correct: false),
      QuizOption(text: 'It allows instanceof to work on primitive types', correct: false),
      QuizOption(text: 'It enables instanceof to check multiple types simultaneously', correct: false),
    ]),
  ],
);
