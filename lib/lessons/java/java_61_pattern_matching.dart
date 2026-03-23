import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson61 = Lesson(
  language: 'Java',
  title: 'Pattern Matching Deep Dive (Java 21)',
  content: """
🎯 METAPHOR:
Pattern matching is like a smart mail sorter that reads
a package and instantly sorts it — checking the type, size,
and contents in one motion. Old Java required: "Is this
a package? Yes. Open it. Check the weight. Check the
contents. Then handle it." Pattern matching does it all
in one declarative line: "If this is a heavy box with
fragile contents, route to aisle 3." More expressive,
less error-prone, less code.

📖 EXPLANATION:
Pattern matching in Java has evolved through several
versions into a powerful feature set in Java 21.

─────────────────────────────────────
TYPE PATTERNS (instanceof) — Java 16:
─────────────────────────────────────
  // Old style:
  if (obj instanceof String) {
      String s = (String) obj;
      System.out.println(s.length());
  }

  // Pattern matching:
  if (obj instanceof String s) {
      System.out.println(s.length());   // s is bound here
  }

  // Guarded patterns (Java 21):
  if (obj instanceof String s && s.length() > 5) {
      System.out.println("Long string: " + s);
  }

─────────────────────────────────────
SWITCH PATTERNS (Java 21 — stable):
─────────────────────────────────────
  String describe(Object obj) {
      return switch (obj) {
          case Integer i when i < 0     -> "negative int: " + i;
          case Integer i                -> "positive int: " + i;
          case String s  when s.isEmpty() -> "empty string";
          case String s                 -> "string: " + s;
          case null                     -> "null";
          default                       -> "other: " + obj;
      };
  }

─────────────────────────────────────
RECORD PATTERNS (Java 21 — stable):
─────────────────────────────────────
  Deconstruct records in patterns:

  record Point(int x, int y) {}
  record Circle(Point center, double radius) {}

  // Match and destructure:
  if (shape instanceof Circle(Point(int x, int y), double r)) {
      System.out.println("Circle at (" + x + "," + y + ") r=" + r);
  }

  // In switch:
  String describe(Object shape) {
      return switch (shape) {
          case Circle(Point(int x, int y), double r) -> "Circle center=(%d,%d) r=%.1f".formatted(x,y,r);
          case Rectangle(Point tl, Point br) -> "Rect %s to %s".formatted(tl, br);
          default -> "unknown";
      };
  }

─────────────────────────────────────
SEALED + PATTERNS = EXHAUSTIVE MATCHING:
─────────────────────────────────────
  sealed interface Expr permits Num, Add, Mul {}
  record Num(int value) implements Expr {}
  record Add(Expr left, Expr right) implements Expr {}
  record Mul(Expr left, Expr right) implements Expr {}

  int eval(Expr expr) {
      return switch (expr) {
          case Num(int n)           -> n;
          case Add(Expr l, Expr r)  -> eval(l) + eval(r);
          case Mul(Expr l, Expr r)  -> eval(l) * eval(r);
      };  // no default — compiler knows all Expr types!
  }

  // eval(Add(Mul(Num(2), Num(3)), Num(4))) = 2*3+4 = 10

─────────────────────────────────────
PATTERN VARIABLE SCOPE:
─────────────────────────────────────
  // Scope: from match point to end of block
  if (obj instanceof String s) {
      // s is in scope here
      System.out.println(s.toUpperCase());
  }
  // s is NOT in scope here

  // Negation — s is in scope in the else branch:
  if (!(obj instanceof String s)) {
      return "not a string";
  }
  // s IS in scope here — control can only reach here if obj IS String
  System.out.println(s.length());

─────────────────────────────────────
GUARDED PATTERNS (when clause):
─────────────────────────────────────
  // Multiple conditions combined:
  return switch (obj) {
      case Integer i when i > 0 && i < 100 -> "small positive";
      case Integer i when i >= 100          -> "large";
      case Integer i                        -> "non-positive";
      default                               -> "not an int";
  };

  // Pattern guards can call methods:
  case String s when s.matches("\\d+") -> "numeric string";

💻 CODE:
import java.util.*;
import java.util.stream.*;

// ─── SEALED EXPRESSION TREE ───────────────────────────
sealed interface Expr permits Num, Add, Sub, Mul, Div {}
record Num(double value)              implements Expr {}
record Add(Expr left, Expr right)     implements Expr {}
record Sub(Expr left, Expr right)     implements Expr {}
record Mul(Expr left, Expr right)     implements Expr {}
record Div(Expr left, Expr right)     implements Expr {}

// ─── SEALED SHAPE HIERARCHY ───────────────────────────
sealed interface Shape permits Circle2, Rectangle2, Triangle2 {}
record Point2(double x, double y) {}
record Circle2(Point2 center, double radius)           implements Shape {}
record Rectangle2(Point2 topLeft, Point2 bottomRight)  implements Shape {}
record Triangle2(Point2 a, Point2 b, Point2 c)         implements Shape {}

public class PatternMatchingDeep {

    // Evaluate expression tree with record patterns
    static double eval(Expr expr) {
        return switch (expr) {
            case Num(double v)          -> v;
            case Add(Expr l, Expr r)    -> eval(l) + eval(r);
            case Sub(Expr l, Expr r)    -> eval(l) - eval(r);
            case Mul(Expr l, Expr r)    -> eval(l) * eval(r);
            case Div(Expr l, Expr r) when eval(r) != 0 -> eval(l) / eval(r);
            case Div(Expr l, Expr r)    -> Double.NaN;
        };
    }

    // Pretty-print expression
    static String pretty(Expr expr) {
        return switch (expr) {
            case Num(double v)       -> String.valueOf((int)v == v ? (int)v : v);
            case Add(Expr l, Expr r) -> "(" + pretty(l) + " + " + pretty(r) + ")";
            case Sub(Expr l, Expr r) -> "(" + pretty(l) + " - " + pretty(r) + ")";
            case Mul(Expr l, Expr r) -> "(" + pretty(l) + " * " + pretty(r) + ")";
            case Div(Expr l, Expr r) -> "(" + pretty(l) + " / " + pretty(r) + ")";
        };
    }

    // Describe shapes with record patterns
    static String describe(Shape shape) {
        return switch (shape) {
            case Circle2(Point2(double cx, double cy), double r) ->
                "Circle at (%.1f,%.1f) radius=%.1f area=%.2f"
                    .formatted(cx, cy, r, Math.PI * r * r);
            case Rectangle2(Point2(double x1, double y1), Point2(double x2, double y2)) ->
                "Rectangle (%.1f,%.1f)→(%.1f,%.1f) area=%.2f"
                    .formatted(x1, y1, x2, y2, Math.abs(x2-x1) * Math.abs(y2-y1));
            case Triangle2(Point2 a, Point2 b, Point2 c) ->
                "Triangle %s-%s-%s".formatted(a, b, c);
        };
    }

    // Type pattern with guards
    static String classify(Object obj) {
        return switch (obj) {
            case Integer i when i < 0     -> "❌ negative: " + i;
            case Integer i when i == 0    -> "⚪ zero";
            case Integer i when i < 10   -> "🟢 small: " + i;
            case Integer i               -> "🔵 large: " + i;
            case String s  when s.isBlank()-> "📭 blank string";
            case String s  when s.length() == 1 -> "📝 single char: '" + s + "'";
            case String s                -> "📄 string[" + s.length() + "]: " + s;
            case Double d                -> String.format("🔢 double: %.4f", d);
            case List<?> l  when l.isEmpty() -> "📦 empty list";
            case List<?> l               -> "📦 list[" + l.size() + "]: " + l;
            case null                    -> "⚫ null";
            default                      -> "❓ " + obj.getClass().getSimpleName();
        };
    }

    public static void main(String[] args) {
        // ─── EXPRESSION TREE ──────────────────────────────
        System.out.println("=== Expression Tree with Record Patterns ===");
        // (2 * 3) + (10 / 2) - 1  =  6 + 5 - 1  =  10
        Expr expr = new Sub(
            new Add(
                new Mul(new Num(2), new Num(3)),
                new Div(new Num(10), new Num(2))
            ),
            new Num(1)
        );
        System.out.println("  Expression: " + pretty(expr));
        System.out.println("  Result:     " + eval(expr));

        // Division by zero
        Expr divZero = new Div(new Num(5), new Num(0));
        System.out.println("  5/0:        " + eval(divZero));

        // ─── SHAPE PATTERNS ───────────────────────────────
        System.out.println("\n=== Shape Record Patterns ===");
        List<Shape> shapes = List.of(
            new Circle2(new Point2(0, 0), 5.0),
            new Rectangle2(new Point2(1, 1), new Point2(4, 3)),
            new Triangle2(new Point2(0,0), new Point2(3,0), new Point2(0,4))
        );
        shapes.forEach(s -> System.out.println("  " + describe(s)));

        // ─── TYPE PATTERNS WITH GUARDS ────────────────────
        System.out.println("\n=== Guarded Patterns ===");
        Object[] items = {-5, 0, 7, 42, "", "a", "hello", 3.14, List.of(), List.of(1,2,3), null};
        for (Object item : items) {
            System.out.println("  " + classify(item));
        }

        // ─── NEGATED PATTERN SCOPE ────────────────────────
        System.out.println("\n=== Pattern Variable Scope ===");
        Object[] objs = {"Hello", 42, null, "World"};
        for (Object o : objs) {
            if (!(o instanceof String s)) {
                System.out.println("  Not a String: " + o);
                continue;
            }
            // s is definitely a String here
            System.out.println("  String (" + s.length() + "): " + s.toUpperCase());
        }
    }
}

📝 KEY POINTS:
✅ instanceof patterns: if (obj instanceof String s) — type check + bind in one step
✅ Switch patterns: dispatch by type AND value with guarded when clauses
✅ Record patterns: case Circle(Point(int x, int y), double r) — nested deconstruction
✅ Sealed + switch = exhaustive matching — no default needed when all types are covered
✅ Negated pattern: if (!(obj instanceof String s)) — s is in scope AFTER the if block
✅ when clause adds conditions to pattern: case Integer i when i > 0 ->
✅ Pattern variables are scoped to where the match is guaranteed
✅ Record patterns work recursively — match nested records in one expression
❌ Pattern variables cannot be reassigned (they are effectively final)
❌ Pattern matching in switch requires Java 21 — check your version
❌ Guarded patterns with when can't access state modified in the arm — use final bindings
❌ Record patterns only work for records — not for regular classes
""",
  quiz: [
    Quiz(question: 'What does case Integer i when i > 0 do in a switch expression?', options: [
      QuizOption(text: 'Matches if the value is an Integer AND greater than zero — binding it to i if both conditions are true', correct: true),
      QuizOption(text: 'Matches any Integer and then checks i > 0 separately in the body', correct: false),
      QuizOption(text: 'Creates a new Integer variable i equal to the maximum of the value and 0', correct: false),
      QuizOption(text: 'The when clause is a compile-time assertion that always passes for positive integers', correct: false),
    ]),
    Quiz(question: 'What is a record pattern in Java 21?', options: [
      QuizOption(text: 'A pattern that deconstructs a record\'s components: case Circle(Point p, double r) binds p and r directly', correct: true),
      QuizOption(text: 'A special annotation that marks a switch case as handling record types', correct: false),
      QuizOption(text: 'A pattern that matches records based on their toString() representation', correct: false),
      QuizOption(text: 'A template pattern specific to records that auto-generates switch cases', correct: false),
    ]),
    Quiz(question: 'Why does switch on a sealed type not need a default clause?', options: [
      QuizOption(text: 'The compiler knows all possible subtypes at compile time — if all are covered, default is redundant and can be omitted', correct: true),
      QuizOption(text: 'Sealed types throw an exception for unmatched cases at runtime', correct: false),
      QuizOption(text: 'The first case in a sealed switch automatically acts as the default', correct: false),
      QuizOption(text: 'default is forbidden in switch expressions — yield must be used instead', correct: false),
    ]),
  ],
);
