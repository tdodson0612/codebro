import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson25 = Lesson(
  language: 'Java',
  title: 'Iterators and for-each',
  content: """
🎯 METAPHOR:
An iterator is like a bookmark that walks through a book.
The bookmark knows two things: "Is there a next page?"
(hasNext()) and "Give me the next page and advance"
(next()). You don't care how the book stores its pages —
whether they're stapled, looseleaf, or digital — the
bookmark interface works the same way. The for-each loop
is the friendly librarian who handles the bookmark for you:
you just say "read every page" and they turn pages for you
automatically. The iterator is the underlying mechanism;
for-each is the clean facade on top.

📖 EXPLANATION:
Java provides two ways to traverse collections: the explicit
Iterator and the enhanced for-each loop.

─────────────────────────────────────
THE Iterator INTERFACE:
─────────────────────────────────────
  Iterator<T> from java.util.Iterator:
    boolean hasNext()  → true if more elements remain
    T next()           → returns next element and advances
    void remove()      → removes the last returned element (optional)

  Usage:
  Iterator<String> it = list.iterator();
  while (it.hasNext()) {
      String element = it.next();
      System.out.println(element);
  }

─────────────────────────────────────
SAFE REMOVAL WITH ITERATOR:
─────────────────────────────────────
  // ❌ WRONG — ConcurrentModificationException!
  for (String s : list) {
      if (s.startsWith("x")) list.remove(s);
  }

  // ✅ CORRECT — use iterator.remove():
  Iterator<String> it = list.iterator();
  while (it.hasNext()) {
      if (it.next().startsWith("x")) {
          it.remove();   // safe — marks for removal
      }
  }

  // ✅ BETTER (Java 8+) — use removeIf():
  list.removeIf(s -> s.startsWith("x"));

─────────────────────────────────────
for-each LOOP (enhanced for):
─────────────────────────────────────
  for (Type element : collection) {
      // use element
  }

  Works with:
  ✅ Any Iterable (List, Set, Queue, etc.)
  ✅ Arrays
  ✅ Any class that implements Iterable<T>

  Limitations:
  ❌ Cannot get the current index
  ❌ Cannot modify the collection (use iterator.remove())
  ❌ Cannot iterate multiple collections at once

─────────────────────────────────────
ListIterator — bidirectional:
─────────────────────────────────────
  Only for Lists. Extends Iterator with:
  boolean hasPrevious()    → can go backwards?
  T previous()             → go to previous element
  int nextIndex()          → index of next element
  int previousIndex()      → index of previous element
  void set(T e)            → replace last returned element
  void add(T e)            → insert before next element

─────────────────────────────────────
Iterable — making your class foreach-able:
─────────────────────────────────────
  class NumberRange implements Iterable<Integer> {
      private int start, end;

      public NumberRange(int start, int end) {
          this.start = start; this.end = end;
      }

      @Override
      public Iterator<Integer> iterator() {
          return new Iterator<>() {
              int current = start;
              @Override public boolean hasNext() { return current <= end; }
              @Override public Integer next() { return current++; }
          };
      }
  }

  for (int n : new NumberRange(1, 5)) {
      System.out.print(n + " ");  // 1 2 3 4 5
  }

─────────────────────────────────────
forEach METHOD (Java 8+):
─────────────────────────────────────
  list.forEach(System.out::println);         // method reference
  list.forEach(s -> System.out.println(s));  // lambda
  map.forEach((k, v) -> println(k + "=" + v));

💻 CODE:
import java.util.*;
import java.util.function.Consumer;

// ─── CUSTOM Iterable ──────────────────────────────────
class Range implements Iterable<Integer> {
    private final int start, end, step;

    public Range(int start, int end, int step) {
        this.start = start;
        this.end   = end;
        this.step  = step;
    }

    public Range(int start, int end) { this(start, end, 1); }

    @Override
    public Iterator<Integer> iterator() {
        return new Iterator<>() {
            private int current = start;

            @Override
            public boolean hasNext() {
                return step > 0 ? current < end : current > end;
            }

            @Override
            public Integer next() {
                if (!hasNext()) throw new NoSuchElementException();
                int value = current;
                current += step;
                return value;
            }
        };
    }
}

// ─── Linked list structure (own iterator) ─────────────
class SimpleLinkedList<T> implements Iterable<T> {
    private static class Node<T> {
        T data;
        Node<T> next;
        Node(T data) { this.data = data; }
    }

    private Node<T> head;
    private int size;

    public void add(T item) {
        Node<T> node = new Node<>(item);
        if (head == null) { head = node; return; }
        Node<T> cur = head;
        while (cur.next != null) cur = cur.next;
        cur.next = node;
        size++;
    }

    public int size() { return size + (head == null ? 0 : 1); }

    @Override
    public Iterator<T> iterator() {
        return new Iterator<>() {
            Node<T> current = head;

            @Override public boolean hasNext() { return current != null; }

            @Override
            public T next() {
                if (!hasNext()) throw new NoSuchElementException();
                T value = current.data;
                current = current.next;
                return value;
            }
        };
    }
}

public class IteratorsAndForEach {
    public static void main(String[] args) {

        // ─── EXPLICIT ITERATOR ────────────────────────────
        System.out.println("=== Explicit Iterator ===");
        List<String> words = new ArrayList<>(
            Arrays.asList("apple", "banana", "cherry", "date", "elderberry"));

        Iterator<String> it = words.iterator();
        while (it.hasNext()) {
            String word = it.next();
            System.out.printf("  %s (len=%d)%n", word, word.length());
        }

        // ─── SAFE REMOVAL WITH ITERATOR ───────────────────
        System.out.println("\n=== Safe removal with iterator ===");
        List<Integer> numbers = new ArrayList<>(
            Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10));
        System.out.println("Before: " + numbers);

        // Remove all odd numbers using iterator
        Iterator<Integer> numIt = numbers.iterator();
        while (numIt.hasNext()) {
            if (numIt.next() % 2 != 0) numIt.remove();
        }
        System.out.println("After (evens only): " + numbers);

        // Modern alternative: removeIf
        List<String> names = new ArrayList<>(
            Arrays.asList("Alice", "Bob", "Alexander", "Ann", "Charlie"));
        names.removeIf(name -> name.startsWith("A"));
        System.out.println("After removeIf (no A): " + names);

        // ─── for-each ─────────────────────────────────────
        System.out.println("\n=== for-each ===");
        String[] planets = {"Mercury", "Venus", "Earth", "Mars"};
        for (String planet : planets) {
            System.out.println("  🪐 " + planet);
        }

        Set<Integer> primes = new LinkedHashSet<>(
            Arrays.asList(2, 3, 5, 7, 11, 13, 17, 19));
        int sum = 0;
        for (int prime : primes) sum += prime;
        System.out.println("  Sum of primes: " + sum);

        // ─── ListIterator — bidirectional ──────────────────
        System.out.println("\n=== ListIterator (bidirectional) ===");
        List<String> letters = new ArrayList<>(
            Arrays.asList("a", "b", "c", "d", "e"));

        System.out.print("Forward:  ");
        ListIterator<String> lit = letters.listIterator();
        while (lit.hasNext()) System.out.print(lit.next() + " ");
        System.out.println();

        System.out.print("Backward: ");
        while (lit.hasPrevious()) System.out.print(lit.previous() + " ");
        System.out.println();

        // Modify while iterating with listIterator
        ListIterator<String> modIt = letters.listIterator();
        while (modIt.hasNext()) {
            String letter = modIt.next();
            modIt.set(letter.toUpperCase());  // modify in place
        }
        System.out.println("Uppercased: " + letters);

        // ─── CUSTOM Iterable ──────────────────────────────
        System.out.println("\n=== Custom Iterable (Range) ===");
        Range r1 = new Range(1, 11);       // 1 to 10
        Range r2 = new Range(0, 20, 3);    // 0,3,6,...,18
        Range r3 = new Range(10, 0, -1);   // 10,9,...,1

        System.out.print("1..10:      ");
        for (int n : r1) System.out.print(n + " ");
        System.out.println();

        System.out.print("0..18 ×3:   ");
        for (int n : r2) System.out.print(n + " ");
        System.out.println();

        System.out.print("10..1 (rev):");
        for (int n : r3) System.out.print(n + " ");
        System.out.println();

        // ─── CUSTOM SimpleLinkedList ──────────────────────
        System.out.println("\n=== Custom LinkedList with Iterator ===");
        SimpleLinkedList<String> ll = new SimpleLinkedList<>();
        ll.add("one"); ll.add("two"); ll.add("three"); ll.add("four");

        System.out.print("for-each: ");
        for (String s : ll) System.out.print(s + " ");
        System.out.println();

        // ─── forEach METHOD ───────────────────────────────
        System.out.println("\n=== forEach method ===");
        List<String> langs = List.of("Java", "Kotlin", "Python", "JavaScript");

        // Method reference
        langs.forEach(System.out::println);

        // Lambda
        Map<String, Integer> scores = Map.of("Alice", 95, "Bob", 82, "Carol", 91);
        System.out.println();
        new TreeMap<>(scores).forEach((name, score) ->
            System.out.printf("  %-8s → %d %s%n",
                name, score, "★".repeat(score / 20)));
    }
}

📝 KEY POINTS:
✅ Iterator.hasNext() checks; .next() retrieves and advances
✅ Never call next() without first checking hasNext()
✅ Use iterator.remove() to safely remove while iterating
✅ for-each is cleaner but doesn't give you the index or safe removal
✅ removeIf(predicate) is the modern way to conditionally remove (Java 8+)
✅ ListIterator supports bidirectional traversal and set() while iterating
✅ Implement Iterable<T> to make your class usable in for-each loops
✅ forEach(lambda) is a clean alternative for side-effect loops
❌ Never modify a collection with add/remove inside a for-each — ConcurrentModificationException
❌ Calling next() when hasNext() is false throws NoSuchElementException
❌ Iterator.remove() can only be called once per next() call
❌ for-each cannot iterate multiple collections simultaneously — use index for that
""",
  quiz: [
    Quiz(question: 'Why does modifying a List with add() or remove() inside a for-each loop cause an exception?', options: [
      QuizOption(text: 'The for-each loop uses an iterator internally and detects structural modification — throwing ConcurrentModificationException', correct: true),
      QuizOption(text: 'for-each creates an immutable snapshot of the list at the start', correct: false),
      QuizOption(text: 'Java prevents all modifications to collections while any reference to them exists', correct: false),
      QuizOption(text: 'The loop variable becomes null when the list is modified', correct: false),
    ]),
    Quiz(question: 'What is the safe way to remove elements from a List while iterating?', options: [
      QuizOption(text: 'Use iterator.remove() or the removeIf(predicate) method', correct: true),
      QuizOption(text: 'Use a for-each loop with list.remove() inside', correct: false),
      QuizOption(text: 'Create a new list and replace the original after iteration', correct: false),
      QuizOption(text: 'Use a synchronized block around the remove call', correct: false),
    ]),
    Quiz(question: 'What extra capability does ListIterator have over a regular Iterator?', options: [
      QuizOption(text: 'It can traverse backwards (hasPrevious/previous) and replace/add elements during iteration', correct: true),
      QuizOption(text: 'It is thread-safe and can be shared between multiple threads', correct: false),
      QuizOption(text: 'It supports faster access than a regular iterator', correct: false),
      QuizOption(text: 'It works on Sets and Maps in addition to Lists', correct: false),
    ]),
  ],
);
