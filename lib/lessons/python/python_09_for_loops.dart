import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson09 = Lesson(
  language: 'Python',
  title: 'Loops: for',
  content: """
🎯 METAPHOR:
A for loop is like a postal worker delivering mail.
They have a stack of letters (an iterable). They don't
know how many there are before they start — they just
take one at a time, deliver it, and move to the next.
When the stack is empty, they're done. The postal worker
doesn't count letters; they process them one by one.
Python's for loop is like this — it visits every item
in a collection, regardless of what kind of collection
it is, and stops when it runs out.

📖 EXPLANATION:
Python's for loop iterates over ANY iterable — lists,
strings, tuples, dicts, sets, ranges, files, generators.
Unlike C/Java for loops, Python's for is a for-each loop.

─────────────────────────────────────
📐 BASIC SYNTAX
─────────────────────────────────────
for variable in iterable:
    # body — runs once per item
    # variable holds current item each iteration

─────────────────────────────────────
📊 RANGE — Numeric Sequences
─────────────────────────────────────
range() generates a sequence of numbers.
Does NOT create a list — it's a lazy generator!

range(5)          → 0, 1, 2, 3, 4
range(2, 7)       → 2, 3, 4, 5, 6
range(0, 10, 2)   → 0, 2, 4, 6, 8 (step 2)
range(10, 0, -1)  → 10, 9, 8, ..., 1 (countdown)

─────────────────────────────────────
🔢 ENUMERATE — Index + Value
─────────────────────────────────────
Like a postal worker counting as they deliver:
"This is letter #1... letter #2..."

enumerate(iterable, start=0)
Returns (index, value) pairs.

for i, name in enumerate(names):
    print(f"{i}: {name}")

─────────────────────────────────────
🤐 ZIP — Multiple Iterables Together
─────────────────────────────────────
Like zipping two jackets together:
pairs corresponding items from two iterables.

for name, score in zip(names, scores):
    print(f"{name}: {score}")

zip() stops at the SHORTEST iterable.
zip_longest() (from itertools) fills with None.

─────────────────────────────────────
📖 ITERATING DICTIONARIES
─────────────────────────────────────
for key in my_dict:             # iterates keys
for key in my_dict.keys():      # same as above
for value in my_dict.values():  # iterates values
for key, val in my_dict.items(): # key-value pairs

─────────────────────────────────────
🔀 LOOP CONTROL
─────────────────────────────────────
break    — exit loop immediately
continue — skip to next iteration
pass     — do nothing (placeholder)

for-else — else runs if loop completed WITHOUT break
  (Python's unique and useful feature)

─────────────────────────────────────
🎯 LIST COMPREHENSIONS (Preview)
─────────────────────────────────────
A compact way to build lists with a for loop:
[expression for item in iterable if condition]

squares = [x**2 for x in range(10)]
evens   = [x for x in range(20) if x % 2 == 0]

Full coverage in the List Comprehensions lesson!

💻 CODE:
# Basic for loop
fruits = ["apple", "banana", "cherry"]
for fruit in fruits:
    print(fruit)

# String iteration (chars)
for char in "Python":
    print(char, end=" ")   # P y t h o n
print()

# Range loops
for i in range(5):
    print(i, end=" ")   # 0 1 2 3 4
print()

for i in range(1, 6):
    print(i, end=" ")   # 1 2 3 4 5
print()

for i in range(0, 11, 2):
    print(i, end=" ")   # 0 2 4 6 8 10
print()

# Countdown
for i in range(10, 0, -1):
    print(i, end=" ")
print("Blast off! 🚀")

# enumerate — index and value
colors = ["red", "green", "blue"]
for i, color in enumerate(colors):
    print(f"{i+1}. {color}")
# 1. red
# 2. green
# 3. blue

for i, color in enumerate(colors, start=1):  # start at 1
    print(f"{i}. {color}")

# zip — parallel iteration
names = ["Alice", "Bob", "Carol"]
scores = [95, 87, 92]
for name, score in zip(names, scores):
    print(f"{name}: {score}")

# zip with 3 iterables
first = [1, 2, 3]
second = ['a', 'b', 'c']
third = [True, False, True]
for a, b, c in zip(first, second, third):
    print(f"{a}, {b}, {c}")

# Dictionary iteration
person = {"name": "Alice", "age": 30, "city": "NYC"}
for key in person:
    print(key)  # just keys

for key, value in person.items():
    print(f"{key}: {value}")

# Nested loops
for i in range(1, 4):
    for j in range(1, 4):
        print(f"{i}×{j}={i*j}", end="  ")
    print()   # newline after each row

# break
for i in range(10):
    if i == 5:
        break
    print(i, end=" ")   # 0 1 2 3 4
print()

# continue
for i in range(10):
    if i % 2 == 0:
        continue   # skip even numbers
    print(i, end=" ")  # 1 3 5 7 9
print()

# for-else (Python unique!)
# else runs only if loop completed WITHOUT break
numbers = [1, 3, 5, 7, 9]
target = 6
for num in numbers:
    if num == target:
        print(f"Found {target}!")
        break
else:
    print(f"{target} not found")   # this runs

# Unpacking in for loops
pairs = [(1, 'a'), (2, 'b'), (3, 'c')]
for num, letter in pairs:
    print(f"{num} → {letter}")

# Nested list unpacking
matrix = [[1,2,3],[4,5,6],[7,8,9]]
for row in matrix:
    for cell in row:
        print(cell, end=" ")
    print()

# List comprehension preview
squares = [x**2 for x in range(1, 6)]
print(squares)  # [1, 4, 9, 16, 25]

# reversed() and sorted()
nums = [3, 1, 4, 1, 5, 9, 2, 6]
for n in sorted(nums):
    print(n, end=" ")   # 1 1 2 3 4 5 6 9
print()
for n in reversed(nums):
    print(n, end=" ")   # 6 2 9 5 1 4 1 3
print()

📝 KEY POINTS:
✅ Python for loops are for-each — they iterate ANY iterable
✅ range() is lazy — doesn't create a list in memory
✅ Use enumerate() when you need both index and value
✅ Use zip() to iterate multiple lists in parallel
✅ for-else: else runs only if loop was NOT broken out of
✅ Use .items() to iterate dict key-value pairs
✅ break exits the loop; continue skips to next iteration
❌ Don't modify a list while iterating over it — use a copy or comprehension
❌ Avoid using range(len(mylist)) to iterate — use enumerate()
❌ zip() stops at shortest — use itertools.zip_longest() if needed
""",
  quiz: [
    Quiz(question: 'What does the else clause in a for-else loop do?', options: [
      QuizOption(text: 'Runs if the loop body raises no exception', correct: false),
      QuizOption(text: 'Always runs after the loop ends', correct: false),
      QuizOption(text: 'Runs only if the loop completed without hitting a break', correct: true),
      QuizOption(text: 'Runs only if the iterable was empty', correct: false),
    ]),
    Quiz(question: 'How do you iterate over both the index and value of a list?', options: [
      QuizOption(text: 'for i, v in enumerate(mylist):', correct: true),
      QuizOption(text: 'for i in range(len(mylist)): v = mylist[i]', correct: false),
      QuizOption(text: 'for i, v in mylist.indexed():', correct: false),
      QuizOption(text: 'for i in mylist.enumerate():', correct: false),
    ]),
    Quiz(question: 'What does range(10, 0, -2) produce?', options: [
      QuizOption(text: '10, 8, 6, 4, 2', correct: true),
      QuizOption(text: '0, 2, 4, 6, 8, 10', correct: false),
      QuizOption(text: '10, 9, 8, 7, 6, 5, 4, 3, 2, 1', correct: false),
      QuizOption(text: '10, 8, 6, 4, 2, 0', correct: false),
    ]),
  ],
);
