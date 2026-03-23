import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson64 = Lesson(
  language: 'Python',
  title: 'Sorting & Algorithms in Python',
  content: '''
🎯 METAPHOR:
Sorting is like organizing a bookshelf.
Python's built-in sorted() is a professional librarian —
highly trained (Timsort), incredibly fast, and handles
any edge case. But sometimes you need to sort books
differently: not alphabetically but by thickness,
then by color, then by author. The key= parameter is
your custom sorting rule — you hand the librarian a
rule sheet, and they apply it to every book comparison.

📖 EXPLANATION:
Python provides sorted() and list.sort() using Timsort
(O(n log n), stable, adaptive). The key= parameter
enables powerful custom sorting without writing your
own comparison logic.

─────────────────────────────────────
📊 SORTED vs LIST.SORT()
─────────────────────────────────────
sorted(iterable, key=None, reverse=False)
  → returns a NEW sorted list
  → works on ANY iterable

list.sort(key=None, reverse=False)
  → sorts IN PLACE (returns None)
  → only works on lists

─────────────────────────────────────
🔑 THE key PARAMETER
─────────────────────────────────────
key receives a FUNCTION called on each element.
Python sorts by the KEY values, not the elements.
The key function is called ONCE per element (efficient).

sorted(words, key=len)           # by length
sorted(words, key=str.lower)     # case-insensitive
sorted(items, key=lambda x: x[1]) # by second element
sorted(objs, key=attrgetter("name"))  # by attribute

─────────────────────────────────────
🔀 MULTI-KEY SORTING
─────────────────────────────────────
Sort by multiple criteria: return a TUPLE from key.
  key=lambda x: (x.dept, -x.score)
  → sort by dept ascending, then score descending

─────────────────────────────────────
🧮 TIMSORT COMPLEXITY
─────────────────────────────────────
Best case:    O(n)       — nearly sorted data
Average:      O(n log n) — random data
Worst case:   O(n log n) — guaranteed
Space:        O(n)
Stable:       Yes — equal elements keep original order

─────────────────────────────────────
🔍 SEARCHING
─────────────────────────────────────
bisect.bisect_left(sorted_list, x)  → insertion point
bisect.insort(sorted_list, x)       → insert in order
For O(1) lookup: use dict/set not list!

💻 CODE:
import operator
from functools import cmp_to_key
import heapq
import bisect

# ── BASIC SORTING ──────────────────

nums = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3]

# sorted() — returns new list
print(sorted(nums))                  # [1, 1, 2, 3, 3, 4, 5, 5, 6, 9]
print(sorted(nums, reverse=True))    # [9, 6, 5, 5, 4, 3, 3, 2, 1, 1]
print(nums)                          # unchanged!

# list.sort() — in place, returns None
lst = [3, 1, 4, 1, 5, 9]
lst.sort()
print(lst)   # [1, 1, 3, 4, 5, 9]

# Any iterable works with sorted()
print(sorted("python"))        # ['h', 'n', 'o', 'p', 't', 'y']
print(sorted({3, 1, 4, 1, 5})) # [1, 3, 4, 5]
print(sorted(range(5, 0, -1))) # [1, 2, 3, 4, 5]

# ── KEY PARAMETER ──────────────────

words = ["banana", "Apple", "cherry", "date", "Elderberry"]

# Sort by length
by_length = sorted(words, key=len)
print(by_length)   # ['date', 'Apple', 'banana', 'cherry', 'Elderberry']

# Case-insensitive sort
by_alpha = sorted(words, key=str.lower)
print(by_alpha)   # ['Apple', 'banana', 'cherry', 'date', 'Elderberry']

# Sort by last character
by_last = sorted(words, key=lambda w: w[-1])
print(by_last)

# ── SORTING OBJECTS ────────────────

from dataclasses import dataclass

@dataclass
class Student:
    name: str
    grade: int
    gpa: float

students = [
    Student("Alice", 12, 3.9),
    Student("Bob",   11, 3.5),
    Student("Carol", 12, 3.7),
    Student("Dave",  11, 3.9),
    Student("Eve",   10, 4.0),
]

# Sort by single field
by_name = sorted(students, key=lambda s: s.name)
for s in by_name:
    print(f"  {s.name}")

# Sort by GPA descending
by_gpa = sorted(students, key=lambda s: s.gpa, reverse=True)
for s in by_gpa:
    print(f"  {s.name}: {s.gpa}")

# Using operator.attrgetter (faster than lambda for attributes)
by_grade = sorted(students, key=operator.attrgetter("grade"))
for s in by_grade:
    print(f"  {s.name}: grade {s.grade}")

# ── MULTI-KEY SORTING ──────────────

# Sort by grade ascending, then GPA descending
def sort_key(s):
    return (s.grade, -s.gpa)   # tuple comparison!

multi_sorted = sorted(students, key=sort_key)
print("\nBy grade↑ then GPA↓:")
for s in multi_sorted:
    print(f"  Grade {s.grade} | GPA {s.gpa} | {s.name}")

# attrgetter with multiple fields
# (both ascending — can't mix directions easily)
by_grade_name = sorted(students,
    key=operator.attrgetter("grade", "name"))

# Descending multiple: negate numerics, reverse strings
# For strings descending — trick: wrap in a comparison class
from functools import cmp_to_key

def compare_students(s1, s2):
    if s1.grade != s2.grade:
        return s1.grade - s2.grade      # grade ascending
    if s1.gpa != s2.gpa:
        return int((s2.gpa - s1.gpa) * 100)  # gpa descending
    return (s1.name > s2.name) - (s1.name < s2.name)   # name ascending

custom_sorted = sorted(students, key=cmp_to_key(compare_students))

# ── STABILITY ──────────────────────

# Stable sort: equal elements keep their relative order!
# This enables sort-then-sort for multi-key:
data = [("Alice", "Eng"), ("Bob", "Mkt"), ("Carol", "Eng"), ("Dave", "Mkt")]

# Step 1: sort by name
step1 = sorted(data, key=lambda x: x[0])
# Step 2: sort by dept — STABLE means names stay sorted within dept!
step2 = sorted(step1, key=lambda x: x[1])
print("Stable multi-sort:")
for row in step2:
    print(f"  {row}")

# ── SORTING DICTS ──────────────────

scores = {"Alice": 92, "Bob": 78, "Carol": 95, "Dave": 65}

# Sort by value
by_value = sorted(scores.items(), key=lambda kv: kv[1], reverse=True)
print(dict(by_value))

# Sort by key (default behavior for dicts)
by_key = dict(sorted(scores.items()))
print(by_key)

# Using itemgetter
by_val = sorted(scores.items(), key=operator.itemgetter(1))
print(dict(by_val))

# ── SEARCHING IN SORTED DATA ────────

import bisect

sorted_nums = [1, 3, 5, 7, 9, 11, 13, 15]

# Find insertion point
pos = bisect.bisect_left(sorted_nums, 6)   # where 6 would go
print(f"6 would be at index {pos}")         # 3

# Is 6 in the list?
def contains(sorted_lst, target):
    pos = bisect.bisect_left(sorted_lst, target)
    return pos < len(sorted_lst) and sorted_lst[pos] == target

print(contains(sorted_nums, 7))    # True
print(contains(sorted_nums, 6))    # False

# Insert maintaining sort order
bisect.insort(sorted_nums, 6)
print(sorted_nums)   # [..., 5, 6, 7, ...]

# ── HEAPQ — EFFICIENT TOP-K ─────────

data = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]

# Top 3 largest
print(heapq.nlargest(3, data))    # [9, 6, 5]

# Top 3 smallest
print(heapq.nsmallest(3, data))   # [1, 1, 2]

# Top 3 students by GPA
top3 = heapq.nlargest(3, students, key=lambda s: s.gpa)
for s in top3:
    print(f"  {s.name}: {s.gpa}")

# Priority queue using heapq
tasks = []
heapq.heappush(tasks, (3, "Low priority task"))
heapq.heappush(tasks, (1, "URGENT task"))
heapq.heappush(tasks, (2, "Normal task"))

while tasks:
    priority, task = heapq.heappop(tasks)
    print(f"[{priority}] {task}")

📝 KEY POINTS:
✅ sorted() returns new list; list.sort() sorts in place (returns None)
✅ key= receives a function called ONCE per element — sort by key value
✅ Timsort is stable — equal elements keep their original relative order
✅ For multi-key: return a tuple from key= (elements compared left to right)
✅ For mixed ascending/descending: negate numeric fields (-score)
✅ bisect for O(log n) search/insert in sorted lists
✅ heapq.nlargest/nsmallest for efficient top-K without full sort
✅ operator.attrgetter/itemgetter is faster than lambda for attributes/indexes
❌ Never do list.sort() on something that's not a list — it doesn't exist
❌ Don't forget reverse=True for descending — or negate the key value
❌ cmp_to_key is a last resort — prefer key= whenever possible
''',
  quiz: [
    Quiz(question: 'What is the difference between sorted() and list.sort()?', options: [
      QuizOption(text: 'sorted() is faster; list.sort() is more flexible', correct: false),
      QuizOption(text: 'sorted() returns a new list; list.sort() sorts in place and returns None', correct: true),
      QuizOption(text: 'sorted() only works on lists; list.sort() works on any iterable', correct: false),
      QuizOption(text: 'They are identical', correct: false),
    ]),
    Quiz(question: 'How do you sort a list of objects by two fields — name ascending then score descending?', options: [
      QuizOption(text: 'key=lambda x: x.name and key=lambda x: -x.score (two sorts)', correct: false),
      QuizOption(text: 'key=lambda x: (x.name, -x.score)', correct: true),
      QuizOption(text: 'sorted(items, by="name", then="score", desc=True)', correct: false),
      QuizOption(text: 'key=[lambda x: x.name, lambda x: x.score]', correct: false),
    ]),
    Quiz(question: 'Why is Python\'s sort called "stable"?', options: [
      QuizOption(text: 'It never raises exceptions', correct: false),
      QuizOption(text: 'Equal elements maintain their original relative order after sorting', correct: true),
      QuizOption(text: 'It always produces the same result on any machine', correct: false),
      QuizOption(text: 'It uses a fixed amount of memory', correct: false),
    ]),
  ],
);
