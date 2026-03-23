import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson44 = Lesson(
  language: 'Java',
  title: 'CompletableFuture and Async Programming',
  content: """
🎯 METAPHOR:
CompletableFuture is like an online order confirmation.
When you order something online, you get a confirmation
immediately — but the package hasn't arrived yet. That
confirmation (the future) represents a PROMISE that the
result is coming. While you wait, you continue your life
(the calling thread is not blocked). You can set up rules:
"When it arrives, unbox it AND put it away." "If it gets
lost, file a claim." "If any of these three orders arrives
first, use that one." CompletableFuture is Java's async
programming primitive — compose complex async workflows
that chain, combine, and handle failures, without ever
blocking a thread.

📖 EXPLANATION:
CompletableFuture (Java 8) is a powerful async construct
that goes far beyond the basic Future<T>.

─────────────────────────────────────
CREATING CompletableFuture:
─────────────────────────────────────
  // Already completed (test/mock):
  CompletableFuture.completedFuture("value")
  CompletableFuture.failedFuture(new RuntimeException())

  // Run async (ForkJoinPool by default):
  CompletableFuture.runAsync(() -> doWork())      // Void result
  CompletableFuture.supplyAsync(() -> compute())  // T result

  // With custom executor:
  CompletableFuture.supplyAsync(() -> compute(), myExecutor)

─────────────────────────────────────
TRANSFORMATION METHODS:
─────────────────────────────────────
  cf.thenApply(fn)        → transform result: T → U
  cf.thenApplyAsync(fn)   → transform on different thread
  cf.thenAccept(consumer) → consume result, return void
  cf.thenRun(runnable)    → run after completion, no result
  cf.thenCompose(fn)      → flat-map: T → CompletableFuture<U>

─────────────────────────────────────
COMBINING FUTURES:
─────────────────────────────────────
  // Wait for both, combine results:
  cf1.thenCombine(cf2, (a, b) -> a + b)

  // Wait for both, accept both results:
  cf1.thenAcceptBoth(cf2, (a, b) -> use(a, b))

  // Run after both complete:
  cf1.runAfterBoth(cf2, runnable)

  // Take whichever completes first:
  cf1.applyToEither(cf2, result -> use(result))

  // Wait for ALL to complete:
  CompletableFuture.allOf(cf1, cf2, cf3)

  // Complete when ANY completes:
  CompletableFuture.anyOf(cf1, cf2, cf3)

─────────────────────────────────────
ERROR HANDLING:
─────────────────────────────────────
  cf.exceptionally(ex -> fallback)
      → if CF failed, return fallback value

  cf.handle((result, ex) -> {
      if (ex != null) return handleError(ex);
      return transform(result);
  })  → always called, handles both success and failure

  cf.whenComplete((result, ex) -> {
      // side effects, result or ex may be null
  })  → like finally — runs always

─────────────────────────────────────
GETTING THE RESULT:
─────────────────────────────────────
  cf.get()                    → blocks, throws checked exceptions
  cf.get(timeout, TimeUnit)   → blocks with timeout
  cf.join()                   → blocks, throws unchecked
  cf.getNow(defaultValue)     → return now or default if not done
  cf.isDone()                 → check if complete
  cf.isCompletedExceptionally()→ check if failed

─────────────────────────────────────
VIRTUAL THREADS (Java 21) integration:
─────────────────────────────────────
  var executor = Executors.newVirtualThreadPerTaskExecutor();
  CompletableFuture.supplyAsync(() -> fetchData(), executor)
      .thenApply(data -> processData(data))
      .join();

  Virtual threads make each task cheap — millions possible.

💻 CODE:
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.*;
import java.util.function.*;
import java.util.stream.*;

public class CompletableFutureDemo {

    // Simulated async services
    static CompletableFuture<String> fetchUser(int id) {
        return CompletableFuture.supplyAsync(() -> {
            simulateDelay(100);
            if (id <= 0) throw new RuntimeException("Invalid user id: " + id);
            return "User#" + id + "[Alice]";
        });
    }

    static CompletableFuture<String> fetchProfile(String userId) {
        return CompletableFuture.supplyAsync(() -> {
            simulateDelay(80);
            return "Profile{" + userId + ", city=London}";
        });
    }

    static CompletableFuture<List<String>> fetchOrders(String userId) {
        return CompletableFuture.supplyAsync(() -> {
            simulateDelay(120);
            return List.of("Order#1001", "Order#1002", "Order#1003");
        });
    }

    static CompletableFuture<Double> fetchProductPrice(String productId) {
        return CompletableFuture.supplyAsync(() -> {
            simulateDelay(60);
            return switch (productId) {
                case "A" -> 29.99;
                case "B" -> 49.99;
                case "C" -> 19.99;
                default  -> throw new RuntimeException("Unknown product: " + productId);
            };
        });
    }

    static void simulateDelay(long ms) {
        try { Thread.sleep(ms); } catch (InterruptedException e) {}
    }

    public static void main(String[] args) throws Exception {

        // ─── BASIC CHAIN ──────────────────────────────────
        System.out.println("=== Basic async chain ===");
        long start = System.currentTimeMillis();

        String result = fetchUser(1)
            .thenApply(user -> user.toUpperCase())      // transform
            .thenApply(user -> "Welcome, " + user)      // transform again
            .get(5, TimeUnit.SECONDS);                  // block for result

        System.out.printf("  Result: %s (%dms)%n", result, elapsed(start));

        // ─── FLAT MAP WITH thenCompose ────────────────────
        System.out.println("\n=== thenCompose (flat-map) ===");
        start = System.currentTimeMillis();

        // Chaining dependent futures
        String profile = fetchUser(1)
            .thenCompose(user -> fetchProfile(user))   // user → Future<profile>
            .get(5, TimeUnit.SECONDS);

        System.out.printf("  Profile: %s (%dms)%n", profile, elapsed(start));

        // ─── PARALLEL EXECUTION WITH allOf ────────────────
        System.out.println("\n=== Parallel execution (allOf) ===");
        start = System.currentTimeMillis();

        // Fetch prices for three products simultaneously
        CompletableFuture<Double> priceA = fetchProductPrice("A");
        CompletableFuture<Double> priceB = fetchProductPrice("B");
        CompletableFuture<Double> priceC = fetchProductPrice("C");

        // Wait for all, then collect results
        CompletableFuture<Void> allDone = CompletableFuture.allOf(priceA, priceB, priceC);
        allDone.get(5, TimeUnit.SECONDS);

        double totalPrice = priceA.join() + priceB.join() + priceC.join();
        System.out.printf("  Prices: A=\$%.2f B=\$%.2f C=\$%.2f Total=\$%.2f (%dms)%n",
            priceA.join(), priceB.join(), priceC.join(), totalPrice, elapsed(start));

        // ─── anyOf — RACE CONDITION ───────────────────────
        System.out.println("\n=== anyOf (first to complete) ===");
        start = System.currentTimeMillis();

        CompletableFuture<String> server1 = CompletableFuture.supplyAsync(() -> {
            simulateDelay(200); return "Response from Server 1";
        });
        CompletableFuture<String> server2 = CompletableFuture.supplyAsync(() -> {
            simulateDelay(100); return "Response from Server 2";  // faster
        });
        CompletableFuture<String> server3 = CompletableFuture.supplyAsync(() -> {
            simulateDelay(300); return "Response from Server 3";
        });

        String fastest = (String) CompletableFuture.anyOf(server1, server2, server3)
            .get(5, TimeUnit.SECONDS);
        System.out.printf("  First response: %s (%dms)%n", fastest, elapsed(start));

        // ─── thenCombine — MERGE TWO ──────────────────────
        System.out.println("\n=== thenCombine (merge two futures) ===");
        start = System.currentTimeMillis();

        String combined = fetchUser(1)
            .thenCombine(
                fetchProductPrice("B"),
                (user, price) -> user + " wants to buy item for\$" + price
            )
            .get(5, TimeUnit.SECONDS);

        System.out.printf("  Combined: %s (%dms)%n", combined, elapsed(start));

        // ─── ERROR HANDLING ───────────────────────────────
        System.out.println("\n=== Error handling ===");

        // exceptionally — provide fallback on failure
        String userResult = fetchUser(-1)      // will throw
            .exceptionally(ex -> {
                System.out.println("  Caught: " + ex.getMessage());
                return "GUEST";
            })
            .get(5, TimeUnit.SECONDS);
        System.out.println("  Fallback result: " + userResult);

        // handle — always called
        fetchUser(-1)
            .handle((result2, ex) -> {
                if (ex != null) {
                    System.out.println("  handle() error: " + ex.getMessage());
                    return "ERROR_USER";
                }
                return result2.toUpperCase();
            })
            .thenAccept(u -> System.out.println("  Final: " + u))
            .get(5, TimeUnit.SECONDS);

        // ─── COMPLEX PIPELINE ─────────────────────────────
        System.out.println("\n=== Complex pipeline ===");
        start = System.currentTimeMillis();

        // Fetch user → fetch their orders → get total order value
        AtomicInteger orderCount = new AtomicInteger(0);

        String summary = fetchUser(1)
            .thenCompose(user -> fetchOrders(user))
            .thenApply(orders -> {
                orderCount.set(orders.size());
                return orders;
            })
            .thenCombine(
                fetchProductPrice("A"),
                (orders, unitPrice) ->
                    String.format("User has %d orders, unit price\$%.2f, total\$%.2f",
                        orders.size(), unitPrice, orders.size() * unitPrice)
            )
            .exceptionally(ex -> "Pipeline failed: " + ex.getMessage())
            .get(5, TimeUnit.SECONDS);

        System.out.printf("  Summary: %s (%dms)%n", summary, elapsed(start));

        // ─── COLLECTING MULTIPLE FUTURES ──────────────────
        System.out.println("\n=== Collect multiple futures ===");
        start = System.currentTimeMillis();

        List<Integer> userIds = List.of(1, 2, 3, 4, 5);

        // Fetch all users in parallel
        List<CompletableFuture<String>> futures = userIds.stream()
            .map(id -> fetchUser(id).exceptionally(e -> "FAILED#" + id))
            .collect(Collectors.toList());

        // Wait for all and collect
        List<String> users = futures.stream()
            .map(CompletableFuture::join)
            .collect(Collectors.toList());

        System.out.printf("  Fetched %d users in %dms (parallel)%n",
            users.size(), elapsed(start));
        users.forEach(u -> System.out.println("    " + u));

        System.out.println("\nAll demos complete ✅");
    }

    static long elapsed(long start) {
        return System.currentTimeMillis() - start;
    }
}

📝 KEY POINTS:
✅ supplyAsync returns a value; runAsync returns Void — choose based on need
✅ thenApply transforms the result; thenCompose flat-maps to a new future
✅ allOf waits for ALL to complete; anyOf completes when the first does
✅ thenCombine merges the results of two independent futures
✅ exceptionally provides a fallback when the future fails
✅ handle() always runs — handles both success and failure in one block
✅ join() is like get() but throws unchecked exceptions (no try-catch needed)
✅ Run truly parallel work with allOf — each starts immediately, results collected after
✅ Use virtual threads (Java 21) for millions of lightweight concurrent tasks
❌ Don't call get() in a chain — it blocks the thread, defeating the purpose
❌ Avoid mixing blocking and non-blocking code — keep chains non-blocking
❌ Don't create a new ForkJoinPool per request — pass a shared executor
❌ CompletableFuture.get() throws InterruptedException and ExecutionException — handle them
""",
  quiz: [
    Quiz(question: 'What is the difference between thenApply() and thenCompose()?', options: [
      QuizOption(text: 'thenApply transforms T → U; thenCompose is for functions returning CompletableFuture<U> (flat-map)', correct: true),
      QuizOption(text: 'thenApply runs on the same thread; thenCompose runs on a new thread', correct: false),
      QuizOption(text: 'thenCompose handles exceptions; thenApply does not', correct: false),
      QuizOption(text: 'They are identical — compose is just an older name for apply', correct: false),
    ]),
    Quiz(question: 'What does CompletableFuture.allOf(cf1, cf2, cf3) return?', options: [
      QuizOption(text: 'A CompletableFuture<Void> that completes when ALL three complete — results must be retrieved separately', correct: true),
      QuizOption(text: 'A CompletableFuture<List<T>> containing all three results when done', correct: false),
      QuizOption(text: 'The result of whichever future completes first', correct: false),
      QuizOption(text: 'A stream of results emitted as each future completes', correct: false),
    ]),
    Quiz(question: 'When should you use handle() instead of exceptionally()?', options: [
      QuizOption(text: 'When you need to handle both success and failure in one place — handle() always runs regardless of outcome', correct: true),
      QuizOption(text: 'handle() is for checked exceptions; exceptionally() is for runtime exceptions', correct: false),
      QuizOption(text: 'handle() is required when the future result type needs to change', correct: false),
      QuizOption(text: 'They are interchangeable — choose based on code style', correct: false),
    ]),
  ],
);
