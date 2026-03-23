import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson23 = Lesson(
  language: 'Java',
  title: 'Collections Framework Overview',
  content: """
🎯 METAPHOR:
The Java Collections Framework is like a professional
kitchen's storage system. You don't just dump everything
in a pile. Spices go in the spice rack (organized by name
— Map). Plates are stacked in order (List). Unique utensil
sizes go in their own slots (Set). The prep table queue
holds the next dishes to go out in order (Queue/Deque).
Each container has a specific purpose and PERFORMANCE
profile — reaching into the spice rack by name is instant
(HashMap = O(1)), while finding a specific plate in a pile
requires scanning (LinkedList search = O(n)).
Choosing the right container IS the skill.

📖 EXPLANATION:
The Java Collections Framework (JCF) is a unified
architecture for storing and manipulating groups of objects.

─────────────────────────────────────
THE COLLECTION HIERARCHY:
─────────────────────────────────────
  Iterable
  └── Collection
      ├── List       → ordered, duplicates allowed
      │   ├── ArrayList       (dynamic array)
      │   ├── LinkedList      (doubly linked list)
      │   └── Vector (legacy) / Stack (legacy)
      ├── Set        → no duplicates
      │   ├── HashSet         (unordered, fastest)
      │   ├── LinkedHashSet   (insertion order)
      │   └── TreeSet         (sorted)
      └── Queue / Deque
          ├── ArrayDeque      (fast stack/queue)
          ├── LinkedList      (also Queue)
          └── PriorityQueue   (heap, priority order)

  Map (NOT a Collection — but part of JCF)
      ├── HashMap             (unordered, fastest)
      ├── LinkedHashMap       (insertion order)
      ├── TreeMap             (sorted by key)
      └── Hashtable (legacy)

─────────────────────────────────────
CHOOSING THE RIGHT COLLECTION:
─────────────────────────────────────
  Need ordered access by index?       → ArrayList
  Need fast insert/delete at ends?    → ArrayDeque / LinkedList
  Need unique elements only?          → HashSet
  Need sorted unique elements?        → TreeSet
  Need key-value lookup?              → HashMap
  Need sorted key-value lookup?       → TreeMap
  Need priority ordering?             → PriorityQueue
  Need thread-safe?                   → ConcurrentHashMap,
                                        CopyOnWriteArrayList

─────────────────────────────────────
PERFORMANCE CHEAT SHEET:
─────────────────────────────────────
  Operation       ArrayList  LinkedList  HashSet  HashMap
  ──────────────────────────────────────────────────────
  get(index)      O(1) ✅    O(n) ❌     N/A      N/A
  add(end)        O(1)       O(1)        N/A      N/A
  add(middle)     O(n)       O(1)*       N/A      N/A
  remove(index)   O(n)       O(1)*       N/A      N/A
  contains        O(n)       O(n)        O(1) ✅  O(1) ✅
  get(key)        N/A        N/A         N/A      O(1) ✅

  * O(1) for LinkedList IF you have the iterator position

─────────────────────────────────────
COMMON OPERATIONS (all collections):
─────────────────────────────────────
  collection.add(element)
  collection.addAll(otherCollection)
  collection.remove(element)
  collection.contains(element)
  collection.size()
  collection.isEmpty()
  collection.clear()
  collection.iterator()
  collection.toArray()
  collection.stream()
  collection.forEach(action)

─────────────────────────────────────
CREATING COLLECTIONS:
─────────────────────────────────────
  // Mutable:
  List<String>   list = new ArrayList<>();
  Set<String>    set  = new HashSet<>();
  Map<String,Int> map = new HashMap<>();

  // Immutable (Java 9+):
  List<String>   list = List.of("a", "b", "c");
  Set<Integer>   set  = Set.of(1, 2, 3);
  Map<String,Int> map = Map.of("a", 1, "b", 2);

  // From array:
  List<String> fromArr = Arrays.asList("a", "b", "c");  // fixed-size
  List<String> fromArr = new ArrayList<>(Arrays.asList(...)); // mutable

─────────────────────────────────────
UTILITY CLASS: java.util.Collections:
─────────────────────────────────────
  Collections.sort(list)
  Collections.sort(list, comparator)
  Collections.reverse(list)
  Collections.shuffle(list)
  Collections.min(collection)
  Collections.max(collection)
  Collections.frequency(collection, element)
  Collections.unmodifiableList(list)
  Collections.synchronizedList(list)
  Collections.disjoint(c1, c2)    // true if no common elements
  Collections.nCopies(5, "hello") // list of 5 "hello"s

💻 CODE:
import java.util.*;
import java.util.stream.*;

public class CollectionsOverview {
    public static void main(String[] args) {

        // ─── CREATION PATTERNS ────────────────────────────
        System.out.println("=== Creation Patterns ===");

        // Mutable collections
        List<String> mutableList = new ArrayList<>(Arrays.asList("C", "A", "B"));
        Set<String>  mutableSet  = new HashSet<>(Arrays.asList("apple", "banana", "apple"));
        Map<String, Integer> mutableMap = new HashMap<>();
        mutableMap.put("one", 1); mutableMap.put("two", 2); mutableMap.put("three", 3);

        // Immutable (Java 9+)
        List<String> immutableList = List.of("x", "y", "z");
        Set<Integer> immutableSet  = Set.of(10, 20, 30);
        Map<String, String> immutableMap = Map.of("US", "Washington", "UK", "London");

        System.out.println("Mutable list: " + mutableList);
        System.out.println("Set (no dups): " + mutableSet);
        System.out.println("Map: " + mutableMap);

        // ─── COLLECTIONS UTILITY ──────────────────────────
        System.out.println("\n=== Collections Utility ===");
        List<Integer> nums = new ArrayList<>(Arrays.asList(5, 2, 8, 1, 9, 3, 7, 4, 6));

        System.out.println("Original:  " + nums);
        Collections.sort(nums);
        System.out.println("Sorted:    " + nums);
        Collections.reverse(nums);
        System.out.println("Reversed:  " + nums);
        System.out.println("Min: " + Collections.min(nums) + ", Max: " + Collections.max(nums));
        System.out.println("Freq of 5: " + Collections.frequency(nums, 5));

        Collections.shuffle(nums, new Random(42));  // seeded for reproducibility
        System.out.println("Shuffled:  " + nums);

        // ─── PERFORMANCE COMPARISON ───────────────────────
        System.out.println("\n=== Performance Comparison ===");

        // ArrayList vs LinkedList for different operations
        int N = 100_000;

        // ArrayList: fast random access
        List<Integer> arrayList = new ArrayList<>();
        for (int i = 0; i < N; i++) arrayList.add(i);

        long start = System.nanoTime();
        int sum = 0;
        for (int i = 0; i < N; i++) sum += arrayList.get(i);  // O(1) each
        long arrTime = System.nanoTime() - start;
        System.out.printf("  ArrayList random access (%d items): %.2fms%n",
            N, arrTime / 1_000_000.0);

        // LinkedList: fast add/remove at front
        LinkedList<Integer> linkedList = new LinkedList<>();
        start = System.nanoTime();
        for (int i = 0; i < 10_000; i++) linkedList.addFirst(i);  // O(1)
        long llTime = System.nanoTime() - start;
        System.out.printf("  LinkedList addFirst (10k items):  %.2fms%n",
            llTime / 1_000_000.0);

        // HashSet: O(1) contains
        Set<Integer> hashSet = new HashSet<>(arrayList);
        start = System.nanoTime();
        boolean found = hashSet.contains(N / 2);  // O(1)
        long hsTime = System.nanoTime() - start;
        System.out.printf("  HashSet.contains (O(1)):          %.3fms (%s)%n",
            hsTime / 1_000_000.0, found);

        // ─── UNMODIFIABLE WRAPPER ─────────────────────────
        System.out.println("\n=== Unmodifiable Collections ===");
        List<String> original = new ArrayList<>(Arrays.asList("a", "b", "c"));
        List<String> readOnly = Collections.unmodifiableList(original);
        System.out.println("Read-only: " + readOnly);
        try {
            readOnly.add("d");  // ❌ throws
        } catch (UnsupportedOperationException e) {
            System.out.println("  ❌ Cannot modify: " + e.getClass().getSimpleName());
        }

        // ─── CHOOSING THE RIGHT COLLECTION ───────────────
        System.out.println("\n=== Choosing the Right Collection ===");
        printChoice("Random access by index",   "ArrayList",       "O(1)");
        printChoice("Fast front/back add/remove","ArrayDeque",      "O(1)");
        printChoice("Unique elements",           "HashSet",         "O(1) contains");
        printChoice("Unique + insertion order",  "LinkedHashSet",   "O(1) + ordered");
        printChoice("Unique + sorted",           "TreeSet",         "O(log n)");
        printChoice("Key-value lookup",          "HashMap",         "O(1)");
        printChoice("Key-value + sorted",        "TreeMap",         "O(log n)");
        printChoice("Priority ordering",         "PriorityQueue",   "O(log n) poll");

        // ─── COMMON OPERATIONS ON ALL COLLECTIONS ─────────
        System.out.println("\n=== Common Collection Operations ===");
        List<String> fruits = new ArrayList<>(
            Arrays.asList("banana", "apple", "cherry", "apple", "date"));

        System.out.println("Size:       " + fruits.size());
        System.out.println("Contains:   " + fruits.contains("apple"));
        System.out.println("Count of apple: " + Collections.frequency(fruits, "apple"));

        fruits.remove("apple");  // removes FIRST occurrence
        System.out.println("After remove first 'apple': " + fruits);

        fruits.removeIf(s -> s.length() > 6);  // remove long words
        System.out.println("After removeIf(len>6): " + fruits);

        // Convert to set (remove duplicates)
        List<Integer> withDups = Arrays.asList(1, 2, 2, 3, 3, 3, 4);
        Set<Integer> unique = new LinkedHashSet<>(withDups); // preserves order
        System.out.println("Dedup: " + withDups + " → " + unique);

        // nCopies
        List<String> defaults = Collections.nCopies(5, "N/A");
        System.out.println("nCopies: " + defaults);
    }

    static void printChoice(String need, String collection, String performance) {
        System.out.printf("  %-30s → %-20s %s%n", need, collection, performance);
    }
}

📝 KEY POINTS:
✅ List: ordered, index-based, allows duplicates (ArrayList, LinkedList)
✅ Set: no duplicates (HashSet = fast, TreeSet = sorted, LinkedHashSet = ordered)
✅ Map: key-value pairs, keys are unique (HashMap, TreeMap, LinkedHashMap)
✅ Queue/Deque: FIFO/LIFO, front/back access (ArrayDeque, PriorityQueue)
✅ ArrayList: O(1) random access; LinkedList: O(1) front/back modification
✅ HashSet/HashMap: O(1) average contains/get — fastest for lookups
✅ TreeSet/TreeMap: always sorted, O(log n) operations
✅ Collections utility class: sort, reverse, shuffle, min, max, frequency
❌ LinkedList search (contains) is O(n) — use HashSet for fast membership tests
❌ List.of(), Set.of(), Map.of() return IMMUTABLE collections — no add/remove
❌ Arrays.asList() returns a fixed-size list — cannot add or remove elements
❌ Don't use Vector or Stack — they're legacy; use ArrayList and ArrayDeque instead
""",
  quiz: [
    Quiz(question: 'Which Java collection provides the fastest get(index) operation?', options: [
      QuizOption(text: 'ArrayList — backed by an array, providing O(1) random access', correct: true),
      QuizOption(text: 'LinkedList — each node stores a direct reference to the next', correct: false),
      QuizOption(text: 'HashSet — hash-based structures provide O(1) for all operations', correct: false),
      QuizOption(text: 'TreeList — sorted structure enables binary search retrieval', correct: false),
    ]),
    Quiz(question: 'What is the time complexity of contains() in a HashSet?', options: [
      QuizOption(text: 'O(1) average — hash-based lookup without scanning the whole set', correct: true),
      QuizOption(text: 'O(n) — must scan all elements to check for membership', correct: false),
      QuizOption(text: 'O(log n) — uses binary search on sorted elements', correct: false),
      QuizOption(text: 'O(n log n) — requires sorting before searching', correct: false),
    ]),
    Quiz(question: 'What does List.of("a", "b") return in Java 9+?', options: [
      QuizOption(text: 'An immutable list — add() and remove() throw UnsupportedOperationException', correct: true),
      QuizOption(text: 'A mutable ArrayList containing the given elements', correct: false),
      QuizOption(text: 'A fixed-size list that allows set() but not add() or remove()', correct: false),
      QuizOption(text: 'A synchronized list safe for concurrent modification', correct: false),
    ]),
  ],
);
