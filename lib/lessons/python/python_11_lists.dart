import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson11 = Lesson(
  language: 'Python',
  title: 'Lists',
  content: """
🎯 METAPHOR:
A list is like a shopping cart.
You can put anything in — apples, milk, a blender —
in any order. You can add more items, remove items,
reorder them, and pick any item by reaching in and
counting from the front (index 0) or back (index -1).
Unlike a box (fixed size), a shopping cart grows
as you add things. Unlike a set (no duplicates), a cart
lets you have three of the same yogurt. It's ordered,
flexible, and holds anything.

📖 EXPLANATION:
Lists are Python's most versatile and commonly used
data structure. They are:
  • ORDERED — items maintain insertion order
  • MUTABLE — can be changed after creation
  • ALLOW DUPLICATES — same value multiple times
  • HETEROGENEOUS — can hold mixed types

─────────────────────────────────────
📐 CREATING LISTS
─────────────────────────────────────
empty    = []
numbers  = [1, 2, 3, 4, 5]
mixed    = [1, "hello", 3.14, True, None]
nested   = [[1,2], [3,4], [5,6]]
from_range = list(range(10))
from_str   = list("hello")   # ['h','e','l','l','o']
repeated = [0] * 5           # [0, 0, 0, 0, 0]

─────────────────────────────────────
🔢 INDEXING AND SLICING
─────────────────────────────────────
Same as strings (lists are sequences too):
lst[0]    → first item
lst[-1]   → last item
lst[1:4]  → items at index 1, 2, 3
lst[::2]  → every other item
lst[::-1] → reversed list

Unlike strings, you CAN assign to list indices:
lst[0] = "new value"   ← strings can't do this!

─────────────────────────────────────
🛠️  LIST METHODS
─────────────────────────────────────
Adding:
  append(x)      — add x to END
  insert(i, x)   — add x at index i
  extend(iter)   — add all items from iterable

Removing:
  remove(x)      — remove FIRST occurrence of x
  pop()          — remove and RETURN last item
  pop(i)         — remove and RETURN item at index i
  clear()        — remove all items
  del lst[i]     — delete item at index

Searching:
  index(x)       — index of first x (ValueError if not found)
  count(x)       — number of occurrences of x
  x in lst       — True/False membership check

Sorting:
  sort()         — sort in place (modifies list!)
  sort(reverse=True)       — sort descending
  sort(key=func)           — sort by key function
  sorted(lst)    — returns NEW sorted list (non-destructive)
  reverse()      — reverse in place

Copying:
  copy()         → shallow copy
  lst[:]         → shallow copy (slice)
  list(lst)      → shallow copy

Other:
  len(lst)       — number of items
  min(lst)       — minimum value
  max(lst)       — maximum value
  sum(lst)       — sum (numbers only)

─────────────────────────────────────
⚠️  SHALLOW vs DEEP COPY
─────────────────────────────────────
b = a              → ALIAS (same object!)
b = a.copy()       → shallow copy
b = a[:]           → shallow copy

For nested lists, use:
import copy
b = copy.deepcopy(a)   → deep copy (copies nested too)

─────────────────────────────────────
🔗 LIST CONCATENATION & REPETITION
─────────────────────────────────────
[1,2] + [3,4]    → [1, 2, 3, 4]
[0] * 3          → [0, 0, 0]
lst += [5, 6]    → extend in place

💻 CODE:
# Creating lists
fruits = ["apple", "banana", "cherry"]
numbers = list(range(1, 6))    # [1, 2, 3, 4, 5]
matrix = [[1,2,3], [4,5,6], [7,8,9]]

# Indexing
print(fruits[0])    # apple
print(fruits[-1])   # cherry
print(fruits[1:3])  # ['banana', 'cherry']
print(fruits[::-1]) # reversed

# Mutating (unlike strings!)
fruits[0] = "avocado"
print(fruits)   # ['avocado', 'banana', 'cherry']

# Adding items
fruits.append("durian")           # add to end
fruits.insert(1, "blueberry")     # insert at index 1
fruits.extend(["elderberry", "fig"])  # add multiple

# Removing items
fruits.remove("banana")   # remove by value
popped = fruits.pop()     # remove and get last
popped2 = fruits.pop(0)   # remove and get first
print(f"Popped: {popped}, {popped2}")

# Searching
nums = [10, 20, 30, 20, 40]
print(20 in nums)          # True
print(nums.index(20))      # 1 (first occurrence)
print(nums.count(20))      # 2 (appears twice)

# Sorting
words = ["banana", "apple", "cherry", "date"]
words.sort()               # sorts in place
print(words)               # alphabetical

words.sort(reverse=True)   # descending
print(words)

# sorted() — non-destructive
original = [3, 1, 4, 1, 5, 9, 2, 6]
sorted_copy = sorted(original)
print(original)     # unchanged!
print(sorted_copy)  # sorted copy

# Sort by key
people = [("Alice", 30), ("Bob", 25), ("Carol", 35)]
people.sort(key=lambda x: x[1])  # sort by age
print(people)

words_by_length = sorted(words, key=len)  # sort by length
print(words_by_length)

# Nested lists (2D matrix)
grid = [[0]*3 for _ in range(3)]  # 3x3 grid of zeros
grid[1][1] = 5     # set center
for row in grid:
    print(row)

# Copy gotcha
a = [1, 2, 3]
b = a        # b IS a — same object!
b.append(4)
print(a)     # [1, 2, 3, 4] ← a changed!

c = a.copy() # c is a COPY
c.append(5)
print(a)     # [1, 2, 3, 4] ← a NOT changed

# Deep copy for nested lists
import copy
original = [[1, 2], [3, 4]]
shallow = original.copy()
deep = copy.deepcopy(original)

original[0][0] = 999
print(shallow[0][0])  # 999 ← shallow copy affected!
print(deep[0][0])     # 1   ← deep copy safe!

# List as stack (LIFO)
stack = []
stack.append("first")
stack.append("second")
stack.append("third")
print(stack.pop())    # third (LIFO!)
print(stack.pop())    # second

# List as queue (FIFO) — better to use collections.deque
from collections import deque
queue = deque()
queue.append("first")
queue.append("second")
queue.append("third")
print(queue.popleft())  # first (FIFO!)

# Unpacking
first, *middle, last = [1, 2, 3, 4, 5]
print(first)   # 1
print(middle)  # [2, 3, 4]
print(last)    # 5

# List comprehension (preview — full lesson coming)
squares = [x**2 for x in range(1, 6)]
print(squares)   # [1, 4, 9, 16, 25]

evens = [x for x in range(20) if x % 2 == 0]
print(evens)     # [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]

# Flatten nested list
nested = [[1,2,3], [4,5,6], [7,8,9]]
flat = [x for row in nested for x in row]
print(flat)  # [1, 2, 3, 4, 5, 6, 7, 8, 9]

# Count occurrences
grades = ["A", "B", "A", "C", "B", "A"]
from collections import Counter
count = Counter(grades)
print(count)  # Counter({'A': 3, 'B': 2, 'C': 1})

📝 KEY POINTS:
✅ Lists are ordered, mutable, allow duplicates
✅ append() for one item, extend() for multiple items
✅ sort() modifies in place; sorted() returns a new list
✅ Use copy() or [:] for shallow copies — assignment creates aliases!
✅ Use copy.deepcopy() for nested lists
✅ pop() removes from end (fast); pop(0) removes from front (slow — use deque)
✅ List unpacking: first, *rest = mylist
❌ Modifying a list while iterating over it causes bugs
❌ b = a is NOT a copy — it's an alias to the same list
❌ insert(0, x) is slow (O(n)) — use deque for frequent front insertions
""",
  quiz: [
    Quiz(question: 'What is the difference between list.sort() and sorted(list)?', options: [
      QuizOption(text: 'sort() modifies the list in place; sorted() returns a new sorted list', correct: true),
      QuizOption(text: 'sorted() is faster than sort()', correct: false),
      QuizOption(text: 'They are identical — both modify in place', correct: false),
      QuizOption(text: 'sort() works on any iterable; sorted() only works on lists', correct: false),
    ]),
    Quiz(question: 'What happens when you do b = a where a is a list?', options: [
      QuizOption(text: 'b is a copy — changing b does not affect a', correct: false),
      QuizOption(text: 'b is an alias — b and a point to the same list object', correct: true),
      QuizOption(text: 'b is a deep copy of a', correct: false),
      QuizOption(text: 'It raises a TypeError', correct: false),
    ]),
    Quiz(question: 'What does first, *rest = [1, 2, 3, 4, 5] produce?', options: [
      QuizOption(text: 'first=1, rest=[2, 3, 4, 5]', correct: true),
      QuizOption(text: 'first=1, rest=2 (only two values)', correct: false),
      QuizOption(text: 'A TypeError — too many values to unpack', correct: false),
      QuizOption(text: 'first=[1], rest=[2,3,4,5]', correct: false),
    ]),
  ],
);
