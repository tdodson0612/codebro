import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson16 = Lesson(
  language: 'Python',
  title: 'Lambda Functions',
  content: '''
🎯 METAPHOR:
A lambda is like a Post-it note with instructions.
A regular function is a full printed manual — title,
chapters, explanations. A lambda is a quick sticky note:
"double this number." No name, no filing, just a tiny
instruction written on the spot and discarded after use.
Perfect for a small one-time operation you don't want
to name and file away.

📖 EXPLANATION:
Lambda functions are anonymous, single-expression functions.
They're defined inline and return the expression's value.

─────────────────────────────────────
📐 SYNTAX
─────────────────────────────────────
lambda parameters: expression

• No def, no name, no return statement
• Expression IS the return value
• Single expression only — no multi-line bodies
• Can use ternary expressions inside

─────────────────────────────────────
🆚 LAMBDA vs DEF
─────────────────────────────────────
Use lambda for:  sort keys, map/filter args, one-liners
Use def for:     anything with multiple lines or a docstring

⚠️  PEP 8: don't assign lambdas to variables
  add = lambda x, y: x+y  ← use def instead
  Lambda is meant to stay ANONYMOUS

─────────────────────────────────────
🗺️  MAP, FILTER, REDUCE
─────────────────────────────────────
map(func, iterable)     → apply func to every item
filter(func, iterable)  → keep items where func is True
reduce(func, iterable)  → fold items into one value

💻 CODE:
# Lambda with sorted() — best real use case
students = [("Alice", 92), ("Bob", 85), ("Carol", 96)]
by_score = sorted(students, key=lambda s: s[1])
print(by_score)   # sorted low to high

by_score_desc = sorted(students, key=lambda s: s[1], reverse=True)
print(by_score_desc)

# Multi-key sort
people = [
    {"name": "Alice", "age": 30, "score": 95},
    {"name": "Bob",   "age": 30, "score": 88},
    {"name": "Carol", "age": 25, "score": 95},
]
# Sort by score desc, then age asc
people.sort(key=lambda p: (-p["score"], p["age"]))
for p in people:
    print(p)

# map() — transform every element
numbers = [1, 2, 3, 4, 5]
squares  = list(map(lambda x: x**2, numbers))
doubled  = list(map(lambda x: x*2, numbers))
print(squares)   # [1, 4, 9, 16, 25]
print(doubled)   # [2, 4, 6, 8, 10]

# Better with list comprehension (more Pythonic):
squares = [x**2 for x in numbers]

# filter() — keep only matching elements
evens  = list(filter(lambda x: x % 2 == 0, range(10)))
print(evens)   # [0, 2, 4, 6, 8]

# Again, comprehension is often cleaner:
evens = [x for x in range(10) if x % 2 == 0]

# reduce() — fold into one value
from functools import reduce
total   = reduce(lambda a, b: a + b, [1, 2, 3, 4, 5])
product = reduce(lambda a, b: a * b, [1, 2, 3, 4, 5])
print(total)    # 15
print(product)  # 120

# max/min with key
words = ["banana", "apple", "kiwi", "strawberry"]
longest  = max(words, key=lambda w: len(w))
shortest = min(words, key=lambda w: len(w))
print(longest)   # strawberry
print(shortest)  # kiwi

# Lambda in higher-order functions
def apply_twice(func, value):
    return func(func(value))

print(apply_twice(lambda x: x * 2, 3))   # 12  (3→6→12)
print(apply_twice(lambda x: x + 10, 5))  # 25  (5→15→25)

# Immediately invoked lambda
result = (lambda x, y: x + y)(10, 20)
print(result)   # 30

📝 KEY POINTS:
✅ Lambda is best as sort key or map/filter argument
✅ Returns the expression's value automatically
✅ Can hold any single expression, including ternary
❌ No statements — no assignments, no loops, no print inside
❌ Don't assign lambdas to variables — use def instead
❌ Complex logic → use def, not a tangled lambda
''',
  quiz: [
    Quiz(question: 'What does lambda x: x**2 do?', options: [
      QuizOption(text: 'Returns an anonymous function that squares its input', correct: true),
      QuizOption(text: 'Assigns x squared to a variable called lambda', correct: false),
      QuizOption(text: 'Raises a SyntaxError — lambda needs parentheses', correct: false),
      QuizOption(text: 'Prints x squared', correct: false),
    ]),
    Quiz(question: 'What is the best real-world use case for lambda?', options: [
      QuizOption(text: 'Replacing all def functions for cleaner code', correct: false),
      QuizOption(text: 'As a key argument in sorted(), max(), or min()', correct: true),
      QuizOption(text: 'Writing multi-step algorithms in one line', correct: false),
      QuizOption(text: 'Defining recursive functions', correct: false),
    ]),
    Quiz(question: 'What does filter(lambda x: x > 0, [-1, 2, -3, 4]) return?', options: [
      QuizOption(text: 'A list [2, 4]', correct: false),
      QuizOption(text: 'A filter iterator yielding 2 and 4', correct: true),
      QuizOption(text: 'True', correct: false),
      QuizOption(text: '[-1, -3] (the rejected items)', correct: false),
    ]),
  ],
);
