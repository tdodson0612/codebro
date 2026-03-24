import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson65 = Lesson(
  language: 'Python',
  title: 'Recursion',
  content: """
🎯 METAPHOR:
Recursion is like looking up a word in a dictionary
and finding its definition uses the very same word.
"Recursion: see recursion." But useful recursion always
has a way to eventually STOP — a base case.
Think of it like Russian nesting dolls: you keep opening
dolls until you find the smallest solid one (base case),
then you know the total count (combine on the way back up).
Every recursive call says "I don't know the full answer,
but if someone solves the slightly-smaller version for me,
I can build the complete answer from that."

📖 EXPLANATION:
Recursion is when a function calls itself. Every recursive
function needs:
  1. A base case — stops recursion (no further calls)
  2. A recursive case — calls itself with a smaller input
  3. Progress toward the base case — MUST shrink each call

─────────────────────────────────────
📐 ANATOMY
─────────────────────────────────────
def factorial(n):
    if n <= 1:      # ← BASE CASE (stops here)
        return 1
    return n * factorial(n - 1)  # ← RECURSIVE CASE

─────────────────────────────────────
📦 CALL STACK
─────────────────────────────────────
Each recursive call adds a FRAME to the call stack.
Python's default recursion limit: 1000 (sys.getrecursionlimit())
Exceeding it → RecursionError: maximum recursion depth exceeded

For deep recursion: use iteration or sys.setrecursionlimit()
For performance: use @lru_cache or convert to iteration

─────────────────────────────────────
🔄 TAIL RECURSION
─────────────────────────────────────
When the recursive call is the VERY LAST operation.
Python does NOT optimize tail calls (unlike some languages).
Still limited by stack depth.
Workaround: use iteration or trampolining.

─────────────────────────────────────
🌳 WHEN RECURSION SHINES
─────────────────────────────────────
✅ Tree traversal (file systems, org charts, JSON)
✅ Divide-and-conquer (merge sort, quick sort)
✅ Backtracking (maze solving, permutations)
✅ Naturally recursive structures (nested lists)
❌ Simple loops (factorial, sum) — use iteration
❌ Very deep recursion (>1000 levels) — use iteration

💻 CODE:
import sys
from functools import lru_cache

# ── CLASSIC EXAMPLES ──────────────

def factorial(n):
    '''n! = n × (n-1) × ... × 1'''
    if n <= 1:          # base case
        return 1
    return n * factorial(n - 1)   # recursive case

for i in range(8):
    print(f"{i}! = {factorial(i)}")

# Trace the call stack:
# factorial(4)
#   → 4 * factorial(3)
#         → 3 * factorial(2)
#               → 2 * factorial(1)
#                     → 1
#               returns 2 * 1 = 2
#         returns 3 * 2 = 6
#   returns 4 * 6 = 24

def fibonacci(n):
    '''F(n) = F(n-1) + F(n-2)'''
    if n < 2:           # base cases: F(0)=0, F(1)=1
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

# SLOW without caching — exponential time O(2^n)
print([fibonacci(i) for i in range(10)])

# FAST with memoization
@lru_cache(maxsize=None)
def fib_fast(n):
    if n < 2:
        return n
    return fib_fast(n - 1) + fib_fast(n - 2)

print(fib_fast(50))   # instant!
print(fib_fast.cache_info())

# ── POWER / SUM ────────────────────

def power(base, exp):
    if exp == 0: return 1
    if exp < 0:  return 1 / power(base, -exp)
    return base * power(base, exp - 1)

print(power(2, 10))   # 1024

def sum_recursive(lst):
    if not lst: return 0
    return lst[0] + sum_recursive(lst[1:])

print(sum_recursive([1, 2, 3, 4, 5]))   # 15

# ── TREE / NESTED STRUCTURES ───────

# Flatten nested list (any depth)
def flatten(nested):
    result = []
    for item in nested:
        if isinstance(item, list):
            result.extend(flatten(item))   # recurse into sublists
        else:
            result.append(item)
    return result

deep = [1, [2, 3], [4, [5, [6, 7]]], 8]
print(flatten(deep))   # [1, 2, 3, 4, 5, 6, 7, 8]

# Tree node
class TreeNode:
    def __init__(self, val, children=None):
        self.val = val
        self.children = children or []

def tree_sum(node):
    '''Sum all values in tree.'''
    if not node: return 0
    return node.val + sum(tree_sum(child) for child in node.children)

def tree_depth(node):
    '''Maximum depth of tree.'''
    if not node.children:
        return 1
    return 1 + max(tree_depth(child) for child in node.children)

def tree_to_list(node):
    '''Depth-first traversal.'''
    result = [node.val]
    for child in node.children:
        result.extend(tree_to_list(child))
    return result

# Build a tree:
#       1
#      /|\\
#     2  3  4
#    / \\
#   5   6
root = TreeNode(1, [
    TreeNode(2, [TreeNode(5), TreeNode(6)]),
    TreeNode(3),
    TreeNode(4),
])

print(f"Sum: {tree_sum(root)}")          # 21
print(f"Depth: {tree_depth(root)}")      # 3
print(f"DFS: {tree_to_list(root)}")      # [1, 2, 5, 6, 3, 4]

# ── DIRECTORY TRAVERSAL ────────────

import os
from pathlib import Path

def count_files(directory):
    '''Recursively count all files in directory.'''
    count = 0
    try:
        for item in Path(directory).iterdir():
            if item.is_file():
                count += 1
            elif item.is_dir():
                count += count_files(item)   # recurse into subdir
    except PermissionError:
        pass
    return count

# count_files("/usr/lib")   # would count all files

# ── BACKTRACKING ───────────────────

def permutations(items):
    '''Generate all orderings of items.'''
    if len(items) <= 1:
        return [list(items)]
    result = []
    for i, item in enumerate(items):
        rest = items[:i] + items[i+1:]   # everything except item
        for perm in permutations(rest):
            result.append([item] + perm)
    return result

perms = permutations([1, 2, 3])
print(f"{len(perms)} permutations of [1,2,3]:")
for p in perms:
    print(f"  {p}")

# Maze solver (backtracking)
def solve_maze(maze, row, col, path=None):
    '''Find a path through a maze (0=open, 1=wall).'''
    if path is None: path = []
    rows, cols = len(maze), len(maze[0])

    # Out of bounds or wall
    if row < 0 or row >= rows or col < 0 or col >= cols:
        return None
    if maze[row][col] == 1:  # wall
        return None
    if (row, col) in path:  # already visited
        return None

    path = path + [(row, col)]

    # Reached the exit (bottom-right)
    if row == rows - 1 and col == cols - 1:
        return path

    # Try all 4 directions
    for dr, dc in [(0,1), (1,0), (0,-1), (-1,0)]:
        result = solve_maze(maze, row + dr, col + dc, path)
        if result:
            return result

    return None   # no path found from here

maze = [
    [0, 0, 1, 0, 0],
    [1, 0, 0, 0, 1],
    [1, 1, 1, 0, 1],
    [0, 0, 0, 0, 0],
    [0, 1, 1, 1, 0],
]
path = solve_maze(maze, 0, 0)
print(f"Path found: {path}")

# ── RECURSION LIMIT ────────────────

print(f"Default recursion limit: {sys.getrecursionlimit()}")  # 1000

# Increase if needed (carefully!)
sys.setrecursionlimit(5000)

# Better: convert to iteration
def factorial_iterative(n):
    result = 1
    for i in range(2, n + 1):
        result *= i
    return result

print(factorial_iterative(100))  # no recursion limit issues!

# Tail-recursive → iterative conversion
def sum_tail_to_iter(lst):
    total = 0
    for item in lst:
        total += item
    return total

📝 KEY POINTS:
✅ Every recursive function MUST have a base case (or it runs forever)
✅ Every recursive call MUST make progress toward the base case
✅ Use @lru_cache to memoize expensive recursive computations (fibonacci!)
✅ Recursion is elegant for trees, nested structures, and divide-and-conquer
✅ Python's default recursion limit is 1000 — use iteration for deeper work
✅ Backtracking = try something, recurse, undo if it fails
❌ Forgetting the base case → RecursionError (infinite recursion)
❌ Not moving toward the base case → infinite recursion even with base case
❌ Using plain recursion for fibonacci without memoization → exponential time
""",
  quiz: [
    Quiz(question: 'What are the two required parts of any recursive function?', options: [
      QuizOption(text: 'A return statement and a loop', correct: false),
      QuizOption(text: 'A base case (stops recursion) and a recursive case (calls itself with a smaller input)', correct: true),
      QuizOption(text: 'A parameter and a default value', correct: false),
      QuizOption(text: 'A try block and an except block', correct: false),
    ]),
    Quiz(question: 'Why is naive recursive fibonacci(50) slow?', options: [
      QuizOption(text: 'Python is slow for arithmetic', correct: false),
      QuizOption(text: 'It recomputes the same subproblems exponentially many times', correct: true),
      QuizOption(text: 'The recursion depth exceeds Python\'s limit', correct: false),
      QuizOption(text: 'Fibonacci numbers are too large for Python integers', correct: false),
    ]),
    Quiz(question: 'What happens if you exceed Python\'s default recursion limit?', options: [
      QuizOption(text: 'Python automatically increases the limit', correct: false),
      QuizOption(text: 'A RecursionError is raised', correct: true),
      QuizOption(text: 'The program silently exits', correct: false),
      QuizOption(text: 'The function returns None', correct: false),
    ]),
  ],
);
