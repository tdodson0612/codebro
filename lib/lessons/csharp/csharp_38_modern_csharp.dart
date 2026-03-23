// lib/lessons/csharp/csharp_38_modern_csharp.dart

import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson38 = Lesson(
  language: 'C#',
  title: 'Modern C#: C# 10, 11, and 12',
  content: '''
🎯 METAPHOR:
Each new C# version is like a software update to your
developer toolkit. The core tools work the same, but
new features remove friction, reduce boilerplate, and
let you express intent more clearly. C# 10-12 are all
about writing LESS code that means MORE — primary constructors,
collection expressions, pattern matching upgrades, and more.
The language keeps getting out of your way.

📖 EXPLANATION:
C# ships a new version every year alongside .NET.
Each version adds features designed to reduce boilerplate
and improve expressiveness.

C# 10 (2021): File-scoped namespaces, global usings,
              record structs, const interpolated strings

C# 11 (2022): Raw string literals, required members,
              generic math, list patterns, file-local types

C# 12 (2023): Primary constructors for classes/structs,
              collection expressions, inline arrays,
              alias any type with "using"

─────────────────────────────────────
📝 C# 11: RAW STRING LITERALS
─────────────────────────────────────
Triple-quoted strings — no escaping needed inside.
The closing quotes must be on their own line.

In C# code they look like:
  string json = \"""
      { "name": "Alice", "path": "C:\\\\Users" }
      \""";

  string html = \$"""
      <div>{name}</div>
      \""";

─────────────────────────────────────
🏗️  C# 12: PRIMARY CONSTRUCTORS
─────────────────────────────────────
Parameters defined on the class declaration are
in scope throughout the class body.

  class Person(string name, int age)
  {
      public string Name { get; } = name;
      public bool IsAdult => age >= 18;
  }

─────────────────────────────────────
📦 C# 12: COLLECTION EXPRESSIONS
─────────────────────────────────────
Unified [] syntax for all collection types.
Spread operator (..) merges collections inline.

  int[] arr   = [1, 2, 3];
  List<int> l = [1, 2, 3];
  int[] combo = [..first, ..second];

💻 CODE:
using System;
using System.Collections.Generic;
using System.Numerics;

// ─── C# 10: FILE-SCOPED NAMESPACE ───
// namespace MyApp.Models;  // no braces, applies to whole file

// ─── C# 10: GLOBAL USINGS (in GlobalUsings.cs) ───
// global using System;
// global using System.Collections.Generic;

// ─── C# 10: RECORD STRUCTS ───
record struct Point3D(double X, double Y, double Z);

// ─── C# 11: REQUIRED MEMBERS ───
class Config11
{
    public required string Host { get; init; }
    public required int Port { get; init; }
    public string Protocol { get; init; } = "https";
}

// ─── C# 11: LIST PATTERNS ───
static string DescribeList(int[] arr) => arr switch
{
    []             => "empty",
    [var x]        => \$"single: {x}",
    [var a, var b] => \$"pair: {a}, {b}",
    [1, 2, ..]     => "starts with 1, 2",
    [.., 9, 10]    => "ends with 9, 10",
    _              => \$"other ({arr.Length} items)"
};

// ─── C# 12: PRIMARY CONSTRUCTORS ───
class Person(string name, int age)
{
    public string Name { get; } = name;
    public int Age { get; } = age;
    public bool IsAdult => age >= 18;

    public override string ToString() => \$"{name} (age {age})";
}

class Logger(string prefix)
{
    public void Log(string message)
        => Console.WriteLine(\$"[{prefix}] {message}");
}

// ─── C# 12: COLLECTION EXPRESSIONS ───
static void CollectionExpressions()
{
    int[] array    = [1, 2, 3, 4, 5];
    List<int> list = [1, 2, 3];

    // Spread operator — combines collections
    int[] first    = [1, 2, 3];
    int[] second   = [4, 5, 6];
    int[] combined = [..first, ..second]; // [1, 2, 3, 4, 5, 6]
    int[] withExtra = [0, ..first, ..second, 7];

    Console.WriteLine(string.Join(", ", withExtra)); // 0,1,2,3,4,5,6,7

    List<string> empty = [];
}

// ─── C# 11: GENERIC MATH ───
static T AddAll<T>(IEnumerable<T> numbers) where T : INumber<T>
{
    T sum = T.Zero;
    foreach (var n in numbers) sum += n;
    return sum;
}

class Program
{
    static void Main()
    {
        // Primary constructor
        var person = new Person("Alice", 30);
        Console.WriteLine(person);           // Alice (age 30)
        Console.WriteLine(person.IsAdult);   // True

        var logger = new Logger("APP");
        logger.Log("Starting up");           // [APP] Starting up

        // Record struct
        var pt  = new Point3D(1.0, 2.0, 3.0);
        var pt2 = pt with { Z = 10.0 };
        Console.WriteLine(pt2);

        // List patterns
        Console.WriteLine(DescribeList(Array.Empty<int>()));  // empty
        Console.WriteLine(DescribeList(new[] { 42 }));        // single: 42
        Console.WriteLine(DescribeList(new[] { 1, 2, 5 }));   // starts with 1, 2

        // Collection expressions
        CollectionExpressions();

        // Required members
        var config = new Config11 { Host = "localhost", Port = 5432 };
        Console.WriteLine(\$"{config.Protocol}://{config.Host}:{config.Port}");
        // https://localhost:5432

        // Generic math
        int[]    ints = { 1, 2, 3, 4, 5 };
        double[] dbs  = { 1.1, 2.2, 3.3 };
        Console.WriteLine(AddAll(ints));   // 15
        Console.WriteLine(AddAll(dbs));    // 6.6
    }
}

📝 KEY POINTS:
✅ Primary constructors (C# 12) eliminate boilerplate constructor + field code
✅ Collection expressions [] unify array/list/span creation syntax
✅ Spread (..) merges collections inline — no Concat() needed
✅ Raw string literals (C# 11) eliminate all escaping — triple-quote delimited
✅ Required members ensure callers provide mandatory values at initialization
✅ Generic math (INumber<T>) enables numeric algorithms on any number type
✅ File-scoped namespaces (C# 10) remove one level of indentation
❌ Primary constructor parameters are captured — be careful with mutation
❌ Collection expressions require the target type to be known — use explicit type
''',
  quiz: [
    Quiz(question: 'What does the spread operator (..) do in a C# 12 collection expression?', options: [
      QuizOption(text: 'Spreads (includes) all elements of another collection inline', correct: true),
      QuizOption(text: 'Creates a range from start to end', correct: false),
      QuizOption(text: 'Copies the collection by value', correct: false),
      QuizOption(text: 'Skips null elements in the collection', correct: false),
    ]),
    Quiz(question: 'What is the benefit of primary constructors in C# 12?', options: [
      QuizOption(text: 'Eliminates boilerplate constructor code — parameters are available throughout the class', correct: true),
      QuizOption(text: 'Prevents the class from having additional constructors', correct: false),
      QuizOption(text: 'Makes all properties automatically read-only', correct: false),
      QuizOption(text: 'Replaces the need for interfaces', correct: false),
    ]),
    Quiz(question: 'What is the advantage of raw string literals (C# 11)?', options: [
      QuizOption(text: 'No escaping needed — backslashes, quotes, and newlines are all literal', correct: true),
      QuizOption(text: 'They are compiled at build time for better performance', correct: false),
      QuizOption(text: 'They can only be used for JSON content', correct: false),
      QuizOption(text: 'They prevent string interpolation', correct: false),
    ]),
  ],
);