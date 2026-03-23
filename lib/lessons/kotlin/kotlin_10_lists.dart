import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson10 = Lesson(
  language: 'Kotlin',
  title: 'Collections: Lists',
  content: """
🎯 METAPHOR:
A List is like a numbered playlist on a music app.
Songs have an ORDER — song #1, song #2, song #3.
You can go directly to song #3 by its position.
You can have the same song twice. The playlist can be
"read-only" (listOf — like a shared public playlist
others can see but not edit) or "editable"
(mutableListOf — your personal playlist you can rearrange).
Kotlin distinguishes these two at the type level —
a read-only list literally doesn't have add() or remove().

📖 EXPLANATION:
Kotlin's collection system is one of its finest features.
It cleanly separates read-only and mutable collections,
and comes with a massive library of functional operations.

─────────────────────────────────────
READ-ONLY vs MUTABLE:
─────────────────────────────────────
  listOf()        → read-only List  (no add/remove)
  mutableListOf() → MutableList     (full modification)

  val fruits = listOf("Apple", "Banana", "Cherry")
  // fruits.add("Mango")  ❌ no add() on read-only list

  val scores = mutableListOf(90, 85, 78)
  scores.add(92)    // ✅ OK

"Read-only" doesn't mean immutable — the underlying
data can still change via other references. It means
THIS reference doesn't expose mutation operations.

─────────────────────────────────────
CREATING LISTS:
─────────────────────────────────────
  listOf(1, 2, 3)                    // read-only
  mutableListOf(1, 2, 3)             // mutable
  emptyList<Int>()                   // empty read-only
  mutableListOf<String>()            // empty mutable
  List(5) { it * 2 }                 // [0, 2, 4, 6, 8]
  buildList { add(1); add(2) }       // builder pattern

─────────────────────────────────────
ACCESSING ELEMENTS:
─────────────────────────────────────
  list[0]          → first element (0-indexed)
  list.first()     → first element
  list.last()      → last element
  list.getOrNull(i) → element at i, or null if out of bounds
  list.size        → number of elements

─────────────────────────────────────
COMMON LIST OPERATIONS:
─────────────────────────────────────
  contains(x)      → true if x is in the list
  indexOf(x)       → index of x, -1 if not found
  isEmpty()        → true if size == 0
  isNotEmpty()     → true if size > 0
  subList(from, to) → portion of the list
  reversed()       → new list in reverse order
  sorted()         → new list in sorted order
  toMutableList()  → convert read-only to mutable copy

─────────────────────────────────────
MUTABLE OPERATIONS:
─────────────────────────────────────
  add(element)         → append to end
  add(index, element)  → insert at position
  remove(element)      → remove first occurrence
  removeAt(index)      → remove by position
  set(index, element)  → replace at position
  clear()              → remove all elements
  addAll(collection)   → add all elements from another

─────────────────────────────────────
FUNCTIONAL OPERATIONS (preview):
─────────────────────────────────────
Lists have powerful built-in functions:
  filter { condition }  → new list matching condition
  map { transform }     → new list with transformed values
  forEach { action }    → run action on each element
  any { condition }     → true if any element matches
  all { condition }     → true if all elements match
  count { condition }   → count matching elements
  sum()                 → sum of all elements (Int/Double)
  joinToString(sep)     → join as a string

(These will be covered in depth in the Collections
Functional Operations lesson.)

💻 CODE:
fun main() {
    // Read-only list
    val fruits = listOf("Apple", "Banana", "Cherry", "Apple")
    println(fruits)              // [Apple, Banana, Cherry, Apple]
    println(fruits[1])           // Banana
    println(fruits.first())      // Apple
    println(fruits.last())       // Apple (last element)
    println(fruits.size)         // 4
    println(fruits.contains("Banana"))  // true
    println("Mango" in fruits)   // false

    // Safe access
    println(fruits.getOrNull(10))  // null (no crash)
    println(fruits.getOrNull(1))   // Banana

    // Mutable list
    val scores = mutableListOf(90, 85, 78)
    scores.add(92)
    scores.add(0, 100)       // insert at index 0
    scores.remove(85)
    scores[2] = 80           // replace index 2
    println(scores)          // [100, 90, 80, 92]

    // Functional operations (preview)
    val numbers = listOf(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

    val evens = numbers.filter { it % 2 == 0 }
    println(evens)            // [2, 4, 6, 8, 10]

    val doubled = numbers.map { it * 2 }
    println(doubled)          // [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]

    val total = numbers.sum()
    println(total)            // 55

    val hasNegative = numbers.any { it < 0 }
    println(hasNegative)      // false

    println(numbers.joinToString(" → "))  // 1 → 2 → 3 → ...

    // Convert and sort
    val unsorted = mutableListOf(5, 2, 8, 1, 9, 3)
    println(unsorted.sorted())     // [1, 2, 3, 5, 8, 9]
    println(unsorted.reversed())   // [3, 9, 1, 8, 2, 5]
    unsorted.sort()                // sorts in place (mutable only)
    println(unsorted)              // [1, 2, 3, 5, 8, 9]

    // List of generated values
    val squares = List(5) { i -> i * i }
    println(squares)          // [0, 1, 4, 9, 16]
}

📝 KEY POINTS:
✅ listOf() is read-only; mutableListOf() is mutable
✅ Lists are ordered and allow duplicate values
✅ Use getOrNull(i) for safe access — no IndexOutOfBoundsException
✅ sorted() and reversed() return NEW lists; sort() modifies in place
✅ List(n) { it * 2 } generates a list from a formula
✅ in operator checks containment: "apple" in fruits
✅ convert between read-only and mutable with toMutableList()
❌ listOf() is NOT immutable — the reference is read-only
❌ Don't use [index] without bounds checking in production
❌ remove() removes the first matching element, not all matches
❌ sorted() on a mutable list does not sort it in place —
   it returns a new list. Use .sort() to sort in place.
""",
  quiz: [
    Quiz(question: 'What is the difference between listOf() and mutableListOf()?', options: [
      QuizOption(text: 'listOf() creates a read-only list; mutableListOf() allows adding and removing elements', correct: true),
      QuizOption(text: 'listOf() is faster; mutableListOf() is thread-safe', correct: false),
      QuizOption(text: 'listOf() allows duplicates; mutableListOf() does not', correct: false),
      QuizOption(text: 'They are identical — just different naming conventions', correct: false),
    ]),
    Quiz(question: 'How do you safely access an element that might be out of bounds?', options: [
      QuizOption(text: 'Use getOrNull(index) — returns null instead of throwing an exception', correct: true),
      QuizOption(text: 'Wrap the access in a try-catch block', correct: false),
      QuizOption(text: 'Use list.safeGet(index)', correct: false),
      QuizOption(text: 'Check list.size > index before accessing', correct: false),
    ]),
    Quiz(question: 'What does sorted() return when called on a list?', options: [
      QuizOption(text: 'A new sorted list — the original list is unchanged', correct: true),
      QuizOption(text: 'The same list sorted in place', correct: false),
      QuizOption(text: 'A sorted copy only if the list is mutable', correct: false),
      QuizOption(text: 'An iterator over the sorted elements', correct: false),
    ]),
  ],
);
