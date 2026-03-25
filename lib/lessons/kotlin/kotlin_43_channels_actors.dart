import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson43 = Lesson(
  language: 'Kotlin',
  title: 'Coroutines Advanced: Channels and Actors',
  content: """
🎯 METAPHOR:
A Channel is like a pneumatic tube system in a hospital —
the kind that carries medication between floors. A nurse
puts a capsule in the tube (sends a value). A pharmacist
at the other end pulls it out (receives it). The tube
handles all the timing: if the pharmacist is busy, the
capsule waits. If the tube is full, the nurse waits.
Neither has to think about timing — the tube handles it.
Multiple senders, multiple receivers, all coordinated
without locks. That's a Channel.

📖 EXPLANATION:
Channels are the coroutine equivalent of a queue that
connects coroutines. They enable safe communication between
coroutines without shared mutable state.

─────────────────────────────────────
CHANNEL BASICS:
─────────────────────────────────────
  val channel = Channel<Int>()

  // Producer coroutine
  launch {
      for (i in 1..5) {
          channel.send(i)     // suspends if full
      }
      channel.close()         // signals no more values
  }

  // Consumer coroutine
  launch {
      for (value in channel) {  // iterates until closed
          println(value)
      }
  }

─────────────────────────────────────
CHANNEL TYPES (buffer sizes):
─────────────────────────────────────
  Channel<Int>()               → RENDEZVOUS: no buffer
                                  sender suspends until receiver ready
  Channel<Int>(capacity = 10)  → BUFFERED: up to 10 items
                                  sender only suspends when full
  Channel<Int>(UNLIMITED)      → unlimited buffer (use carefully)
  Channel<Int>(CONFLATED)      → only keeps latest value (like StateFlow)

─────────────────────────────────────
PRODUCE — shorthand for producer coroutine:
─────────────────────────────────────
  val channel = produce {
      for (i in 1..5) {
          send(i * i)
      }
  }

  for (square in channel) {
      println(square)   // 1, 4, 9, 16, 25
  }

─────────────────────────────────────
FAN-OUT — one channel, multiple consumers:
─────────────────────────────────────
  val jobs = produce { repeat(20) { send(it) } }

  repeat(5) { workerId ->
      launch {
          for (job in jobs) {
              println("Worker \$workerId: job \$job")
          }
      }
  }

Jobs are distributed across workers automatically.

─────────────────────────────────────
FAN-IN — multiple senders, one channel:
─────────────────────────────────────
  fun CoroutineScope.produceFrom(
      items: List<Int>, dest: SendChannel<Int>
  ) = launch {
      items.forEach { dest.send(it) }
  }

  val merged = Channel<Int>()
  produceFrom(listOf(1, 3, 5), merged)
  produceFrom(listOf(2, 4, 6), merged)

─────────────────────────────────────
ACTORS — encapsulated state via messages:
─────────────────────────────────────
An actor is a coroutine that owns state privately and
receives messages through a Channel. Callers send messages
instead of directly mutating state — thread-safe by design.

  sealed class CounterMsg
  object Increment : CounterMsg()
  data class GetCount(val response: CompletableDeferred<Int>) : CounterMsg()

  fun CoroutineScope.counterActor() = actor<CounterMsg> {
      var counter = 0
      for (msg in channel) {
          when (msg) {
              is Increment -> counter++
              is GetCount  -> msg.response.complete(counter)
          }
      }
  }

  val counter = counterActor()
  repeat(1000) { counter.send(Increment) }
  val deferred = CompletableDeferred<Int>()
  counter.send(GetCount(deferred))
  println(deferred.await())   // 1000

─────────────────────────────────────
SELECT — wait for multiple channels:
─────────────────────────────────────
  select<Unit> {
      channel1.onReceive { value -> println("From ch1: \$value") }
      channel2.onReceive { value -> println("From ch2: \$value") }
  }

Like a switch statement but for channels — handles
whichever one is ready first.

─────────────────────────────────────
CHANNEL vs FLOW:
─────────────────────────────────────
  Channel:           Hot, push-based, coroutine primitive
  Flow:              Cold (usually), pull-based, declarative

  Use Channel for:   coroutine-to-coroutine communication
  Use Flow for:      observable data streams, reactive UIs

💻 CODE:
import kotlinx.coroutines.*
import kotlinx.coroutines.channels.*

// Pipeline pattern: chain of producers/transformers
fun CoroutineScope.generateNumbers(count: Int): ReceiveChannel<Int> = produce {
    for (i in 1..count) {
        send(i)
        delay(10)
    }
}

fun CoroutineScope.squareNumbers(input: ReceiveChannel<Int>): ReceiveChannel<Int> = produce {
    for (n in input) {
        send(n * n)
    }
}

fun CoroutineScope.filterEven(input: ReceiveChannel<Int>): ReceiveChannel<Int> = produce {
    for (n in input) {
        if (n % 2 == 0) send(n)
    }
}

// Actor pattern
sealed class BankMessage
data class Deposit(val amount: Double) : BankMessage()
data class Withdraw(val amount: Double, val response: CompletableDeferred<Boolean>) : BankMessage()
data class Balance(val response: CompletableDeferred<Double>) : BankMessage()

@OptIn(ObsoleteCoroutinesApi::class)
fun CoroutineScope.bankActor(initialBalance: Double) = actor<BankMessage> {
    var balance = initialBalance
    for (msg in channel) {
        when (msg) {
            is Deposit -> {
                balance += msg.amount
                println("  Deposited ${
msg.amount}, balance now \$balance")
            }
            is Withdraw -> {
                if (msg.amount <= balance) {
                    balance -= msg.amount
                    println("  Withdrew ${
msg.amount}, balance now \$balance")
                    msg.response.complete(true)
                } else {
                    println("  Insufficient funds for ${
msg.amount}, balance \$balance")
                    msg.response.complete(false)
                }
            }
            is Balance -> msg.response.complete(balance)
        }
    }
}

@OptIn(ObsoleteCoroutinesApi::class, ExperimentalCoroutinesApi::class)
fun main() = runBlocking {
    // ─── Basic channel ────────────────────────────────
    println("=== Basic Channel ===")
    val channel = Channel<String>()

    launch {
        listOf("Hello", "from", "a", "channel").forEach {
            channel.send(it)
        }
        channel.close()
    }

    for (word in channel) {
        print("\$word ")
    }
    println()

    // ─── Pipeline ────────────────────────────────────
    println("\\n=== Pipeline ===")
    val numbers = generateNumbers(10)
    val squares = squareNumbers(numbers)
    val evenSquares = filterEven(squares)

    println("Even squares from 1-10:")
    for (n in evenSquares) {
        print("\$n ")
    }
    println()

    // ─── Fan-out (work distribution) ─────────────────
    println("\\n=== Fan-out ===")
    val jobs = produce {
        repeat(12) { send(it + 1) }
    }

    val results = mutableListOf<String>()
    val resultChannel = Channel<String>()

    repeat(3) { workerId ->
        launch {
            for (job in jobs) {
                delay((Math.random() * 50).toLong())
                resultChannel.send("Worker \$workerId completed job #\$job")
            }
        }
    }

    // Collect results (one per job)
    repeat(12) {
        results.add(resultChannel.receive())
    }
    results.sorted().forEach { println("  \$it") }

    // ─── Buffered channel ─────────────────────────────
    println("\\n=== Buffered Channel (capacity=3) ===")
    val buffered = Channel<Int>(3)

    // Producer fills buffer without waiting
    launch {
        repeat(5) { i ->
            println("Sending \$i...")
            buffered.send(i)
            println("Sent \$i")
        }
        buffered.close()
    }

    delay(100)  // give producer time to fill buffer
    println("Receiving:")
    for (item in buffered) {
        delay(20)
        println("  Received: \$item")
    }

    // ─── Actor pattern ────────────────────────────────
    println("\\n=== Actor (Bank Account) ===")
    val bank = bankActor(1000.0)

    // Concurrent transactions
    coroutineScope {
        launch { bank.send(Deposit(500.0)) }
        launch { bank.send(Deposit(250.0)) }

        val wd1 = CompletableDeferred<Boolean>()
        val wd2 = CompletableDeferred<Boolean>()

        launch { bank.send(Withdraw(300.0, wd1)) }
        launch { bank.send(Withdraw(2000.0, wd2)) }

        println("Withdraw 300: ${
wd1.await()}")
        println("Withdraw 2000: ${
wd2.await()}")
    }

    val finalBalance = CompletableDeferred<Double>()
    bank.send(Balance(finalBalance))
    println("Final balance: ${
finalBalance.await()}")
    bank.close()
}

📝 KEY POINTS:
✅ Channels enable safe coroutine-to-coroutine communication
✅ Closed channels signal completion — iterate with for(x in channel)
✅ produce {} is the idiomatic shorthand for a producer coroutine
✅ Buffered channels decouple sender and receiver speeds
✅ CONFLATED channels only keep the latest value — like StateFlow
✅ Actors encapsulate mutable state behind message passing — no locks
✅ CompletableDeferred<T> enables request-response patterns with actors
✅ Pipeline pattern chains produce {} blocks for stream processing
❌ Always close() channels when done — unclosed channels leak
❌ Don't share mutable state between coroutines — use channels/actors
❌ Actor API is marked ObsoleteCoroutinesApi — use Mutex for simpler cases
❌ Receiving from a closed, empty channel throws ClosedReceiveChannelException
""",
  quiz: [
    Quiz(question: 'What is a RENDEZVOUS channel in Kotlin coroutines?', options: [
      QuizOption(text: 'A channel with no buffer — the sender suspends until the receiver is ready to receive', correct: true),
      QuizOption(text: 'A channel that connects two coroutines running on the same thread', correct: false),
      QuizOption(text: 'A channel that automatically closes after one value is sent and received', correct: false),
      QuizOption(text: 'A special channel type for synchronizing with the main thread', correct: false),
    ]),
    Quiz(question: 'What is the actor pattern in coroutines designed to solve?', options: [
      QuizOption(text: 'Thread-safe access to mutable state by replacing shared state with message passing', correct: true),
      QuizOption(text: 'Parallel execution of CPU-bound tasks across multiple cores', correct: false),
      QuizOption(text: 'Organizing coroutines into a hierarchy with structured cancellation', correct: false),
      QuizOption(text: 'Broadcasting events from one coroutine to many receivers simultaneously', correct: false),
    ]),
    Quiz(question: 'When should you use a Channel instead of a Flow?', options: [
      QuizOption(text: 'For coroutine-to-coroutine communication where one pushes values and another receives them', correct: true),
      QuizOption(text: 'When you need lazy evaluation and transformation operators like map and filter', correct: false),
      QuizOption(text: 'When you want to observe state changes in a reactive UI', correct: false),
      QuizOption(text: 'Channels and Flows are interchangeable — choose based on personal preference', correct: false),
    ]),
  ],
);
