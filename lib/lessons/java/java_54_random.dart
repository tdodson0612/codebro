import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson54 = Lesson(
  language: 'Java',
  title: 'Random Numbers: Random, SecureRandom, and More',
  content: """
🎯 METAPHOR:
Randomness in programming comes in flavors. java.util.Random
is like rolling a standard casino die — predictable if you
know the seed (not truly random, but good enough for games
and simulations). ThreadLocalRandom is the same die but
with its own separate roller per player so they don't trip
over each other (thread-safe without contention). SecureRandom
is the casino's certified, audited randomness — cryptographically
unpredictable, used for passwords, tokens, and security keys.
SplittableRandom is the parallel pipeline version — designed
for splitting and feeding into parallel streams efficiently.
Use the right die for the right game.

📖 EXPLANATION:

─────────────────────────────────────
java.util.Random — general purpose:
─────────────────────────────────────
  Random rand = new Random();          // seed from system time
  Random rand = new Random(42);        // fixed seed (reproducible)

  rand.nextInt()             → any int (negative or positive)
  rand.nextInt(n)            → [0, n)  exclusive upper bound
  rand.nextInt(min, max)     → [min, max) (Java 17+)
  rand.nextLong()            → any long
  rand.nextDouble()          → [0.0, 1.0)
  rand.nextFloat()           → [0.0, 1.0)
  rand.nextBoolean()         → true or false
  rand.nextGaussian()        → standard normal (mean 0, std 1)
  rand.ints(count)           → IntStream of random ints
  rand.ints(count, min, max) → bounded IntStream
  rand.doubles(count)        → DoubleStream
  rand.longs(count)          → LongStream

  // Shuffle:
  Collections.shuffle(list, rand);

─────────────────────────────────────
Math.random() — quick one-liner:
─────────────────────────────────────
  double r = Math.random();          // [0.0, 1.0)
  int die = (int)(Math.random() * 6) + 1;  // [1, 6]

  Uses Random internally. Convenient but limited.
  Prefer Random for more control.

─────────────────────────────────────
ThreadLocalRandom — concurrent usage:
─────────────────────────────────────
  ThreadLocalRandom.current().nextInt(1, 7)   // [1, 7) = die roll
  ThreadLocalRandom.current().nextDouble()

  Each thread gets its own Random — no contention.
  Faster than synchronized Random in multithreaded code.
  Cannot be seeded (by design).

─────────────────────────────────────
SecureRandom — cryptographic randomness:
─────────────────────────────────────
  SecureRandom sr = new SecureRandom();
  byte[] token = new byte[32];
  sr.nextBytes(token);         // fills with cryptographic random bytes
  sr.nextInt(1000000)          // random 6-digit number

  Use for: passwords, session tokens, salt, cryptographic keys.
  DO NOT use for: games, simulations (too slow, overkill).

─────────────────────────────────────
SplittableRandom — parallel streams:
─────────────────────────────────────
  SplittableRandom sr = new SplittableRandom(42);
  sr.ints(10, 1, 101)          // IntStream: 10 values in [1, 100]
      .parallel()
      .forEach(System.out::println);

  Designed for parallel computation. Seedable. Not thread-safe
  (each parallel fork gets a split, hence the name).

─────────────────────────────────────
RANDOM STREAMS (Java 8+):
─────────────────────────────────────
  new Random().ints(10, 1, 101)         // 10 random ints in [1, 100]
  new Random().doubles(5, 0.0, 1.0)    // 5 random doubles
  new Random().longs(5)                 // 5 random longs

  // Infinite stream with limit:
  new Random().ints(1, 7).limit(10)     // 10 dice rolls

─────────────────────────────────────
COMMON PATTERNS:
─────────────────────────────────────
  Random int in range [min, max] inclusive:
  int n = rand.nextInt(max - min + 1) + min;
  // Java 17+: rand.nextInt(min, max + 1)

  Random element from array:
  String pick = arr[rand.nextInt(arr.length)];

  Random element from list:
  String pick = list.get(rand.nextInt(list.size()));

  Shuffle a list:
  Collections.shuffle(list);

  Coin flip:
  boolean heads = rand.nextBoolean();

  Weighted random:
  double r = rand.nextDouble();
  String outcome = r < 0.5 ? "common" : r < 0.8 ? "rare" : "epic";

  Unique random sample (without replacement):
  Collections.shuffle(list);
  List<String> sample = list.subList(0, k);

💻 CODE:
import java.util.*;
import java.util.concurrent.*;
import java.util.security.SecureRandom;
import java.util.stream.*;
import java.util.concurrent.atomic.*;

public class RandomNumbers {
    public static void main(String[] args) throws InterruptedException {

        // ─── java.util.Random ─────────────────────────────
        System.out.println("=== java.util.Random ===");
        Random rand = new Random(42);   // seeded for reproducibility

        System.out.print("  nextInt(10):    ");
        for (int i = 0; i < 8; i++) System.out.print(rand.nextInt(10) + " ");
        System.out.println();

        System.out.printf("  nextDouble():   %.4f%n", rand.nextDouble());
        System.out.printf("  nextGaussian(): %.4f (standard normal)%n", rand.nextGaussian());
        System.out.println("  nextBoolean():  " + rand.nextBoolean());

        // Range [min, max] inclusive:
        int min = 50, max = 100;
        System.out.print("  [50,100]:       ");
        for (int i = 0; i < 5; i++) {
            System.out.print(rand.nextInt(max - min + 1) + min + " ");
        }
        System.out.println();

        // Java 17+:
        // System.out.print("  Java17 range:   ");
        // for (int i = 0; i < 5; i++) System.out.print(rand.nextInt(50, 101) + " ");

        // ─── RANDOM STREAMS ───────────────────────────────
        System.out.println("\n=== Random Streams ===");
        Random sr = new Random(99);

        // 10 dice rolls
        int[] dice = sr.ints(10, 1, 7).toArray();
        System.out.println("  10 dice rolls: " + Arrays.toString(dice));

        // Statistics of many rolls
        long[] freq = new long[7];
        sr.ints(100_000, 1, 7).forEach(n -> freq[n]++);
        System.out.println("  Frequency (100k rolls):");
        for (int i = 1; i <= 6; i++) {
            double pct = freq[i] / 1000.0;
            System.out.printf("    %d: %.1f%% %s%n", i, pct, "█".repeat((int)pct));
        }

        // Double stream
        double[] samples = new Random().doubles(5, 0.0, 100.0).toArray();
        System.out.println("  5 random doubles: " +
            Arrays.stream(samples).mapToObj(d -> String.format("%.2f", d))
                .collect(Collectors.joining(", ")));

        // ─── Math.random() ────────────────────────────────
        System.out.println("\n=== Math.random() ===");
        System.out.print("  Coin flips: ");
        for (int i = 0; i < 10; i++) {
            System.out.print(Math.random() < 0.5 ? "H " : "T ");
        }
        System.out.println();

        // Quick die: (int)(Math.random() * 6) + 1
        System.out.print("  Quick dice: ");
        for (int i = 0; i < 8; i++) {
            System.out.print((int)(Math.random() * 6) + 1 + " ");
        }
        System.out.println();

        // ─── ThreadLocalRandom ────────────────────────────
        System.out.println("\n=== ThreadLocalRandom ===");
        int numThreads = 4;
        AtomicLong totalSum = new AtomicLong();
        List<Thread> threads = new ArrayList<>();

        for (int t = 0; t < numThreads; t++) {
            final int tid = t;
            threads.add(new Thread(() -> {
                long local = ThreadLocalRandom.current()
                    .ints(25_000, 1, 101)
                    .asLongStream()
                    .sum();
                totalSum.addAndGet(local);
                System.out.printf("  Thread %d sum of 25k numbers in [1,100]: %,d%n", tid, local);
            }));
        }
        threads.forEach(Thread::start);
        for (Thread t : threads) t.join();
        System.out.printf("  Grand total: %,d (expected ~%,d)%n",
            totalSum.get(), (long)(50.5 * 25_000 * numThreads));

        // ─── SecureRandom ─────────────────────────────────
        System.out.println("\n=== SecureRandom (cryptographic) ===");
        SecureRandom secure = new SecureRandom();

        // Random token (hex string)
        byte[] tokenBytes = new byte[16];
        secure.nextBytes(tokenBytes);
        String token = HexFormat.of().formatHex(tokenBytes);
        System.out.println("  Session token:   " + token);
        System.out.println("  Token length:    " + token.length() + " hex chars");

        // OTP (one-time password)
        int otp = secure.nextInt(900_000) + 100_000;   // 6-digit
        System.out.println("  OTP (6-digit):   " + otp);

        // Salt for password hashing
        byte[] salt = new byte[32];
        secure.nextBytes(salt);
        System.out.println("  Salt (Base64):   " +
            Base64.getEncoder().encodeToString(salt).substring(0, 20) + "...");

        // ─── SplittableRandom ─────────────────────────────
        System.out.println("\n=== SplittableRandom (parallel) ===");
        SplittableRandom splittable = new SplittableRandom(42);

        long parallelSum = splittable.ints(1_000_000, 1, 101)
            .parallel()
            .asLongStream()
            .sum();
        System.out.printf("  Sum of 1M values in [1,100]: %,d (expected ~%,d)%n",
            parallelSum, 50_500_000L);

        // ─── COMMON PATTERNS ──────────────────────────────
        System.out.println("\n=== Common Random Patterns ===");
        Random r = new Random();

        // Pick random element
        String[] fruits = {"apple", "banana", "cherry", "date", "elderberry"};
        String pick = fruits[r.nextInt(fruits.length)];
        System.out.println("  Random fruit: " + pick);

        // Shuffle and sample
        List<String> deck = new ArrayList<>(
            Arrays.asList("A♠","K♠","Q♠","J♠","10♠","9♠","8♠","7♠"));
        Collections.shuffle(deck);
        System.out.println("  Shuffled top 5: " + deck.subList(0, 5));

        // Weighted random
        Map<String, Double> weights = new LinkedHashMap<>();
        weights.put("Common",   0.60);
        weights.put("Rare",     0.30);
        weights.put("Epic",     0.09);
        weights.put("Legendary",0.01);

        System.out.print("  10 loot drops: ");
        for (int i = 0; i < 10; i++) {
            double roll = r.nextDouble();
            double cumulative = 0;
            for (var entry : weights.entrySet()) {
                cumulative += entry.getValue();
                if (roll < cumulative) {
                    System.out.print(entry.getKey().charAt(0) + " ");
                    break;
                }
            }
        }
        System.out.println();

        // Gaussian / normal distribution
        System.out.print("  Gaussian (mean=70, std=10): ");
        Random gr = new Random(77);
        for (int i = 0; i < 6; i++) {
            double score = gr.nextGaussian() * 10 + 70;
            System.out.printf("%.0f ", Math.max(0, Math.min(100, score)));
        }
        System.out.println();
    }
}

📝 KEY POINTS:
✅ Random: general purpose, seedable, reproducible — use for games/simulations
✅ Math.random(): quick one-liner, uses Random internally
✅ ThreadLocalRandom: for multithreaded code — no contention between threads
✅ SecureRandom: cryptographically strong — use for tokens, passwords, security
✅ SplittableRandom: designed for parallel streams — seedable, efficient
✅ rand.nextInt(n) gives [0, n) — add offset for different ranges
✅ Random produces IntStream/DoubleStream/LongStream for bulk generation
✅ Collections.shuffle() randomizes a list in-place
✅ Weighted random: generate a double, compare against cumulative weights
❌ Don't use Random for security — it is predictable given the seed
❌ Don't use SecureRandom for performance-critical loops — it's much slower
❌ nextInt(n) includes 0 but excludes n — remember the exclusive upper bound
❌ Fixed seed (new Random(42)) gives the same sequence every run — good for testing
""",
  quiz: [
    Quiz(question: 'Which Random implementation should you use for generating session tokens and passwords?', options: [
      QuizOption(text: 'SecureRandom — it uses a cryptographically strong algorithm that is not predictable', correct: true),
      QuizOption(text: 'Random with a large seed — more bits means more randomness', correct: false),
      QuizOption(text: 'ThreadLocalRandom — it cannot be seeded, making it less predictable', correct: false),
      QuizOption(text: 'Math.random() — it uses system entropy for better randomness', correct: false),
    ]),
    Quiz(question: 'What range does rand.nextInt(6) produce?', options: [
      QuizOption(text: '[0, 5] inclusive — 0, 1, 2, 3, 4, or 5 (6 is excluded)', correct: true),
      QuizOption(text: '[1, 6] inclusive — useful for dice rolls', correct: false),
      QuizOption(text: '[0, 6] inclusive — 0, 1, 2, 3, 4, 5, or 6', correct: false),
      QuizOption(text: '[1, 5] inclusive — both bounds are excluded', correct: false),
    ]),
    Quiz(question: 'Why should you use ThreadLocalRandom instead of Random in multithreaded code?', options: [
      QuizOption(text: 'Each thread gets its own instance — no synchronization contention, so it is significantly faster', correct: true),
      QuizOption(text: 'ThreadLocalRandom produces more truly random values than shared Random', correct: false),
      QuizOption(text: 'Random is not thread-safe and throws exceptions when used concurrently', correct: false),
      QuizOption(text: 'ThreadLocalRandom generates values in parallel using all CPU cores', correct: false),
    ]),
  ],
);
