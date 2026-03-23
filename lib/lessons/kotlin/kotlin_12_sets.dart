import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson12 = Lesson(
  language: 'Kotlin',
  title: 'Collections: Sets',
  content: """
🎯 METAPHOR:
A Set is like a guest list for an exclusive party —
each person can only appear ONCE. If you try to add
someone who's already on the list, nothing happens.
No duplicates, no arguments, just a quiet rejection.
A Set also doesn't care about ORDER — it cares about
MEMBERSHIP. The question a Set answers best is:
"Is this person on the list?" — not "Who is third?"

📖 EXPLANATION:
A Set is a collection that contains unique elements only.
Unlike a List, Sets do not guarantee order (unless you use
LinkedHashSet or TreeSet), and they do not allow duplicates.

─────────────────────────────────────
CREATING SETS:
─────────────────────────────────────
  setOf(...)           // read-only, insertion order kept
  mutableSetOf(...)    // mutable, insertion order kept
  hashSetOf(...)       // unordered, fastest lookup
  linkedSetOf(...)     // insertion order maintained
  sortedSetOf(...)     // always sorted (TreeSet)

  val colors = setOf("red", "green", "blue", "red")
  println(colors)   // [red, green, blue]  — duplicate removed!

─────────────────────────────────────
KEY CHARACTERISTICS:
─────────────────────────────────────
  ✅ No duplicates — adding an existing element does nothing
  ✅ Membership check (contains) is O(1) for HashSet
  ❌ No index-based access — you cannot do set[0]
  ❌ No guaranteed order (unless LinkedHashSet or TreeSet)

─────────────────────────────────────
COMMON SET OPERATIONS:
─────────────────────────────────────
  set.contains(x)     → true if x is in the set
  x in set            → same, cleaner syntax
  set.size            → number of elements
  set.isEmpty()       → true if no elements
  set.toList()        → convert to a List

─────────────────────────────────────
MUTABLE SET OPERATIONS:
─────────────────────────────────────
  add(element)        → adds if not already present
  remove(element)     → removes if present
  addAll(collection)  → add all (duplicates ignored)
  removeAll(collection) → remove all matching
  retainAll(collection) → keep only elements in both
  clear()             → remove all

─────────────────────────────────────
SET MATH — union, intersection, difference:
─────────────────────────────────────
These are the real power of sets — mathematical operations.

  A union B       → all elements in A OR B (or both)
  A intersect B   → only elements in BOTH A and B
  A subtract B    → elements in A but NOT in B

  val a = setOf(1, 2, 3, 4)
  val b = setOf(3, 4, 5, 6)

  a union b        → {1, 2, 3, 4, 5, 6}
  a intersect b    → {3, 4}
  a subtract b     → {1, 2}

─────────────────────────────────────
WHEN TO USE SET vs LIST:
─────────────────────────────────────
  Use List when:
    → Order matters
    → Duplicates are allowed or expected
    → You need index access

  Use Set when:
    → You need uniqueness guaranteed
    → You need fast membership testing
    → Order doesn't matter

  Common pattern: collect into a Set to deduplicate,
  then convert to List if you need ordered access.

💻 CODE:
fun main() {
    // Read-only set — duplicates automatically removed
    val tags = setOf("kotlin", "android", "mobile", "kotlin", "android")
    println(tags)          // [kotlin, android, mobile]
    println(tags.size)     // 3 — not 5

    // Membership check
    println("kotlin" in tags)    // true
    println("ios" in tags)       // false

    // Mutable set
    val permissions = mutableSetOf("READ", "WRITE")
    permissions.add("EXECUTE")
    permissions.add("READ")     // already exists — ignored
    println(permissions)         // [READ, WRITE, EXECUTE]

    permissions.remove("WRITE")
    println(permissions)         // [READ, EXECUTE]

    // Set math
    val teamA = setOf("Alice", "Bob", "Charlie")
    val teamB = setOf("Charlie", "Dave", "Eve")

    val everyone = teamA union teamB
    println("Union: \$everyone")
    // [Alice, Bob, Charlie, Dave, Eve]

    val overlap = teamA intersect teamB
    println("Both teams: \$overlap")
    // [Charlie]

    val onlyA = teamA subtract teamB
    println("Only in A: \$onlyA")
    // [Alice, Bob]

    // Deduplication pattern
    val rawData = listOf(1, 2, 2, 3, 3, 3, 4, 4, 4, 4)
    val unique = rawData.toSet()
    println(unique)          // [1, 2, 3, 4]
    val sortedUnique = rawData.toSortedSet()
    println(sortedUnique)    // [1, 2, 3, 4]

    // retainAll — keep only matching
    val allowed = mutableSetOf("admin", "editor", "viewer", "guest")
    val userRoles = setOf("editor", "viewer", "banned")
    allowed.retainAll(userRoles)
    println(allowed)         // [editor, viewer]

    // Convert between types
    val numSet = setOf(5, 3, 1, 4, 2)
    val numList = numSet.toList()
    val sortedList = numSet.sorted()    // returns a sorted List
    println(numList)         // order not guaranteed for HashSet
    println(sortedList)      // [1, 2, 3, 4, 5]
}

📝 KEY POINTS:
✅ Sets automatically ignore duplicate elements
✅ Use in for fast, readable membership checks
✅ union, intersect, subtract are built-in set operations
✅ HashSet has O(1) lookup — fastest for membership checks
✅ setOf() maintains insertion order (LinkedHashSet)
✅ sortedSetOf() keeps elements sorted at all times
✅ Deduplicate a List with list.toSet()
❌ No index access on sets — use toList() if you need it
❌ Sets don't guarantee order unless you use sorted/linked variants
❌ add() on a set silently does nothing if element exists —
   there's no error or warning
❌ Don't use a Set when you need to count duplicates —
   use a Map<T, Int> for frequency counting instead
""",
  quiz: [
    Quiz(question: 'What happens when you add a duplicate element to a Kotlin Set?', options: [
      QuizOption(text: 'The duplicate is silently ignored — the set is unchanged', correct: true),
      QuizOption(text: 'An exception is thrown', correct: false),
      QuizOption(text: 'The old element is replaced by the new one', correct: false),
      QuizOption(text: 'The set stores both and resolves the conflict later', correct: false),
    ]),
    Quiz(question: 'What does the intersect operation return when applied to two sets?', options: [
      QuizOption(text: 'A new set containing only elements present in both sets', correct: true),
      QuizOption(text: 'A new set containing all elements from both sets', correct: false),
      QuizOption(text: 'A new set with elements from the first set not in the second', correct: false),
      QuizOption(text: 'The size of the overlap between the two sets', correct: false),
    ]),
    Quiz(question: 'When should you prefer a Set over a List?', options: [
      QuizOption(text: 'When you need guaranteed uniqueness and fast membership testing', correct: true),
      QuizOption(text: 'When you need to access elements by index', correct: false),
      QuizOption(text: 'When the collection will contain fewer than 10 elements', correct: false),
      QuizOption(text: 'When elements need to be stored in insertion order', correct: false),
    ]),
  ],
);
