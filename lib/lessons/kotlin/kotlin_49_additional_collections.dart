import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson49 = Lesson(
  language: 'Kotlin',
  title: 'ArrayDeque, PriorityQueue, and Additional Collections',
  content: """
🎯 METAPHOR:
Different collection types are like different containers
at a café. A regular List is a shelf — items sit in order,
you pick by position. An ArrayDeque is like a double-ended
conveyor belt — you can add or take from EITHER end quickly
(great for stacks AND queues). A PriorityQueue is like a
hospital triage line — patients don't go in order of
arrival; the most critical patient is ALWAYS next,
regardless of when they arrived. Choosing the right
container for the job makes your code both cleaner and faster.

📖 EXPLANATION:
Kotlin's standard library includes several specialized
collection types beyond the basic List, Set, and Map.

─────────────────────────────────────
ArrayDeque — double-ended queue:
─────────────────────────────────────
ArrayDeque supports efficient add/remove from BOTH ends.
It's the recommended implementation for stacks and queues
in Kotlin (replaces Stack and LinkedList for these uses).

  val deque = ArrayDeque<String>()

  // Add to ends
  deque.addFirst("A")    // front
  deque.addLast("B")     // back
  deque.addFirst("Z")    // front again

  // Peek (look without removing)
  deque.first()          // "Z"
  deque.last()           // "B"

  // Remove from ends
  deque.removeFirst()    // "Z"
  deque.removeLast()     // "B"

  // Use as a STACK (LIFO — Last In, First Out):
  deque.addLast(item)    // push
  deque.removeLast()     // pop
  deque.last()           // peek

  // Use as a QUEUE (FIFO — First In, First Out):
  deque.addLast(item)    // enqueue
  deque.removeFirst()    // dequeue
  deque.first()          // peek front

─────────────────────────────────────
PriorityQueue — ordered by priority:
─────────────────────────────────────
Elements are retrieved in priority order (smallest first
by default). Uses a heap data structure internally.

  val pq = PriorityQueue<Int>()
  pq.add(5); pq.add(1); pq.add(3)
  pq.poll()   // 1 (smallest first)
  pq.poll()   // 3
  pq.poll()   // 5

  // Custom priority (largest first):
  val maxPQ = PriorityQueue<Int>(compareByDescending { it })

  // Priority by property:
  data class Task(val name: String, val priority: Int)
  val taskQueue = PriorityQueue<Task>(compareBy { it.priority })

─────────────────────────────────────
LinkedHashMap — insertion-order map:
─────────────────────────────────────
  val lhm = LinkedHashMap<String, Int>()
  lhm["banana"] = 2
  lhm["apple"] = 1
  lhm["cherry"] = 3
  println(lhm)   // {banana=2, apple=1, cherry=3} — insertion order

─────────────────────────────────────
TreeMap — sorted map:
─────────────────────────────────────
  val sorted = java.util.TreeMap<String, Int>()
  sorted["banana"] = 2
  sorted["apple"] = 1
  sorted["cherry"] = 3
  println(sorted)   // {apple=1, banana=2, cherry=3} — sorted by key

  // Custom comparator:
  val byLength = java.util.TreeMap<String, Int>(compareBy { it.length })

─────────────────────────────────────
ArrayDeque vs Stack vs LinkedList:
─────────────────────────────────────
  java.util.Stack    → legacy, thread-synchronized, slow
  java.util.LinkedList → linked nodes, more overhead
  ArrayDeque         → ✅ Kotlin-native, array-backed, fast

  Always prefer ArrayDeque for stack/queue use cases in Kotlin.

─────────────────────────────────────
buildList, buildMap, buildSet:
─────────────────────────────────────
Kotlin 1.6+ provides builder functions that create
read-only collections with a mutable builder inside:

  val primes = buildList {
      add(2)
      for (n in 3..50 step 2) {
          if ((2 until n).none { n % it == 0 }) add(n)
      }
  }
  // primes is a read-only List<Int>

  val config = buildMap {
      put("host", "localhost")
      put("port", "8080")
      if (isDevelopment) put("debug", "true")
  }

─────────────────────────────────────
COLLECTION INTEROP with Java:
─────────────────────────────────────
  // Kotlin List → Java List
  val kotlinList: List<String> = listOf("a", "b")
  val javaList: java.util.List<String> = kotlinList as java.util.List<String>

  // Java's ArrayList → Kotlin's MutableList
  val javaArrayList = java.util.ArrayList<String>()
  val mutableList: MutableList<String> = javaArrayList

  // Convert explicitly when needed:
  val copy = kotlinList.toMutableList()

💻 CODE:
import java.util.PriorityQueue
import java.util.TreeMap
import java.util.LinkedHashMap

// ─── ArrayDeque as a STACK ──────────────────────────

fun stackDemo() {
    println("=== ArrayDeque as Stack (LIFO) ===")

    val stack = ArrayDeque<String>()

    // Push operations
    stack.addLast("first")
    stack.addLast("second")
    stack.addLast("third")
    println("After pushes: \$stack")

    // Pop operations
    while (stack.isNotEmpty()) {
        println("Popped: ${
stack.removeLast()}")
    }

    // Practical: undo history
    println("\\n--- Undo stack ---")
    val undoStack = ArrayDeque<String>()
    val actions = listOf("Type 'H'", "Type 'e'", "Type 'l'", "Type 'l'", "Type 'o'")
    actions.forEach { undoStack.addLast(it); println("Do: \$it") }

    println("\\nUndo sequence:")
    repeat(3) {
        if (undoStack.isNotEmpty()) println("Undone: ${
undoStack.removeLast()}")
    }
}

// ─── ArrayDeque as a QUEUE ──────────────────────────

fun queueDemo() {
    println("\\n=== ArrayDeque as Queue (FIFO) ===")

    val queue = ArrayDeque<String>()

    // Enqueue
    queue.addLast("customer1")
    queue.addLast("customer2")
    queue.addLast("customer3")
    println("Queue: \$queue")

    // Dequeue
    while (queue.isNotEmpty()) {
        println("Serving: ${
queue.removeFirst()}")
    }
}

// ─── ArrayDeque as a SLIDING WINDOW ─────────────────

fun slidingWindowDemo() {
    println("\\n=== Sliding window (deque) ===")

    val data = listOf(3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5)
    val windowSize = 3
    val window = ArrayDeque<Int>()

    println("Data: \$data")
    print("Running avg (window=\$windowSize): ")

    for (value in data) {
        window.addLast(value)
        if (window.size > windowSize) window.removeFirst()
        if (window.size == windowSize) {
            print("${
"%.1f".format(window.average())} ")
        }
    }
    println()
}

// ─── PRIORITY QUEUE ──────────────────────────────────

data class Task(val name: String, val priority: Int, val description: String) {
    override fun toString() = "[\$priority] \$name"
}

fun priorityQueueDemo() {
    println("\\n=== PriorityQueue ===")

    // Min-heap (lowest priority number = highest urgency)
    val taskQueue = PriorityQueue<Task>(compareBy { it.priority })

    taskQueue.add(Task("Write tests", 3, "Unit tests for auth module"))
    taskQueue.add(Task("Fix crash", 1, "App crashes on login"))
    taskQueue.add(Task("Update docs", 5, "Update README"))
    taskQueue.add(Task("Security patch", 1, "Critical CVE-2024-XXXX"))
    taskQueue.add(Task("Refactor DB", 4, "Clean up data layer"))
    taskQueue.add(Task("Add logging", 2, "Add structured logging"))

    println("Processing tasks by priority:")
    while (taskQueue.isNotEmpty()) {
        val task = taskQueue.poll()
        println("  Processing: \$task — ${
task.description}")
    }

    // Dijkstra-style: min-priority queue for distances
    println("\\n--- Shortest path simulation ---")
    data class Node(val name: String, val dist: Int)
    val pq = PriorityQueue<Node>(compareBy { it.dist })

    pq.add(Node("B", 4))
    pq.add(Node("C", 2))
    pq.add(Node("D", 7))
    pq.add(Node("E", 1))

    print("Visit order: ")
    while (pq.isNotEmpty()) {
        val node = pq.poll()
        print("${
node.name}(${
node.dist}) ")
    }
    println()
}

// ─── TreeMap and buildMap ─────────────────────────────

fun specialMapsDemo() {
    println("\\n=== Special Maps ===")

    // TreeMap — always sorted
    val wordFreq = TreeMap<String, Int>()
    "the quick brown fox jumps over the lazy dog".split(" ")
        .forEach { word -> wordFreq[word] = (wordFreq[word] ?: 0) + 1 }
    println("Word frequencies (sorted):")
    wordFreq.forEach { (word, count) -> println("  \$word: \$count") }

    // TreeMap with custom comparator — sort by length, then alphabetically
    val byLength = TreeMap<String, Int>(compareBy({ it.length }, { it }))
    wordFreq.forEach { (k, v) -> byLength[k] = v }
    println("\\nSorted by length then alpha:")
    byLength.entries.take(5).forEach { (word, count) -> println("  \$word: \$count") }

    // buildList — idiomatic collection building
    println("\\n=== buildList / buildMap / buildSet ===")

    val fibonacci = buildList {
        add(0L); add(1L)
        while (last() < 1000L) add(this[size - 1] + this[size - 2])
    }
    println("Fibonacci under 1000: \$fibonacci")

    val squaresMap = buildMap {
        for (i in 1..10) put(i, i * i)
    }
    println("Squares: \$squaresMap")

    val vowels = buildSet {
        addAll(listOf('a', 'e', 'i', 'o', 'u'))
        addAll(listOf('A', 'E', 'I', 'O', 'U'))
    }
    println("Vowels: \$vowels")
}

fun main() {
    stackDemo()
    queueDemo()
    slidingWindowDemo()
    priorityQueueDemo()
    specialMapsDemo()
}

📝 KEY POINTS:
✅ ArrayDeque is Kotlin's recommended stack/queue — fast, array-backed
✅ addFirst/removeLast for stack (LIFO); addLast/removeFirst for queue (FIFO)
✅ PriorityQueue retrieves elements by priority, not insertion order
✅ PriorityQueue uses natural order (min) by default; pass a Comparator to customize
✅ TreeMap keeps keys sorted; LinkedHashMap preserves insertion order
✅ buildList/buildMap/buildSet create read-only collections with mutable building
✅ ArrayDeque replaces java.util.Stack and LinkedList for stack/queue uses
✅ first() and last() peek without removing; removeFirst/Last removes and returns
❌ Don't use java.util.Stack — it's synchronized and legacy
❌ PriorityQueue.peek() returns without removing; poll() removes and returns
❌ PriorityQueue does NOT guarantee iteration order — only poll() is ordered
❌ buildList is Kotlin 1.6+ — check your target version
""",
  quiz: [
    Quiz(question: 'Which ArrayDeque operations implement a stack (LIFO) pattern?', options: [
      QuizOption(text: 'addLast() to push and removeLast() to pop', correct: true),
      QuizOption(text: 'addFirst() to push and removeFirst() to pop', correct: false),
      QuizOption(text: 'addLast() to push and removeFirst() to pop', correct: false),
      QuizOption(text: 'push() and pop() — ArrayDeque has dedicated stack methods', correct: false),
    ]),
    Quiz(question: 'What determines the retrieval order of elements in a PriorityQueue?', options: [
      QuizOption(text: 'The natural ordering or a custom Comparator — not the insertion order', correct: true),
      QuizOption(text: 'First-in-first-out — insertion order is always preserved', correct: false),
      QuizOption(text: 'Last-in-first-out — the most recently added element is retrieved first', correct: false),
      QuizOption(text: 'Random order — PriorityQueue uses a random selection algorithm', correct: false),
    ]),
    Quiz(question: 'What does buildList { } produce?', options: [
      QuizOption(text: 'A read-only List built using a mutable builder inside the lambda', correct: true),
      QuizOption(text: 'A MutableList that can be modified after creation', correct: false),
      QuizOption(text: 'A lazy Sequence that generates elements on demand', correct: false),
      QuizOption(text: 'An ArrayList backed by a fixed-size array', correct: false),
    ]),
  ],
);
