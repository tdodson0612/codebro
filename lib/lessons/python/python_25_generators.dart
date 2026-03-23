import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson25 = Lesson(
  language: 'Python',
  title: 'Generators & Iterators',
  content: """
🎯 METAPHOR:
A generator is like a vending machine vs a grocery bag.
A regular function is a grocery bag — it fills up everything
at once and hands it all to you. A generator is a vending
machine — it has millions of snacks available, but only
dispenses ONE at a time when you press a button (call next()).
If you only want 5 snacks, you press 5 times and the machine
stops. You don't need 1,000 snacks pre-bagged to find what
you want. This is crucial when dealing with huge datasets
that would overflow memory if loaded at once.

📖 EXPLANATION:
Generators produce values one at a time, on demand (lazily).
They use "yield" instead of "return."
Each call to next() resumes from where the function paused.

─────────────────────────────────────
⚡ yield vs return
─────────────────────────────────────
return   — exits the function and returns a value
yield    — pauses the function, returns a value,
           AND remembers where it paused (all local
           state is frozen). Next next() call resumes
           from after the yield.

─────────────────────────────────────
🔄 HOW GENERATORS WORK
─────────────────────────────────────
1. Call a generator function → get a generator OBJECT
   (function body does NOT run yet!)
2. Call next(gen) or iterate with for → runs until
   next yield, pauses, returns yielded value
3. Repeat until function returns → StopIteration raised
4. for loops handle StopIteration automatically

─────────────────────────────────────
🆚 GENERATOR vs LIST
─────────────────────────────────────
List:      creates ALL values at once in memory
Generator: creates ONE value at a time, on demand

For 1 billion numbers:
  list(range(10**9))         → 8GB RAM!!
  (x for x in range(10**9)) → almost 0 bytes

─────────────────────────────────────
📦 GENERATOR EXPRESSIONS
─────────────────────────────────────
(expression for item in iterable if condition)
Like a list comprehension but lazy.

─────────────────────────────────────
🔀 yield from
─────────────────────────────────────
Delegates to another generator or iterable.
Cleaner than looping and yielding each item.

yield from range(10)  instead of  for x in range(10): yield x

─────────────────────────────────────
📬 SEND TO GENERATOR
─────────────────────────────────────
yield can also RECEIVE values via gen.send(value).
This turns it into a coroutine (two-way communication).

─────────────────────────────────────
🔁 THE ITERATOR PROTOCOL
─────────────────────────────────────
Any object with __iter__ and __next__ is an iterator.
__iter__ returns self.
__next__ returns next value or raises StopIteration.
Generators implement this automatically.

💻 CODE:
# Basic generator function
def countdown(n):
    print("Starting countdown!")
    while n > 0:
        yield n          # pause here, send n
        n -= 1           # resumes here on next call
    print("Done!")

gen = countdown(5)
print(type(gen))         # <class 'generator'>
print(next(gen))         # Starting countdown! → 5
print(next(gen))         # 4
print(next(gen))         # 3

# for loop handles StopIteration automatically
for value in countdown(3):
    print(value)         # 3, 2, 1

# Infinite generator
def integers(start=0):
    n = start
    while True:
        yield n
        n += 1

# Take only what you need
gen = integers()
first_10 = [next(gen) for _ in range(10)]
print(first_10)  # [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

# Fibonacci generator — infinite, uses no list!
def fibonacci():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

fib = fibonacci()
print([next(fib) for _ in range(10)])  # [0,1,1,2,3,5,8,13,21,34]

# Memory comparison
import sys
lst_gen  = (x**2 for x in range(1_000_000))  # generator
lst_list = [x**2 for x in range(1_000_000)]  # list

print(f"List size:      {sys.getsizeof(lst_list):,} bytes")
print(f"Generator size: {sys.getsizeof(lst_gen)} bytes")
# List: ~8MB, Generator: 200 bytes!

# Generator pipeline — process data in stages
def read_lines(filename):
    with open(filename) as f:
        yield from f   # yield each line lazily

def filter_lines(lines, keyword):
    for line in lines:
        if keyword.lower() in line.lower():
            yield line

def strip_lines(lines):
    for line in lines:
        yield line.strip()

# These chain together without loading anything into memory:
# lines = strip_lines(filter_lines(read_lines("huge_log.txt"), "ERROR"))
# for line in lines: print(line)

# yield from
def chain_iterables(*iterables):
    for it in iterables:
        yield from it    # delegate to each iterable

result = list(chain_iterables([1,2,3], [4,5,6], range(7,10)))
print(result)  # [1, 2, 3, 4, 5, 6, 7, 8, 9]

# Recursive generator with yield from
def flatten(nested):
    for item in nested:
        if isinstance(item, list):
            yield from flatten(item)   # recurse
        else:
            yield item

deep = [1, [2, 3], [4, [5, [6, 7]]]]
print(list(flatten(deep)))   # [1, 2, 3, 4, 5, 6, 7]

# Generator with send() — bidirectional generator
def accumulator():
    total = 0
    while True:
        value = yield total    # yield current total, receive new value
        if value is None:
            break
        total += value

acc = accumulator()
next(acc)        # prime the generator (first yield)
print(acc.send(10))   # 10
print(acc.send(20))   # 30
print(acc.send(5))    # 35

# Custom iterator class (using protocol)
class CountUp:
    def __init__(self, start, stop):
        self.current = start
        self.stop = stop

    def __iter__(self):
        return self

    def __next__(self):
        if self.current > self.stop:
            raise StopIteration
        val = self.current
        self.current += 1
        return val

for n in CountUp(1, 5):
    print(n, end=" ")   # 1 2 3 4 5
print()

# itertools — generator-based tools
from itertools import islice, takewhile, dropwhile, count, cycle

# islice — take first n from generator
gen = fibonacci()
first_8 = list(islice(gen, 8))
print(first_8)   # [0, 1, 1, 2, 3, 5, 8, 13]

# takewhile — take while condition true
gen = fibonacci()
under_100 = list(takewhile(lambda x: x < 100, gen))
print(under_100)  # [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]

# cycle — infinite repeating
colors = cycle(["red", "green", "blue"])
print([next(colors) for _ in range(7)])
# ['red', 'green', 'blue', 'red', 'green', 'blue', 'red']

# count — infinite counter with step
for n in islice(count(10, 5), 5):
    print(n, end=" ")  # 10 15 20 25 30
print()

📝 KEY POINTS:
✅ Generators produce values one-at-a-time — huge memory savings
✅ yield pauses the function AND preserves all local state
✅ Calling a generator function returns a generator object — body doesn't run yet
✅ Use "yield from" to delegate to sub-generators cleanly
✅ Generator pipelines process huge data with minimal memory
✅ itertools provides powerful generator-based tools: islice, takewhile, chain, etc.
❌ You can only iterate a generator ONCE — it's exhausted after
❌ Can't index or len() a generator — it's lazy/one-pass
❌ Don't use a list when you only need to iterate once — use a generator
""",
  quiz: [
    Quiz(question: 'What is the key difference between "yield" and "return"?', options: [
      QuizOption(text: 'yield pauses the function and saves state; return exits the function entirely', correct: true),
      QuizOption(text: 'yield is for loops only; return works everywhere', correct: false),
      QuizOption(text: 'yield returns a list; return returns a single value', correct: false),
      QuizOption(text: 'They are identical — just different keywords', correct: false),
    ]),
    Quiz(question: 'What happens when you call a generator function like gen = my_gen()?', options: [
      QuizOption(text: 'The function body runs completely and stores results', correct: false),
      QuizOption(text: 'A generator object is returned; the function body does NOT run yet', correct: true),
      QuizOption(text: 'The first yield is immediately executed', correct: false),
      QuizOption(text: 'It raises a TypeError — generator functions must be iterated directly', correct: false),
    ]),
    Quiz(question: 'Why use a generator instead of a list for a 1-billion item sequence?', options: [
      QuizOption(text: 'Generators are faster to compute', correct: false),
      QuizOption(text: 'A generator uses nearly zero memory vs gigabytes for a list', correct: true),
      QuizOption(text: 'Generators support indexing which lists don\'t', correct: false),
      QuizOption(text: 'Lists can\'t hold more than 1 million items', correct: false),
    ]),
  ],
);
