import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson07 = Lesson(
  language: 'Kotlin',
  title: 'Loops: for, while, do-while',
  content: """
🎯 METAPHOR:
Loops are like a factory assembly line. The assembly line
runs the same operation on every item that comes through —
over and over — until the conveyor belt is empty. Without
loops, you'd have to write the same instruction for every
single item by hand. With loops, you write the instruction
ONCE and say: "do this for every item." A for loop is like
a scheduled assembly line — you know exactly how many items
are coming. A while loop is like a line that keeps running
as long as parts keep arriving — no fixed count.

📖 EXPLANATION:
Kotlin has three loop types: for, while, and do-while.
The for loop in Kotlin is uniquely powerful because it works
with ranges, collections, and anything iterable.

─────────────────────────────────────
FOR LOOP:
─────────────────────────────────────
Kotlin's for loop always iterates over something:
a range, a list, a map, a string — anything iterable.
There is no C-style for(i=0; i<n; i++) in Kotlin.

  for (item in collection) {
      // do something with item
  }

With ranges:
  for (i in 1..5) { }          // 1 2 3 4 5
  for (i in 1 until 5) { }     // 1 2 3 4
  for (i in 5 downTo 1) { }    // 5 4 3 2 1
  for (i in 1..10 step 2) { }  // 1 3 5 7 9

─────────────────────────────────────
ITERATING WITH INDEX:
─────────────────────────────────────
Use withIndex() to get both the index and value:

  for ((index, value) in list.withIndex()) {
      println("\$index: \$value")
  }

─────────────────────────────────────
WHILE LOOP:
─────────────────────────────────────
Runs as long as the condition is true.
Checks condition BEFORE each iteration.

  while (condition) {
      // runs 0 or more times
  }

Use when you don't know the count in advance.

─────────────────────────────────────
DO-WHILE LOOP:
─────────────────────────────────────
Like while, but checks condition AFTER each iteration.
Guarantees the body runs AT LEAST ONCE.

  do {
      // runs 1 or more times
  } while (condition)

Metaphor: A do-while is like a test drive.
You ALWAYS take at least one lap (the do) before you
decide whether to keep going (the while check).

─────────────────────────────────────
BREAK AND CONTINUE:
─────────────────────────────────────
  break    → exit the loop immediately
  continue → skip the rest of this iteration, go to next

─────────────────────────────────────
LABELED LOOPS (nested break/continue):
─────────────────────────────────────
Kotlin supports labeled break/continue to escape
from nested loops — something Java requires extra
flags to do:

  outer@ for (i in 1..3) {
      for (j in 1..3) {
          if (j == 2) break@outer   // exits BOTH loops
      }
  }

─────────────────────────────────────
REPEAT:
─────────────────────────────────────
Kotlin has a clean utility for simple repetition:

  repeat(5) {
      println("Hello!")
  }

💻 CODE:
fun main() {
    // Basic range loop
    for (i in 1..5) {
        print("\$i ")   // 1 2 3 4 5
    }
    println()

    // until (exclusive end)
    for (i in 0 until 5) {
        print("\$i ")   // 0 1 2 3 4
    }
    println()

    // downTo and step
    for (i in 10 downTo 1 step 2) {
        print("\$i ")   // 10 8 6 4 2
    }
    println()

    // Iterate over a list
    val fruits = listOf("Apple", "Banana", "Cherry")
    for (fruit in fruits) {
        println("I like \$fruit")
    }

    // Iterate with index
    for ((index, fruit) in fruits.withIndex()) {
        println("\$index: \$fruit")
    }

    // Iterate over a String
    for (char in "Kotlin") {
        print("\$char-")   // K-o-t-l-i-n-
    }
    println()

    // while loop
    var count = 0
    while (count < 5) {
        print("\$count ")
        count++
    }
    println()   // 0 1 2 3 4

    // do-while — runs at least once
    var input = 0
    do {
        println("Processing: \$input")
        input++
    } while (input < 3)
    // Prints: 0, 1, 2

    // break and continue
    for (i in 1..10) {
        if (i == 6) break        // stop at 6
        if (i % 2 == 0) continue // skip even numbers
        print("\$i ")            // 1 3 5
    }
    println()

    // Labeled break (escape nested loop)
    outer@ for (i in 1..3) {
        for (j in 1..3) {
            if (i == 2 && j == 2) {
                println("Breaking out at i=\$i, j=\$j")
                break@outer
            }
            println("i=\$i, j=\$j")
        }
    }

    // repeat utility
    repeat(3) { iteration ->
        println("Repeat #\$iteration")
    }
}

📝 KEY POINTS:
✅ Kotlin's for loop always iterates over something iterable
✅ Ranges: .. (inclusive), until (exclusive), downTo, step
✅ withIndex() gives you both index and value in a for loop
✅ while checks condition BEFORE running — may run 0 times
✅ do-while checks AFTER — always runs at least once
✅ Use labeled break/continue for nested loop control
✅ repeat(n) is a clean shortcut for simple repetition
❌ There is no C-style for(int i=0; i<n; i++) in Kotlin
❌ Don't use while(true) without a guaranteed break condition
❌ Modifying a collection while iterating it causes errors
   — iterate a copy or use removeIf() instead
""",
  quiz: [
    Quiz(question: 'How do you iterate from 1 to 10, skipping every other number (1, 3, 5...)?', options: [
      QuizOption(text: 'for (i in 1..10 step 2)', correct: true),
      QuizOption(text: 'for (i in 1..10 skip 2)', correct: false),
      QuizOption(text: 'for (i in 1..10 by 2)', correct: false),
      QuizOption(text: 'for (i in 1..10; i += 2)', correct: false),
    ]),
    Quiz(question: 'What is the key difference between while and do-while?', options: [
      QuizOption(text: 'do-while always executes its body at least once before checking the condition', correct: true),
      QuizOption(text: 'while can only iterate over numbers; do-while works with collections', correct: false),
      QuizOption(text: 'while is faster; do-while is safer', correct: false),
      QuizOption(text: 'do-while requires an else branch', correct: false),
    ]),
    Quiz(question: 'What does break@outer do in a labeled Kotlin loop?', options: [
      QuizOption(text: 'Breaks out of the loop labeled outer, not just the inner loop', correct: true),
      QuizOption(text: 'Pauses the outer loop and continues the inner one', correct: false),
      QuizOption(text: 'It is invalid syntax — break cannot be labeled in Kotlin', correct: false),
      QuizOption(text: 'Breaks out of the function entirely', correct: false),
    ]),
  ],
);
