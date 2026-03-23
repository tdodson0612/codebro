import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson26 = Lesson(
  language: 'Kotlin',
  title: 'Coroutines: Flow',
  content: """
🎯 METAPHOR:
A Flow is like a water pipe. A regular function is like
a bucket — you ask for water, you get ONE bucketful, done.
A Flow is a pipe that delivers water continuously, one
drop at a time, over time. You can attach a filter (to
only let through cold water), a transformer (to heat the
water), and a collector at the end (your shower head).
The pipe only runs water when someone turns on the tap
(cold Flow — collecting triggers emission). The pipe can
also be a live TV broadcast — it keeps streaming whether
you're watching or not (hot Flow — StateFlow/SharedFlow).

📖 EXPLANATION:
Flow is Kotlin's reactive streams solution. While suspend
functions return ONE value, Flow emits MULTIPLE values
over time — perfect for data streams, real-time updates,
and reactive UIs.

─────────────────────────────────────
COLD vs HOT FLOWS:
─────────────────────────────────────
  Cold Flow (Flow<T>):
    → Doesn't start until collected
    → Each collector gets its OWN independent stream
    → Like a YouTube video — starts from beginning each time

  Hot Flow (StateFlow, SharedFlow):
    → Active regardless of collectors
    → All collectors share the SAME stream
    → Like live TV — you join mid-stream

─────────────────────────────────────
CREATING A FLOW:
─────────────────────────────────────
  val numbersFlow = flow {
      emit(1)         // emit a value
      delay(100)
      emit(2)
      delay(100)
      emit(3)
  }

  // Also:
  flowOf(1, 2, 3)              // from fixed values
  listOf(1, 2, 3).asFlow()     // from a collection
  (1..10).asFlow()             // from a range

─────────────────────────────────────
COLLECTING A FLOW:
─────────────────────────────────────
  numbersFlow.collect { value ->
      println(value)   // called for each emitted value
  }

collect is a terminal operator — it triggers the flow.
It's suspend — must be called from a coroutine.

─────────────────────────────────────
FLOW OPERATORS (intermediate):
─────────────────────────────────────
  map { }              → transform each value
  filter { }           → keep matching values
  take(n)              → only take first n values
  onEach { }           → side effect on each value
  flatMapConcat { }    → map to flows, merge in order
  flatMapMerge { }     → map to flows, merge concurrently
  catch { }            → handle exceptions in the flow
  onStart { }          → run before first emission
  onCompletion { }     → run when flow completes
  buffer()             → decouple producer and consumer speeds
  conflate()           → skip intermediate values if slow
  debounce(ms)         → only emit after silence period
  distinctUntilChanged → only emit when value changes

─────────────────────────────────────
TERMINAL OPERATORS:
─────────────────────────────────────
  collect { }          → process each value
  toList()             → collect all into a List
  toSet()              → collect all into a Set
  first()              → first value (and cancel)
  last()               → last value
  single()             → exactly one value or exception
  count()              → total number of values
  reduce { acc, it } → fold without initial value
  fold(init) { }       → fold with initial value

─────────────────────────────────────
StateFlow — hot, state-holding:
─────────────────────────────────────
  val _state = MutableStateFlow(0)  // initial value required
  val state: StateFlow<Int> = _state

  _state.value = 1     // update state
  _state.update { it + 1 }  // atomic update

  // Collect: always emits current value to new collectors
  state.collect { println("State: \$it") }

─────────────────────────────────────
SharedFlow — hot, event broadcast:
─────────────────────────────────────
  val _events = MutableSharedFlow<String>()

  // Emit:
  _events.emit("User logged in")

  // Collect:
  _events.collect { println("Event: \$it") }

  SharedFlow doesn't replay by default — late collectors
  miss past events (configure with replay parameter).

💻 CODE:
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*

// Simulating a data stream
fun temperatureStream(): Flow<Double> = flow {
    val temperatures = listOf(18.5, 19.0, 21.5, 20.0, 22.0, 19.5)
    for (temp in temperatures) {
        emit(temp)
        delay(500)   // emit every 500ms
    }
}

fun numberStream(): Flow<Int> = flow {
    for (i in 1..10) {
        emit(i)
        delay(100)
    }
}

// Simulate an API that pages through results
fun pagedResults(pages: Int): Flow<List<String>> = flow {
    for (page in 1..pages) {
        delay(200)
        emit(listOf("Item \${(page - 1) * 3 + 1}", "Item \${(page - 1) * 3 + 2}", "Item \${(page - 1) * 3 + 3}"))
    }
}

fun main() = runBlocking {
    // Basic collection
    println("--- Basic Flow ---")
    numberStream()
        .filter { it % 2 == 0 }
        .map { it * it }
        .take(3)
        .collect { println("Value: \$it") }
    // 4, 16, 36 (squares of 2, 4, 6)

    // Terminal operators
    println("\\n--- Terminal operators ---")
    val numbers = numberStream()
    println("Sum: \${numbers.toList().sum()}")

    val firstEven = numberStream().filter { it % 2 == 0 }.first()
    println("First even: \$firstEven")

    val total = numberStream().fold(0) { acc, n -> acc + n }
    println("Total via fold: \$total")

    // onEach, onStart, onCompletion
    println("\\n--- Lifecycle operators ---")
    numberStream()
        .take(5)
        .onStart { println("Flow starting...") }
        .onEach { println("  Processing \$it") }
        .onCompletion { cause ->
            if (cause != null) println("Failed: \$cause")
            else println("Flow completed!")
        }
        .collect()

    // catch — error handling in flow
    println("\\n--- Error handling ---")
    flow<Int> {
        emit(1)
        emit(2)
        throw RuntimeException("Stream error!")
        emit(3)   // never reached
    }
    .catch { e -> println("Caught: \${e.message}") }
    .onCompletion { println("Done (after catch)") }
    .collect { println("Got: \$it") }

    // Flat map paged results
    println("\\n--- flatMapConcat ---")
    pagedResults(3)
        .flatMapConcat { page -> page.asFlow() }
        .collect { println("  \$it") }

    // StateFlow example
    println("\\n--- StateFlow ---")
    val counter = MutableStateFlow(0)

    val collectJob = launch {
        counter
            .take(6)
            .collect { println("Counter: \$it") }
    }

    repeat(5) { i ->
        delay(100)
        counter.value = i + 1
    }
    collectJob.join()

    // SharedFlow example
    println("\\n--- SharedFlow ---")
    val eventBus = MutableSharedFlow<String>()

    val listener1 = launch {
        eventBus.take(3).collect { println("Listener 1: \$it") }
    }
    val listener2 = launch {
        eventBus.take(3).collect { println("Listener 2: \$it") }
    }

    delay(50)
    eventBus.emit("Login event")
    eventBus.emit("Data loaded")
    eventBus.emit("UI ready")

    listener1.join()
    listener2.join()
}

📝 KEY POINTS:
✅ Flow emits multiple values over time — perfect for streams
✅ Cold flows only run when collected — no collector = no work
✅ Use map/filter/take to build pipelines before collecting
✅ catch {} handles exceptions mid-flow without crashing
✅ StateFlow holds current state and replays it to new collectors
✅ SharedFlow is for events — all active collectors receive them
✅ toList(), first(), fold() are terminal operators that trigger flow
✅ onStart, onEach, onCompletion add lifecycle hooks
❌ Never collect a Flow on the Main thread with a blocking call
❌ Don't emit from non-suspend context inside flow { }
❌ StateFlow only emits when value CHANGES — distinctUntilChanged built-in
❌ SharedFlow doesn't replay by default — late collectors miss events
""",
  quiz: [
    Quiz(question: 'What is the difference between a cold Flow and a hot StateFlow?', options: [
      QuizOption(text: 'Cold Flow only starts emitting when collected; StateFlow is always active and holds current state', correct: true),
      QuizOption(text: 'Cold Flow is faster; StateFlow is thread-safe', correct: false),
      QuizOption(text: 'StateFlow requires a CoroutineScope; cold Flow does not', correct: false),
      QuizOption(text: 'They are identical except StateFlow has type safety', correct: false),
    ]),
    Quiz(question: 'What does the catch operator do in a Flow pipeline?', options: [
      QuizOption(text: 'It intercepts exceptions thrown upstream and allows recovery without crashing the flow', correct: true),
      QuizOption(text: 'It retries the failed emission a configurable number of times', correct: false),
      QuizOption(text: 'It cancels the flow and returns a default value', correct: false),
      QuizOption(text: 'It wraps each emitted value in a Result type automatically', correct: false),
    ]),
    Quiz(question: 'Which operator would you use to collect all Flow values into a List?', options: [
      QuizOption(text: 'toList() — a terminal operator that suspends until all values are collected', correct: true),
      QuizOption(text: 'collect { list.add(it) } — the only way to accumulate values', correct: false),
      QuizOption(text: 'buffer() — buffers values into a list before emitting', correct: false),
      QuizOption(text: 'asFlow().toList() — you must convert first', correct: false),
    ]),
  ],
);
