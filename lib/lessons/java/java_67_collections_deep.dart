import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson67 = Lesson(
  language: 'Java',
  title: 'Collections Deep Dive: Deque, PriorityQueue, and Patterns',
  content: """
🎯 METAPHOR:
Different collections are like different types of
containers in a warehouse. A Deque is a double-ended
conveyor belt — you can add or take from either end.
A PriorityQueue is a VIP entrance queue — the most
important person always goes next, not the person who's
been waiting longest. ArrayDeque beats LinkedList for
stacks and queues because it avoids pointer-chasing
(like a straight shelf vs. a treasure hunt).
Understanding which container to reach for — and why —
is what separates proficient Java developers from beginners.

📖 EXPLANATION:
This lesson covers the less-used but very powerful
collection types and patterns beyond the basics.

─────────────────────────────────────
DEQUE — DOUBLE-ENDED QUEUE:
─────────────────────────────────────
  Deque<T>: supports add/remove from BOTH ends.
  Best implementation: ArrayDeque (backed by resizable array).
  Beats LinkedList for stack/queue use (no node allocation).

  ArrayDeque<String> deque = new ArrayDeque<>();

  // Stack (LIFO):
  deque.push("a");           // addFirst
  deque.pop();               // removeFirst → "a"
  deque.peek();              // peekFirst

  // Queue (FIFO):
  deque.offer("a");          // addLast
  deque.poll();              // removeFirst → "a"
  deque.peekFirst();

  // Both ends:
  deque.addFirst("head");    deque.addLast("tail");
  deque.pollFirst();         deque.pollLast();
  deque.peekFirst();         deque.peekLast();

─────────────────────────────────────
PRIORITYQUEUE — HEAP-BASED:
─────────────────────────────────────
  PriorityQueue<Integer> pq = new PriorityQueue<>(); // min-heap
  pq.add(5); pq.add(1); pq.add(3);
  pq.poll()  → 1 (smallest always first)
  pq.peek()  → next without removing

  // Max-heap:
  PriorityQueue<Integer> maxPQ = new PriorityQueue<>(
      Comparator.reverseOrder());

  // By field:
  PriorityQueue<Task> taskPQ = new PriorityQueue<>(
      Comparator.comparingInt(Task::getPriority));

  ⚠️ Iteration order is NOT sorted — only poll() is ordered.

─────────────────────────────────────
COLLECTIONS ALGORITHM PATTERNS:
─────────────────────────────────────
  SLIDING WINDOW (using ArrayDeque):
  Find max in each window of size k:
  Deque<Integer> window = new ArrayDeque<>();
  // Maintain decreasing indices in window

  MONOTONIC STACK (pattern):
  Find next greater element:
  Deque<Integer> stack = new ArrayDeque<>();
  for (int i = n - 1; i >= 0; i--) {
      while (!stack.isEmpty() && stack.peek() <= arr[i])
          stack.pop();
      result[i] = stack.isEmpty() ? -1 : stack.peek();
      stack.push(arr[i]);
  }

  FREQUENCY MAP:
  Map<String, Long> freq = words.stream()
      .collect(Collectors.groupingBy(
          Function.identity(), Collectors.counting()));

  TOP-K ELEMENTS (with min-heap of size k):
  PriorityQueue<Integer> topK = new PriorityQueue<>(k);
  for (int n : nums) {
      topK.offer(n);
      if (topK.size() > k) topK.poll();
  }
  // topK now contains the k largest elements

─────────────────────────────────────
NAVIGABLESETS AND MAPS:
─────────────────────────────────────
  TreeSet/TreeMap implement NavigableSet/NavigableMap.

  TreeSet<Integer> ts = new TreeSet<>(data);
  ts.floor(5)    → largest element ≤ 5
  ts.ceiling(5)  → smallest element ≥ 5
  ts.lower(5)    → strictly less than 5
  ts.higher(5)   → strictly greater than 5
  ts.headSet(5)  → elements < 5
  ts.tailSet(5)  → elements ≥ 5
  ts.subSet(3,7) → [3, 7)

  TreeMap<K,V>:
  map.firstKey() / lastKey()
  map.floorKey(key) / ceilingKey(key)
  map.lowerKey(key) / higherKey(key)
  map.headMap(key) / tailMap(key) / subMap(from, to)

─────────────────────────────────────
COLLECTIONS UTILITY OPERATIONS:
─────────────────────────────────────
  Collections.disjoint(c1, c2)    → true if no common elements
  Collections.nCopies(5, "x")     → immutable ["x","x","x","x","x"]
  Collections.frequency(c, obj)   → count occurrences
  Collections.replaceAll(list, fn)→ replace all elements
  Collections.unmodifiableList(l) → read-only wrapper
  Collections.synchronizedList(l) → thread-safe wrapper

  // Synchronized collections vs concurrent:
  // Collections.synchronizedX() → synchronized on every call (coarse)
  // ConcurrentHashMap, CopyOnWriteArrayList → fine-grained concurrent

─────────────────────────────────────
COPYONWRITE — thread-safe reads:
─────────────────────────────────────
  CopyOnWriteArrayList<String> cowList = new CopyOnWriteArrayList<>();
  // Reads: fast, no locking, snapshot of array
  // Writes: create a new copy — slow but thread-safe

  Use for: event listener lists (rarely modified, often read)

💻 CODE:
import java.util.*;
import java.util.stream.*;

public class CollectionsDeepDive {
    public static void main(String[] args) {

        // ─── ARRAYDEQUE AS STACK ──────────────────────────
        System.out.println("=== ArrayDeque as Stack ===");
        Deque<String> stack = new ArrayDeque<>();
        stack.push("first"); stack.push("second"); stack.push("third");
        System.out.println("  Stack: " + stack);
        while (!stack.isEmpty()) System.out.println("  pop: " + stack.pop());

        // ─── ARRAYDEQUE AS QUEUE ──────────────────────────
        System.out.println("\n=== ArrayDeque as Queue ===");
        Deque<Integer> queue = new ArrayDeque<>();
        for (int i = 1; i <= 5; i++) queue.offer(i);
        System.out.println("  Queue: " + queue);
        while (!queue.isEmpty()) System.out.print(queue.poll() + " ");
        System.out.println();

        // ─── PRIORITYQUEUE ────────────────────────────────
        System.out.println("\n=== PriorityQueue ===");
        record Task(String name, int priority) {}

        PriorityQueue<Task> taskQ = new PriorityQueue<>(
            Comparator.comparingInt(Task::priority));

        taskQ.add(new Task("Deploy", 3));
        taskQ.add(new Task("Critical Bug", 1));
        taskQ.add(new Task("Refactor", 5));
        taskQ.add(new Task("Security Patch", 1));
        taskQ.add(new Task("Feature", 4));

        System.out.println("  Processing by priority:");
        while (!taskQ.isEmpty()) {
            Task t = taskQ.poll();
            System.out.printf("  [P%d] %s%n", t.priority(), t.name());
        }

        // ─── TOP-K PATTERN ────────────────────────────────
        System.out.println("\n=== Top-K Pattern ===");
        int[] scores = {45, 92, 78, 65, 88, 71, 95, 55, 82, 69};
        int k = 3;

        // Min-heap of size k → gives top k largest
        PriorityQueue<Integer> topK = new PriorityQueue<>(k);
        for (int score : scores) {
            topK.offer(score);
            if (topK.size() > k) topK.poll();  // remove smallest if over k
        }
        List<Integer> topKList = new ArrayList<>(topK);
        Collections.sort(topKList, Collections.reverseOrder());
        System.out.println("  All scores: " + Arrays.toString(scores));
        System.out.println("  Top " + k + ": " + topKList);

        // ─── TREESET NAVIGATION ───────────────────────────
        System.out.println("\n=== NavigableSet (TreeSet) ===");
        TreeSet<Integer> ts = new TreeSet<>(Arrays.asList(2, 5, 8, 12, 18, 23, 31));
        System.out.println("  Set: " + ts);
        System.out.println("  floor(10):    " + ts.floor(10));     // 8
        System.out.println("  ceiling(10):  " + ts.ceiling(10));   // 12
        System.out.println("  lower(8):     " + ts.lower(8));      // 5
        System.out.println("  higher(8):    " + ts.higher(8));     // 12
        System.out.println("  headSet(10):  " + ts.headSet(10));   // [2,5,8]
        System.out.println("  tailSet(10):  " + ts.tailSet(10));   // [12,18,23,31]
        System.out.println("  subSet(5,18): " + ts.subSet(5, 18)); // [5,8,12]

        // ─── FREQUENCY MAP PATTERN ────────────────────────
        System.out.println("\n=== Frequency Map Pattern ===");
        String text = "the quick brown fox jumps over the lazy dog the";
        Map<String, Long> freq = Arrays.stream(text.split("\\s+"))
            .collect(Collectors.groupingBy(w -> w, Collectors.counting()));
        System.out.println("  Word frequencies (sorted by count desc):");
        freq.entrySet().stream()
            .sorted(Map.Entry.<String, Long>comparingByValue().reversed()
                .thenComparing(Map.Entry.comparingByKey()))
            .forEach(e -> System.out.printf("    %-10s %d%n", e.getKey(), e.getValue()));

        // ─── MONOTONIC STACK ──────────────────────────────
        System.out.println("\n=== Monotonic Stack (Next Greater Element) ===");
        int[] arr = {2, 1, 5, 3, 6, 4, 8, 9};
        int[] nextGreater = new int[arr.length];
        Deque<Integer> monoStack = new ArrayDeque<>();

        for (int i = arr.length - 1; i >= 0; i--) {
            while (!monoStack.isEmpty() && monoStack.peek() <= arr[i])
                monoStack.pop();
            nextGreater[i] = monoStack.isEmpty() ? -1 : monoStack.peek();
            monoStack.push(arr[i]);
        }
        System.out.println("  Input:        " + Arrays.toString(arr));
        System.out.println("  Next greater: " + Arrays.toString(nextGreater));

        // ─── COLLECTIONS UTILITIES ────────────────────────
        System.out.println("\n=== Collections Utilities ===");
        List<Integer> nums = new ArrayList<>(Arrays.asList(3, 1, 4, 1, 5, 9, 2, 6));
        System.out.println("  Original:    " + nums);
        System.out.println("  frequency(1):" + Collections.frequency(nums, 1));
        System.out.println("  nCopies(3,X):" + Collections.nCopies(3, "X"));

        List<Integer> set1 = List.of(1, 2, 3);
        List<Integer> set2 = List.of(4, 5, 6);
        List<Integer> set3 = List.of(3, 4, 5);
        System.out.println("  disjoint({1,2,3},{4,5,6}): " + Collections.disjoint(set1, set2));
        System.out.println("  disjoint({1,2,3},{3,4,5}): " + Collections.disjoint(set1, set3));
    }
}

📝 KEY POINTS:
✅ ArrayDeque is the preferred stack/queue — faster than LinkedList, no null allowed
✅ PriorityQueue polls elements in priority order (min by default) — not insertion order
✅ Iteration over PriorityQueue is NOT sorted — only poll() guarantees order
✅ Top-K pattern: min-heap of size k, poll smallest when over k
✅ TreeSet/TreeMap NavigableSet/Map: floor/ceiling/lower/higher for range queries
✅ Monotonic stack pattern: find next/previous greater/smaller in O(n)
✅ Collections.disjoint() efficiently checks if two collections share no elements
✅ CopyOnWriteArrayList: fast reads, slow writes — ideal for listener lists
❌ ArrayDeque does NOT allow null elements — use LinkedList if null is needed
❌ PriorityQueue peek() and iterator() do NOT guarantee sorted order — only poll() does
❌ Don't sort a PriorityQueue for display — drain it: while(!pq.isEmpty()) pq.poll()
❌ CopyOnWriteArrayList's write cost (full copy) makes it expensive for frequent writes
""",
  quiz: [
    Quiz(question: 'Why is ArrayDeque preferred over LinkedList for stack/queue operations?', options: [
      QuizOption(text: 'ArrayDeque uses a contiguous array — faster cache-friendly access, no node allocation overhead', correct: true),
      QuizOption(text: 'ArrayDeque supports null elements while LinkedList does not', correct: false),
      QuizOption(text: 'ArrayDeque is thread-safe; LinkedList requires external synchronization', correct: false),
      QuizOption(text: 'LinkedList has O(n) push/pop while ArrayDeque has O(1)', correct: false),
    ]),
    Quiz(question: 'What does PriorityQueue.peek() return?', options: [
      QuizOption(text: 'The highest-priority element without removing it — but iterating the queue does NOT produce elements in order', correct: true),
      QuizOption(text: 'The last element added to the queue', correct: false),
      QuizOption(text: 'A sorted snapshot of the entire queue', correct: false),
      QuizOption(text: 'The element at the head of the internal heap array', correct: false),
    ]),
    Quiz(question: 'What does TreeSet.floor(x) return?', options: [
      QuizOption(text: 'The greatest element in the set that is less than or equal to x', correct: true),
      QuizOption(text: 'The smallest element in the set that is greater than or equal to x', correct: false),
      QuizOption(text: 'The element immediately before x in insertion order', correct: false),
      QuizOption(text: 'x rounded down to the nearest integer in the set', correct: false),
    ]),
  ],
);
