import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson01 = Lesson(
  language: 'Kotlin',
  title: 'What is Kotlin?',
  content: """
🎯 METAPHOR:
Kotlin is like a brand-new, ergonomically designed version
of a tool you already know. Imagine Java is a reliable but
heavy old wrench — it gets the job done, but your hand gets
tired and you have to be careful not to strip the bolt.
Kotlin is the same wrench, redesigned by engineers who used
it for 20 years and said: "Here's every mistake we made.
Now watch us fix all of them." Same bolts. Same engine.
Completely better to hold.

📖 EXPLANATION:
Kotlin is a modern, statically typed programming language
developed by JetBrains (the company behind IntelliJ IDEA).
It was released in 2016 and became Google's preferred
language for Android development in 2017.

─────────────────────────────────────
WHERE KOTLIN RUNS:
─────────────────────────────────────
  Kotlin/JVM   → compiles to Java bytecode, runs on the JVM
  Kotlin/JS    → compiles to JavaScript
  Kotlin/Native → compiles to native binaries (iOS, desktop)
  Kotlin Multiplatform → share code across all platforms
─────────────────────────────────────

WHY KOTLIN EXISTS:
Java has been around since 1995. It's powerful but verbose,
and carries decades of legacy design decisions. JetBrains
built Kotlin to be:

  ✅ 100% interoperable with Java
  ✅ Far less boilerplate
  ✅ Null-safe by design
  ✅ More expressive and concise
  ✅ Fully supported on Android

A Java "Hello World" vs Kotlin "Hello World":

Java:
  public class Main {
      public static void main(String[] args) {
          System.out.println("Hello, World!");
      }
  }

Kotlin:
  fun main() {
      println("Hello, World!")
  }

Same result. Kotlin does it in 3 lines instead of 5,
with no class wrapper required for simple programs.

─────────────────────────────────────
KOTLIN'S KEY PHILOSOPHY:
─────────────────────────────────────
  Concise     → say more with less code
  Safe        → null pointer crashes are a compiler error
  Expressive  → code reads like what it does
  Pragmatic   → built by developers, for developers
─────────────────────────────────────

💻 CODE:
// Your first Kotlin program
fun main() {
    // println prints with a newline at the end
    println("Hello, World!")

    // Variables — two kinds
    val name = "Terry"      // val = immutable (like final in Java)
    var score = 0           // var = mutable

    score = 42              // OK — score is mutable
    // name = "Bob"         // ERROR — name is immutable

    println("Player: \$name, Score: \$score")

    // String templates — embed expressions directly
    val doubled = score * 2
    println("Double the score: \$doubled")
    println("Inline math: \${score + 100}")
}

📝 KEY POINTS:
✅ Kotlin compiles to the JVM — you can use any Java library
✅ fun is the keyword for functions (not void, not def)
✅ println() prints with a newline — no System.out needed
✅ val = immutable reference, var = mutable reference
✅ String templates use \$ and \${} to embed values
✅ No semicolons required at end of lines
❌ Kotlin is NOT a scripting language — it is fully compiled
❌ val does not mean the object is frozen — it means the
   reference cannot be reassigned (the object can still change)
❌ Don't confuse Kotlin with JavaScript — they share some
   syntax ideas but are completely different languages
""",
  quiz: [
    Quiz(question: 'Who created Kotlin?', options: [
      QuizOption(text: 'JetBrains', correct: true),
      QuizOption(text: 'Google', correct: false),
      QuizOption(text: 'Oracle', correct: false),
      QuizOption(text: 'Microsoft', correct: false),
    ]),
    Quiz(question: 'What does val mean in Kotlin?', options: [
      QuizOption(text: 'An immutable reference that cannot be reassigned', correct: true),
      QuizOption(text: 'A value type stored on the stack', correct: false),
      QuizOption(text: 'A variable that can change freely', correct: false),
      QuizOption(text: 'A validation keyword for null checks', correct: false),
    ]),
    Quiz(question: 'Which of these is true about Kotlin?', options: [
      QuizOption(text: 'It is 100% interoperable with Java', correct: true),
      QuizOption(text: 'It requires semicolons at end of statements', correct: false),
      QuizOption(text: 'It can only run on Android devices', correct: false),
      QuizOption(text: 'It was created by Google in 2010', correct: false),
    ]),
  ],
);
