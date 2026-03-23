import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson62 = Lesson(
  language: 'Java',
  title: 'Advanced Concurrency: Locks, Semaphores, and Barriers',
  content: """
🎯 METAPHOR:
synchronized is the simple lock on a bathroom door — only
one person in at a time. ReentrantLock is the same lock
but with extra features: a timer (tryLock with timeout),
an intercom (condition variables), and a record of who's
inside (fair ordering). ReadWriteLock is the library
rule: anyone can read simultaneously, but writing requires
exclusive access. Semaphore is the parking garage: it
has exactly N spots — take one when you enter, return it
when you leave. CountDownLatch is the race starting gun:
all runners wait at the line, and when the gun fires (count
reaches zero), everyone starts at once.

📖 EXPLANATION:
java.util.concurrent provides rich concurrency primitives
beyond basic synchronized.

─────────────────────────────────────
REENTRANTLOCK — flexible mutual exclusion:
─────────────────────────────────────
  ReentrantLock lock = new ReentrantLock();
  ReentrantLock fairLock = new ReentrantLock(true);  // fair ordering

  lock.lock();
  try {
      // critical section
  } finally {
      lock.unlock();   // ALWAYS in finally!
  }

  // Try with timeout:
  if (lock.tryLock(5, TimeUnit.SECONDS)) {
      try { criticalSection(); }
      finally { lock.unlock(); }
  } else {
      System.out.println("Could not acquire lock in time");
  }

  // Interruptible:
  lock.lockInterruptibly();

─────────────────────────────────────
CONDITION VARIABLES — precise signaling:
─────────────────────────────────────
  Condition notEmpty = lock.newCondition();
  Condition notFull  = lock.newCondition();

  // Producer:
  lock.lock();
  try {
      while (buffer.isFull()) notFull.await();  // wait
      buffer.add(item);
      notEmpty.signal();   // wake one waiting consumer
  } finally { lock.unlock(); }

  // Consumer:
  lock.lock();
  try {
      while (buffer.isEmpty()) notEmpty.await();
      Item item = buffer.take();
      notFull.signal();
  } finally { lock.unlock(); }

─────────────────────────────────────
READWRITELOCK — concurrent reads:
─────────────────────────────────────
  ReadWriteLock rwl = new ReentrantReadWriteLock();
  Lock readLock  = rwl.readLock();
  Lock writeLock = rwl.writeLock();

  // Many readers simultaneously:
  readLock.lock();
  try { return data; }
  finally { readLock.unlock(); }

  // Exclusive writer:
  writeLock.lock();
  try { data = newValue; }
  finally { writeLock.unlock(); }

  Use when: many reads, few writes.
  StampedLock (Java 8): even more optimistic reads.

─────────────────────────────────────
SEMAPHORE — limited resource pool:
─────────────────────────────────────
  Semaphore sem = new Semaphore(3);  // 3 permits

  sem.acquire();   // take a permit (blocks if none)
  try { useResource(); }
  finally { sem.release(); }  // return permit

  sem.tryAcquire()                  // non-blocking
  sem.tryAcquire(timeout, unit)     // with timeout
  sem.availablePermits()            // current permits

  Use for: connection pools, rate limiting, bounded resources

─────────────────────────────────────
COUNTDOWNLATCH — wait for N events:
─────────────────────────────────────
  CountDownLatch latch = new CountDownLatch(3);

  // 3 workers signal when done:
  executor.submit(() -> { doWork(); latch.countDown(); });
  executor.submit(() -> { doWork(); latch.countDown(); });
  executor.submit(() -> { doWork(); latch.countDown(); });

  latch.await();   // main thread waits until count=0
  latch.await(timeout, unit);  // with timeout

  Not reusable — use CyclicBarrier for repeated use.

─────────────────────────────────────
CYCLICBARRIER — reusable meeting point:
─────────────────────────────────────
  CyclicBarrier barrier = new CyclicBarrier(3, () ->
      System.out.println("All threads met at barrier!"));

  // Each thread calls:
  barrier.await();  // waits until all N threads arrive

  Automatically resets after all arrive — reusable.
  Optional Runnable runs when all threads reach barrier.

─────────────────────────────────────
PHASER — flexible barrier (Java 7):
─────────────────────────────────────
  Phaser phaser = new Phaser(N);
  phaser.arriveAndAwaitAdvance();  // barrier per phase
  phaser.register();               // add participant
  phaser.arriveAndDeregister();    // leave

─────────────────────────────────────
EXCHANGER — swap objects between threads:
─────────────────────────────────────
  Exchanger<String> exchanger = new Exchanger<>();
  Thread A: String from B = exchanger.exchange("from A");
  Thread B: String from A = exchanger.exchange("from B");

💻 CODE:
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.*;
import java.util.concurrent.locks.*;
import java.util.stream.*;

public class AdvancedConcurrency {
    public static void main(String[] args) throws Exception {

        // ─── REENTRANTLOCK ────────────────────────────────
        System.out.println("=== ReentrantLock ===");
        ReentrantLock lock = new ReentrantLock();
        AtomicInteger counter = new AtomicInteger(0);

        ExecutorService pool = Executors.newFixedThreadPool(5);
        List<Future<?>> futures = new ArrayList<>();

        for (int i = 0; i < 5; i++) {
            futures.add(pool.submit(() -> {
                for (int j = 0; j < 1000; j++) {
                    lock.lock();
                    try { counter.incrementAndGet(); }
                    finally { lock.unlock(); }
                }
            }));
        }
        for (Future<?> f : futures) f.get();
        System.out.println("  Counter (expected 5000): " + counter.get());

        // tryLock with timeout
        Lock timed = new ReentrantLock();
        timed.lock();
        pool.submit(() -> {
            try {
                boolean acquired = timed.tryLock(100, TimeUnit.MILLISECONDS);
                System.out.println("  tryLock(100ms) acquired: " + acquired);
            } catch (InterruptedException e) {}
        }).get();
        timed.unlock();

        // ─── READWRITELOCK ────────────────────────────────
        System.out.println("\n=== ReadWriteLock ===");
        ReadWriteLock rwl = new ReentrantReadWriteLock();
        AtomicInteger reads = new AtomicInteger(0);
        AtomicInteger writes = new AtomicInteger(0);
        int[] data = {0};

        // Writer
        pool.submit(() -> {
            for (int i = 1; i <= 5; i++) {
                rwl.writeLock().lock();
                try {
                    data[0] = i;
                    writes.incrementAndGet();
                    Thread.sleep(5);
                } catch (InterruptedException e) {}
                finally { rwl.writeLock().unlock(); }
            }
        });

        // Multiple readers
        List<Future<Integer>> readFutures = new ArrayList<>();
        for (int i = 0; i < 10; i++) {
            readFutures.add(pool.submit(() -> {
                rwl.readLock().lock();
                try {
                    reads.incrementAndGet();
                    return data[0];
                } finally { rwl.readLock().unlock(); }
            }));
        }
        pool.shutdown();
        pool.awaitTermination(2, TimeUnit.SECONDS);
        System.out.println("  Reads: " + reads.get() + " | Writes: " + writes.get());
        System.out.println("  Final value: " + data[0]);

        // ─── SEMAPHORE ────────────────────────────────────
        System.out.println("\n=== Semaphore (connection pool) ===");
        Semaphore sem = new Semaphore(3);  // max 3 concurrent
        ExecutorService pool2 = Executors.newFixedThreadPool(8);
        AtomicInteger active = new AtomicInteger(0);
        AtomicInteger maxActive = new AtomicInteger(0);

        List<Future<?>> semFutures = IntStream.range(0, 8)
            .mapToObj(i -> pool2.submit(() -> {
                try {
                    sem.acquire();
                    int cur = active.incrementAndGet();
                    maxActive.updateAndGet(m -> Math.max(m, cur));
                    System.out.printf("  Thread %d in (active=%d, permits=%d)%n",
                        i, cur, sem.availablePermits());
                    Thread.sleep(50);
                    active.decrementAndGet();
                    sem.release();
                } catch (InterruptedException e) {}
            }))
            .collect(Collectors.toList());

        for (Future<?> f : semFutures) f.get();
        pool2.shutdown();
        System.out.println("  Max concurrent: " + maxActive.get() + " (limit=3)");

        // ─── COUNTDOWNLATCH ───────────────────────────────
        System.out.println("\n=== CountDownLatch ===");
        int workers = 5;
        CountDownLatch ready  = new CountDownLatch(workers);  // all ready
        CountDownLatch start  = new CountDownLatch(1);          // start gun
        CountDownLatch finish = new CountDownLatch(workers);  // all done

        ExecutorService runners = Executors.newFixedThreadPool(workers);
        for (int i = 0; i < workers; i++) {
            final int id = i + 1;
            runners.submit(() -> {
                System.out.println("  Worker " + id + " ready");
                ready.countDown();
                try {
                    start.await();   // wait for start signal
                    Thread.sleep((long)(Math.random() * 100));
                    System.out.println("  Worker " + id + " finished");
                    finish.countDown();
                } catch (InterruptedException e) {}
            });
        }

        ready.await();    // wait for all workers to be ready
        System.out.println("  All workers ready — starting!");
        start.countDown(); // fire the starting gun
        finish.await();    // wait for all to finish
        System.out.println("  All workers done!");
        runners.shutdown();

        // ─── CYCLICBARRIER ────────────────────────────────
        System.out.println("\n=== CyclicBarrier ===");
        int parties = 3;
        AtomicInteger phase = new AtomicInteger(0);
        CyclicBarrier barrier = new CyclicBarrier(parties, () ->
            System.out.println("  === Phase " + phase.incrementAndGet() + " complete ==="));

        ExecutorService barrierPool = Executors.newFixedThreadPool(parties);
        for (int t = 0; t < parties; t++) {
            final int tid = t;
            barrierPool.submit(() -> {
                try {
                    for (int p = 1; p <= 3; p++) {
                        System.out.printf("  Thread %d doing phase %d work%n", tid, p);
                        Thread.sleep((long)(Math.random() * 50));
                        barrier.await();  // wait for all
                    }
                } catch (Exception e) {}
            });
        }
        barrierPool.shutdown();
        barrierPool.awaitTermination(2, TimeUnit.SECONDS);
    }
}

📝 KEY POINTS:
✅ ReentrantLock: ALWAYS put unlock() in a finally block to prevent deadlock
✅ tryLock(timeout) avoids indefinite blocking — gracefully handle lock unavailability
✅ ReadWriteLock: concurrent reads are fine; writes need exclusive access
✅ Semaphore: controls access to a fixed pool of resources (DB connections, rate limiting)
✅ CountDownLatch: wait for N events; count can't be reset — one-time use
✅ CyclicBarrier: all threads wait at a point; automatically resets — use for phases
✅ Condition variables (lock.newCondition()) allow precise wake-up of waiting threads
✅ StampedLock (Java 8): optimistic reads without locking — most performant for read-heavy workloads
❌ Never call await() outside a lock — IllegalMonitorStateException
❌ Forgetting unlock() in a finally block causes permanent deadlock
❌ ReentrantLock vs synchronized: use ReentrantLock when you need tryLock/timeout/interruptible
❌ CountDownLatch cannot be reset — create a new one for the next countdown
""",
  quiz: [
    Quiz(question: 'Why must lock.unlock() always be called in a finally block?', options: [
      QuizOption(text: 'If the critical section throws an exception, finally ensures the lock is always released — preventing permanent deadlock', correct: true),
      QuizOption(text: 'The lock will expire automatically if not released in finally', correct: false),
      QuizOption(text: 'finally is the only place where unlock() compiles without a checked exception', correct: false),
      QuizOption(text: 'JVM garbage collection requires locks to be released in finally blocks', correct: false),
    ]),
    Quiz(question: 'What is the key difference between CountDownLatch and CyclicBarrier?', options: [
      QuizOption(text: 'CountDownLatch is one-time use; CyclicBarrier resets automatically after all parties arrive', correct: true),
      QuizOption(text: 'CountDownLatch works for inter-process communication; CyclicBarrier is thread-only', correct: false),
      QuizOption(text: 'CyclicBarrier blocks one thread; CountDownLatch blocks multiple threads simultaneously', correct: false),
      QuizOption(text: 'They are identical — CyclicBarrier is just the newer version of CountDownLatch', correct: false),
    ]),
    Quiz(question: 'When is ReadWriteLock more efficient than a regular lock?', options: [
      QuizOption(text: 'When reads are frequent and writes are rare — multiple threads can read concurrently without blocking each other', correct: true),
      QuizOption(text: 'When write operations are faster than read operations', correct: false),
      QuizOption(text: 'When the data structure being protected is immutable', correct: false),
      QuizOption(text: 'ReadWriteLock is always more efficient than ReentrantLock regardless of read/write ratio', correct: false),
    ]),
  ],
);
