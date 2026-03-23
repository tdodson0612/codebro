import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson55 = Lesson(
  language: 'Java',
  title: 'Strings Deep Dive',
  content: """
🎯 METAPHOR:
A Java String is like a framed photograph sealed behind glass.
You can look at it, measure it, describe it — but you cannot
change it. Want a different photo? You order a new one.
The original sits untouched. This immutability is what lets
Java reuse the same String object in a pool — if two people
ask for a photo of "hello," they get the same framed print
from the archive. StringBuilder is the photo editor's darkroom:
work-in-progress, modifiable, not yet framed. Only when you
call toString() do you get the finished, sealed print.
StringBuffer is the same darkroom but with a lock on the door
(thread-safe, but slower).

📖 EXPLANATION:
We covered String basics in lesson 04. This lesson goes
deep: String pool internals, all methods, char operations,
StringBuilder vs StringBuffer, and String memory.

─────────────────────────────────────
STRING POOL AND INTERNING:
─────────────────────────────────────
  String literals go to the String Pool (Metaspace):
  String a = "hello";
  String b = "hello";
  a == b   → true  (same pooled object)

  new String("hello") bypasses the pool:
  String c = new String("hello");
  a == c   → false (different object)

  intern() forces a String into the pool:
  String d = c.intern();
  a == d   → true  (d is now the pooled instance)

  In practice: use .equals(), not == or intern().

─────────────────────────────────────
COMPLETE STRING API:
─────────────────────────────────────
  INSPECTION:
  s.length()              → number of chars
  s.isEmpty()             → length == 0
  s.isBlank()             → length == 0 or all whitespace
  s.charAt(i)             → char at index i
  s.codePointAt(i)        → Unicode code point at i
  s.chars()               → IntStream of char codes
  s.codePoints()          → IntStream of code points
  s.toCharArray()         → char[]

  SEARCHING:
  s.indexOf(ch)            → first index of char (-1 if not found)
  s.indexOf(str)           → first index of substring
  s.indexOf(str, from)     → search starting at 'from'
  s.lastIndexOf(ch)        → last index of char
  s.lastIndexOf(str, from) → last index, searching backward
  s.contains(str)          → true if substring present
  s.startsWith(prefix)     → prefix match
  s.endsWith(suffix)       → suffix match
  s.startsWith(prefix,toffset) → prefix match starting at toffset
  s.matches(regex)         → full regex match
  s.regionMatches(...)     → compare regions of two strings

  TRANSFORMATION:
  s.substring(start)          → from start to end
  s.substring(start, end)     → [start, end)
  s.toLowerCase()             → lowercase
  s.toLowerCase(Locale)       → locale-specific lowercase
  s.toUpperCase()             → uppercase
  s.toUpperCase(Locale)       → locale-specific uppercase
  s.trim()                    → remove ASCII whitespace
  s.strip()                   → remove Unicode whitespace (Java 11)
  s.stripLeading()            → remove leading whitespace
  s.stripTrailing()           → remove trailing whitespace
  s.replace(old, new)         → replace all char occurrences
  s.replace(CharSeq, CharSeq) → replace all substring occurrences
  s.replaceAll(regex, repl)   → regex replace all
  s.replaceFirst(regex, repl) → regex replace first
  s.concat(str)               → append (prefer + for readability)
  s.intern()                  → return pooled instance

  SPLITTING / JOINING:
  s.split(regex)              → String[]
  s.split(regex, limit)       → String[] with limit
  String.join(sep, parts)     → join with separator
  String.join(sep, list)      → join collection

  FORMATTING:
  String.format(template, args)    → formatted String
  s.formatted(args)                → Java 15+ shorthand
  String.valueOf(x)                → any type → String

  COMPARISON:
  s.equals(other)              → value equality ✅
  s.equalsIgnoreCase(other)    → case-insensitive ✅
  s.compareTo(other)           → lexicographic order
  s.compareToIgnoreCase(other) → case-insensitive order
  s.contentEquals(CharSeq)     → compare with any CharSequence

  JAVA 11+:
  s.repeat(n)         → repeat n times
  s.lines()           → Stream<String> of lines
  s.indent(n)         → indent each line by n spaces
  s.strip()           → Unicode-aware trim

  JAVA 12+:
  s.transform(fn)     → apply a Function<String, R>

  JAVA 15+:
  s.formatted(args)   → like String.format but as instance method

─────────────────────────────────────
StringBuilder vs StringBuffer:
─────────────────────────────────────
  StringBuilder  → NOT thread-safe, FASTER — use this
  StringBuffer   → thread-safe (synchronized), SLOWER — legacy

  Both share the same API:
  sb.append(x)        → add to end
  sb.insert(i, x)     → insert at index
  sb.delete(start,end)→ delete range
  sb.deleteCharAt(i)  → delete one char
  sb.replace(s,e,str) → replace range with string
  sb.reverse()        → reverse in-place
  sb.charAt(i)        → read char
  sb.setCharAt(i, c)  → write char
  sb.indexOf(str)     → find substring
  sb.length()         → current length
  sb.capacity()       → internal buffer capacity
  sb.ensureCapacity(n)→ pre-allocate buffer
  sb.toString()       → produce final String

─────────────────────────────────────
CHAR OPERATIONS WITHIN STRINGS:
─────────────────────────────────────
  // Iterate chars:
  for (char c : s.toCharArray()) { }
  s.chars().forEach(c -> { });
  for (int i = 0; i < s.length(); i++) {
      char c = s.charAt(i);
  }

  // Count occurrences of a char:
  long count = s.chars().filter(c -> c == 'a').count();

  // Filter chars:
  String letters = s.chars()
      .filter(Character::isLetter)
      .collect(StringBuilder::new,
               StringBuilder::appendCodePoint,
               StringBuilder::append)
      .toString();

─────────────────────────────────────
STRING PERFORMANCE TIPS:
─────────────────────────────────────
  ❌ String concat in loop (O(n²)):
  String s = "";
  for (int i = 0; i < n; i++) s += "x";

  ✅ StringBuilder (O(n)):
  StringBuilder sb = new StringBuilder();
  for (int i = 0; i < n; i++) sb.append("x");
  String s = sb.toString();

  ✅ String.join() for known parts:
  String result = String.join(", ", list);

  ✅ Collectors.joining() in streams:
  String result = stream.collect(Collectors.joining(", ", "[", "]"));

💻 CODE:
import java.util.*;
import java.util.stream.*;

public class StringsDeepDive {
    public static void main(String[] args) {

        // ─── STRING POOL ──────────────────────────────────
        System.out.println("=== String Pool ===");
        String a = "hello";
        String b = "hello";
        String c = new String("hello");
        String d = c.intern();

        System.out.println("  Literal == literal:      " + (a == b));  // true
        System.out.println("  Literal == new String(): " + (a == c));  // false
        System.out.println("  Literal == intern():      " + (a == d));  // true
        System.out.println("  equals() always works:   " + a.equals(c)); // true ✅

        // ─── INSPECTION ───────────────────────────────────
        System.out.println("\n=== String Inspection ===");
        String text = "  Hello, Java World!  ";
        System.out.println("  Original:    '" + text + "'");
        System.out.println("  length():    " + text.length());
        System.out.println("  isEmpty():   " + text.isEmpty());
        System.out.println("  isBlank():   " + text.isBlank());
        System.out.println("  charAt(7):   " + text.charAt(7));
        System.out.println("  indexOf('J'):" + text.indexOf('J'));
        System.out.println("  contains('Java'):" + text.contains("Java"));
        System.out.println("  startsWith(' '): " + text.startsWith(" "));

        // ─── TRANSFORMATION ───────────────────────────────
        System.out.println("\n=== Transformation ===");
        System.out.println("  strip():         '" + text.strip() + "'");
        System.out.println("  stripLeading():  '" + text.stripLeading() + "'");
        System.out.println("  stripTrailing(): '" + text.stripTrailing() + "'");
        System.out.println("  toUpperCase():   " + text.strip().toUpperCase());
        System.out.println("  toLowerCase():   " + text.strip().toLowerCase());
        System.out.println("  replace(l,L):    " + text.strip().replace('l', 'L'));
        System.out.println("  replaceAll:      " + text.strip().replaceAll("[aeiou]", "*"));
        System.out.println("  repeat(3):       " + "ab".repeat(3));

        // ─── SPLITTING AND JOINING ────────────────────────
        System.out.println("\n=== Split and Join ===");
        String csv = "Alice,28,Engineering,London";
        String[] fields = csv.split(",");
        System.out.println("  Fields: " + Arrays.toString(fields));

        String sentence = "The   quick   brown   fox";
        String[] words = sentence.split("\\s+");
        System.out.println("  Words: " + Arrays.toString(words));

        // Split with limit
        String limited = "a:b:c:d:e";
        String[] parts = limited.split(":", 3);  // max 3 parts
        System.out.println("  Split limit 3: " + Arrays.toString(parts));

        // Join
        System.out.println("  join: " + String.join(" | ", words));
        System.out.println("  join list: " + String.join(", ",
            List.of("Java", "Kotlin", "Python")));

        // ─── CHARS AND CHAR OPERATIONS ────────────────────
        System.out.println("\n=== Char Operations ===");
        String sample = "Hello, World! 123";
        long letters = sample.chars().filter(Character::isLetter).count();
        long digits  = sample.chars().filter(Character::isDigit).count();
        long spaces  = sample.chars().filter(ch -> ch == ' ').count();
        long upper   = sample.chars().filter(Character::isUpperCase).count();

        System.out.println("  Sample: '" + sample + "'");
        System.out.printf("  Letters=%d Digits=%d Spaces=%d Upper=%d%n",
            letters, digits, spaces, upper);

        // Filter to letters only
        String lettersOnly = sample.chars()
            .filter(Character::isLetter)
            .collect(StringBuilder::new, StringBuilder::appendCodePoint, StringBuilder::append)
            .toString();
        System.out.println("  Letters only: " + lettersOnly);

        // Frequency map
        Map<Character, Long> freq = sample.chars()
            .filter(ch -> ch != ' ')
            .mapToObj(ch -> (char) ch)
            .collect(Collectors.groupingBy(ch -> ch, Collectors.counting()));
        System.out.println("  Char freq: " + new TreeMap<>(freq));

        // ─── StringBuilder ────────────────────────────────
        System.out.println("\n=== StringBuilder ===");
        StringBuilder sb = new StringBuilder("Hello");
        sb.append(", ").append("World").append("!");
        System.out.println("  After appends: " + sb);

        sb.insert(5, " Beautiful");
        System.out.println("  After insert:  " + sb);

        sb.delete(5, 15);
        System.out.println("  After delete:  " + sb);

        sb.replace(7, 12, "Java");
        System.out.println("  After replace: " + sb);

        sb.reverse();
        System.out.println("  After reverse: " + sb);

        // Efficiency demo
        System.out.println("\n=== Performance: + vs StringBuilder ===");
        int N = 10_000;

        long t1 = System.nanoTime();
        StringBuilder sbPerf = new StringBuilder();
        for (int i = 0; i < N; i++) sbPerf.append("x");
        long sbTime = System.nanoTime() - t1;

        long t2 = System.nanoTime();
        String concat = "";
        for (int i = 0; i < N; i++) concat += "x";
        long concatTime = System.nanoTime() - t2;

        System.out.printf("  StringBuilder (%d iters): %,d ns%n", N, sbTime);
        System.out.printf("  Concatenation (%d iters): %,d ns%n", N, concatTime);
        System.out.printf("  StringBuilder is ~%.0fx faster%n",
            (double)concatTime / sbTime);

        // ─── Java 11+ String methods ──────────────────────
        System.out.println("\n=== Java 11+ Methods ===");
        String multiline = "line one\nline two\nline three\nline four";
        System.out.println("  lines(): " + multiline.lines().collect(Collectors.toList()));
        System.out.println("  indent(4):");
        System.out.print("code".indent(4));

        // transform (Java 12+)
        String transformed = "  hello, world  "
            .transform(String::strip)
            .transform(String::toUpperCase)
            .transform(s -> s.replace(",", "!"));
        System.out.println("  transform chain: " + transformed);

        // formatted (Java 15+)
        String msg = "Name: %-10s Score: %3d".formatted("Alice", 95);
        System.out.println("  formatted(): " + msg);

        // ─── COMPARISON METHODS ───────────────────────────
        System.out.println("\n=== Comparison ===");
        System.out.println("  compareTo: " + "apple".compareTo("banana")); // negative
        System.out.println("  compareToIgnoreCase: " + "APPLE".compareToIgnoreCase("apple")); // 0
        System.out.println("  contentEquals: " + "hello".contentEquals(new StringBuilder("hello")));

        // regionMatches
        System.out.println("  regionMatches: " +
            "Hello World".regionMatches(true, 6, "world of java", 0, 5)); // true, ignore case
    }
}

📝 KEY POINTS:
✅ String literals are pooled — same content, same object reference
✅ new String("x") bypasses the pool — always use equals() not ==
✅ intern() returns the pooled instance — rarely needed in practice
✅ strip() is Unicode-aware; trim() only handles ASCII whitespace
✅ chars() returns IntStream — use mapToObj or collect for String operations
✅ StringBuilder is the right tool for building strings incrementally
✅ StringBuffer is thread-safe but slower — rarely needed today
✅ split(regex, limit) limits the number of parts returned
✅ String.join() and Collectors.joining() are idiomatic for joining collections
✅ transform() chains String operations cleanly (Java 12+)
❌ Never use + in a loop — O(n²) time — use StringBuilder
❌ Never use == to compare String values — use equals()
❌ StringBuffer synchronization overhead is usually not worth it — use StringBuilder
❌ split(",") keeps trailing empty strings — split(",", -1) keeps all
""",
  quiz: [
    Quiz(question: 'What does String.intern() do?', options: [
      QuizOption(text: 'Returns the canonical pooled instance of the string — if an equal string is in the pool, returns that; otherwise adds and returns this one', correct: true),
      QuizOption(text: 'Makes the string immutable and prevents further modifications', correct: false),
      QuizOption(text: 'Stores the string in a database for persistent retrieval', correct: false),
      QuizOption(text: 'Converts the string to its internal byte representation', correct: false),
    ]),
    Quiz(question: 'What is the key difference between String.trim() and String.strip()?', options: [
      QuizOption(text: 'strip() is Unicode-aware and removes all Unicode whitespace; trim() only removes ASCII characters ≤ space (\\u0020)', correct: true),
      QuizOption(text: 'trim() removes from both ends; strip() only removes from the leading side', correct: false),
      QuizOption(text: 'strip() is deprecated in Java 11 in favor of trim()', correct: false),
      QuizOption(text: 'They are identical — strip() is just an alias added for readability', correct: false),
    ]),
    Quiz(question: 'When should you use StringBuilder instead of String concatenation with +?', options: [
      QuizOption(text: 'Whenever building a string inside a loop — + creates a new String object each iteration making it O(n²)', correct: true),
      QuizOption(text: 'Only when the string exceeds 1000 characters', correct: false),
      QuizOption(text: 'StringBuilder should always be used — + is deprecated in all contexts', correct: false),
      QuizOption(text: 'Only in multithreaded code — + is not thread-safe', correct: false),
    ]),
  ],
);
