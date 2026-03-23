import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson39 = Lesson(
  language: 'Java',
  title: 'Inner Classes and Anonymous Classes',
  content: """
🎯 METAPHOR:
Inner classes are like the rooms inside a house. The guest
bedroom (inner class) is inside the house (outer class) and
can access everything in the house — the living room TV,
the kitchen appliances (private fields of the outer class).
Guests can reach the bedroom by going through the house
(creating an inner class instance needs an outer class
instance). A static inner room (static nested class) is
like a separate studio apartment attached to the house —
it's physically nearby but has its own entrance and doesn't
need the main house to function. Anonymous classes are like
assembling temporary furniture from a flat-pack: you build
it once for this specific use, it has no name, and once
the purpose is served, it's discarded.

📖 EXPLANATION:
Java has four kinds of nested classes, each with different
rules about scope, access, and instantiation.

─────────────────────────────────────
FOUR TYPES OF NESTED CLASSES:
─────────────────────────────────────
  1. Static nested class  → no outer instance needed
  2. Inner class          → requires outer instance, has outer 'this'
  3. Local class          → defined inside a method
  4. Anonymous class      → no name, defined and instantiated inline

─────────────────────────────────────
1. STATIC NESTED CLASS:
─────────────────────────────────────
  class Outer {
      static class Nested {       // no link to Outer instance
          void show() { }
      }
  }

  Outer.Nested nested = new Outer.Nested();  // no Outer needed

  Common use: helper classes that logically belong together.
  Example: Map.Entry is a static nested interface inside Map.

─────────────────────────────────────
2. INNER CLASS (non-static):
─────────────────────────────────────
  class Outer {
      private String secret = "hidden";

      class Inner {
          void reveal() {
              System.out.println(secret);  // accesses outer private!
          }
      }
  }

  Outer outer = new Outer();
  Outer.Inner inner = outer.new Inner();  // needs outer instance!

  Use case: iterator implementations (LinkedList.ListItr).

─────────────────────────────────────
3. LOCAL CLASS:
─────────────────────────────────────
  void someMethod() {
      int x = 10;  // must be effectively final

      class LocalHelper {
          void doWork() {
              System.out.println(x);  // captures effectively final
          }
      }

      new LocalHelper().doWork();
  }

  Rarely used — lambda usually replaces this.

─────────────────────────────────────
4. ANONYMOUS CLASS:
─────────────────────────────────────
  // Define and instantiate inline — no class name:
  Comparator<String> byLength = new Comparator<String>() {
      @Override
      public int compare(String a, String b) {
          return Integer.compare(a.length(), b.length());
      }
  };

  // Modern equivalent — lambda (much cleaner):
  Comparator<String> byLength = (a, b) -> Integer.compare(a.length(), b.length());

  // Still useful for interfaces with MORE than one method:
  MouseListener ml = new MouseAdapter() {
      @Override
      public void mouseClicked(MouseEvent e) { ... }
      @Override
      public void mouseEntered(MouseEvent e) { ... }
  };

─────────────────────────────────────
ACCESSING OUTER CLASS FROM INNER CLASS:
─────────────────────────────────────
  class Outer {
      private int value = 10;

      class Inner {
          private int value = 20;

          void show() {
              int value = 30;
              System.out.println(value);         // 30 (local)
              System.out.println(this.value);    // 20 (inner)
              System.out.println(Outer.this.value); // 10 (outer)
          }
      }
  }

─────────────────────────────────────
WHEN EACH IS APPROPRIATE:
─────────────────────────────────────
  Static nested → logically grouped helper, no outer state needed
  Inner class   → needs access to outer private state (rare)
  Local class   → scoped helper in one method (use lambda instead)
  Anonymous     → one-off implementation of interface with 1 method
                  (use lambda instead for functional interfaces)
                  Still useful for abstract classes and multi-method interfaces

💻 CODE:
import java.util.*;

// ─── OUTER CLASS WITH NESTED TYPES ───────────────────
class LinkedStack<T> {

    // Static nested class — no LinkedStack instance needed
    static class Stats {
        private int maxSize;
        private int operations;

        public void record(int size) {
            operations++;
            maxSize = Math.max(maxSize, size);
        }

        public String report() {
            return String.format("Ops: %d, MaxSize: %d", operations, maxSize);
        }
    }

    // Private node class — implementation detail
    private static class Node<T> {
        T data;
        Node<T> next;
        Node(T data) { this.data = data; }
    }

    private Node<T> top;
    private int size;
    private final Stats stats = new Stats();

    public void push(T item) {
        Node<T> node = new Node<>(item);
        node.next = top;
        top = node;
        size++;
        stats.record(size);
    }

    public T pop() {
        if (top == null) throw new EmptyStackException();
        T data = top.data;
        top = top.next;
        size--;
        stats.record(size);
        return data;
    }

    public T peek() {
        if (top == null) throw new EmptyStackException();
        return top.data;
    }

    public boolean isEmpty() { return top == null; }
    public int size()        { return size; }
    public Stats getStats()  { return stats; }

    // Inner class — needs access to LinkedStack instance
    class Iterator implements java.util.Iterator<T> {
        private Node<T> current = top;

        @Override
        public boolean hasNext() { return current != null; }

        @Override
        public T next() {
            if (!hasNext()) throw new NoSuchElementException();
            T data = current.data;
            current = current.next;
            return data;
        }
    }

    public Iterator iterator() { return new Iterator(); }

    @Override
    public String toString() {
        var sb = new StringBuilder("Stack[");
        var it = iterator();
        while (it.hasNext()) {
            sb.append(it.next());
            if (it.hasNext()) sb.append(", ");
        }
        return sb.append("]").toString();
    }
}

// ─── ANONYMOUS CLASSES ────────────────────────────────
abstract class Validator<T> {
    protected String name;

    public Validator(String name) { this.name = name; }

    public abstract boolean validate(T value);

    public abstract String errorMessage(T value);

    public final boolean check(T value) {
        boolean valid = validate(value);
        if (!valid) {
            System.out.println("  ❌ " + name + ": " + errorMessage(value));
        }
        return valid;
    }
}

public class InnerAndAnonymous {
    public static void main(String[] args) {

        // ─── STATIC NESTED CLASS ──────────────────────────
        System.out.println("=== Static Nested Class ===");
        LinkedStack.Stats stats = new LinkedStack.Stats();  // no outer instance
        stats.record(3); stats.record(7); stats.record(5);
        System.out.println("  " + stats.report());

        // ─── INNER CLASS ──────────────────────────────────
        System.out.println("\n=== Inner Class (LinkedStack with Iterator) ===");
        LinkedStack<String> stack = new LinkedStack<>();
        stack.push("first");
        stack.push("second");
        stack.push("third");
        stack.push("fourth");

        System.out.println("  Stack: " + stack);
        System.out.println("  Size: " + stack.size());

        // Use inner class iterator
        System.out.print("  Iterate: ");
        LinkedStack<String>.Iterator it = stack.iterator();  // inner class
        while (it.hasNext()) System.out.print(it.next() + " ");
        System.out.println();

        System.out.println("  Pop: " + stack.pop());
        System.out.println("  Stack: " + stack);
        System.out.println("  Stats: " + stack.getStats().report());

        // ─── ANONYMOUS CLASSES ────────────────────────────
        System.out.println("\n=== Anonymous Classes ===");

        // Anonymous Comparator (shown, then replaced by lambda)
        List<String> words = new ArrayList<>(
            Arrays.asList("banana", "fig", "apple", "elderberry", "cherry"));

        // Anonymous class (old style):
        Comparator<String> byLengthThenAlpha = new Comparator<String>() {
            @Override
            public int compare(String a, String b) {
                int lenComp = Integer.compare(a.length(), b.length());
                return lenComp != 0 ? lenComp : a.compareTo(b);
            }
        };

        words.sort(byLengthThenAlpha);
        System.out.println("  Sorted (anon class): " + words);

        // Modern equivalent:
        words.sort(Comparator.comparingInt(String::length).thenComparing(Comparator.naturalOrder()));
        System.out.println("  Sorted (lambda/ref):  " + words);

        // Anonymous class for abstract class (can't use lambda):
        Validator<String> emailValidator = new Validator<String>("Email") {
            @Override
            public boolean validate(String value) {
                return value != null && value.contains("@") &&
                       value.contains(".") && value.length() >= 5;
            }

            @Override
            public String errorMessage(String value) {
                return "'" + value + "' is not a valid email";
            }
        };

        Validator<Integer> ageValidator = new Validator<Integer>("Age") {
            @Override
            public boolean validate(Integer value) {
                return value != null && value >= 0 && value <= 150;
            }

            @Override
            public String errorMessage(Integer value) {
                return value + " is out of range [0, 150]";
            }
        };

        System.out.println("\n  Validation:");
        emailValidator.check("terry@example.com");
        emailValidator.check("notanemail");
        emailValidator.check("");
        ageValidator.check(30);
        ageValidator.check(-1);
        ageValidator.check(200);

        // ─── INNER CLASS ACCESSING OUTER PRIVATE FIELDS ───
        System.out.println("\n=== Inner class accessing outer private ===");

        class DataContainer {
            private String secret = "private data";
            private int counter = 0;

            class Reader {
                public String read() {
                    counter++;                           // accesses outer field
                    return "Read #" + counter + ": " + secret; // accesses outer private
                }
            }

            Reader newReader() { return new Reader(); }
        }

        DataContainer container = new DataContainer();
        DataContainer.Reader reader = container.new Reader();
        System.out.println("  " + reader.read());
        System.out.println("  " + reader.read());
        System.out.println("  " + container.newReader().read());  // another reader

        // ─── PRACTICAL: anonymous Runnable ────────────────
        System.out.println("\n=== Anonymous Runnable / Thread ===");
        Thread t1 = new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("  Anonymous Runnable on " +
                    Thread.currentThread().getName());
            }
        });

        Thread t2 = new Thread(() ->
            System.out.println("  Lambda Runnable on " +
                Thread.currentThread().getName()));

        t1.start(); t2.start();
        try { t1.join(); t2.join(); } catch (InterruptedException e) {}
    }
}

📝 KEY POINTS:
✅ Static nested class: no outer instance needed — use for logically grouped helpers
✅ Inner class: has implicit reference to outer instance — can access outer private members
✅ Outer.Inner inst = outerInstance.new Inner() — inner class needs outer instance
✅ Use Outer.this.field to explicitly reference the outer class's field
✅ Anonymous classes are useful for abstract classes and multi-method interfaces
✅ For functional interfaces (one method), always prefer lambdas over anonymous classes
✅ Map.Entry, Iterator implementations are classic static/inner nested class uses
✅ Local classes capture effectively final variables from the enclosing method
❌ Inner classes hold an implicit reference to the outer class — memory leak risk
❌ Don't create inner classes just because they're nested — use static nested if outer state isn't needed
❌ Anonymous classes can't define constructors — use local/named class if you need one
❌ Inner class instances cannot be created without an outer class instance
""",
  quiz: [
    Quiz(question: 'How do you instantiate a non-static inner class?', options: [
      QuizOption(text: 'You need an outer class instance first: outer.new Inner()', correct: true),
      QuizOption(text: 'The same as any class: new Outer.Inner()', correct: false),
      QuizOption(text: 'Only the outer class can create inner class instances', correct: false),
      QuizOption(text: 'Inner classes are instantiated automatically with the outer class', correct: false),
    ]),
    Quiz(question: 'When is an anonymous class still preferable to a lambda in modern Java?', options: [
      QuizOption(text: 'When implementing an abstract class or an interface with more than one method', correct: true),
      QuizOption(text: 'When the implementation is more than 5 lines of code', correct: false),
      QuizOption(text: 'Anonymous classes are never preferable — lambdas replace all use cases', correct: false),
      QuizOption(text: 'When the anonymous class needs to access fields of the outer class', correct: false),
    ]),
    Quiz(question: 'What is a potential memory leak risk with non-static inner classes?', options: [
      QuizOption(text: 'Inner class instances hold an implicit reference to the outer class — preventing it from being garbage collected', correct: true),
      QuizOption(text: 'Inner classes create a new ClassLoader that is never released', correct: false),
      QuizOption(text: 'Each inner class instance creates a thread that runs indefinitely', correct: false),
      QuizOption(text: 'Inner classes cache all method call results, consuming unlimited memory', correct: false),
    ]),
  ],
);
