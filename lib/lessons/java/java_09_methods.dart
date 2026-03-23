import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson09 = Lesson(
  language: 'Java',
  title: 'Methods',
  content: """
🎯 METAPHOR:
A method is like a named recipe in a cookbook. You write
the recipe once — "Make Pasta: boil water, add pasta,
cook 8 minutes, drain." Then any time anyone wants pasta,
they just say "Make Pasta" instead of writing all the
steps again. Methods are the same: write the logic once,
name it, call it from anywhere. Good methods are like
good tools — they do ONE THING well, they have a clear
name that tells you what they do, and they don't leave
a mess behind (no unexpected side effects).

📖 EXPLANATION:

─────────────────────────────────────
METHOD ANATOMY:
─────────────────────────────────────
  accessModifier returnType methodName(parameters) {
      // body
      return value;   // if returnType is not void
  }

  public static int add(int a, int b) {
      return a + b;
  }

  Parts:
    public      → visibility (who can call this)
    static      → belongs to class (not an instance)
    int         → return type (what type is returned)
    add         → method name (verb, camelCase)
    int a, b    → parameters (inputs)

─────────────────────────────────────
RETURN TYPES:
─────────────────────────────────────
  void          → returns nothing
  int, double   → returns a primitive
  String, List  → returns an object
  int[]         → returns an array

  A void method can have early return (no value):
  void process(String s) {
      if (s == null) return;   // early exit
      // ... rest of logic
  }

─────────────────────────────────────
PARAMETER PASSING:
─────────────────────────────────────
  Java is PASS-BY-VALUE — always.

  For PRIMITIVES: a copy of the value is passed.
  Changes inside the method don't affect the original.

  For OBJECTS: a copy of the REFERENCE is passed.
  The method can mutate the object's STATE (fields),
  but cannot reassign the original variable.

  void addOne(int n) { n++; }     // original unchanged
  void clear(List<Integer> list)  // list is cleared in caller too!
      { list.clear(); }

─────────────────────────────────────
METHOD OVERLOADING:
─────────────────────────────────────
  Same method name, different parameters.
  Java picks the correct one at compile time.

  int add(int a, int b) { return a + b; }
  double add(double a, double b) { return a + b; }
  int add(int a, int b, int c) { return a + b + c; }
  String add(String a, String b) { return a + b; }

  // All valid — same name, different signatures:
  add(3, 4)          → int version
  add(3.0, 4.0)      → double version
  add(1, 2, 3)       → three-param version
  add("Hi", "!")     → String version

─────────────────────────────────────
RECURSION:
─────────────────────────────────────
  A method that calls itself. Needs a BASE CASE to stop.

  int factorial(int n) {
      if (n <= 1) return 1;         // base case
      return n * factorial(n - 1); // recursive case
  }

─────────────────────────────────────
STATIC vs INSTANCE METHODS:
─────────────────────────────────────
  static method   → called on the CLASS: Math.abs(-5)
                    no 'this' reference inside
                    can't access instance fields

  instance method → called on an OBJECT: str.length()
                    has 'this' reference
                    can access instance fields

─────────────────────────────────────
METHOD NAMING CONVENTIONS:
─────────────────────────────────────
  ✅ camelCase, starts with verb
  ✅ calculateTotal(), getUserById(), isValid()
  ✅ getName(), setName()  (getters/setters)
  ❌ CalcTotal(), Calc_total(), doTheThing()

💻 CODE:
import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;

public class Methods {

    // ─── STATIC UTILITY METHODS ──────────────────────────
    static int add(int a, int b) { return a + b; }
    static double add(double a, double b) { return a + b; }
    static String add(String a, String b) { return a + b; }  // overloaded

    static int max(int a, int b, int c) {
        return Math.max(a, Math.max(b, c));
    }

    static boolean isPrime(int n) {
        if (n < 2) return false;
        for (int i = 2; i <= Math.sqrt(n); i++) {
            if (n % i == 0) return false;
        }
        return true;
    }

    static int[] filterPrimes(int[] nums) {
        List<Integer> primes = new ArrayList<>();
        for (int n : nums) {
            if (isPrime(n)) primes.add(n);
        }
        return primes.stream().mapToInt(Integer::intValue).toArray();
    }

    // ─── RECURSION ────────────────────────────────────────
    static long factorial(int n) {
        if (n <= 1) return 1;
        return n * factorial(n - 1);
    }

    static int fibonacci(int n) {
        if (n <= 1) return n;
        return fibonacci(n - 1) + fibonacci(n - 2);
    }

    static int binarySearch(int[] arr, int target, int lo, int hi) {
        if (lo > hi) return -1;
        int mid = (lo + hi) / 2;
        if (arr[mid] == target) return mid;
        if (arr[mid] < target) return binarySearch(arr, target, mid + 1, hi);
        return binarySearch(arr, target, lo, mid - 1);
    }

    // ─── PASS-BY-VALUE DEMOS ─────────────────────────────
    static void tryToChangeInt(int n) {
        n = 999;  // only changes local copy
    }

    static void actuallyChangeList(List<String> list) {
        list.add("added inside method!");  // modifies the object
    }

    // ─── VARARGS ──────────────────────────────────────────
    static double average(double... values) {
        if (values.length == 0) return 0;
        double sum = 0;
        for (double v : values) sum += v;
        return sum / values.length;
    }

    static String join(String separator, String... parts) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < parts.length; i++) {
            if (i > 0) sb.append(separator);
            sb.append(parts[i]);
        }
        return sb.toString();
    }

    public static void main(String[] args) {

        // ─── OVERLOADING ──────────────────────────────────
        System.out.println("=== Method Overloading ===");
        System.out.println("add(3, 4)         = " + add(3, 4));
        System.out.println("add(3.5, 4.5)     = " + add(3.5, 4.5));
        System.out.println("add(\"Hi\", \"!\")   = " + add("Hi", "!"));
        System.out.println("max(3, 7, 5)      = " + max(3, 7, 5));

        // ─── PRIME CHECK ──────────────────────────────────
        System.out.println("\n=== Prime Numbers ===");
        int[] candidates = {2, 3, 4, 10, 13, 17, 20, 29, 30, 31};
        System.out.println("Candidates: " + Arrays.toString(candidates));
        System.out.println("Primes:     " + Arrays.toString(filterPrimes(candidates)));

        // ─── RECURSION ────────────────────────────────────
        System.out.println("\n=== Recursion ===");
        for (int i = 0; i <= 10; i++) {
            System.out.printf("  %2d! = %d%n", i, factorial(i));
        }

        System.out.print("Fibonacci(0-10): ");
        for (int i = 0; i <= 10; i++) {
            System.out.print(fibonacci(i) + " ");
        }
        System.out.println();

        // Recursive binary search
        int[] sorted = {1, 3, 5, 7, 9, 11, 13, 15, 17, 19};
        System.out.println("BinSearch for 11: index " +
            binarySearch(sorted, 11, 0, sorted.length - 1));
        System.out.println("BinSearch for 6:  index " +
            binarySearch(sorted, 6, 0, sorted.length - 1));

        // ─── PASS BY VALUE ────────────────────────────────
        System.out.println("\n=== Pass-by-Value ===");
        int x = 10;
        tryToChangeInt(x);
        System.out.println("int after tryToChange: " + x);  // still 10

        List<String> names = new ArrayList<>(List.of("Alice", "Bob"));
        System.out.println("List before: " + names);
        actuallyChangeList(names);
        System.out.println("List after:  " + names);  // modified!

        // ─── VARARGS ──────────────────────────────────────
        System.out.println("\n=== Varargs ===");
        System.out.printf("average(1,2,3)     = %.2f%n", average(1, 2, 3));
        System.out.printf("average(10,20,30,40)= %.2f%n", average(10, 20, 30, 40));
        System.out.printf("average()          = %.2f%n", average());

        System.out.println(join(", ", "Java", "Python", "Kotlin"));
        System.out.println(join(" | ", "A", "B", "C", "D"));

        // ─── CHAINING METHODS ─────────────────────────────
        System.out.println("\n=== Method chaining (String) ===");
        String result = "  hello, WORLD!  "
                .strip()
                .toLowerCase()
                .replace(",", "")
                .replace("!", "");
        System.out.println("Result: '" + result + "'");
    }
}

📝 KEY POINTS:
✅ Method signature = name + parameter types (not return type)
✅ void methods return nothing; other types must use return
✅ Overloading: same name, different parameters — chosen at compile time
✅ Java is pass-by-value: primitives copy the value; objects copy the reference
✅ Recursion needs a base case to prevent infinite recursion → StackOverflowError
✅ static methods belong to the class; instance methods belong to objects
✅ Varargs (Type...) must be the last parameter
✅ Method names should be verbs in camelCase: calculateTotal(), isValid()
❌ Methods can't have the same name AND same parameters — that's a duplicate
❌ Overloading on return type alone is NOT allowed
❌ Pass-by-value doesn't mean objects are safe — their state can be modified
❌ Deep recursion without tailrec optimization → StackOverflowError in Java
""",
  quiz: [
    Quiz(question: 'What determines which overloaded method Java calls at compile time?', options: [
      QuizOption(text: 'The number and types of arguments passed to the method', correct: true),
      QuizOption(text: 'The return type of the method', correct: false),
      QuizOption(text: 'The access modifier of the method', correct: false),
      QuizOption(text: 'The order in which the overloads are declared', correct: false),
    ]),
    Quiz(question: 'When you pass an object to a method in Java and modify the object inside, what happens to the original?', options: [
      QuizOption(text: 'The original object is modified — the reference is copied but points to the same object', correct: true),
      QuizOption(text: 'A deep copy is made — the original is unaffected', correct: false),
      QuizOption(text: 'Java throws an ImmutableArgumentException', correct: false),
      QuizOption(text: 'The behavior depends on whether the class implements Cloneable', correct: false),
    ]),
    Quiz(question: 'What is a base case in a recursive method?', options: [
      QuizOption(text: 'The condition that stops the recursion — without it the method calls itself forever', correct: true),
      QuizOption(text: 'The first method in the call stack', correct: false),
      QuizOption(text: 'The default return value when no arguments are passed', correct: false),
      QuizOption(text: 'The minimum number of recursive calls required', correct: false),
    ]),
  ],
);
