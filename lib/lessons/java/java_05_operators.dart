import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson05 = Lesson(
  language: 'Java',
  title: 'Operators',
  content: """
🎯 METAPHOR:
Operators are the grammar of mathematics and logic written
in code. Just like English has verbs that act on nouns
("she RUNS," "he EATS"), operators act on values:
5 PLUS 3, x GREATER THAN y, flag AND isReady.
Java operators come in families — arithmetic, assignment,
comparison, logical, bitwise — each with its own rules
about who goes first (precedence) and what types they work
on. Master the operators and you can express any
calculation, any condition, any decision your program needs.

📖 EXPLANATION:

─────────────────────────────────────
ARITHMETIC OPERATORS:
─────────────────────────────────────
  +   addition          5 + 3 = 8
  -   subtraction       10 - 4 = 6
  *   multiplication    3 * 4 = 12
  /   division          17 / 5 = 3   (integer: truncates!)
  %   modulo (remain)   17 % 5 = 2
  ++  increment         x++  or  ++x
  --  decrement         x--  or  --x

  ⚠️ Integer division truncates: 7 / 2 = 3, not 3.5
     Cast to double: (double)7 / 2 = 3.5

─────────────────────────────────────
PREFIX vs POSTFIX increment:
─────────────────────────────────────
  int x = 5;
  int a = x++;   // a = 5, THEN x becomes 6   (post: use THEN increment)
  int b = ++x;   // x becomes 7, THEN b = 7   (pre: increment THEN use)

  In a standalone statement: x++ and ++x are identical.
  The difference only matters when used IN an expression.

─────────────────────────────────────
ASSIGNMENT OPERATORS:
─────────────────────────────────────
  =    assign            x = 5
  +=   add & assign      x += 3   → x = x + 3
  -=   sub & assign      x -= 2   → x = x - 2
  *=   mul & assign      x *= 4   → x = x * 4
  /=   div & assign      x /= 2   → x = x / 2
  %=   mod & assign      x %= 3   → x = x % 3

─────────────────────────────────────
COMPARISON OPERATORS (return boolean):
─────────────────────────────────────
  ==   equal to          5 == 5   → true
  !=   not equal         5 != 3   → true
  >    greater than      7 > 4    → true
  <    less than         3 < 9    → true
  >=   greater or equal  5 >= 5   → true
  <=   less or equal     4 <= 6   → true

  ⚠️ == on Objects checks REFERENCE, not content.
     Use .equals() for object content comparison.

─────────────────────────────────────
LOGICAL OPERATORS:
─────────────────────────────────────
  &&   AND   both must be true     true && true  → true
  ||   OR    at least one true     false || true → true
  !    NOT   flips true/false      !true → false

  SHORT-CIRCUIT EVALUATION:
  && stops at first false — right side never evaluated
  || stops at first true  — right side never evaluated

  // Safe null check using short-circuit:
  if (obj != null && obj.isValid()) { ... }
  // If obj is null, obj.isValid() is NEVER called ✅

─────────────────────────────────────
BITWISE OPERATORS:
─────────────────────────────────────
  &    bitwise AND        1010 & 1100 = 1000
  |    bitwise OR         1010 | 1100 = 1110
  ^    bitwise XOR        1010 ^ 1100 = 0110
  ~    bitwise NOT        ~1010 = ...0101
  <<   left shift         5 << 1 = 10  (multiply by 2)
  >>   right shift        20 >> 2 = 5  (divide by 4)
  >>>  unsigned right     (fills with 0 instead of sign bit)

─────────────────────────────────────
TERNARY OPERATOR:
─────────────────────────────────────
  condition ? valueIfTrue : valueIfFalse

  int max = (a > b) ? a : b;
  String status = (score >= 60) ? "Pass" : "Fail";

  Reads as: "if condition then first, else second."
  Like a compact if/else that RETURNS a value.

─────────────────────────────────────
INSTANCEOF OPERATOR:
─────────────────────────────────────
  if (obj instanceof String) {
      String s = (String) obj;   // safe cast
  }

  // Pattern matching instanceof (Java 16+):
  if (obj instanceof String s) {
      System.out.println(s.length()); // s is already cast!
  }

─────────────────────────────────────
OPERATOR PRECEDENCE (high → low):
─────────────────────────────────────
  1. ()  []  .               (grouping, indexing, member)
  2. ++  --  !  ~  (cast)    (unary)
  3. *   /   %               (multiplicative)
  4. +   -                   (additive)
  5. <<  >>  >>>             (shift)
  6. <   >   <=  >=          (relational)
  7. ==  !=                  (equality)
  8. &                       (bitwise AND)
  9. ^                       (bitwise XOR)
  10. |                      (bitwise OR)
  11. &&                     (logical AND)
  12. ||                     (logical OR)
  13. ?:                     (ternary)
  14. =  +=  -=  etc         (assignment)

  When in doubt: use parentheses! (2 + 3) * 4 is always clear.

💻 CODE:
public class Operators {
    public static void main(String[] args) {

        // ─── ARITHMETIC ──────────────────────────────────
        System.out.println("=== Arithmetic ===");
        int a = 17, b = 5;
        System.out.println(a + " + " + b + " = " + (a + b));   // 22
        System.out.println(a + " - " + b + " = " + (a - b));   // 12
        System.out.println(a + " * " + b + " = " + (a * b));   // 85
        System.out.println(a + " / " + b + " = " + (a / b));   // 3 ⚠️
        System.out.println(a + " % " + b + " = " + (a % b));   // 2
        System.out.println("(double)" + a + "/" + b + " = " + ((double)a / b)); // 3.4

        // ─── PREFIX vs POSTFIX ────────────────────────────
        System.out.println("\n=== Increment/Decrement ===");
        int x = 10;
        System.out.println("x    = " + x);
        System.out.println("x++  = " + x++); // prints 10, then x=11
        System.out.println("x    = " + x);   // 11
        System.out.println("++x  = " + ++x); // x=12, prints 12
        System.out.println("x    = " + x);   // 12

        // ─── COMPOUND ASSIGNMENT ──────────────────────────
        System.out.println("\n=== Compound Assignment ===");
        int score = 100;
        score += 50;  System.out.println("After +=50 : " + score); // 150
        score -= 20;  System.out.println("After -=20 : " + score); // 130
        score *= 2;   System.out.println("After *=2  : " + score); // 260
        score /= 4;   System.out.println("After /=4  : " + score); // 65
        score %= 10;  System.out.println("After %=10 : " + score); // 5

        // ─── COMPARISON ──────────────────────────────────
        System.out.println("\n=== Comparison ===");
        System.out.println("10 > 5   : " + (10 > 5));
        System.out.println("10 == 10 : " + (10 == 10));
        System.out.println("10 != 5  : " + (10 != 5));
        System.out.println("3 >= 3   : " + (3 >= 3));
        System.out.println("4 <= 6   : " + (4 <= 6));

        // ─── LOGICAL ─────────────────────────────────────
        System.out.println("\n=== Logical ===");
        boolean hot = true, sunny = true, rainy = false;
        System.out.println("hot && sunny  : " + (hot && sunny));   // true
        System.out.println("hot && rainy  : " + (hot && rainy));   // false
        System.out.println("hot || rainy  : " + (hot || rainy));   // true
        System.out.println("!hot          : " + (!hot));            // false
        System.out.println("!rainy        : " + (!rainy));          // true

        // Short-circuit safety
        String str = null;
        boolean safe = (str != null && str.length() > 0);
        System.out.println("null-safe check: " + safe);  // false, no NPE

        // ─── TERNARY ─────────────────────────────────────
        System.out.println("\n=== Ternary ===");
        int[] testScores = {45, 72, 88, 55, 91};
        for (int s : testScores) {
            String grade = s >= 90 ? "A" :
                           s >= 80 ? "B" :
                           s >= 70 ? "C" :
                           s >= 60 ? "D" : "F";
            System.out.printf("  Score %3d → %s%n", s, grade);
        }

        // ─── BITWISE ─────────────────────────────────────
        System.out.println("\n=== Bitwise ===");
        int p = 0b1010;   // 10
        int q = 0b1100;   // 12
        System.out.printf("p   = %4s (%d)%n", Integer.toBinaryString(p), p);
        System.out.printf("q   = %4s (%d)%n", Integer.toBinaryString(q), q);
        System.out.printf("p&q = %4s (%d)%n", Integer.toBinaryString(p & q), p & q);
        System.out.printf("p|q = %4s (%d)%n", Integer.toBinaryString(p | q), p | q);
        System.out.printf("p^q = %4s (%d)%n", Integer.toBinaryString(p ^ q), p ^ q);
        System.out.printf("p<<1= %4s (%d)  [*2]%n", Integer.toBinaryString(p << 1), p << 1);
        System.out.printf("p>>1= %4s (%d)  [/2]%n", Integer.toBinaryString(p >> 1), p >> 1);

        // ─── FLAGS PATTERN ───────────────────────────────
        System.out.println("\n=== Bitwise Flags ===");
        final int READ    = 0b001;  // 1
        final int WRITE   = 0b010;  // 2
        final int EXECUTE = 0b100;  // 4

        int perms = READ | WRITE;   // 3 = rw-
        System.out.println("Can read : " + ((perms & READ) != 0));
        System.out.println("Can write: " + ((perms & WRITE) != 0));
        System.out.println("Can exec : " + ((perms & EXECUTE) != 0));

        // ─── instanceof ──────────────────────────────────
        System.out.println("\n=== instanceof ===");
        Object[] items = {"hello", 42, 3.14, true, "world"};
        for (Object item : items) {
            if (item instanceof String s) {         // pattern matching
                System.out.println("String: " + s.toUpperCase());
            } else if (item instanceof Integer i) {
                System.out.println("Integer: " + (i * 2));
            } else {
                System.out.println("Other: " + item);
            }
        }
    }
}

📝 KEY POINTS:
✅ Integer division truncates — 17 / 5 = 3, not 3.4
✅ Cast to double for decimal division: (double)a / b
✅ && and || short-circuit — right side not evaluated if result is known
✅ Use && null checks safely: obj != null && obj.method()
✅ Ternary ? : returns a value — compact if/else for expressions
✅ Prefix ++x increments first; postfix x++ uses value first
✅ instanceof with pattern matching (Java 16+) casts automatically
✅ Bitwise & | ^ ~ << >> >>> work on individual bits
❌ == on objects checks reference equality — use .equals() for content
❌ Don't confuse & (bitwise AND) with && (logical AND)
❌ Don't confuse | (bitwise OR) with || (logical OR)
❌ Chained ternary is readable up to 2-3 levels — beyond that use if/else
""",
  quiz: [
    Quiz(question: 'What is the result of 17 / 5 in Java when both are int?', options: [
      QuizOption(text: '3 — integer division truncates toward zero', correct: true),
      QuizOption(text: '3.4 — Java automatically promotes to double', correct: false),
      QuizOption(text: '4 — Java rounds up to the nearest integer', correct: false),
      QuizOption(text: 'A compilation error — mixed division is not allowed', correct: false),
    ]),
    Quiz(question: 'What does the && operator do when the left side is false?', options: [
      QuizOption(text: 'Short-circuits — the right side is never evaluated', correct: true),
      QuizOption(text: 'Evaluates both sides and combines the results', correct: false),
      QuizOption(text: 'Throws a short-circuit exception', correct: false),
      QuizOption(text: 'Evaluates the right side and ignores the left', correct: false),
    ]),
    Quiz(question: 'What does the expression x++ return when x is 10?', options: [
      QuizOption(text: '10 — it returns the original value, then increments x', correct: true),
      QuizOption(text: '11 — it increments first and returns the new value', correct: false),
      QuizOption(text: 'It depends on whether x is int or Integer', correct: false),
      QuizOption(text: 'A compilation error — ++ cannot be used in expressions', correct: false),
    ]),
  ],
);
