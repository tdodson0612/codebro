import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson14 = Lesson(
  language: 'Python',
  title: 'Sets',
  content: """
🎯 METAPHOR:
A set is like a bag of unique poker chips.
No matter how many times you throw in the same chip,
the bag only keeps one of each value. The chips are
also UNORDERED — shake the bag and the chips tumble
into any random arrangement. But this is actually the
SUPERPOWER: sets are blazing fast at one thing —
"Is this chip already in the bag?" — it checks instantly
in O(1), regardless of bag size. Perfect for removing
duplicates and testing membership.

📖 EXPLANATION:
Sets are UNORDERED collections of UNIQUE, IMMUTABLE elements.
They are like dictionaries but with only keys, no values.
Based on hash tables — lookup is O(1).

─────────────────────────────────────
📐 CREATING SETS
─────────────────────────────────────
empty   = set()          ← NOT {} (that's an empty dict!)
numbers = {1, 2, 3, 4, 5}
letters = set("hello")   → {'h', 'e', 'l', 'o'}
from_list = set([1, 2, 2, 3, 3, 3])  → {1, 2, 3}

⚠️  {} creates an EMPTY DICT, not an empty set!
    Use set() for empty set.

─────────────────────────────────────
🛠️  SET METHODS
─────────────────────────────────────
Adding:
  add(x)       — add single element
  update(iter) — add all elements from iterable

Removing:
  remove(x)    — remove x (KeyError if not found)
  discard(x)   — remove x (NO error if not found)
  pop()        — remove and return ARBITRARY item
  clear()      — remove all items

─────────────────────────────────────
🔢 SET OPERATIONS — Math Superpowers
─────────────────────────────────────
Like Venn diagrams from math class!

UNION (|) — all elements from EITHER set
  a | b   or   a.union(b)
  {1,2,3} | {3,4,5} → {1,2,3,4,5}

INTERSECTION (&) — only elements in BOTH sets
  a & b   or   a.intersection(b)
  {1,2,3} & {3,4,5} → {3}

DIFFERENCE (-) — elements in a but NOT in b
  a - b   or   a.difference(b)
  {1,2,3} - {3,4,5} → {1, 2}

SYMMETRIC DIFFERENCE (^) — in ONE but not BOTH
  a ^ b   or   a.symmetric_difference(b)
  {1,2,3} ^ {3,4,5} → {1, 2, 4, 5}

─────────────────────────────────────
📏 SET COMPARISONS
─────────────────────────────────────
a.issubset(b)      a <= b  — all of a is in b
a.issuperset(b)    a >= b  — b is entirely in a
a.isdisjoint(b)            — no shared elements
a == b                     — same elements

─────────────────────────────────────
🧊 FROZENSET — Immutable Set
─────────────────────────────────────
Like a set but immutable — can be used as dict key
or put inside another set.

fs = frozenset([1, 2, 3])
Can read but not add/remove elements.

─────────────────────────────────────
⚡ SET vs LIST — Performance
─────────────────────────────────────
                  List     Set
Membership (in)   O(n)     O(1)  ← huge!
Add element       O(1)     O(1)
Remove element    O(n)     O(1)
Duplicates        Yes      No

Use set when checking "is X in this collection"
repeatedly. Convert list to set for fast lookups.

💻 CODE:
# Creating sets
fruits = {"apple", "banana", "cherry"}
unique = set([1, 2, 2, 3, 3, 3, 4])
print(unique)   # {1, 2, 3, 4} — duplicates gone!

letters = set("mississippi")
print(letters)  # {'m', 'i', 's', 'p'} — unordered!

# Empty set MUST use set()
empty_set  = set()    # ✅ empty set
empty_dict = {}       # ✅ empty dict (not a set!)
print(type(empty_set))  # <class 'set'>
print(type(empty_dict)) # <class 'dict'>

# Adding and removing
s = {1, 2, 3}
s.add(4)
s.add(2)    # already there — no change, no error
print(s)    # {1, 2, 3, 4}

s.discard(10)  # safe — no error even if missing
s.remove(3)    # removes 3, KeyError if not found

# Membership testing (FAST!)
large_list = list(range(1000000))
large_set  = set(large_list)

# O(n) list search:
print(999999 in large_list)  # True but slow

# O(1) set search:
print(999999 in large_set)   # True and INSTANT

# Set operations
a = {1, 2, 3, 4, 5}
b = {4, 5, 6, 7, 8}

print("Union:", a | b)               # {1,2,3,4,5,6,7,8}
print("Intersection:", a & b)        # {4, 5}
print("Difference a-b:", a - b)      # {1, 2, 3}
print("Difference b-a:", b - a)      # {6, 7, 8}
print("Symmetric diff:", a ^ b)      # {1,2,3,6,7,8}

# Set comparisons
small = {1, 2}
large = {1, 2, 3, 4}
print(small.issubset(large))    # True  (small ⊆ large)
print(large.issuperset(small))  # True  (large ⊇ small)
print({1,2}.isdisjoint({3,4}))  # True  (no overlap)
print({1,2} == {2,1})           # True  (order irrelevant)

# Remove duplicates from list (preserve order Python 3.7+)
duplicates = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3]
unique_list = list(set(duplicates))     # order NOT preserved
print(unique_list)

# Preserve order while deduplicating:
seen = set()
ordered_unique = []
for item in duplicates:
    if item not in seen:
        seen.add(item)
        ordered_unique.append(item)
print(ordered_unique)  # [3, 1, 4, 5, 9, 2, 6] — order preserved

# Practical: find common elements
team_a = {"Alice", "Bob", "Carol", "Dave"}
team_b = {"Carol", "Dave", "Eve", "Frank"}
both_teams = team_a & team_b
print(f"In both teams: {both_teams}")  # Carol, Dave
only_a = team_a - team_b
print(f"Only in team A: {only_a}")     # Alice, Bob

# Set comprehension
even_squares = {x**2 for x in range(10) if x % 2 == 0}
print(even_squares)   # {0, 4, 16, 36, 64}

# Frozenset
fs = frozenset({1, 2, 3})
print(fs)
# Can be used as dict key or in another set:
d = {fs: "frozen set as key"}
nested = {frozenset({1,2}), frozenset({3,4})}

# Update methods (in-place set operations)
x = {1, 2, 3}
y = {3, 4, 5}
x |= y              # union in place
x &= {1, 2, 3}      # intersection in place
x -= {2}            # difference in place
print(x)

# Check if two lists share elements
list1 = [1, 2, 3, 4]
list2 = [5, 6, 7, 8]
print(not set(list1).isdisjoint(set(list2)))  # False (no shared)
list3 = [3, 4, 5]
print(not set(list1).isdisjoint(set(list3)))  # True (3, 4 shared)

📝 KEY POINTS:
✅ Sets are unordered and contain only unique elements
✅ set() for empty set — {} creates an empty dict!
✅ Membership testing is O(1) — much faster than lists for lookups
✅ Set operations: | union, & intersection, - difference, ^ symmetric diff
✅ Use discard() not remove() when element might not exist
✅ frozenset is hashable — can be used as dict key or inside sets
✅ Convert list to set to remove duplicates (order lost)
❌ Sets have no indexing — can't do my_set[0]
❌ Can't put mutable items (lists, dicts) in a set — they're unhashable
❌ {} is an empty dict, not an empty set — use set()
""",
  quiz: [
    Quiz(question: 'What does set([1,2,2,3,3,3]) produce?', options: [
      QuizOption(text: '{1, 2, 2, 3, 3, 3} — sets allow duplicates', correct: false),
      QuizOption(text: '{1, 2, 3} — duplicates are automatically removed', correct: true),
      QuizOption(text: 'A ValueError — duplicates are not allowed', correct: false),
      QuizOption(text: '[1, 2, 3] — returns a sorted list', correct: false),
    ]),
    Quiz(question: 'What is the time complexity of checking "x in my_set"?', options: [
      QuizOption(text: 'O(n) — must scan the entire set', correct: false),
      QuizOption(text: 'O(log n) — binary search', correct: false),
      QuizOption(text: 'O(1) — hash-based lookup', correct: true),
      QuizOption(text: 'O(n²) — sets are slow for membership tests', correct: false),
    ]),
    Quiz(question: 'What is the correct way to create an empty set?', options: [
      QuizOption(text: '{} — curly braces create an empty set', correct: false),
      QuizOption(text: 'set() — the set() constructor', correct: true),
      QuizOption(text: 'empty_set = [] then convert', correct: false),
      QuizOption(text: 'set{} — special syntax for empty set', correct: false),
    ]),
  ],
);
