import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson07 = Lesson(
  language: 'Java',
  title: 'Loops: for, while, do-while',
  content: """
🎯 METAPHOR:
Loops are like the repeat setting on a washing machine.
You don't reprogram the machine for every shirt — you set
it to "run 30 minutes, then stop." The for loop is like
setting an exact timer: "do this exactly 10 times."
The while loop is like a moisture sensor: "keep running
as long as clothes are still wet — check before each cycle."
The do-while is like the initial spin: "ALWAYS run at least
once, THEN check if you need another cycle."
And break is the CANCEL button — stop everything right now.
continue is like skipping a shirt that's already clean.

📖 EXPLANATION:

─────────────────────────────────────
for LOOP — count-controlled:
─────────────────────────────────────
  for (initialization; condition; update) {
      // body
  }

  for (int i = 0; i < 10; i++) {
      System.out.println(i);   // 0, 1, 2, ... 9
  }

  Parts:
    initialization → runs once at start (int i = 0)
    condition      → checked before each iteration (i < 10)
    update         → runs after each body (i++)

─────────────────────────────────────
for-each LOOP — enhanced for:
─────────────────────────────────────
  for (Type element : collection) {
      // use element
  }

  int[] numbers = {10, 20, 30, 40};
  for (int n : numbers) {
      System.out.println(n);
  }

  Cleaner than index-based for when you don't need the index.
  Works with arrays and any Iterable (List, Set, etc.)

─────────────────────────────────────
while LOOP — condition-controlled:
─────────────────────────────────────
  while (condition) {
      // runs as long as condition is true
  }

  Checks condition BEFORE each iteration.
  May run ZERO times if condition is initially false.

─────────────────────────────────────
do-while LOOP — run-then-check:
─────────────────────────────────────
  do {
      // runs at least once
  } while (condition);

  Checks condition AFTER each iteration.
  Guarantees the body runs at LEAST once.

  Classic use: input validation — ask at least once:
    do {
        System.out.print("Enter a positive number: ");
        input = scanner.nextInt();
    } while (input <= 0);

─────────────────────────────────────
break — exit the loop:
─────────────────────────────────────
  for (int i = 0; i < 100; i++) {
      if (i == 5) break;       // exits the loop at i=5
      System.out.println(i);   // prints 0,1,2,3,4
  }

─────────────────────────────────────
continue — skip this iteration:
─────────────────────────────────────
  for (int i = 0; i < 10; i++) {
      if (i % 2 == 0) continue;  // skip even numbers
      System.out.println(i);      // prints 1,3,5,7,9
  }

─────────────────────────────────────
LABELED break/continue — nested loops:
─────────────────────────────────────
  outer:
  for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
          if (i == 1 && j == 1) break outer;  // exits both loops
          System.out.println(i + "," + j);
      }
  }

─────────────────────────────────────
INFINITE LOOP + break:
─────────────────────────────────────
  while (true) {
      // process incoming requests
      if (shouldStop()) break;
  }

  // Or:
  for (;;) {   // classic C-style infinite loop
      if (shouldStop()) break;
  }

💻 CODE:
public class Loops {
    public static void main(String[] args) {

        // ─── BASIC for ────────────────────────────────────
        System.out.println("=== Basic for loop ===");
        for (int i = 1; i <= 5; i++) {
            System.out.printf("  i = %d%n", i);
        }

        // Countdown
        System.out.print("Countdown: ");
        for (int i = 10; i >= 1; i--) {
            System.out.print(i + " ");
        }
        System.out.println("→ Launch! 🚀");

        // Stepping
        System.out.print("Evens 2-20: ");
        for (int i = 2; i <= 20; i += 2) {
            System.out.print(i + " ");
        }
        System.out.println();

        // ─── for-each ────────────────────────────────────
        System.out.println("\n=== for-each ===");
        String[] planets = {"Mercury", "Venus", "Earth", "Mars",
                            "Jupiter", "Saturn", "Uranus", "Neptune"};
        for (String planet : planets) {
            System.out.printf("  🪐 %s%n", planet);
        }

        // ─── NESTED for LOOP ──────────────────────────────
        System.out.println("\n=== Multiplication table ===");
        System.out.print("    ");
        for (int j = 1; j <= 5; j++) System.out.printf("%4d", j);
        System.out.println();
        System.out.println("    " + "────".repeat(5));
        for (int i = 1; i <= 5; i++) {
            System.out.printf(" %2d │", i);
            for (int j = 1; j <= 5; j++) {
                System.out.printf("%4d", i * j);
            }
            System.out.println();
        }

        // ─── while LOOP ───────────────────────────────────
        System.out.println("\n=== while loop ===");
        int n = 1;
        long sum = 0;
        while (sum < 100) {
            sum += n;
            n++;
        }
        System.out.println("First n where sum >= 100: n=" + (n-1) + ", sum=" + sum);

        // Binary search with while
        System.out.println("\n=== Binary search simulation ===");
        int[] sorted = {2, 5, 8, 12, 16, 23, 38, 56, 72, 91};
        int target = 23;
        int low = 0, high = sorted.length - 1, steps = 0;
        while (low <= high) {
            int mid = (low + high) / 2;
            steps++;
            if (sorted[mid] == target) {
                System.out.printf("  Found %d at index %d in %d steps%n",
                    target, mid, steps);
                break;
            } else if (sorted[mid] < target) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }

        // ─── do-while ─────────────────────────────────────
        System.out.println("\n=== do-while ===");
        // Simulated input validation (without Scanner for demo)
        int[] simulatedInputs = {-5, 0, -1, 7}; // 7 is valid
        int inputIdx = 0;
        int userInput;
        do {
            userInput = simulatedInputs[inputIdx++];
            System.out.println("  Input: " + userInput +
                (userInput > 0 ? " ✅" : " ❌ must be positive"));
        } while (userInput <= 0);
        System.out.println("  Accepted: " + userInput);

        // ─── break and continue ───────────────────────────
        System.out.println("\n=== break and continue ===");
        System.out.print("Skip multiples of 3: ");
        for (int i = 1; i <= 15; i++) {
            if (i % 3 == 0) continue;    // skip
            System.out.print(i + " ");
        }
        System.out.println();

        System.out.print("Stop at first multiple of 7: ");
        for (int i = 1; i <= 50; i++) {
            if (i % 7 == 0) {
                System.out.println("found " + i + "!");
                break;
            }
            System.out.print(i + " ");
        }

        // ─── LABELED break ────────────────────────────────
        System.out.println("\n=== Labeled break (nested loop) ===");
        outer:
        for (int i = 1; i <= 4; i++) {
            for (int j = 1; j <= 4; j++) {
                if (i + j == 6) {
                    System.out.println("  Breaking outer at i=" + i + ", j=" + j);
                    break outer;
                }
                System.out.printf("  (%d,%d) ", i, j);
            }
        }

        // ─── PATTERN: accumulate with loop ────────────────
        System.out.println("\n\n=== Fibonacci with loop ===");
        int fibCount = 12;
        long prev = 0, curr = 1;
        System.out.print("Fibonacci: " + prev + " " + curr);
        for (int i = 2; i < fibCount; i++) {
            long next = prev + curr;
            System.out.print(" " + next);
            prev = curr;
            curr = next;
        }
        System.out.println();

        // ─── PRIME SIEVE ──────────────────────────────────
        System.out.println("\n=== Primes up to 50 ===");
        System.out.print("Primes: ");
        outer2:
        for (int i = 2; i <= 50; i++) {
            for (int d = 2; d <= Math.sqrt(i); d++) {
                if (i % d == 0) continue outer2;  // labeled continue
            }
            System.out.print(i + " ");
        }
        System.out.println();
    }
}

📝 KEY POINTS:
✅ for loop: know exactly how many iterations → for(init; cond; update)
✅ for-each: iterate every element cleanly → for(Type x : collection)
✅ while: check before running → may run 0 times
✅ do-while: check after running → always runs at least once
✅ break exits the loop immediately; continue skips to next iteration
✅ Labeled break/continue work with nested loops
✅ for(;;) or while(true) create intentional infinite loops
✅ Use for-each when you don't need the index — cleaner and safer
❌ Modifying a collection while iterating it causes ConcurrentModificationException
❌ Off-by-one errors: i < n vs i <= n — be precise about boundaries
❌ Infinite loops without a guaranteed break condition will hang the program
❌ Don't use the loop variable after the loop ends — declare scope inside
""",
  quiz: [
    Quiz(question: 'What is the key difference between while and do-while?', options: [
      QuizOption(text: 'while checks the condition before running; do-while always runs the body at least once', correct: true),
      QuizOption(text: 'while runs faster; do-while is safer with null values', correct: false),
      QuizOption(text: 'do-while requires an explicit break to exit; while does not', correct: false),
      QuizOption(text: 'while supports break and continue; do-while does not', correct: false),
    ]),
    Quiz(question: 'What does the continue statement do inside a loop?', options: [
      QuizOption(text: 'Skips the rest of the current iteration and moves to the next one', correct: true),
      QuizOption(text: 'Exits the loop entirely', correct: false),
      QuizOption(text: 'Restarts the loop from the beginning', correct: false),
      QuizOption(text: 'Pauses the loop until a condition is met', correct: false),
    ]),
    Quiz(question: 'When should you prefer a for-each loop over a traditional for loop?', options: [
      QuizOption(text: 'When you need to iterate every element and do not need the index', correct: true),
      QuizOption(text: 'When iterating backwards through an array', correct: false),
      QuizOption(text: 'Only when the collection contains more than 10 elements', correct: false),
      QuizOption(text: 'For-each is always preferred — traditional for is deprecated', correct: false),
    ]),
  ],
);
