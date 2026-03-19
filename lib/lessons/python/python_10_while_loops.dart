import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson10 = Lesson(
  language: 'Python',
  title: 'Loops: while',
  content: '''
🎯 METAPHOR:
A while loop is like a vending machine.
It keeps asking "Did I get payment?" — and while the
answer is no, it keeps waiting. Only when the condition
changes (coins inserted = true) does it stop the loop
and dispense the item. If someone jams the coin slot,
it waits forever — that's an infinite loop. You need
a clear exit condition to prevent the machine from
spinning its gears indefinitely.

📖 EXPLANATION:
while loops repeat a block of code AS LONG AS a condition
remains True. Unlike for loops (which know their iterable),
while loops continue until something changes the condition.

─────────────────────────────────────
📐 BASIC SYNTAX
─────────────────────────────────────
while condition:
    # body — repeats while condition is True
    # MUST eventually make condition False!
    # or use break to exit

─────────────────────────────────────
🔄 FOR vs WHILE — When to Use Which
─────────────────────────────────────
Use for when:   you have an iterable, or know # of times
Use while when: you don't know how many iterations needed,
                waiting for user input, game loops,
                polling, retry logic

for loops are FINITE and predictable.
while loops can be INDEFINITE — until some event occurs.

─────────────────────────────────────
⚠️  INFINITE LOOPS
─────────────────────────────────────
while True:   ← intentional infinite loop
    ...       (must use break to exit)

Common unintentional causes:
  • Forgetting to update the loop variable
  • Condition can never become False
  • Loop variable updated in wrong direction

─────────────────────────────────────
🔁 DO-WHILE PATTERN
─────────────────────────────────────
Python has no do-while. Simulate with:

while True:
    action()      # runs at least once
    if condition: # check after running
        break

─────────────────────────────────────
⏰ LOOP CONTROL (same as for loops)
─────────────────────────────────────
break    — exit the while loop immediately
continue — skip rest of body, re-check condition
pass     — do nothing (placeholder)

while-else — else runs if loop ended without break

─────────────────────────────────────
🔂 WALRUS OPERATOR := (Python 3.8+)
─────────────────────────────────────
Assigns a value AND uses it in the condition.
Like "assign while checking":

while (line := file.readline()):
    process(line)

while (n := int(input())) != 0:
    print(f"Got: {n}")

💻 CODE:
# Basic while loop
count = 0
while count < 5:
    print(count, end=" ")   # 0 1 2 3 4
    count += 1               # MUST update or infinite loop!
print()

# User input loop (until valid input)
while True:
    answer = input("Enter yes or no: ").lower()
    if answer in ("yes", "no"):
        break
    print("Invalid! Please type 'yes' or 'no'")
print(f"You chose: {answer}")

# Countdown timer
seconds = 5
while seconds > 0:
    print(f"⏰ {seconds}...")
    seconds -= 1
print("🎉 Time's up!")

# while-else
attempts = 0
max_attempts = 3
password = "secret123"

while attempts < max_attempts:
    guess = input("Password: ")
    if guess == password:
        print("✅ Access granted!")
        break
    attempts += 1
    print(f"Wrong! {max_attempts - attempts} attempts left")
else:
    print("🔒 Account locked — too many attempts")

# Accumulator pattern
total = 0
while True:
    value = input("Enter number (or 'done'): ")
    if value.lower() == "done":
        break
    try:
        total += float(value)
    except ValueError:
        print("Not a number, skipping")
print(f"Total: {total}")

# Game loop pattern
import random
secret = random.randint(1, 100)
guesses = 0

print("🎮 Guess the number (1-100)")
while True:
    guesses += 1
    try:
        guess = int(input(f"Guess #{guesses}: "))
    except ValueError:
        print("Enter a valid number!")
        guesses -= 1
        continue

    if guess < secret:
        print("📉 Too low!")
    elif guess > secret:
        print("📈 Too high!")
    else:
        print(f"🎉 Correct in {guesses} guesses!")
        break

# Walrus operator (Python 3.8+)
import sys
# Read lines until empty
data = ["line 1", "line 2", "", "line 4"]
i = 0
while (line := data[i] if i < len(data) else ""):
    print(f"Processing: {line}")
    i += 1

# Retry logic pattern
import random
def might_fail():
    return random.random() > 0.7   # 30% success

max_retries = 5
for attempt in range(1, max_retries + 1):
    if might_fail():
        print(f"✅ Succeeded on attempt {attempt}")
        break
    print(f"❌ Attempt {attempt} failed, retrying...")
else:
    print("All retries exhausted")

# Fibonacci with while
a, b = 0, 1
while a < 100:
    print(a, end=" ")
    a, b = b, a + b   # swap in one line!
print()

# Binary search (while loop use case)
def binary_search(arr, target):
    left, right = 0, len(arr) - 1
    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1

sorted_list = [1, 3, 5, 7, 9, 11, 13, 15]
print(binary_search(sorted_list, 7))   # 3
print(binary_search(sorted_list, 6))   # -1

📝 KEY POINTS:
✅ while is best when you don't know how many iterations needed
✅ while True + break is the clean pattern for "run until condition"
✅ ALWAYS make sure the condition can eventually become False
✅ while-else: else runs if loop completed WITHOUT break
✅ Use the walrus operator := for clean assignment-in-condition (3.8+)
✅ Retry patterns, game loops, input validation — classic while uses
❌ Forgetting to update the loop variable = infinite loop
❌ for loops are cleaner when iterating collections — don't use while
❌ Modifying a list during a for loop is dangerous — while is safer for that
''',
  quiz: [
    Quiz(question: 'When should you prefer a while loop over a for loop?', options: [
      QuizOption(text: 'When iterating over a list', correct: false),
      QuizOption(text: 'When you know exactly how many iterations are needed', correct: false),
      QuizOption(text: 'When iterations continue until a condition changes, not a fixed count', correct: true),
      QuizOption(text: 'while is always faster than for', correct: false),
    ]),
    Quiz(question: 'What does the else clause of a while-else do?', options: [
      QuizOption(text: 'Runs when the while condition first becomes False naturally (no break hit)', correct: true),
      QuizOption(text: 'Runs when an exception occurs in the loop', correct: false),
      QuizOption(text: 'Runs after every loop iteration', correct: false),
      QuizOption(text: 'Always runs, regardless of break or condition', correct: false),
    ]),
    Quiz(question: 'What does the walrus operator := do in while (n := int(input())) != 0?', options: [
      QuizOption(text: 'Assigns the input to n AND uses it in the condition simultaneously', correct: true),
      QuizOption(text: 'Checks if n is not zero before assigning', correct: false),
      QuizOption(text: 'Creates a new variable inside the while condition (not allowed)', correct: false),
      QuizOption(text: 'It is a syntax error in Python', correct: false),
    ]),
  ],
);
