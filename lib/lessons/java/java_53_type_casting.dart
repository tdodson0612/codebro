import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson53 = Lesson(
  language: 'Java',
  title: 'Type Casting and the Java Type System',
  content: """
🎯 METAPHOR:
Type casting is like translating between languages.
Widening is like translating English to a simplified
dialect — no information is lost, the translation is
automatic. Narrowing is like squeezing a full novel
into a tweet — you must explicitly choose to do it,
accept that some content will be cut off, and take
responsibility for the result. Casting an object is
like presenting someone's passport at a border: if the
passport says they're from the right country (correct
subtype), entry is granted. If they're pretending to
be from a country they're not (wrong subtype), the
border guard throws them out (ClassCastException).

📖 EXPLANATION:
Java's type system has two layers: primitive types and
reference types. Casting rules differ between them.

─────────────────────────────────────
PRIMITIVE WIDENING CONVERSIONS (automatic):
─────────────────────────────────────
  byte → short → int → long → float → double
             ↘            ↘
            char → int

  int i = 42;
  long l = i;       // widening — automatic, no data loss
  double d = i;     // widening — automatic
  float f = i;      // widening — but may lose precision!

  ⚠️ int → float can lose precision for large values:
  int big = 123_456_789;
  float f = big;    // 1.23456792E8 (not exact)

─────────────────────────────────────
PRIMITIVE NARROWING CONVERSIONS (explicit cast):
─────────────────────────────────────
  double d = 9.99;
  int i = (int) d;         // → 9 (decimal TRUNCATED, not rounded)
  byte b = (byte) 300;     // → 44 (wraps around — overflow!)

  The cast operator: (TargetType)expression

  // Safe narrowing pattern:
  if (value >= Byte.MIN_VALUE && value <= Byte.MAX_VALUE) {
      byte b = (byte) value;  // safe to narrow
  }

─────────────────────────────────────
REFERENCE UPCASTING (always safe, automatic):
─────────────────────────────────────
  Dog dog = new Dog("Rex");
  Animal animal = dog;       // upcast — Dog IS-A Animal
  Object obj = dog;          // upcast — everything IS-A Object

  No cast syntax needed. Always succeeds.

─────────────────────────────────────
REFERENCE DOWNCASTING (explicit, can fail):
─────────────────────────────────────
  Animal animal = new Dog("Rex");
  Dog dog = (Dog) animal;    // downcast — must cast explicitly
  // ✅ succeeds — actual object IS a Dog

  Animal animal2 = new Cat("Whiskers");
  Dog dog2 = (Dog) animal2; // ❌ ClassCastException — not a Dog!

  // Safe pattern — check before casting:
  if (animal instanceof Dog) {
      Dog d = (Dog) animal;     // safe
  }

  // Modern pattern matching (Java 16+):
  if (animal instanceof Dog d) {
      d.bark();                 // d is already cast and typed
  }

─────────────────────────────────────
PATTERN MATCHING instanceof (Java 16):
─────────────────────────────────────
  // One expression: test + bind variable
  if (obj instanceof String s && s.length() > 5) {
      System.out.println(s.toUpperCase());
  }

  // With negation:
  if (!(obj instanceof String s)) {
      return;   // obj is definitely not a String here
  }
  // s is in scope here — it IS a String

  // In switch (Java 21):
  String result = switch (obj) {
      case Integer i when i > 0 -> "positive int: " + i;
      case Integer i             -> "non-positive int: " + i;
      case String s              -> "string: " + s;
      case null                  -> "null";
      default                    -> "other";
  };

─────────────────────────────────────
NUMERIC PROMOTION — hidden conversions:
─────────────────────────────────────
  byte b1 = 10, b2 = 20;
  byte b3 = b1 + b2;      // ❌ ERROR — result is int!
  byte b3 = (byte)(b1 + b2); // ✅ explicit cast

  Arithmetic on byte/short/char always promotes to int.
  Mixed int+long → long.
  Mixed int+double → double.
  Mixed float+double → double.

─────────────────────────────────────
CHECKED vs UNCHECKED CASTS:
─────────────────────────────────────
  ClassCastException: runtime failure on bad reference cast.
  Can be caught but usually indicates a design problem.

  Generic casts generate "unchecked" compiler warnings:
  List<String> list = (List<String>) someObject;  // ⚠️ unchecked

  @SuppressWarnings("unchecked") to silence when you're sure.

─────────────────────────────────────
THE TYPE HIERARCHY:
─────────────────────────────────────
  Object                    → root of all reference types
    ↓
  Interfaces                → can be implemented by any class
    ↓
  Abstract classes          → partial implementation
    ↓
  Concrete classes          → full implementation

  null is assignable to ANY reference type.
  Every class implicitly extends Object.
  Primitives are NOT objects (except when boxed).

💻 CODE:
import java.util.*;

sealed interface Shape permits Circle, Rect, Tri {}
record Circle(double radius) implements Shape {}
record Rect(double w, double h) implements Shape {}
record Tri(double base, double height) implements Shape {}

class Animal { String name; Animal(String n) { name = n; } }
class Dog extends Animal { Dog(String n) { super(n); } void bark() { System.out.println(name + ": Woof!"); } }
class Cat extends Animal { Cat(String n) { super(n); } void meow() { System.out.println(name + ": Meow!"); } }

public class TypeCasting {
    public static void main(String[] args) {

        // ─── PRIMITIVE WIDENING ───────────────────────────
        System.out.println("=== Primitive Widening (automatic) ===");
        byte  b = 42;
        short s = b;       // byte → short
        int   i = s;       // short → int
        long  l = i;       // int → long
        float f = l;       // long → float
        double d = f;      // float → double
        System.out.printf("  byte=%d → short=%d → int=%d → long=%d → float=%.1f → double=%.1f%n",
            b, s, i, l, f, d);

        // Precision loss: int → float
        int big = 123_456_789;
        float lossyFloat = big;
        System.out.printf("  int %d → float %.1f (loss: %d)%n",
            big, lossyFloat, big - (int)lossyFloat);

        // ─── PRIMITIVE NARROWING ──────────────────────────
        System.out.println("\n=== Primitive Narrowing (explicit) ===");
        double pi = 3.14159;
        int truncated = (int) pi;     // decimal dropped
        System.out.println("  (int) 3.14159 = " + truncated);

        long large = 300L;
        byte narrow = (byte) large;   // wraps around
        System.out.println("  (byte) 300 = " + narrow);

        double neg = -1.9;
        int negInt = (int) neg;        // truncates toward zero
        System.out.println("  (int) -1.9 = " + negInt);

        // ─── NUMERIC PROMOTION ────────────────────────────
        System.out.println("\n=== Numeric Promotion ===");
        byte b1 = 10, b2 = 20;
        // byte b3 = b1 + b2;  // ❌ compile error — result is int
        byte b3 = (byte)(b1 + b2);   // ✅
        System.out.println("  byte + byte cast to byte: " + b3);

        int x = 5;
        long y = 10L;
        long xy = x + y;    // int promoted to long
        System.out.println("  int + long = long: " + xy);

        int a = 3;
        double dd = 3.14;
        double ad = a + dd;  // int promoted to double
        System.out.printf("  int + double = double: %.2f%n", ad);

        // ─── REFERENCE UPCASTING ─────────────────────────
        System.out.println("\n=== Reference Upcasting ===");
        Dog rex = new Dog("Rex");
        Animal animal = rex;    // upcast — always safe
        Object obj = rex;       // upcast to Object

        System.out.println("  dog.name:     " + rex.name);
        System.out.println("  animal.name:  " + animal.name);
        System.out.println("  obj.toString():" + obj);

        // Via parent reference, only Animal methods visible:
        // animal.bark();  // ❌ compile error — Animal doesn't have bark()

        // ─── REFERENCE DOWNCASTING ────────────────────────
        System.out.println("\n=== Reference Downcasting ===");
        Animal[] animals = {new Dog("Rex"), new Cat("Whiskers"), new Dog("Buddy"), new Cat("Luna")};

        for (Animal an : animals) {
            if (an instanceof Dog d) {                 // pattern matching
                d.bark();                              // safe — d is Dog
            } else if (an instanceof Cat c) {
                c.meow();                              // safe — c is Cat
            }
        }

        // Classic cast (pre-Java 16):
        Animal a2 = new Dog("Max");
        if (a2 instanceof Dog) {
            Dog dog = (Dog) a2;   // safe — checked first
            dog.bark();
        }

        // Bad cast — ClassCastException:
        try {
            Animal cat2 = new Cat("Felix");
            Dog wrongCast = (Dog) cat2;   // ❌ runtime error
        } catch (ClassCastException e) {
            System.out.println("  ❌ ClassCastException: " + e.getMessage());
        }

        // ─── PATTERN MATCHING IN switch ───────────────────
        System.out.println("\n=== Pattern Matching in switch ===");
        Object[] items = {42, "hello", 3.14, true, null, new ArrayList<>()};

        for (Object item : items) {
            String desc = switch (item) {
                case Integer n when n > 0 -> "positive int: " + n;
                case Integer n            -> "non-positive int: " + n;
                case String s  when s.length() > 3 -> "long string: '" + s + "'";
                case String s             -> "short string: '" + s + "'";
                case Double dbl           -> String.format("double: %.2f", dbl);
                case Boolean bool         -> "boolean: " + bool;
                case null                 -> "null!";
                default                   -> "other: " + item.getClass().getSimpleName();
            };
            System.out.println("  " + desc);
        }

        // ─── SEALED TYPES + EXHAUSTIVE switch ─────────────
        System.out.println("\n=== Sealed types — exhaustive switch ===");
        List<Shape> shapes = List.of(
            new Circle(5), new Rect(3, 4), new Tri(6, 8));

        for (Shape shape : shapes) {
            double area = switch (shape) {
                case Circle c -> Math.PI * c.radius() * c.radius();
                case Rect r   -> r.w() * r.h();
                case Tri t    -> 0.5 * t.base() * t.height();
            };   // no default needed — sealed, exhaustive
            System.out.printf("  %s → area = %.2f%n",
                shape.getClass().getSimpleName(), area);
        }

        // ─── GENERIC UNCHECKED CASTS ──────────────────────
        System.out.println("\n=== Unchecked Generic Cast ===");
        Object raw = new ArrayList<>(List.of("a", "b", "c"));

        @SuppressWarnings("unchecked")
        List<String> typed = (List<String>) raw;  // ⚠️ unchecked but safe here
        System.out.println("  Unchecked cast result: " + typed);

        // ─── TYPE HIERARCHY DEMO ──────────────────────────
        System.out.println("\n=== Type Hierarchy ===");
        Dog dog2 = new Dog("Buddy");
        System.out.println("  Dog instanceof Dog:    " + (dog2 instanceof Dog));
        System.out.println("  Dog instanceof Animal: " + (dog2 instanceof Animal));
        System.out.println("  Dog instanceof Object: " + (dog2 instanceof Object));
        System.out.println("  null instanceof Dog:   " + (null instanceof Dog));
        System.out.println("  Dog.class.getSuperclass(): " + Dog.class.getSuperclass().getSimpleName());
    }
}

📝 KEY POINTS:
✅ Widening conversions are automatic and safe (small → large type)
✅ Narrowing conversions require explicit cast and may lose data
✅ (int) 3.9 truncates toward zero — gives 3, not 4
✅ byte/short/char arithmetic promotes to int automatically
✅ Upcasting (Dog → Animal) is always automatic and safe
✅ Downcasting (Animal → Dog) requires explicit cast and can fail at runtime
✅ instanceof check before cast prevents ClassCastException
✅ Pattern matching instanceof (Java 16): if (obj instanceof String s) — test + bind
✅ Pattern matching switch (Java 21): exhaustive type dispatch with guards
✅ null instanceof T always returns false (no NPE)
❌ (int) on a double TRUNCATES — not rounds (3.9 → 3, not 4)
❌ (byte) 300 wraps around — result is 44, not an exception
❌ Downcasting without instanceof check risks ClassCastException
❌ int → float can lose precision for large integers (not just doubles)
""",
  quiz: [
    Quiz(question: 'What does (int) 3.9 produce in Java?', options: [
      QuizOption(text: '3 — casting truncates the decimal part toward zero, never rounds', correct: true),
      QuizOption(text: '4 — Java rounds to the nearest integer when casting', correct: false),
      QuizOption(text: 'A compile error — double cannot be cast to int directly', correct: false),
      QuizOption(text: 'It depends on the current rounding mode setting', correct: false),
    ]),
    Quiz(question: 'What happens when you add a byte and a short in Java?', options: [
      QuizOption(text: 'The result is automatically promoted to int — you need (byte) or (short) cast to store it back', correct: true),
      QuizOption(text: 'The result is a short because it is the wider of the two types', correct: false),
      QuizOption(text: 'The result is a byte if there is no overflow', correct: false),
      QuizOption(text: 'Java throws a compile error because byte and short cannot be mixed', correct: false),
    ]),
    Quiz(question: 'What does if (animal instanceof Dog d) do in Java 16+?', options: [
      QuizOption(text: 'Tests if animal is a Dog AND binds it to the variable d — eliminating the need for a separate cast', correct: true),
      QuizOption(text: 'Declares a new Dog named d and assigns animal to it, throwing if incompatible', correct: false),
      QuizOption(text: 'Checks if animal is a subclass of Dog specifically (not Dog itself)', correct: false),
      QuizOption(text: 'It is just syntactic sugar with no behavior difference from instanceof without binding', correct: false),
    ]),
  ],
);
