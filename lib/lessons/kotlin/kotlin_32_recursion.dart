import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson32 = Lesson(
  language: 'Kotlin',
  title: 'Recursion and Tail Recursion',
  content: """
🎯 METAPHOR:
Recursion is like looking up a word in a dictionary, only
to find it defined using another word you don't know,
which is defined using another word you don't know, and so
on — until finally you reach a word defined in plain
English (the base case). You then unwind back through all
the definitions until you understand the original word.
Each lookup is a stack frame. If the chain of "see also"
is too long, your brain explodes — that's a stack overflow.
Tail recursion is like keeping only ONE bookmark — the
current page — instead of a separate bookmark for every
step. When each step doesn't need to come back,
the stack stays flat, no matter how deep you go.

📖 EXPLANATION:
Recursion is when a function calls itself. Every recursive
solution needs a BASE CASE (where it stops) and a RECURSIVE
CASE (where it calls itself on a smaller problem).

─────────────────────────────────────
BASIC RECURSION:
─────────────────────────────────────
  fun factorial(n: Int): Long {
      if (n <= 1) return 1L          // base case
      return n * factorial(n - 1)   // recursive case
  }

  factorial(5) → 5 * factorial(4)
               → 5 * 4 * factorial(3)
               → 5 * 4 * 3 * factorial(2)
               → 5 * 4 * 3 * 2 * factorial(1)
               → 5 * 4 * 3 * 2 * 1 = 120

Each call is pushed onto the call stack. For large n,
this causes a StackOverflowError.

─────────────────────────────────────
STACK OVERFLOW PROBLEM:
─────────────────────────────────────
  factorial(100_000)   // ❌ StackOverflowError!

The call stack has limited space. Every pending recursive
call occupies a stack frame. Deep recursion exhausts it.

─────────────────────────────────────
TAIL RECURSION — the fix:
─────────────────────────────────────
A tail-recursive function makes the recursive call as its
VERY LAST action — nothing else is done after it returns.
Kotlin can optimize this into a loop (zero stack frames).

  // NOT tail recursive — multiplies after recursive call
  fun factorial(n: Int): Long =
      if (n <= 1) 1L else n * factorial(n - 1)  // multiply happens AFTER

  // TAIL recursive — accumulator carries the work forward
  tailrec fun factorial(n: Int, acc: Long = 1L): Long =
      if (n <= 1) acc else factorial(n - 1, acc * n)

  factorial(100_000)   // ✅ Works perfectly — compiled to a loop!

The tailrec keyword tells Kotlin to optimize the function.
If the function is NOT actually tail-recursive, Kotlin
gives a compile warning.

─────────────────────────────────────
MUTUAL RECURSION:
─────────────────────────────────────
Two functions that call each other:

  fun isEven(n: Int): Boolean = if (n == 0) true else isOdd(n - 1)
  fun isOdd(n: Int): Boolean = if (n == 0) false else isEven(n - 1)

Cannot use tailrec for mutual recursion in Kotlin.
Use an iterative approach for large inputs instead.

─────────────────────────────────────
TREE TRAVERSAL — natural recursion use case:
─────────────────────────────────────
  data class TreeNode(
      val value: Int,
      val left: TreeNode? = null,
      val right: TreeNode? = null
  )

  fun sum(node: TreeNode?): Int {
      if (node == null) return 0      // base case
      return node.value + sum(node.left) + sum(node.right)
  }

─────────────────────────────────────
FIBONACCI — classic recursion trap:
─────────────────────────────────────
Naive fibonacci is exponential — same values computed
over and over. Fix it with memoization or iteration.

  // Naive — O(2^n) — terrible!
  fun fib(n: Int): Long = when {
      n <= 0 -> 0
      n == 1 -> 1
      else   -> fib(n - 1) + fib(n - 2)
  }

  // Tail recursive — O(n) — good
  tailrec fun fib(n: Int, a: Long = 0, b: Long = 1): Long = when {
      n == 0 -> a
      else   -> fib(n - 1, b, a + b)
  }

─────────────────────────────────────
WHEN TO USE RECURSION:
─────────────────────────────────────
  ✅ Tree/graph traversal
  ✅ Divide and conquer algorithms
  ✅ Parsing nested structures
  ✅ Mathematical sequences
  ❌ Simple loops — use for/while instead
  ❌ Very deep recursion without tailrec

💻 CODE:
// Tail-recursive factorial
tailrec fun factorial(n: Long, acc: Long = 1L): Long =
    if (n <= 1L) acc else factorial(n - 1L, acc * n)

// Tail-recursive fibonacci
tailrec fun fib(n: Int, a: Long = 0L, b: Long = 1L): Long = when {
    n == 0 -> a
    n == 1 -> b
    else   -> fib(n - 1, b, a + b)
}

// Binary search — recursive
fun binarySearch(list: List<Int>, target: Int, low: Int = 0, high: Int = list.size - 1): Int {
    if (low > high) return -1
    val mid = (low + high) / 2
    return when {
        list[mid] == target -> mid
        list[mid] < target  -> binarySearch(list, target, mid + 1, high)
        else                -> binarySearch(list, target, low, mid - 1)
    }
}

// Flatten a nested list — recursive
fun flattenNested(list: List<Any>): List<Any> {
    val result = mutableListOf<Any>()
    for (item in list) {
        @Suppress("UNCHECKED_CAST")
        if (item is List<*>) result.addAll(flattenNested(item as List<Any>))
        else result.add(item)
    }
    return result
}

// Tree structure
data class TreeNode(
    val value: Int,
    val left: TreeNode? = null,
    val right: TreeNode? = null
)

fun treeSum(node: TreeNode?): Int = when (node) {
    null -> 0
    else -> node.value + treeSum(node.left) + treeSum(node.right)
}

fun treeDepth(node: TreeNode?): Int = when (node) {
    null -> 0
    else -> 1 + maxOf(treeDepth(node.left), treeDepth(node.right))
}

fun treeInOrder(node: TreeNode?): List<Int> = when (node) {
    null -> emptyList()
    else -> treeInOrder(node.left) + node.value + treeInOrder(node.right)
}

// Merge sort — classic recursive divide & conquer
fun mergeSort(list: List<Int>): List<Int> {
    if (list.size <= 1) return list   // base case
    val mid = list.size / 2
    val left = mergeSort(list.subList(0, mid))
    val right = mergeSort(list.subList(mid, list.size))
    return merge(left, right)
}

fun merge(left: List<Int>, right: List<Int>): List<Int> {
    val result = mutableListOf<Int>()
    var i = 0; var j = 0
    while (i < left.size && j < right.size) {
        if (left[i] <= right[j]) result.add(left[i++])
        else result.add(right[j++])
    }
    result.addAll(left.drop(i))
    result.addAll(right.drop(j))
    return result
}

fun main() {
    // Factorial
    println("=== Tail-recursive factorial ===")
    for (n in listOf(0L, 1L, 5L, 10L, 20L)) {
        println("\$n! =\${
factorial(n)}")
    }

    // Fibonacci
    println("\\n=== Tail-recursive fibonacci ===")
    println("First 15 Fibonacci numbers:")
    println((0..14).map { fib(it) })

    // Binary search
    println("\\n=== Binary search ===")
    val sorted = listOf(2, 5, 8, 12, 16, 23, 38, 56, 72, 91)
    println("List: \$sorted")
    println("Search 23: index\${
binarySearch(sorted, 23)}")  // 5
    println("Search 72: index\${
binarySearch(sorted, 72)}")  // 8
    println("Search 99: index\${
binarySearch(sorted, 99)}")  // -1

    // Flatten
    println("\\n=== Flatten nested list ===")
    val nested: List<Any> = listOf(1, listOf(2, 3), listOf(4, listOf(5, 6)), 7)
    println("Nested: \$nested")
    println("Flat:  \${
flattenNested(nested)}")

    // Tree operations
    println("\\n=== Tree traversal ===")
    val tree = TreeNode(
        10,
        TreeNode(5, TreeNode(2), TreeNode(7)),
        TreeNode(15, TreeNode(12), TreeNode(20))
    )
    println("In-order:\${
treeInOrder(tree)}")   // [2, 5, 7, 10, 12, 15, 20]
    println("Sum:  \${
treeSum(tree)}")           // 71
    println("Depth:\${
treeDepth(tree)}")         // 3

    // Merge sort
    println("\\n=== Merge sort ===")
    val unsorted = listOf(38, 27, 43, 3, 9, 82, 10)
    println("Before: \$unsorted")
    println("After: \${
mergeSort(unsorted)}")

    // Tail recursion handles large inputs safely
    println("\\n=== Large input (tail recursion) ===")
    println("100,000! ends in: ...(\${
factorial(100_000L).toString().takeLast(5)})")
    println("fib(80) =\${
fib(80)}")
}

📝 KEY POINTS:
✅ Every recursive function needs a base case to stop recursion
✅ tailrec optimizes tail-recursive functions into loops — no stack overflow
✅ Tail recursion: the recursive call must be the LAST operation
✅ Use an accumulator parameter to convert to tail-recursive form
✅ Tree traversal, divide-and-conquer, and parsing are ideal for recursion
✅ Kotlin validates tailrec — warns you if optimization can't apply
✅ Binary search and merge sort are classic recursive algorithms
❌ Don't use naive recursion for Fibonacci — exponential time
❌ tailrec only works when the recursive call is truly the last action
❌ Mutual recursion (isEven/isOdd) cannot use tailrec
❌ Always identify your base case FIRST — missing it = infinite loop
""",
  quiz: [
    Quiz(question: 'What does the tailrec keyword do in Kotlin?', options: [
      QuizOption(text: 'It tells the compiler to optimize the recursive function into a loop, preventing stack overflow', correct: true),
      QuizOption(text: 'It makes the recursive function run in a separate thread', correct: false),
      QuizOption(text: 'It caches recursive results to avoid recomputation', correct: false),
      QuizOption(text: 'It limits recursion depth to a safe maximum automatically', correct: false),
    ]),
    Quiz(question: 'What is required for a function to be eligible for tailrec optimization?', options: [
      QuizOption(text: 'The recursive call must be the very last operation — nothing is done with its return value', correct: true),
      QuizOption(text: 'The function must have exactly one parameter', correct: false),
      QuizOption(text: 'The function must return Unit or a primitive type', correct: false),
      QuizOption(text: 'The base case must always return 0 or null', correct: false),
    ]),
    Quiz(question: 'Why is the naive recursive Fibonacci implementation inefficient?', options: [
      QuizOption(text: 'It recomputes the same subproblems exponentially — fib(n) calls fib(n-1) and fib(n-2) which overlap massively', correct: true),
      QuizOption(text: 'It uses too much memory because it stores all intermediate values', correct: false),
      QuizOption(text: 'Recursion is always slower than iteration for mathematical functions', correct: false),
      QuizOption(text: 'Kotlin\'s JVM does not optimize integer arithmetic in recursive functions', correct: false),
    ]),
  ],
);
