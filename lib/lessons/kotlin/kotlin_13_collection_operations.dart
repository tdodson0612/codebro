import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson13 = Lesson(
  language: 'Kotlin',
  title: 'Collection Functional Operations',
  content: """
🎯 METAPHOR:
Kotlin's collection operations are like a kitchen assembly
line with specialized stations. The raw ingredients (your
collection) go in one end. Each station does one thing:
the FILTER station removes ingredients that don't meet
the recipe, the MAP station transforms each ingredient
into something new, the REDUCE station combines everything
into one final dish. You can chain stations together —
the output of one becomes the input of the next.
No mess, no loops, no temporary variables. Just a clean
pipeline from raw data to final result.

📖 EXPLANATION:
Kotlin collections have dozens of built-in higher-order
functions. These take lambdas and let you write data
transformations as clear, readable pipelines instead of
messy nested loops.

─────────────────────────────────────
FILTER — keep matching elements:
─────────────────────────────────────
  filter { condition }       → new collection, matching only
  filterNot { condition }    → new collection, non-matching only
  filterNotNull()            → removes null elements
  filterIsInstance<T>()      → keeps only elements of type T

─────────────────────────────────────
MAP — transform each element:
─────────────────────────────────────
  map { transform }          → new collection, each transformed
  mapNotNull { transform }   → transform + filter out nulls
  flatMap { transform }      → map then flatten nested lists
  flatten()                  → flatten a list of lists

─────────────────────────────────────
AGGREGATION — collapse to one value:
─────────────────────────────────────
  sum()                  → sum of numbers
  sumOf { it.field }     → sum of a property
  average()              → average of numbers
  count()                → total size
  count { condition }    → count matching elements
  min() / max()          → smallest / largest
  minBy { } / maxBy { } → element with min/max property
  reduce { acc, it -> }  → fold without initial value
  fold(init) { acc, it ->} → fold with initial value

─────────────────────────────────────
SEARCHING:
─────────────────────────────────────
  any { condition }      → true if ANY element matches
  all { condition }      → true if ALL elements match
  none { condition }     → true if NO elements match
  find { condition }     → first matching or null
  findLast { condition } → last matching or null
  first { condition }    → first matching or throws
  last { condition }     → last matching or throws
  indexOf(element)       → index of first match

─────────────────────────────────────
GROUPING AND PARTITIONING:
─────────────────────────────────────
  groupBy { key }        → Map<K, List<V>> grouped by key
  partition { condition } → Pair<List, List> (matches, rest)
  chunked(n)             → split into sublists of size n
  windowed(n)            → sliding windows of size n
  zip(other)             → pair up two lists element by element

─────────────────────────────────────
SORTING:
─────────────────────────────────────
  sorted()               → natural order (new list)
  sortedBy { it.field }  → sort by property (new list)
  sortedByDescending { } → sort descending
  reversed()             → reversed copy
  shuffled()             → random order copy

─────────────────────────────────────
CHAINING OPERATIONS:
─────────────────────────────────────
The real power: chain operations together cleanly.

  val result = people
      .filter { it.age >= 18 }
      .sortedBy { it.name }
      .map { it.name.uppercase() }
      .take(5)

Each step returns a new collection — no mutation,
no side effects, completely readable.

💻 CODE:
data class Student(val name: String, val grade: Int, val subject: String)

fun main() {
    val students = listOf(
        Student("Alice", 92, "Math"),
        Student("Bob", 78, "Science"),
        Student("Charlie", 95, "Math"),
        Student("Dave", 65, "Science"),
        Student("Eve", 88, "Math"),
        Student("Frank", 71, "Science")
    )

    // filter
    val passing = students.filter { it.grade >= 80 }
    println("Passing:\${
passing.map { it.name }}")
    // [Alice, Charlie, Eve]

    // map
    val names = students.map { it.name }
    println("Names: \$names")

    val gradeReport = students.map { "\${
it.name}:\${
it.grade}" }
    println(gradeReport)

    // sumOf and average
    val totalGrade = students.sumOf { it.grade }
    val avgGrade = students.map { it.grade }.average()
    println("Total: \$totalGrade, Average:\${
"%.1f".format(avgGrade)}")

    // any / all / none
    println(students.any { it.grade == 100 })     // false
    println(students.all { it.grade >= 60 })      // true
    println(students.none { it.grade < 50 })      // true

    // find
    val topStudent = students.maxBy { it.grade }
    println("Top student:\${
topStudent?.name}")  // Charlie

    val firstFailing = students.find { it.grade < 70 }
    println("First failing:\${
firstFailing?.name}")  // Dave

    // groupBy
    val bySubject = students.groupBy { it.subject }
    bySubject.forEach { subject, group ->
        val names2 = group.map { it.name }
        println("\$subject: \$names2")
    }

    // partition
    val (honor, regular) = students.partition { it.grade >= 90 }
    println("Honor roll:\${
honor.map { it.name }}")  // [Alice, Charlie]
    println("Regular:\${
regular.map { it.name }}")

    // sortedBy
    val ranked = students.sortedByDescending { it.grade }
    ranked.forEachIndexed { i, s ->
        println("\${
i + 1}.\${
s.name} —\${
s.grade}")
    }

    // flatMap
    val sentences = listOf("Hello World", "Kotlin is fun")
    val words = sentences.flatMap { it.split(" ") }
    println(words)   // [Hello, World, Kotlin, is, fun]

    // chunked and zip
    val numbers = (1..10).toList()
    val chunks = numbers.chunked(3)
    println(chunks)  // [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10]]

    val letters = listOf("a", "b", "c")
    val nums2 = listOf(1, 2, 3)
    val zipped = letters.zip(nums2)
    println(zipped)  // [(a, 1), (b, 2), (c, 3)]

    // fold
    val product = listOf(1, 2, 3, 4, 5).fold(1) { acc, n -> acc * n }
    println("Product: \$product")  // 120

    // Chained pipeline
    val topMathStudents = students
        .filter { it.subject == "Math" }
        .sortedByDescending { it.grade }
        .take(2)
        .map { "\${
it.name} (\${
it.grade})" }
    println("Top math students: \$topMathStudents")
}

📝 KEY POINTS:
✅ filter keeps matching elements; map transforms them
✅ Chain operations — each returns a new collection
✅ groupBy returns Map<Key, List<Value>>
✅ partition returns a Pair of (matching, non-matching) lists
✅ fold processes a collection into a single value with a seed
✅ flatMap maps then flattens — great for nested lists
✅ find returns null if not found; first throws
✅ maxBy / minBy find the element with the max/min property
❌ These operations return NEW collections — originals unchanged
❌ Don't use forEach when you need a transformed result — use map
❌ reduce throws on empty lists — use fold with a default instead
❌ Avoid deeply chained operations with side effects in lambdas
""",
  quiz: [
    Quiz(question: 'What is the difference between find { } and first { } in Kotlin?', options: [
      QuizOption(text: 'find returns null if nothing matches; first throws NoSuchElementException', correct: true),
      QuizOption(text: 'find searches from the end; first searches from the beginning', correct: false),
      QuizOption(text: 'first is faster; find works on any Iterable', correct: false),
      QuizOption(text: 'They are identical — just different naming styles', correct: false),
    ]),
    Quiz(question: 'What does groupBy { it.category } return?', options: [
      QuizOption(text: 'A Map where each key is a category and the value is a list of matching elements', correct: true),
      QuizOption(text: 'A List of elements sorted by category', correct: false),
      QuizOption(text: 'A Set of unique categories', correct: false),
      QuizOption(text: 'A Pair of (matching, non-matching) lists', correct: false),
    ]),
    Quiz(question: 'What does flatMap do that regular map does not?', options: [
      QuizOption(text: 'It maps each element to a collection and then flattens all results into one list', correct: true),
      QuizOption(text: 'It maps and filters in a single pass for better performance', correct: false),
      QuizOption(text: 'It maps elements and removes null results automatically', correct: false),
      QuizOption(text: 'It maps over both keys and values of a Map simultaneously', correct: false),
    ]),
  ],
);
