import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson71 = Lesson(
  language: 'Java',
  title: 'Data Structures from Scratch in Java',
  content: """
🎯 METAPHOR:
Building data structures from scratch is like a chef
learning to make knives before cooking. You don't NEED
to forge your own knives to cook — Java's collections
provide excellent ready-made tools. But understanding
how a linked list, binary search tree, or hash map is
built reveals WHY they behave the way they do. Why is
HashMap O(1) but TreeMap O(log n)? Why does LinkedList
beat ArrayList at insertions but lose at random access?
The internals answer these questions, and that knowledge
makes you a better user of the built-in tools.

📖 EXPLANATION:
Implementing classic data structures teaches the
complexity guarantees of Java's built-in collections.

─────────────────────────────────────
SINGLY LINKED LIST:
─────────────────────────────────────
  class Node<T> {
      T data;
      Node<T> next;
      Node(T data) { this.data = data; }
  }

  Operations:
  addFirst(T) → O(1)  — update head pointer
  addLast(T)  → O(n)  — traverse to tail
  removeFirst()→ O(1) — update head pointer
  contains(T) → O(n)  — linear scan
  size()      → O(n)  — count nodes

  WHY Java's LinkedList uses doubly-linked:
  → addLast and removeLast also O(1) with tail pointer

─────────────────────────────────────
BINARY SEARCH TREE:
─────────────────────────────────────
  BST property: left < node < right at every node.

  insert(T) → O(h) where h = tree height
  search(T) → O(h)
  delete(T) → O(h)

  Balanced BST (AVL, Red-Black): h = O(log n) guaranteed
  Unbalanced (sorted inserts): h = O(n) — degrades to list

  WHY TreeMap/TreeSet are O(log n):
  → They use Red-Black tree — always balanced

─────────────────────────────────────
HASH MAP (simplified):
─────────────────────────────────────
  Array of buckets + hash function:

  bucket_index = key.hashCode() % capacity

  Collision resolution:
  → Chaining (linked list per bucket)
  → Open addressing (linear probe)

  Java's HashMap: chaining, but long chains (>8)
  converted to Red-Black trees (Java 8+).

  put(K, V)  → O(1) average, O(n) worst (all in one bucket)
  get(K)     → O(1) average
  Load factor: 0.75 default → resize at 75% capacity

─────────────────────────────────────
STACK (using array):
─────────────────────────────────────
  class Stack<T> {
      Object[] data = new Object[16];
      int top = -1;

      void push(T item) {
          if (++top == data.length) resize();
          data[top] = item;
      }
      @SuppressWarnings("unchecked")
      T pop() { return (T) data[top--]; }
      T peek() { return (T) data[top]; }
  }

  All operations O(1) amortized (resize is O(n) but rare).
  WHY ArrayDeque beats LinkedList for stacks:
  → No node allocation, cache-friendly contiguous memory.

─────────────────────────────────────
MIN HEAP:
─────────────────────────────────────
  Array-based binary heap where parent ≤ children.
  Parent of index i: (i-1)/2
  Children of index i: 2*i+1 and 2*i+2

  insert(T): add to end, sift up  → O(log n)
  extractMin(): remove root, move last to root, sift down → O(log n)
  peek(): array[0] → O(1)

  WHY PriorityQueue uses heap:
  → O(log n) insert/remove, O(1) peek, O(n) space.

─────────────────────────────────────
GRAPH REPRESENTATION:
─────────────────────────────────────
  Adjacency List (preferred for sparse graphs):
  Map<Integer, List<Integer>> graph = new HashMap<>();

  Adjacency Matrix (dense graphs):
  boolean[][] adj = new boolean[V][V];

  BFS: Queue-based, finds shortest path in unweighted graph
  DFS: Stack/recursion based, topological sort, cycle detection

💻 CODE:
import java.util.*;

// ─── GENERIC LINKED LIST ──────────────────────────────
class SinglyLinkedList<T> implements Iterable<T> {
    private static class Node<T> {
        T data; Node<T> next;
        Node(T d) { data = d; }
    }

    private Node<T> head;
    private int size;

    public void addFirst(T item) {
        Node<T> n = new Node<>(item);
        n.next = head; head = n; size++;
    }

    public void addLast(T item) {
        Node<T> n = new Node<>(item);
        if (head == null) { head = n; }
        else {
            Node<T> cur = head;
            while (cur.next != null) cur = cur.next;
            cur.next = n;
        }
        size++;
    }

    public T removeFirst() {
        if (head == null) throw new NoSuchElementException();
        T val = head.data; head = head.next; size--; return val;
    }

    public boolean contains(T item) {
        for (Node<T> cur = head; cur != null; cur = cur.next)
            if (Objects.equals(cur.data, item)) return true;
        return false;
    }

    public void reverse() {
        Node<T> prev = null, cur = head;
        while (cur != null) {
            Node<T> next = cur.next;
            cur.next = prev; prev = cur; cur = next;
        }
        head = prev;
    }

    public int size() { return size; }

    @Override
    public Iterator<T> iterator() {
        return new Iterator<>() {
            Node<T> current = head;
            public boolean hasNext() { return current != null; }
            public T next() { T d = current.data; current = current.next; return d; }
        };
    }

    @Override public String toString() {
        StringBuilder sb = new StringBuilder("[");
        for (Node<T> c = head; c != null; c = c.next) {
            if (sb.length() > 1) sb.append(" → ");
            sb.append(c.data);
        }
        return sb.append("]").toString();
    }
}

// ─── MIN HEAP ─────────────────────────────────────────
class MinHeap {
    private int[] data;
    private int size;

    MinHeap(int capacity) { data = new int[capacity]; }

    void insert(int val) {
        if (size == data.length) data = Arrays.copyOf(data, size * 2);
        data[size] = val;
        siftUp(size++);
    }

    int peek() { if (size == 0) throw new NoSuchElementException(); return data[0]; }

    int extractMin() {
        int min = peek();
        data[0] = data[--size];
        if (size > 0) siftDown(0);
        return min;
    }

    private void siftUp(int i) {
        while (i > 0) {
            int parent = (i - 1) / 2;
            if (data[parent] <= data[i]) break;
            swap(i, parent); i = parent;
        }
    }

    private void siftDown(int i) {
        while (true) {
            int smallest = i, l = 2*i+1, r = 2*i+2;
            if (l < size && data[l] < data[smallest]) smallest = l;
            if (r < size && data[r] < data[smallest]) smallest = r;
            if (smallest == i) break;
            swap(i, smallest); i = smallest;
        }
    }

    private void swap(int i, int j) { int t = data[i]; data[i] = data[j]; data[j] = t; }
    int size() { return size; }
}

// ─── GRAPH + BFS/DFS ──────────────────────────────────
class Graph {
    private final Map<Integer, List<Integer>> adj = new HashMap<>();

    void addEdge(int u, int v) {
        adj.computeIfAbsent(u, k -> new ArrayList<>()).add(v);
        adj.computeIfAbsent(v, k -> new ArrayList<>()).add(u);
    }

    List<Integer> bfs(int start) {
        List<Integer> visited = new ArrayList<>();
        Set<Integer> seen = new HashSet<>();
        Queue<Integer> queue = new LinkedList<>();
        queue.offer(start); seen.add(start);
        while (!queue.isEmpty()) {
            int node = queue.poll();
            visited.add(node);
            for (int neighbor : adj.getOrDefault(node, List.of())) {
                if (!seen.contains(neighbor)) {
                    seen.add(neighbor); queue.offer(neighbor);
                }
            }
        }
        return visited;
    }

    List<Integer> dfs(int start) {
        List<Integer> visited = new ArrayList<>();
        dfsHelper(start, new HashSet<>(), visited);
        return visited;
    }

    private void dfsHelper(int node, Set<Integer> seen, List<Integer> visited) {
        seen.add(node); visited.add(node);
        for (int neighbor : adj.getOrDefault(node, List.of())) {
            if (!seen.contains(neighbor)) dfsHelper(neighbor, seen, visited);
        }
    }
}

public class DataStructures {
    public static void main(String[] args) {

        // ─── LINKED LIST ──────────────────────────────────
        System.out.println("=== Singly Linked List ===");
        SinglyLinkedList<Integer> list = new SinglyLinkedList<>();
        for (int i = 1; i <= 5; i++) list.addLast(i);
        System.out.println("  List: " + list);
        list.addFirst(0);
        System.out.println("  After addFirst(0): " + list);
        System.out.println("  Contains 3: " + list.contains(3));
        list.reverse();
        System.out.println("  Reversed: " + list);
        System.out.println("  removeFirst: " + list.removeFirst() + " → " + list);

        // ─── MIN HEAP ─────────────────────────────────────
        System.out.println("\n=== Min Heap ===");
        MinHeap heap = new MinHeap(16);
        int[] values = {5, 3, 8, 1, 9, 2, 7, 4, 6};
        for (int v : values) heap.insert(v);
        System.out.println("  Inserted: " + Arrays.toString(values));
        System.out.print("  Extract all (sorted): ");
        while (heap.size() > 0) System.out.print(heap.extractMin() + " ");
        System.out.println();

        // ─── GRAPH BFS/DFS ────────────────────────────────
        System.out.println("\n=== Graph Traversal ===");
        //     1
        //    / \\
        //   2   3
        //  / \\   \\
        // 4   5   6
        Graph g = new Graph();
        g.addEdge(1, 2); g.addEdge(1, 3);
        g.addEdge(2, 4); g.addEdge(2, 5);
        g.addEdge(3, 6);

        System.out.println("  BFS from 1: " + g.bfs(1));
        System.out.println("  DFS from 1: " + g.dfs(1));

        // ─── COMPLEXITY SUMMARY ───────────────────────────
        System.out.println("\n=== Complexity Summary ===");
        String[][] table = {
            { "Structure",    "Access", "Search", "Insert", "Delete" },
            { "ArrayList",    "O(1)",   "O(n)",   "O(n)",   "O(n)" },
            { "LinkedList",   "O(n)",   "O(n)",   "O(1)*",  "O(1)*" },
            { "ArrayDeque",   "O(1)",   "O(n)",   "O(1)",   "O(1)" },
            { "HashSet/Map",  "O(1)",   "O(1)",   "O(1)",   "O(1)" },
            { "TreeSet/Map",  "O(logn)","O(logn)","O(logn)","O(logn)"},
            { "PriorityQueue","O(1)",   "O(n)",   "O(logn)","O(logn)"},
        };
        for (String[] row : table) {
            System.out.printf("  %-15s %-8s %-8s %-8s %-8s%n",
                row[0], row[1], row[2], row[3], row[4]);
        }
        System.out.println("  * LinkedList insert/delete O(1) only if you have the iterator position");
    }
}

📝 KEY POINTS:
✅ Linked list O(1) at head; O(n) traversal — explains why ArrayList beats it for random access
✅ Binary heap insert/delete O(log n) — explains PriorityQueue's complexity
✅ Hash map O(1) average — explains HashMap/HashSet speed (good hash function required)
✅ BST search O(h) — balanced gives O(log n), degenerate gives O(n)
✅ BFS uses a queue (finds shortest path in unweighted graph)
✅ DFS uses recursion/stack (good for topological sort, cycle detection)
✅ Array-backed structures (ArrayList, ArrayDeque) have better cache locality than linked
✅ Java's HashMap converts long chains (>8) to Red-Black trees — O(log n) worst case
❌ LinkedList's O(1) insert only applies if you already have the iterator/node reference
❌ Unbalanced BST (e.g., sorted inserts) degrades to O(n) — TreeMap uses Red-Black tree
❌ HashMap worst case is O(n) — all keys hash to same bucket (hash collision attack)
❌ Don't use recursion for DFS on large graphs — stack overflow; use explicit stack
""",
  quiz: [
    Quiz(question: 'Why does HashMap have O(1) average complexity but O(n) worst case?', options: [
      QuizOption(text: 'Average: keys distribute across buckets (O(1) lookup). Worst: all keys hash to same bucket (O(n) linear scan)', correct: true),
      QuizOption(text: 'O(1) is for reads; O(n) happens during resizing when the load factor is exceeded', correct: false),
      QuizOption(text: 'O(n) occurs when the map contains null keys that require special handling', correct: false),
      QuizOption(text: 'O(1) is only guaranteed for String keys; other types degrade to O(n)', correct: false),
    ]),
    Quiz(question: 'What traversal algorithm finds the shortest path in an unweighted graph?', options: [
      QuizOption(text: 'BFS (Breadth-First Search) — it explores all nodes at distance k before any at distance k+1', correct: true),
      QuizOption(text: 'DFS (Depth-First Search) — it follows edges to their deepest point', correct: false),
      QuizOption(text: 'Binary search — it divides the graph in half at each step', correct: false),
      QuizOption(text: 'In-order traversal — it processes nodes in sorted order', correct: false),
    ]),
    Quiz(question: 'Why does ArrayDeque beat LinkedList for stack and queue operations?', options: [
      QuizOption(text: 'ArrayDeque uses a contiguous array — better CPU cache locality and no node allocation overhead per operation', correct: true),
      QuizOption(text: 'ArrayDeque uses synchronized access; LinkedList is not thread-safe', correct: false),
      QuizOption(text: 'ArrayDeque supports null elements while LinkedList rejects them', correct: false),
      QuizOption(text: 'LinkedList has O(n) push/pop while ArrayDeque has O(log n)', correct: false),
    ]),
  ],
);
