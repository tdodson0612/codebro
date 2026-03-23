import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson11 = Lesson(
  language: 'Kotlin',
  title: 'Collections: Maps',
  content: """
🎯 METAPHOR:
A Map is like a dictionary. Every word (key) maps to
a definition (value). You don't flip through every page
to find a word — you go directly to it by name. And just
like a real dictionary, every word is unique. You can't
have "apple" defined twice. But two different words CAN
have the same definition. Maps are the lookup tables
of programming — instant access by key, no searching.

📖 EXPLANATION:
A Map stores key-value pairs. Keys are unique; values
can repeat. Kotlin has read-only Map and mutable MutableMap.

─────────────────────────────────────
CREATING MAPS:
─────────────────────────────────────
  mapOf(key to value, ...)          // read-only
  mutableMapOf(key to value, ...)   // mutable
  emptyMap<K, V>()                  // empty read-only
  hashMapOf(...)                    // HashMap (unordered)
  linkedMapOf(...)                  // LinkedHashMap (insertion order)
  sortedMapOf(...)                  // TreeMap (sorted by key)

  val ages = mapOf("Terry" to 30, "Sam" to 25, "Bob" to 35)
  
  The to keyword creates a Pair<K, V> — it's just syntax sugar.

─────────────────────────────────────
ACCESSING VALUES:
─────────────────────────────────────
  map["key"]           → value or null if missing
  map.get("key")       → same as above
  map.getValue("key")  → value or throws NoSuchElementException
  map.getOrDefault("key", default) → value or default
  map.getOrElse("key") { default } → value or lambda result

  Prefer map["key"] ?: default  for safe access.

─────────────────────────────────────
COMMON MAP OPERATIONS:
─────────────────────────────────────
  map.keys          → Set of all keys
  map.values        → Collection of all values
  map.entries       → Set of Map.Entry (key-value pairs)
  map.size          → number of pairs
  map.isEmpty()     → true if no entries
  map.contains(key) → true if key exists
  map.containsKey(key)    → same
  map.containsValue(val)  → true if value exists

─────────────────────────────────────
MUTABLE MAP OPERATIONS:
─────────────────────────────────────
  put(key, value)        → add or replace entry
  remove(key)            → remove by key
  clear()                → remove all
  putAll(otherMap)       → merge another map in
  map[key] = value       → same as put (operator shorthand)

─────────────────────────────────────
ITERATING A MAP:
─────────────────────────────────────
  // Iterate entries
  for ((key, value) in map) {
      println("\$key → \$value")
  }

  // Iterate keys only
  for (key in map.keys) { }

  // Iterate values only
  for (value in map.values) { }

  // forEach
  map.forEach { key, value -> println("\$key: \$value") }

─────────────────────────────────────
FUNCTIONAL OPERATIONS ON MAPS:
─────────────────────────────────────
  filter { (k, v) -> condition }   → new map matching condition
  mapValues { (k, v) -> newVal }   → transform values
  mapKeys { (k, v) -> newKey }     → transform keys
  any { (k, v) -> condition }      → true if any entry matches
  all { (k, v) -> condition }      → true if all match

💻 CODE:
fun main() {
    // Read-only map
    val capitals = mapOf(
        "USA" to "Washington D.C.",
        "UK" to "London",
        "Japan" to "Tokyo",
        "France" to "Paris"
    )

    // Access
    println(capitals["Japan"])             // Tokyo
    println(capitals["Germany"])           // null
    println(capitals.getOrDefault("Germany", "Unknown"))  // Unknown

    // Keys and values
    println(capitals.keys)     // [USA, UK, Japan, France]
    println(capitals.values)   // [Washington D.C., London, Tokyo, Paris]
    println(capitals.size)     // 4

    // Checking
    println("UK" in capitals)              // true
    println(capitals.containsValue("Paris"))  // true

    // Iterating
    for ((country, capital) in capitals) {
        println("\$country → \$capital")
    }

    // Mutable map
    val scores = mutableMapOf(
        "Alice" to 90,
        "Bob" to 85
    )
    scores["Charlie"] = 92          // add new entry
    scores["Bob"] = 88              // update existing
    scores.remove("Alice")
    println(scores)   // {Bob=88, Charlie=92}

    // Merge maps
    val extra = mapOf("Dave" to 78, "Eve" to 95)
    scores.putAll(extra)
    println(scores)   // {Bob=88, Charlie=92, Dave=78, Eve=95}

    // Functional operations
    val highScorers = scores.filter { (_, score) -> score >= 90 }
    println(highScorers)   // {Charlie=92, Eve=95}

    val letterGrades = scores.mapValues { (_, score) ->
        when (score) {
            in 90..100 -> "A"
            in 80..89  -> "B"
            else       -> "C"
        }
    }
    println(letterGrades)  // {Bob=B, Charlie=A, Dave=C, Eve=A}

    // forEach
    letterGrades.forEach { name, grade ->
        println("\$name earned a \$grade")
    }

    // Convert list of pairs to map
    val pairs = listOf("a" to 1, "b" to 2, "c" to 3)
    val fromPairs = pairs.toMap()
    println(fromPairs)   // {a=1, b=2, c=3}
}

📝 KEY POINTS:
✅ mapOf() is read-only; mutableMapOf() is mutable
✅ Keys are unique — putting the same key twice replaces the value
✅ map["key"] returns null if key doesn't exist — safe access
✅ Use getOrDefault() or ?: to handle missing keys cleanly
✅ Iterate with for ((key, value) in map) for both at once
✅ filter and mapValues create new maps — originals unchanged
✅ mapOf preserves insertion order (LinkedHashMap under the hood)
❌ getValue() throws if the key is missing — use carefully
❌ Don't use map["key"]!! unless you're certain the key exists
❌ Map keys must be unique — values don't have to be
❌ Modifying a map while iterating it causes ConcurrentModificationException
""",
  quiz: [
    Quiz(question: 'What does map["missingKey"] return in Kotlin if the key does not exist?', options: [
      QuizOption(text: 'null', correct: true),
      QuizOption(text: 'An empty string', correct: false),
      QuizOption(text: 'It throws NoSuchElementException', correct: false),
      QuizOption(text: 'The default value for that type', correct: false),
    ]),
    Quiz(question: 'Which statement about Map keys is true?', options: [
      QuizOption(text: 'Keys must be unique; values can repeat', correct: true),
      QuizOption(text: 'Both keys and values must be unique', correct: false),
      QuizOption(text: 'Keys can repeat; values must be unique', correct: false),
      QuizOption(text: 'Neither keys nor values have uniqueness constraints', correct: false),
    ]),
    Quiz(question: 'How do you iterate over both keys and values of a map simultaneously?', options: [
      QuizOption(text: 'for ((key, value) in map)', correct: true),
      QuizOption(text: 'for (entry in map.entries()) { entry.key; entry.value }', correct: false),
      QuizOption(text: 'map.forEachEntry { it.key; it.value }', correct: false),
      QuizOption(text: 'for (key in map) { map.get(key) }', correct: false),
    ]),
  ],
);
