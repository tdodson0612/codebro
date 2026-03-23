import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson51 = Lesson(
  language: 'Java',
  title: 'Autoboxing, Unboxing, and Wrapper Classes',
  content: """
🎯 METAPHOR:
Autoboxing is like an automatic gift-wrapping machine
at a store. You hand over a raw item — a plain integer
like 42 — and the machine wraps it in a box labeled
"Integer" so it can be shipped through the collections
system (which only accepts boxed packages). Unboxing
is the reverse: the recipient tears off the box to get
the raw number back for actual arithmetic.
The wrapping/unwrapping happens automatically — hence
"auto" boxing. But it has a cost: each wrap creates a
new object on the heap. Wrapping millions of integers
in a tight loop is like gift-wrapping a million screws
one at a time. You can do it, but you'll regret it.

📖 EXPLANATION:
Java has 8 primitive types and 8 corresponding wrapper
classes that let primitives behave as objects.

─────────────────────────────────────
PRIMITIVE → WRAPPER CLASS:
─────────────────────────────────────
  byte    → Byte
  short   → Short
  int     → Integer
  long    → Long
  float   → Float
  double  → Double
  char    → Character
  boolean → Boolean

─────────────────────────────────────
AUTOBOXING — automatic primitive → wrapper:
─────────────────────────────────────
  // Java does this automatically:
  Integer boxed = 42;          // equivalent to Integer.valueOf(42)
  Double dbl    = 3.14;        // equivalent to Double.valueOf(3.14)
  Boolean flag  = true;        // equivalent to Boolean.valueOf(true)

  // Needed for collections (can't use primitives):
  List<Integer> nums = new ArrayList<>();
  nums.add(1);      // autoboxed to Integer
  nums.add(2);
  nums.add(3);

─────────────────────────────────────
UNBOXING — automatic wrapper → primitive:
─────────────────────────────────────
  Integer x = 10;
  int y = x;          // unboxed automatically
  int z = x + 5;      // x unboxed for arithmetic

  // DANGER: NullPointerException from unboxing null!
  Integer n = null;
  int value = n;      // ❌ NullPointerException!

  // Always null-check before unboxing:
  int value = (n != null) ? n : 0;

─────────────────────────────────────
INTEGER CACHE — surprising behavior:
─────────────────────────────────────
  Java caches Integer objects for values -128 to 127.
  Within this range, the SAME object is returned.

  Integer a = 100;
  Integer b = 100;
  System.out.println(a == b);    // true  (same cached object)

  Integer c = 200;
  Integer d = 200;
  System.out.println(c == d);    // false (different objects!)
  System.out.println(c.equals(d)); // true  (value comparison)

  → ALWAYS use .equals() to compare wrapper values!
  → NEVER use == on Integer, Double, Boolean, etc.

─────────────────────────────────────
WRAPPER CLASS UTILITY METHODS:
─────────────────────────────────────
  Integer:
  Integer.parseInt("42")          → int 42
  Integer.valueOf("42")           → Integer 42
  Integer.toString(42)            → "42"
  Integer.toBinaryString(42)      → "101010"
  Integer.toHexString(42)         → "2a"
  Integer.toOctalString(42)       → "52"
  Integer.MAX_VALUE               → 2147483647
  Integer.MIN_VALUE               → -2147483648
  Integer.BYTES                   → 4
  Integer.SIZE                    → 32
  Integer.bitCount(42)            → 3 (number of 1-bits)
  Integer.reverse(42)             → reverse bit pattern
  Integer.highestOneBit(42)       → 32 (highest power of 2)
  Integer.numberOfLeadingZeros(42)→ 26
  Integer.compare(a, b)           → safe comparison
  Integer.sum(a, b)               → a + b (for method refs)
  Integer.max(a, b)               → maximum
  Integer.min(a, b)               → minimum

  Double:
  Double.parseDouble("3.14")      → double
  Double.isNaN(x)                 → true if x is NaN
  Double.isInfinite(x)            → true if ±∞
  Double.isFinite(x)              → true if not NaN or ∞
  Double.MAX_VALUE, MIN_VALUE
  Double.POSITIVE_INFINITY
  Double.NaN

  Character:
  Character.isDigit('5')          → true
  Character.isLetter('A')         → true
  Character.isLetterOrDigit('3')  → true
  Character.isUpperCase('A')      → true
  Character.isLowerCase('a')      → true
  Character.isWhitespace(' ')     → true
  Character.toUpperCase('a')      → 'A'
  Character.toLowerCase('A')      → 'a'
  Character.getNumericValue('9')  → 9
  Character.isAlphabetic('a')     → true

  Boolean:
  Boolean.parseBoolean("true")    → true
  Boolean.parseBoolean("yes")     → false (only "true" counts)
  Boolean.toString(true)          → "true"
  Boolean.compare(true, false)    → 1

─────────────────────────────────────
PERFORMANCE CONSIDERATIONS:
─────────────────────────────────────
  // ❌ Slow — creates Integer objects on each iteration:
  Long sum = 0L;
  for (long i = 0; i < 10_000_000; i++) {
      sum += i;    // unbox sum, add i, rebox result
  }

  // ✅ Fast — all primitives, no boxing:
  long sum = 0L;
  for (long i = 0; i < 10_000_000; i++) {
      sum += i;
  }

  Use IntStream/LongStream for numeric operations:
  long sum = LongStream.range(0, 10_000_000).sum(); // no boxing

─────────────────────────────────────
WHEN AUTOBOXING IS CONVENIENT:
─────────────────────────────────────
  ✅ Putting primitives into collections
  ✅ Using primitives as generic type params
  ✅ Assigning to wrapper type variables
  ✅ Method parameters that expect Object

  ❌ Tight arithmetic loops (use primitives)
  ❌ Large numeric arrays (use int[], double[])
  ❌ Stream pipelines on numbers (use IntStream)

💻 CODE:
import java.util.*;
import java.util.stream.*;
import java.util.function.*;

public class AutoboxingWrappers {
    public static void main(String[] args) {

        // ─── AUTOBOXING AND UNBOXING ──────────────────────
        System.out.println("=== Autoboxing and Unboxing ===");

        // Autoboxing — implicit
        Integer a = 42;          // Integer.valueOf(42)
        Double  d = 3.14;        // Double.valueOf(3.14)
        Boolean b = true;        // Boolean.valueOf(true)
        Character c = 'J';       // Character.valueOf('J')

        System.out.println("  Integer:   " + a);
        System.out.println("  Double:    " + d);
        System.out.println("  Boolean:   " + b);
        System.out.println("  Character: " + c);

        // Unboxing — implicit
        int    rawInt  = a;         // intValue()
        double rawDbl  = d;         // doubleValue()
        boolean rawBool= b;         // booleanValue()
        char   rawChar = c;         // charValue()

        System.out.println("  Unboxed: " + rawInt + " " + rawDbl + " " + rawBool + " " + rawChar);

        // Arithmetic triggers unboxing
        Integer x = 10, y = 20;
        Integer sum = x + y;      // unbox both, add, rebox result
        System.out.println("  10 + 20 = " + sum);

        // ─── INTEGER CACHE TRAP ───────────────────────────
        System.out.println("\n=== Integer Cache (-128 to 127) ===");

        Integer p = 100, q = 100;
        Integer r = 200, s = 200;

        System.out.println("  100 == 100 (cached):      " + (p == q));   // true
        System.out.println("  200 == 200 (not cached):  " + (r == s));   // false!
        System.out.println("  100.equals(100):           " + p.equals(q)); // true
        System.out.println("  200.equals(200):           " + r.equals(s)); // true ✅

        // Safe comparison
        System.out.println("  Integer.compare(200,200):  " + Integer.compare(200, 200));

        // Boolean cache: always cached (only 2 values)
        Boolean bt1 = true, bt2 = true;
        System.out.println("  true == true (cached):    " + (bt1 == bt2)); // always true

        // ─── NULL UNBOXING DANGER ─────────────────────────
        System.out.println("\n=== Null Unboxing Danger ===");
        Integer nullable = null;

        // Safe check before unboxing:
        int safe = (nullable != null) ? nullable : 0;
        System.out.println("  Safe unbox null: " + safe);

        // getOrDefault from map — prevents NPE
        Map<String, Integer> scores = new HashMap<>();
        scores.put("Alice", 95);
        int aliceScore = scores.getOrDefault("Alice", 0);
        int bobScore   = scores.getOrDefault("Bob",   0);   // null → 0
        System.out.println("  Alice: " + aliceScore + ", Bob: " + bobScore);

        // ─── INTEGER UTILITY METHODS ──────────────────────
        System.out.println("\n=== Integer Utility Methods ===");
        System.out.println("  parseInt(\"42\"):      " + Integer.parseInt("42"));
        System.out.println("  parseInt(\"FF\",16):  " + Integer.parseInt("FF", 16));
        System.out.println("  toBinaryString(42): " + Integer.toBinaryString(42));
        System.out.println("  toHexString(255):   " + Integer.toHexString(255));
        System.out.println("  toOctalString(8):   " + Integer.toOctalString(8));
        System.out.println("  bitCount(255):       " + Integer.bitCount(255));
        System.out.println("  highestOneBit(100): " + Integer.highestOneBit(100));
        System.out.println("  reverse(1):          " + Integer.toBinaryString(Integer.reverse(1)));
        System.out.println("  MAX_VALUE:           " + Integer.MAX_VALUE);
        System.out.println("  MIN_VALUE:           " + Integer.MIN_VALUE);
        System.out.println("  SIZE (bits):         " + Integer.SIZE);
        System.out.println("  BYTES:               " + Integer.BYTES);

        // Using wrappers as method references in streams
        System.out.println("\n  Integer method refs in streams:");
        List<String> numStrings = List.of("3", "1", "4", "1", "5", "9", "2", "6");
        List<Integer> parsed = numStrings.stream()
            .map(Integer::parseInt)           // method reference
            .sorted()
            .collect(Collectors.toList());
        System.out.println("  Parsed & sorted: " + parsed);
        System.out.println("  Sum:   " + parsed.stream().reduce(0, Integer::sum));
        System.out.println("  Max:   " + parsed.stream().reduce(Integer::max));

        // ─── DOUBLE UTILITY METHODS ───────────────────────
        System.out.println("\n=== Double Utility Methods ===");
        System.out.println("  parseDouble(\"3.14\"): " + Double.parseDouble("3.14"));
        System.out.println("  isNaN(0.0/0.0):       " + Double.isNaN(0.0/0.0));
        System.out.println("  isInfinite(1.0/0.0):  " + Double.isInfinite(1.0/0.0));
        System.out.println("  isFinite(3.14):        " + Double.isFinite(3.14));
        System.out.println("  MAX_VALUE:             " + Double.MAX_VALUE);
        System.out.println("  MIN_VALUE:             " + Double.MIN_VALUE);
        System.out.println("  NaN:                   " + Double.NaN);
        System.out.println("  POSITIVE_INFINITY:     " + Double.POSITIVE_INFINITY);

        // ─── CHARACTER UTILITY METHODS ────────────────────
        System.out.println("\n=== Character Utility Methods ===");
        char[] testChars = {'A', 'a', '5', ' ', '!', '©'};
        for (char ch : testChars) {
            System.out.printf("  '%s' → letter=%-5s digit=%-5s upper=%-5s lower=%-5s ws=%s%n",
                ch,
                Character.isLetter(ch),
                Character.isDigit(ch),
                Character.isUpperCase(ch),
                Character.isLowerCase(ch),
                Character.isWhitespace(ch));
        }

        System.out.println();
        System.out.println("  toUpperCase('a'): " + Character.toUpperCase('a'));
        System.out.println("  toLowerCase('Z'): " + Character.toLowerCase('Z'));
        System.out.println("  getNumericValue('7'): " + Character.getNumericValue('7'));
        System.out.println("  getNumericValue('F'): " + Character.getNumericValue('F'));  // 15

        // ─── PERFORMANCE COMPARISON ───────────────────────
        System.out.println("\n=== Performance: Boxing vs Primitive ===");
        final int N = 10_000_000;

        // Slow — boxing
        long t1 = System.nanoTime();
        Long boxedSum = 0L;
        for (long i = 0; i < N; i++) boxedSum += i;
        long boxedTime = System.nanoTime() - t1;

        // Fast — primitive
        long t2 = System.nanoTime();
        long primitiveSum = 0L;
        for (long i = 0; i < N; i++) primitiveSum += i;
        long primitiveTime = System.nanoTime() - t2;

        // Fastest — stream
        long t3 = System.nanoTime();
        long streamSum = LongStream.range(0, N).sum();
        long streamTime = System.nanoTime() - t3;

        System.out.printf("  Boxed Long sum:    %,d  (%,.0f ms)%n", boxedSum, boxedTime/1e6);
        System.out.printf("  Primitive long:    %,d  (%,.0f ms)%n", primitiveSum, primitiveTime/1e6);
        System.out.printf("  LongStream.sum():  %,d  (%,.0f ms)%n", streamSum, streamTime/1e6);

        // ─── WRAPPER IN COLLECTIONS ───────────────────────
        System.out.println("\n=== Wrappers in Collections ===");
        // Must use Integer, not int, as type parameter
        List<Integer> list = new ArrayList<>(List.of(5, 3, 8, 1, 9, 2, 7));
        Collections.sort(list);
        System.out.println("  Sorted: " + list);

        Map<Character, Integer> charCount = new LinkedHashMap<>();
        "hello world".chars()
            .filter(ch -> ch != ' ')
            .mapToObj(ch -> (char)ch)
            .forEach(ch -> charCount.merge(ch, 1, Integer::sum));
        System.out.println("  Char counts: " + charCount);
    }
}

📝 KEY POINTS:
✅ Each primitive has a wrapper: int→Integer, double→Double, boolean→Boolean etc.
✅ Autoboxing: primitives auto-convert to wrappers when needed (collections, generics)
✅ Unboxing: wrappers auto-convert to primitives for arithmetic
✅ Integer cache covers -128 to 127 — cached objects reused for those values
✅ ALWAYS use .equals() to compare wrappers — never == (except boolean)
✅ Unboxing null throws NullPointerException — always null-check first
✅ Character class has rich utility methods for char classification/conversion
✅ Use IntStream/LongStream for numeric operations — avoids boxing overhead
✅ Integer.parseInt() returns int; Integer.valueOf() returns Integer
❌ Never use == to compare Integer objects outside -128..127 range
❌ Don't use Long/Integer in tight loops — boxing/unboxing is expensive
❌ Boolean.parseBoolean() only returns true for the exact string "true" (case-insensitive)
❌ Avoid mixing boxed and primitive types in expressions — causes silent unboxing
""",
  quiz: [
    Quiz(question: 'Why does Integer a = 200; Integer b = 200; a == b return false?', options: [
      QuizOption(text: 'Java only caches Integer objects from -128 to 127 — values outside this range create new objects', correct: true),
      QuizOption(text: 'Integer comparison with == is always false regardless of value', correct: false),
      QuizOption(text: 'The boxing cache is disabled for values above 100', correct: false),
      QuizOption(text: 'Each assignment calls new Integer() which always creates a distinct object', correct: false),
    ]),
    Quiz(question: 'What exception is thrown when you unbox a null wrapper reference?', options: [
      QuizOption(text: 'NullPointerException — the JVM cannot convert null to a primitive value', correct: true),
      QuizOption(text: 'AutoUnboxingException — a specific exception for null unboxing', correct: false),
      QuizOption(text: 'IllegalStateException — null is an illegal state for a numeric wrapper', correct: false),
      QuizOption(text: 'No exception — null unboxes to the default value (0 or false)', correct: false),
    ]),
    Quiz(question: 'What is the difference between Integer.parseInt("42") and Integer.valueOf("42")?', options: [
      QuizOption(text: 'parseInt returns a primitive int; valueOf returns an Integer object (potentially cached)', correct: true),
      QuizOption(text: 'parseInt is faster; valueOf validates the input format first', correct: false),
      QuizOption(text: 'They are completely identical — valueOf just calls parseInt internally', correct: false),
      QuizOption(text: 'parseInt can parse hex; valueOf only parses decimal', correct: false),
    ]),
  ],
);
