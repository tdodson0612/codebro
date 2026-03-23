import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson52 = Lesson(
  language: 'Java',
  title: 'Varargs, Arrays Deep Dive, and Array Covariance',
  content: """
🎯 METAPHOR:
Varargs (variable arguments) are like a buffet serving
spoon that can scoop one item or twenty — the same spoon,
the same motion, however many you need. Before varargs,
you had to write separate methods for 1 item, 2 items,
3 items... or pass an array every time. Varargs says
"just hand me however many you have" and wraps them
into an array for you automatically.

Array covariance is the Java design quirk where a
String[] can be assigned to an Object[] — which sounds
logical but creates a runtime trap: the Object[] reference
points to a String[] container, and trying to stuff an
Integer into it throws ArrayStoreException at runtime
rather than at compile time. Generics were invented
largely to fix this kind of problem.

📖 EXPLANATION:

─────────────────────────────────────
VARARGS (variable-length arguments):
─────────────────────────────────────
  A method declared with Type... param can accept
  any number of arguments of that type — including zero.

  void printAll(String... items) {
      for (String s : items) System.out.println(s);
  }

  printAll();                       // zero args
  printAll("one");                  // one arg
  printAll("one", "two", "three"); // three args
  printAll(new String[]{"a","b"});  // explicit array

  Internally, varargs IS an array. You can treat it like
  one inside the method.

─────────────────────────────────────
VARARGS RULES:
─────────────────────────────────────
  ✅ Must be the LAST parameter
  ✅ Only ONE varargs parameter per method
  ✅ Can be overloaded with non-varargs versions
  ✅ Works with generics: <T> T last(T... items)

  // ❌ Illegal — varargs not last:
  void bad(String... items, int count) { }

  // ✅ Varargs after regular params:
  void good(String prefix, int... numbers) { }

─────────────────────────────────────
VARARGS OVERLOAD RESOLUTION:
─────────────────────────────────────
  When a non-varargs overload exists, Java prefers it:

  void process(int a, int b) { }        // overload 1
  void process(int... nums) { }          // overload 2

  process(1, 2);  // calls overload 1 (exact match wins)
  process(1, 2, 3); // calls overload 2 (varargs)

─────────────────────────────────────
@SafeVarargs — suppress heap pollution warning:
─────────────────────────────────────
  Generic varargs cause an "unchecked" warning:
  <T> void add(List<T>... lists) { }   // ⚠️ warning

  If you're sure your method is safe:
  @SafeVarargs
  final <T> void add(List<T>... lists) { }

─────────────────────────────────────
ARRAYS DEEP DIVE:
─────────────────────────────────────
  Array creation forms:
  int[] a1 = new int[5];            // zeroed: [0,0,0,0,0]
  int[] a2 = {1, 2, 3};             // literal
  int[] a3 = new int[]{1, 2, 3};    // explicit form
  int[] a4 = Arrays.copyOf(a2, 5);  // [1,2,3,0,0]

  Multi-dimensional:
  int[][] matrix = new int[3][4];          // 3×4 zeroed
  int[][] jagged = {{1},{2,3},{4,5,6}};   // rows of diff length

  Array properties:
  a.length          → int (field, not method)
  a.clone()         → shallow copy
  Arrays.toString(a)→ "[1, 2, 3]"
  Arrays.deepToString(matrix) → "[[1,2],[3,4]]"

  Sorting:
  Arrays.sort(arr)              // natural order (in-place)
  Arrays.sort(arr, comparator) // custom order (Object[] only)
  Arrays.sort(arr, from, to)   // sort a range

  Searching (MUST be sorted first!):
  Arrays.binarySearch(arr, key) // O(log n) — returns index or negative

  Copying:
  Arrays.copyOf(arr, newLen)          // extends/truncates
  Arrays.copyOfRange(arr, from, to)  // partial copy
  System.arraycopy(src, srcPos, dst, dstPos, len) // fastest

  Filling:
  Arrays.fill(arr, value)            // fill all
  Arrays.fill(arr, from, to, value)  // fill range

  Comparing:
  Arrays.equals(a, b)          // element-by-element (1D)
  Arrays.deepEquals(a, b)      // nested arrays

─────────────────────────────────────
ARRAY COVARIANCE — the tricky part:
─────────────────────────────────────
  Java arrays are COVARIANT: if B extends A, then B[] is an A[].
  This sounds useful but creates a runtime trap:

  String[] strings = {"hello", "world"};
  Object[] objects = strings;     // ✅ compiles — covariance
  objects[0] = 42;                // ❌ ArrayStoreException at RUNTIME

  The array KNOWS its element type at runtime (String[]).
  Even though the reference is Object[], storing an Integer
  throws ArrayStoreException.

  CONTRAST with generics — List<String> is NOT a List<Object>:
  List<String> strList = new ArrayList<>();
  List<Object> objList = strList;  // ❌ COMPILE ERROR — safer!

  This is why generics exist: compile-time type safety
  that arrays cannot provide.

─────────────────────────────────────
CONVERTING BETWEEN ARRAYS AND LISTS:
─────────────────────────────────────
  int[] arr = {1, 2, 3};

  // Array → List (fixed-size, backed by array):
  List<String> fixed = Arrays.asList("a", "b", "c");

  // Array → mutable List:
  List<String> mutable = new ArrayList<>(Arrays.asList("a","b","c"));

  // List → Array:
  String[] back = list.toArray(new String[0]);
  // Java 11+:
  String[] back2 = list.toArray(String[]::new);

  // Primitive array → List (must box):
  List<Integer> boxed = Arrays.stream(arr).boxed()
      .collect(Collectors.toList());

💻 CODE:
import java.util.*;
import java.util.stream.*;
import java.util.function.*;

public class VarargsArrays {
    public static void main(String[] args) {

        // ─── VARARGS BASICS ───────────────────────────────
        System.out.println("=== Varargs ===");

        System.out.println("  sum():             " + sum());
        System.out.println("  sum(5):            " + sum(5));
        System.out.println("  sum(1,2,3):        " + sum(1, 2, 3));
        System.out.println("  sum(1..5):         " + sum(1, 2, 3, 4, 5));

        System.out.println("  join(\"-\"):         " + join("-"));
        System.out.println("  join(\"-\",a,b,c):  " + join("-", "a", "b", "c"));
        System.out.println("  join(\",\",1,2,3):  " + join(",", "1", "2", "3"));

        format("Name: %s, Age: %d, Score: %.1f%%", "Alice", 30, 95.5);

        // Passing array to varargs
        int[] arr = {10, 20, 30};
        // System.out.println(sum(arr)); // ❌ wrong type — primitive array
        // Must convert: sum(Arrays.stream(arr).toArray())
        // Or use the Integer[] form:
        Integer[] boxed = {10, 20, 30};
        System.out.println("  sum(Integer[]): " + sumBoxed(boxed));

        // ─── OVERLOAD RESOLUTION ──────────────────────────
        System.out.println("\n=== Varargs Overload Resolution ===");
        System.out.println("  test(1, 2):       " + test(1, 2));   // non-varargs wins
        System.out.println("  test(1, 2, 3):    " + test(1, 2, 3)); // varargs
        System.out.println("  test(1):          " + test(1));       // varargs

        // ─── ARRAYS CREATION ──────────────────────────────
        System.out.println("\n=== Array Creation Patterns ===");

        int[] zeros    = new int[5];
        int[] literal  = {1, 2, 3, 4, 5};
        int[] explicit = new int[]{10, 20, 30};
        int[] fromOf   = IntStream.rangeClosed(1, 5).toArray();
        int[] generated= IntStream.iterate(1, n -> n * 2).limit(8).toArray();

        System.out.println("  Zeros:     " + Arrays.toString(zeros));
        System.out.println("  Literal:   " + Arrays.toString(literal));
        System.out.println("  Generated: " + Arrays.toString(generated));

        // ─── ARRAYS UTILITY METHODS ───────────────────────
        System.out.println("\n=== Arrays Utility Methods ===");
        int[] data = {5, 2, 8, 1, 9, 3, 7, 4, 6};
        System.out.println("  Original: " + Arrays.toString(data));

        int[] copy = data.clone();
        Arrays.sort(copy);
        System.out.println("  Sorted:   " + Arrays.toString(copy));

        int idx = Arrays.binarySearch(copy, 7);
        System.out.println("  Index of 7 (sorted): " + idx);

        int[] filled = new int[5];
        Arrays.fill(filled, 99);
        System.out.println("  Filled:   " + Arrays.toString(filled));

        // Partial sort
        int[] partial = {5, 2, 8, 1, 9, 3, 7};
        Arrays.sort(partial, 2, 6);  // sort indices 2..5
        System.out.println("  Partial sort [2,6): " + Arrays.toString(partial));

        // ─── SYSTEM.ARRAYCOPY ─────────────────────────────
        System.out.println("\n=== System.arraycopy (fastest) ===");
        int[] src = {1, 2, 3, 4, 5, 6, 7, 8};
        int[] dst = new int[5];
        System.arraycopy(src, 2, dst, 0, 5);  // copy 5 from index 2
        System.out.println("  src: " + Arrays.toString(src));
        System.out.println("  dst: " + Arrays.toString(dst));

        // ─── 2D ARRAY ─────────────────────────────────────
        System.out.println("\n=== 2D Arrays ===");
        int[][] matrix = {
            {1, 2, 3},
            {4, 5, 6},
            {7, 8, 9}
        };
        System.out.println("  Matrix: " + Arrays.deepToString(matrix));
        System.out.println("  [1][1] = " + matrix[1][1]);

        // Transpose
        int rows = matrix.length, cols = matrix[0].length;
        int[][] transposed = new int[cols][rows];
        for (int i = 0; i < rows; i++)
            for (int j = 0; j < cols; j++)
                transposed[j][i] = matrix[i][j];
        System.out.println("  Transposed: " + Arrays.deepToString(transposed));

        // ─── ARRAY COVARIANCE TRAP ────────────────────────
        System.out.println("\n=== Array Covariance ===");
        String[] strings = {"hello", "world"};
        Object[] objects = strings;   // ✅ compiles — String[] IS-A Object[]
        System.out.println("  Objects: " + Arrays.toString(objects));
        System.out.println("  Type:    " + objects.getClass().getComponentType());

        try {
            objects[0] = 42;   // ❌ runtime exception!
        } catch (ArrayStoreException e) {
            System.out.println("  ❌ ArrayStoreException: " + e.getMessage());
        }

        // Generics DON'T have this problem — compile-time safety:
        List<String> strList = new ArrayList<>(List.of("a","b"));
        // List<Object> objList = strList;  // ❌ compile error — safer!
        System.out.println("  Generics prevent covariance at compile time ✅");

        // ─── ARRAY ↔ LIST CONVERSIONS ─────────────────────
        System.out.println("\n=== Array ↔ List Conversions ===");
        String[] strArr = {"apple", "banana", "cherry"};

        // Array → fixed-size List
        List<String> fixed = Arrays.asList(strArr);
        System.out.println("  asList: " + fixed);

        // Array → mutable List
        List<String> mutable = new ArrayList<>(Arrays.asList(strArr));
        mutable.add("date");
        System.out.println("  mutable: " + mutable);

        // List → Array (modern)
        String[] backToArr = mutable.toArray(String[]::new);
        System.out.println("  back to array: " + Arrays.toString(backToArr));

        // Primitive array → List (boxing required)
        int[] prims = {1, 2, 3, 4, 5};
        List<Integer> boxedList = Arrays.stream(prims).boxed()
            .collect(Collectors.toList());
        System.out.println("  int[] → List<Integer>: " + boxedList);

        // List<Integer> → int[]
        int[] unboxedArr = boxedList.stream()
            .mapToInt(Integer::intValue).toArray();
        System.out.println("  List<Integer> → int[]: " + Arrays.toString(unboxedArr));
    }

    static int sum(int... nums) {
        int total = 0;
        for (int n : nums) total += n;
        return total;
    }

    static int sumBoxed(Integer... nums) {
        return Arrays.stream(nums).mapToInt(Integer::intValue).sum();
    }

    static String join(String sep, String... parts) {
        return String.join(sep, parts);
    }

    static void format(String template, Object... args) {
        System.out.println("  format: " + String.format(template, args));
    }

    static String test(int a, int b) { return "non-varargs: " + (a + b); }
    static String test(int... nums) { return "varargs: sum=" + sum(nums); }
}

📝 KEY POINTS:
✅ Varargs (Type...) is syntactic sugar for an array — treat it as one inside the method
✅ Varargs must be the last parameter; only one per method
✅ Non-varargs overload always wins over varargs when both match
✅ Arrays.sort() sorts in-place; Arrays.copyOf() creates a new array
✅ System.arraycopy() is the fastest way to copy portions of arrays
✅ Arrays.binarySearch() requires the array to be SORTED first
✅ Array covariance: String[] is an Object[], but storing wrong types throws ArrayStoreException
✅ Generics are NOT covariant — List<String> is NOT a List<Object> (safer)
✅ Arrays.asList() gives a FIXED-SIZE list — wrap in new ArrayList<>() to make mutable
✅ Convert int[] to List<Integer> via Arrays.stream(arr).boxed().collect(toList())
❌ Arrays.asList() returns a fixed-size list — add/remove throws UnsupportedOperationException
❌ Arrays.binarySearch() gives undefined results on unsorted arrays
❌ arr.length is a field, not a method — no parentheses (unlike String.length())
❌ Primitive arrays (int[]) cannot be used directly with generic methods — must box
""",
  quiz: [
    Quiz(question: 'What rule must a varargs parameter follow in a method signature?', options: [
      QuizOption(text: 'It must be the last parameter, and there can only be one per method', correct: true),
      QuizOption(text: 'It must be the first parameter to allow type inference', correct: false),
      QuizOption(text: 'It can appear anywhere but must be of type Object', correct: false),
      QuizOption(text: 'There can be up to three varargs parameters per method', correct: false),
    ]),
    Quiz(question: 'What is array covariance and why is it dangerous?', options: [
      QuizOption(text: 'String[] can be assigned to Object[], but storing the wrong type throws ArrayStoreException at runtime instead of compile time', correct: true),
      QuizOption(text: 'Arrays automatically convert element types when assigned to a parent array type', correct: false),
      QuizOption(text: 'Covariant arrays always make copies, causing unexpected performance overhead', correct: false),
      QuizOption(text: 'Array covariance causes compile errors that are difficult to diagnose', correct: false),
    ]),
    Quiz(question: 'What does Arrays.asList() return and what is its key limitation?', options: [
      QuizOption(text: 'A fixed-size List backed by the array — add() and remove() throw UnsupportedOperationException', correct: true),
      QuizOption(text: 'An immutable List that does not reflect changes to the original array', correct: false),
      QuizOption(text: 'A sorted List with the same elements as the array', correct: false),
      QuizOption(text: 'A regular mutable ArrayList containing copies of the array elements', correct: false),
    ]),
  ],
);
