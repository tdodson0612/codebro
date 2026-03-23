import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson08 = Lesson(
  language: 'Java',
  title: 'Arrays',
  content: """
🎯 METAPHOR:
An array is like a row of numbered mailboxes in an apartment
building. Each box is the SAME SIZE (same type) and has
a NUMBER (index, starting at 0). You can jump directly
to box #7 without checking every box before it — that's
constant-time access. The mailbox row is fixed in length
when built — you can't add an 11th box to a 10-box row.
You can only change what's INSIDE a box, not add or remove
boxes. If you need a flexible container, you want
ArrayList — the stretchy bag instead of the fixed-size row.

📖 EXPLANATION:
Arrays are the most basic data structure in Java —
fixed-size, ordered containers of the same type.

─────────────────────────────────────
DECLARING AND CREATING ARRAYS:
─────────────────────────────────────
  // Declaration only (null reference):
  int[] numbers;

  // Declare + create (elements default to 0/null/false):
  int[] numbers = new int[5];      // [0, 0, 0, 0, 0]
  String[] names = new String[3];  // [null, null, null]

  // Declare + create + initialize:
  int[] primes = {2, 3, 5, 7, 11};           // array literal
  int[] evens  = new int[]{2, 4, 6, 8, 10};  // explicit form

─────────────────────────────────────
INDEXING — zero-based:
─────────────────────────────────────
  int[] arr = {10, 20, 30, 40, 50};
  //            0   1   2   3   4    ← indices

  arr[0]              → 10   (first element)
  arr[4]              → 50   (last element)
  arr[arr.length - 1] → 50   (safe last element)
  arr[5]              → ❌ ArrayIndexOutOfBoundsException!

─────────────────────────────────────
DEFAULT VALUES:
─────────────────────────────────────
  int[]     → 0
  double[]  → 0.0
  boolean[] → false
  char[]    → '\0'  (null character)
  String[]  → null
  Object[]  → null

─────────────────────────────────────
MULTIDIMENSIONAL ARRAYS:
─────────────────────────────────────
  // 2D array (matrix):
  int[][] matrix = new int[3][4];  // 3 rows, 4 columns
  matrix[0][0] = 1;

  // Initialize with values:
  int[][] grid = {
      {1, 2, 3},
      {4, 5, 6},
      {7, 8, 9}
  };

  // Jagged array (rows of different lengths):
  int[][] jagged = new int[3][];
  jagged[0] = new int[]{1};
  jagged[1] = new int[]{2, 3};
  jagged[2] = new int[]{4, 5, 6};

─────────────────────────────────────
ARRAY UTILITY: java.util.Arrays:
─────────────────────────────────────
  Arrays.sort(arr)           → sort in place (ascending)
  Arrays.sort(arr, comp)     → sort with custom Comparator
  Arrays.binarySearch(arr,v) → fast search (must be sorted)
  Arrays.fill(arr, value)    → fill all elements with value
  Arrays.copyOf(arr, newLen) → copy with new length
  Arrays.copyOfRange(arr,from,to) → partial copy
  Arrays.equals(a, b)        → compare element-by-element
  Arrays.toString(arr)       → "[1, 2, 3, 4, 5]"
  Arrays.deepToString(arr2D) → nested arrays as string

─────────────────────────────────────
PASSING ARRAYS TO METHODS:
─────────────────────────────────────
  Arrays are REFERENCE types — passing an array passes
  a reference to the same data. Modifications inside
  the method affect the original array.

  void doubleAll(int[] arr) {
      for (int i = 0; i < arr.length; i++) {
          arr[i] *= 2;   // modifies the ORIGINAL array
      }
  }

─────────────────────────────────────
VARARGS — variable argument arrays:
─────────────────────────────────────
  void printAll(String... items) {  // String... = String[]
      for (String s : items) System.out.println(s);
  }

  printAll("apple", "banana", "cherry");  // auto-wrapped
  printAll(new String[]{"x", "y"});       // explicit array

  Must be the LAST parameter if combined with others.

💻 CODE:
import java.util.Arrays;

public class ArraysDemo {
    public static void main(String[] args) {

        // ─── CREATION ─────────────────────────────────────
        System.out.println("=== Array Creation ===");
        int[] nums = {5, 2, 8, 1, 9, 3, 7, 4, 6};
        System.out.println("Original : " + Arrays.toString(nums));
        System.out.println("Length   : " + nums.length);
        System.out.println("First    : " + nums[0]);
        System.out.println("Last     : " + nums[nums.length - 1]);

        // Default values
        int[]    ints    = new int[3];
        boolean[] bools  = new boolean[3];
        String[]  strs   = new String[3];
        System.out.println("\nDefaults:");
        System.out.println("  int[]    : " + Arrays.toString(ints));
        System.out.println("  boolean[]: " + Arrays.toString(bools));
        System.out.println("  String[] : " + Arrays.toString(strs));

        // ─── SORTING & SEARCHING ─────────────────────────
        System.out.println("\n=== Sort & Search ===");
        int[] sorted = nums.clone();     // copy before sorting
        Arrays.sort(sorted);
        System.out.println("Sorted   : " + Arrays.toString(sorted));

        int target = 7;
        int idx = Arrays.binarySearch(sorted, target);
        System.out.println("Index of " + target + " : " + idx);

        // ─── COPY & FILL ──────────────────────────────────
        System.out.println("\n=== Copy & Fill ===");
        int[] copy = Arrays.copyOf(nums, nums.length);
        System.out.println("Copy      : " + Arrays.toString(copy));

        int[] extended = Arrays.copyOf(nums, 12);  // pads with 0
        System.out.println("Extended  : " + Arrays.toString(extended));

        int[] partial = Arrays.copyOfRange(nums, 2, 6);
        System.out.println("Partial[2-6]: " + Arrays.toString(partial));

        int[] filled = new int[5];
        Arrays.fill(filled, 99);
        System.out.println("Filled    : " + Arrays.toString(filled));

        // ─── MODIFYING VIA METHOD ─────────────────────────
        System.out.println("\n=== Array as reference ===");
        int[] original = {10, 20, 30};
        System.out.println("Before: " + Arrays.toString(original));
        doubleAll(original);
        System.out.println("After : " + Arrays.toString(original));  // modified!

        // ─── 2D ARRAYS ────────────────────────────────────
        System.out.println("\n=== 2D Array (Matrix) ===");
        int[][] matrix = {
            {1, 2, 3},
            {4, 5, 6},
            {7, 8, 9}
        };

        // Print matrix
        for (int row = 0; row < matrix.length; row++) {
            System.out.print("  [ ");
            for (int col = 0; col < matrix[row].length; col++) {
                System.out.printf("%2d ", matrix[row][col]);
            }
            System.out.println("]");
        }

        System.out.println("Center element: " + matrix[1][1]);

        // Matrix sum
        int total = 0;
        for (int[] row : matrix) {
            for (int val : row) total += val;
        }
        System.out.println("Sum of all elements: " + total);

        System.out.println(Arrays.deepToString(matrix));

        // ─── JAGGED ARRAY ────────────────────────────────
        System.out.println("\n=== Jagged Array (triangle) ===");
        int[][] triangle = new int[5][];
        for (int i = 0; i < triangle.length; i++) {
            triangle[i] = new int[i + 1];
            Arrays.fill(triangle[i], i + 1);
        }
        for (int[] row : triangle) {
            System.out.println("  " + Arrays.toString(row));
        }

        // ─── VARARGS ──────────────────────────────────────
        System.out.println("\n=== Varargs ===");
        System.out.println("Sum(1,2,3)     = " + sum(1, 2, 3));
        System.out.println("Sum(10,20)     = " + sum(10, 20));
        System.out.println("Sum(1,2,3,4,5) = " + sum(1, 2, 3, 4, 5));
        printAll("Java", "is", "fun", "to", "learn");

        // ─── PRACTICAL: frequency count ───────────────────
        System.out.println("\n=== Frequency Count ===");
        int[] dice = {3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5};
        int[] freq = new int[10];  // freq[i] = count of i
        for (int roll : dice) freq[roll]++;
        System.out.println("Rolls: " + Arrays.toString(dice));
        System.out.print("Counts: ");
        for (int i = 1; i <= 9; i++) {
            if (freq[i] > 0)
                System.out.printf("%d×%d  ", i, freq[i]);
        }
        System.out.println();
    }

    static void doubleAll(int[] arr) {
        for (int i = 0; i < arr.length; i++) arr[i] *= 2;
    }

    static int sum(int... numbers) {  // varargs
        int total = 0;
        for (int n : numbers) total += n;
        return total;
    }

    static void printAll(String... items) {
        System.out.print("Items: ");
        for (String s : items) System.out.print(s + " ");
        System.out.println();
    }
}

📝 KEY POINTS:
✅ Arrays are zero-indexed — first element is at index 0
✅ arr.length gives the size (not a method call — no parentheses!)
✅ Arrays have fixed size — use ArrayList for dynamic sizing
✅ Arrays.sort() sorts in place (modifies the array)
✅ Arrays.toString() prints arrays readably: "[1, 2, 3]"
✅ Arrays are reference types — passing to methods modifies the original
✅ Use arr.clone() or Arrays.copyOf() to make a true copy
✅ Varargs (String...) lets a method accept any number of arguments
❌ Accessing index >= arr.length throws ArrayIndexOutOfBoundsException
❌ Arrays.equals() for 1D; Arrays.deepEquals() for 2D — don't mix them
❌ Using == to compare arrays checks reference, not content
❌ Sorting a 2D array with Arrays.sort() sorts the ROW REFERENCES, not content
""",
  quiz: [
    Quiz(question: 'What is the index of the first element in a Java array?', options: [
      QuizOption(text: '0 — Java arrays are zero-indexed', correct: true),
      QuizOption(text: '1 — Java arrays are one-indexed like in most languages', correct: false),
      QuizOption(text: 'It depends on how the array was declared', correct: false),
      QuizOption(text: '-1 — Java uses negative indexing for the first element', correct: false),
    ]),
    Quiz(question: 'What is the correct way to get the number of elements in a Java array?', options: [
      QuizOption(text: 'arr.length — length is a field, not a method', correct: true),
      QuizOption(text: 'arr.length() — length is a method like in String', correct: false),
      QuizOption(text: 'arr.size() — same as ArrayList', correct: false),
      QuizOption(text: 'Arrays.length(arr) — static utility method', correct: false),
    ]),
    Quiz(question: 'What happens when you pass an array to a method and modify it inside?', options: [
      QuizOption(text: 'The original array is modified — arrays are reference types', correct: true),
      QuizOption(text: 'A copy is created — Java always passes arrays by value', correct: false),
      QuizOption(text: 'A CopyOnWriteException is thrown to protect the original', correct: false),
      QuizOption(text: 'It depends on whether the array is declared final', correct: false),
    ]),
  ],
);
