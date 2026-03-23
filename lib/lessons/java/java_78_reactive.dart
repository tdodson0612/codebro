import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson78 = Lesson(
  language: 'Java',
  title: 'Reactive Programming and the Flow API (Java 9)',
  content: """
🎯 METAPHOR:
Reactive programming is like subscribing to a newspaper
instead of going to the library every day to check for news.
Pull model (traditional): you go to the library (poll the DB),
ask "is there new data?", get it, go back tomorrow.
Push model (reactive): you subscribe, and new editions
are delivered to your door the moment they're printed.
Backpressure is the subscription agreement: "Don't send
me more than 3 newspapers per day — I can't read faster."
The publisher respects your reading speed, buffering extra
editions rather than flooding your mailbox.

📖 EXPLANATION:
The Flow API (java.util.concurrent.Flow) is Java 9's
built-in reactive streams API — a standard interface
for reactive stream implementations.

─────────────────────────────────────
REACTIVE STREAMS PRINCIPLES:
─────────────────────────────────────
  1. Non-blocking: publisher doesn't block waiting for consumer
  2. Async: producer and consumer run independently
  3. Backpressure: consumer controls how fast it receives items
  4. Error handling: errors are signals in the stream

─────────────────────────────────────
JAVA FLOW API — 4 INTERFACES:
─────────────────────────────────────
  Flow.Publisher<T>      → produces items
  Flow.Subscriber<T>     → consumes items
  Flow.Subscription      → link between publisher and subscriber
  Flow.Processor<T,R>    → transforms (both publisher and subscriber)

  Publisher.subscribe(Subscriber)
  Subscriber.onSubscribe(Subscription)  ← called once at start
  Subscription.request(n)               ← consumer asks for n items
  Subscriber.onNext(item)               ← publisher sends item
  Subscriber.onError(throwable)         ← stream error
  Subscriber.onComplete()               ← no more items

─────────────────────────────────────
BACKPRESSURE — the key feature:
─────────────────────────────────────
  Without backpressure (plain futures/callbacks):
  Publisher sends at MAX RATE → consumer buffer overflows
  → OutOfMemoryError or data loss

  With backpressure:
  Subscriber calls subscription.request(10)
  Publisher sends UP TO 10 items
  Subscriber processes them, calls request(10) again
  Publisher WAITS if subscriber hasn't requested more

─────────────────────────────────────
SubmissionPublisher — built-in publisher:
─────────────────────────────────────
  SubmissionPublisher<String> pub = new SubmissionPublisher<>();
  pub.subscribe(mySubscriber);

  pub.submit("item1");  // blocks if subscriber is too slow
  pub.offer("item2", 100, TimeUnit.MS, (s, item) -> false); // non-blocking

  pub.close();  // signals onComplete() to all subscribers

─────────────────────────────────────
REAL REACTIVE FRAMEWORKS:
─────────────────────────────────────
  Project Reactor (Spring WebFlux):
  Mono<T>:   0 or 1 item
  Flux<T>:   0 to N items

  RxJava 3:
  Single<T>: 1 item
  Maybe<T>:  0 or 1 item
  Observable<T>: N items
  Flowable<T>: N items with backpressure

  The Flow API provides the interfaces — Reactor/RxJava
  provide the rich operators (map, filter, flatMap, zip, etc.)

─────────────────────────────────────
WHEN TO USE REACTIVE:
─────────────────────────────────────
  ✅ High-throughput streaming data (IoT, events, logs)
  ✅ Composing multiple async operations (API chaining)
  ✅ Backpressure-sensitive pipelines

  ❌ Simple CRUD operations (regular blocking is fine)
  ❌ Small-scale apps (complexity not worth it)
  ❌ When team isn't familiar (steep learning curve)

  For most apps: virtual threads handle I/O better
  than reactive with less complexity.

─────────────────────────────────────
PUBLISHER vs STREAM vs COMPLETABLEFUTURE:
─────────────────────────────────────
  CompletableFuture<T>  → single async value
  Stream<T>             → synchronous, lazy, blocking
  Flow.Publisher<T>     → async, non-blocking, backpressure

💻 CODE:
import java.util.concurrent.*;
import java.util.*;
import java.util.concurrent.Flow.*;

// ─── CUSTOM SUBSCRIBER ────────────────────────────────
class PrintSubscriber<T> implements Subscriber<T> {
    private Subscription subscription;
    private final int batchSize;
    private final String name;
    private int received = 0;

    PrintSubscriber(String name, int batchSize) {
        this.name = name;
        this.batchSize = batchSize;
    }

    @Override
    public void onSubscribe(Subscription sub) {
        this.subscription = sub;
        System.out.println("  [" + name + "] Subscribed — requesting " + batchSize);
        subscription.request(batchSize); // request first batch
    }

    @Override
    public void onNext(T item) {
        received++;
        System.out.println("  [" + name + "] Received #" + received + ": " + item);
        if (received % batchSize == 0) {
            System.out.println("  [" + name + "] Processed batch — requesting " + batchSize + " more");
            subscription.request(batchSize);
        }
    }

    @Override
    public void onError(Throwable t) {
        System.out.println("  [" + name + "] ERROR: " + t.getMessage());
    }

    @Override
    public void onComplete() {
        System.out.println("  [" + name + "] COMPLETE — received " + received + " items total");
    }
}

// ─── SIMPLE TRANSFORMATION PROCESSOR ─────────────────
class TransformProcessor<T, R> extends SubmissionPublisher<R>
        implements Processor<T, R> {

    private final java.util.function.Function<T, R> transformer;
    private Subscription subscription;

    TransformProcessor(java.util.function.Function<T, R> transformer) {
        this.transformer = transformer;
    }

    @Override
    public void onSubscribe(Subscription sub) {
        this.subscription = sub;
        sub.request(Long.MAX_VALUE);  // pull all items
    }

    @Override
    public void onNext(T item) {
        submit(transformer.apply(item));  // transform and forward
    }

    @Override
    public void onError(Throwable t) { closeExceptionally(t); }

    @Override
    public void onComplete() { close(); }
}

public class ReactiveFlow {
    public static void main(String[] args) throws Exception {

        // ─── BASIC PUBLISHER-SUBSCRIBER ───────────────────
        System.out.println("=== Basic Flow: Publisher → Subscriber ===");

        try (SubmissionPublisher<String> publisher = new SubmissionPublisher<>()) {
            PrintSubscriber<String> subscriber = new PrintSubscriber<>("Sub1", 3);
            publisher.subscribe(subscriber);

            // Publish items
            String[] items = {"Apple", "Banana", "Cherry", "Date", "Elderberry",
                               "Fig", "Grape", "Honeydew"};
            for (String item : items) {
                System.out.println("  Publishing: " + item);
                publisher.submit(item);
                Thread.sleep(20);  // let subscriber process
            }
            Thread.sleep(200);  // wait for all to be processed
        }  // close() called automatically → onComplete()

        // ─── MULTIPLE SUBSCRIBERS ─────────────────────────
        System.out.println("\n=== Multiple Subscribers ===");

        try (SubmissionPublisher<Integer> numPub = new SubmissionPublisher<>()) {
            PrintSubscriber<Integer> slowSub  = new PrintSubscriber<>("Slow",  2);
            PrintSubscriber<Integer> fastSub  = new PrintSubscriber<>("Fast",  5);
            numPub.subscribe(slowSub);
            numPub.subscribe(fastSub);

            for (int i = 1; i <= 6; i++) {
                numPub.submit(i * 10);
                Thread.sleep(10);
            }
            Thread.sleep(300);
        }

        // ─── PROCESSOR — transform pipeline ───────────────
        System.out.println("\n=== Processor Pipeline ===");

        try (SubmissionPublisher<String> source = new SubmissionPublisher<>()) {
            // Pipeline: source → uppercase → print
            TransformProcessor<String, String> upperProc =
                new TransformProcessor<>(String::toUpperCase);
            PrintSubscriber<String> sink = new PrintSubscriber<>("Sink", 10);

            source.subscribe(upperProc);   // source → processor
            upperProc.subscribe(sink);     // processor → sink

            List<String> words = List.of("hello", "world", "java", "reactive");
            words.forEach(w -> {
                System.out.println("  Source emitting: " + w);
                source.submit(w);
            });

            Thread.sleep(200);
        }

        // ─── REACTIVE CONCEPT COMPARISON ──────────────────
        System.out.println("\n=== Reactive vs Traditional Comparison ===");
        System.out.println("""
          Traditional (blocking):
            for (Event event : eventSource.getAll()) {  // blocks until done
                process(event);
            }

          Reactive (non-blocking + backpressure):
            publisher.subscribe(new Subscriber<Event>() {
                public void onSubscribe(Subscription s) {
                    s.request(10);  // request 10 at a time
                }
                public void onNext(Event e) {
                    process(e);
                    // request more when ready
                }
            });
          """);

        // ─── REAL FRAMEWORKS REFERENCE ────────────────────
        System.out.println("=== Real Reactive Frameworks ===");
        System.out.println("""
          Project Reactor (Spring WebFlux):
            Mono<User> user = userRepo.findById(id);   // 0 or 1
            Flux<Order> orders = orderRepo.findAll();  // stream

            user.flatMap(u -> orderRepo.findByUser(u))
                .filter(o -> o.getTotal() > 100)
                .map(OrderDto::from)
                .subscribe(dto -> System.out.println(dto));

          RxJava 3:
            Observable.fromIterable(items)
                .filter(s -> s.length() > 3)
                .map(String::toUpperCase)
                .subscribe(System.out::println);

          Key operators (same in both):
            map(), flatMap(), filter(), take(), skip()
            zip(), merge(), concat(), switchMap()
            retry(), timeout(), onErrorReturn()
            buffer(), window(), debounce(), throttle()
          """);
    }
}

📝 KEY POINTS:
✅ The Flow API provides 4 interfaces: Publisher, Subscriber, Subscription, Processor
✅ Backpressure: subscriber calls subscription.request(n) to control flow rate
✅ SubmissionPublisher is the built-in publisher — handles buffering and backpressure
✅ onSubscribe → request(n) → onNext (×n) → request(n) → ... → onComplete
✅ Processor implements both Subscriber and Publisher — transforms between stages
✅ Project Reactor (Mono/Flux) and RxJava are the production-grade reactive libraries
✅ Virtual threads often achieve reactive benefits with less complexity for I/O-bound work
✅ Reactive shines for: streaming data, backpressure-sensitive pipelines, event-driven systems
❌ Flow API alone lacks operators (map, filter, flatMap) — use Reactor or RxJava for production
❌ Reactive adds significant complexity — only use when the benefits outweigh the cost
❌ Never block inside a reactive pipeline (Thread.sleep, JDBC) — defeats the purpose
❌ Backpressure only works if both publisher and subscriber respect it
""",
  quiz: [
    Quiz(question: 'What is backpressure in reactive programming?', options: [
      QuizOption(text: 'A mechanism where the subscriber controls how many items the publisher sends — preventing buffer overflow', correct: true),
      QuizOption(text: 'A technique where the publisher pushes data backward through the pipeline for retry', correct: false),
      QuizOption(text: 'The memory pressure caused by too many subscribers holding references', correct: false),
      QuizOption(text: 'A network optimization that compresses data before sending to subscribers', correct: false),
    ]),
    Quiz(question: 'What is the correct sequence of method calls in the Flow API lifecycle?', options: [
      QuizOption(text: 'subscribe() → onSubscribe() → request(n) → onNext() × n → onComplete()', correct: true),
      QuizOption(text: 'subscribe() → onNext() → request(n) → onSubscribe() → onComplete()', correct: false),
      QuizOption(text: 'request(n) → subscribe() → onSubscribe() → onNext() → onComplete()', correct: false),
      QuizOption(text: 'onSubscribe() → subscribe() → onNext() → request(n) → onComplete()', correct: false),
    ]),
    Quiz(question: 'When should you prefer virtual threads over reactive programming?', options: [
      QuizOption(text: 'For I/O-bound applications where you want non-blocking behavior with simpler blocking-style code and lower learning curve', correct: true),
      QuizOption(text: 'When processing unbounded streaming data with strict backpressure requirements', correct: false),
      QuizOption(text: 'When composing many async operations with complex transformation pipelines', correct: false),
      QuizOption(text: 'Virtual threads and reactive programming are identical — choose based on team preference', correct: false),
    ]),
  ],
);
