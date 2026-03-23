import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson74 = Lesson(
  language: 'Python',
  title: 'Interview Patterns & Coding Challenges',
  content: '''
🎯 METAPHOR:
Python interview questions are like standardized tests —
they check specific skills in specific ways. Knowing the
material isn't enough; you also need to recognize the pattern.
"Two sum" = use a dict for O(1) lookup. "Find duplicates" =
use a Counter or set. "Longest sequence" = sliding window
or dynamic programming. Once you map question patterns to
Python idioms, each challenge becomes familiar territory.

📖 EXPLANATION:
This lesson covers the Python patterns that come up
repeatedly in technical interviews and competitive
programming: data structure tricks, algorithm patterns,
and idiomatic Python solutions.

─────────────────────────────────────
🔑 COMMON PATTERNS
─────────────────────────────────────
Two Pointers    → sorted array, find pairs
Sliding Window  → subarray/substring problems
Hash Map        → O(1) lookup, counting, grouping
Stack/Queue     → balanced brackets, BFS/DFS
Heap            → K largest/smallest items
Binary Search   → sorted data O(log n)
Dynamic Prog.   → overlapping subproblems

─────────────────────────────────────
🐍 PYTHON INTERVIEW TRICKS
─────────────────────────────────────
collections.Counter    → instant frequency count
collections.defaultdict → no KeyError for new keys
collections.deque      → O(1) both ends
heapq                  → efficient priority queue
sorted(key=)           → flexible custom sorting
enumerate()            → index + value in loops
zip()                  → parallel iteration
set operations         → intersection, union, difference
any()/all()            → check conditions on iterables
dict comprehension     → transform/filter dicts

💻 CODE:
from collections import Counter, defaultdict, deque
import heapq
from functools import lru_cache
from typing import Optional

# ── TWO SUM ───────────────────────

def two_sum(nums: list[int], target: int) -> list[int]:
    """Find two numbers that add to target. O(n)."""
    seen = {}   # value → index
    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i
    return []

print(two_sum([2, 7, 11, 15], 9))   # [0, 1]
print(two_sum([3, 2, 4], 6))         # [1, 2]

# ── ANAGRAM DETECTION ─────────────

def is_anagram(s: str, t: str) -> bool:
    """Check if t is an anagram of s."""
    return Counter(s) == Counter(t)

def group_anagrams(strs: list[str]) -> list[list[str]]:
    """Group words that are anagrams of each other."""
    groups = defaultdict(list)
    for word in strs:
        key = "".join(sorted(word))   # canonical form
        groups[key].append(word)
    return list(groups.values())

print(is_anagram("anagram", "nagaram"))   # True
print(group_anagrams(["eat","tea","tan","ate","nat","bat"]))

# ── SLIDING WINDOW ────────────────

def max_sum_subarray(nums: list[int], k: int) -> int:
    """Max sum of subarray of length k. O(n)."""
    if len(nums) < k:
        return 0
    window_sum = sum(nums[:k])
    max_sum = window_sum
    for i in range(k, len(nums)):
        window_sum += nums[i] - nums[i - k]
        max_sum = max(max_sum, window_sum)
    return max_sum

def longest_unique_substring(s: str) -> int:
    """Length of longest substring without repeating chars."""
    char_index = {}
    left = max_len = 0
    for right, char in enumerate(s):
        if char in char_index and char_index[char] >= left:
            left = char_index[char] + 1
        char_index[char] = right
        max_len = max(max_len, right - left + 1)
    return max_len

print(max_sum_subarray([2, 1, 5, 1, 3, 2], 3))  # 9
print(longest_unique_substring("abcabcbb"))       # 3

# ── STACK PATTERNS ────────────────

def is_valid_brackets(s: str) -> bool:
    """Valid parentheses/brackets/braces."""
    pairs = {")": "(", "]": "[", "}": "{"}
    stack = []
    for char in s:
        if char in "([{":
            stack.append(char)
        elif char in ")]}":
            if not stack or stack[-1] != pairs[char]:
                return False
            stack.pop()
    return not stack

print(is_valid_brackets("()[]{}"))   # True
print(is_valid_brackets("([)]"))     # False
print(is_valid_brackets("{[]}"))     # True

def daily_temperatures(temps: list[int]) -> list[int]:
    """Days until warmer temperature. O(n)."""
    result = [0] * len(temps)
    stack = []   # indices of days waiting for warmer temp
    for i, temp in enumerate(temps):
        while stack and temps[stack[-1]] < temp:
            idx = stack.pop()
            result[idx] = i - idx
        stack.append(i)
    return result

print(daily_temperatures([73, 74, 75, 71, 69, 72, 76, 73]))
# [1, 1, 4, 2, 1, 1, 0, 0]

# ── LINKED LIST (without class) ───

def reverse_linked_list(head: Optional["ListNode"]):
    """Reverse a linked list. O(n)."""
    prev, curr = None, head
    while curr:
        next_node = curr.next
        curr.next = prev
        prev = curr
        curr = next_node
    return prev

# ── DYNAMIC PROGRAMMING ───────────

@lru_cache(maxsize=None)
def fib(n: int) -> int:
    if n <= 1: return n
    return fib(n-1) + fib(n-2)

def climb_stairs(n: int) -> int:
    """Ways to climb n stairs (1 or 2 steps). O(n)."""
    if n <= 2: return n
    dp = [0] * (n + 1)
    dp[1], dp[2] = 1, 2
    for i in range(3, n + 1):
        dp[i] = dp[i-1] + dp[i-2]
    return dp[n]

def coin_change(coins: list[int], amount: int) -> int:
    """Minimum coins to make amount. O(amount × coins)."""
    dp = [float("inf")] * (amount + 1)
    dp[0] = 0
    for coin in coins:
        for i in range(coin, amount + 1):
            dp[i] = min(dp[i], dp[i - coin] + 1)
    return dp[amount] if dp[amount] != float("inf") else -1

print(climb_stairs(5))              # 8
print(coin_change([1, 5, 11], 15))  # 3 (5+5+5 or 11+1+1+1+1)

# ── BINARY SEARCH ─────────────────

def binary_search(arr: list[int], target: int) -> int:
    lo, hi = 0, len(arr) - 1
    while lo <= hi:
        mid = (lo + hi) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            lo = mid + 1
        else:
            hi = mid - 1
    return -1

def search_rotated(nums: list[int], target: int) -> int:
    """Binary search in rotated sorted array."""
    lo, hi = 0, len(nums) - 1
    while lo <= hi:
        mid = (lo + hi) // 2
        if nums[mid] == target:
            return mid
        # Left half is sorted
        if nums[lo] <= nums[mid]:
            if nums[lo] <= target < nums[mid]:
                hi = mid - 1
            else:
                lo = mid + 1
        else:
            if nums[mid] < target <= nums[hi]:
                lo = mid + 1
            else:
                hi = mid - 1
    return -1

print(binary_search([1,3,5,7,9,11,13], 7))  # 3
print(search_rotated([4,5,6,7,0,1,2], 0))   # 4

# ── HEAP PATTERNS ─────────────────

def k_largest(nums: list[int], k: int) -> list[int]:
    return heapq.nlargest(k, nums)

def k_smallest(nums: list[int], k: int) -> list[int]:
    return heapq.nsmallest(k, nums)

def merge_sorted_lists(lists: list[list[int]]) -> list[int]:
    """Merge k sorted lists efficiently. O(n log k)."""
    heap = []
    for i, lst in enumerate(lists):
        if lst:
            heapq.heappush(heap, (lst[0], i, 0))
    result = []
    while heap:
        val, list_idx, elem_idx = heapq.heappop(heap)
        result.append(val)
        if elem_idx + 1 < len(lists[list_idx]):
            next_val = lists[list_idx][elem_idx + 1]
            heapq.heappush(heap, (next_val, list_idx, elem_idx + 1))
    return result

data = [5, 3, 8, 1, 9, 2, 7, 4, 6]
print(k_largest(data, 3))     # [9, 8, 7]
print(k_smallest(data, 3))    # [1, 2, 3]

lists = [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
print(merge_sorted_lists(lists))  # [1, 2, 3, 4, 5, 6, 7, 8, 9]

# ── MATRIX PATTERNS ───────────────

def rotate_matrix_90(matrix: list[list]) -> list[list]:
    """Rotate NxN matrix 90° clockwise in-place."""
    n = len(matrix)
    # Transpose
    for i in range(n):
        for j in range(i, n):
            matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]
    # Reverse each row
    for row in matrix:
        row.reverse()
    return matrix

def spiral_order(matrix: list[list]) -> list:
    """Return elements in spiral order."""
    result = []
    while matrix:
        result += matrix.pop(0)
        matrix = list(zip(*matrix))[::-1]  # rotate remaining
    return result

m = [[1,2,3],[4,5,6],[7,8,9]]
print(spiral_order(m))   # [1,2,3,6,9,8,7,4,5]

# ── PYTHONIC TRICKS ───────────────

# Flatten nested list
from itertools import chain
nested = [[1,2],[3,4],[5,6]]
flat = list(chain.from_iterable(nested))
print(flat)

# Most common element
data = [1,2,2,3,3,3,4]
print(Counter(data).most_common(1)[0][0])   # 3

# Group by condition
nums = range(10)
groups = defaultdict(list)
for n in nums:
    groups["even" if n%2==0 else "odd"].append(n)
print(dict(groups))

# Running total
from itertools import accumulate
print(list(accumulate([1,2,3,4,5])))   # [1,3,6,10,15]

# Transpose matrix
matrix = [[1,2,3],[4,5,6],[7,8,9]]
transposed = list(map(list, zip(*matrix)))
print(transposed)   # [[1,4,7],[2,5,8],[3,6,9]]

📝 KEY POINTS:
✅ Counter for frequency counting — replace dict + loop instantly
✅ defaultdict(list) for grouping — no if-key-in-dict boilerplate
✅ deque for O(1) operations at both ends
✅ Two pointers, sliding window, hash map — learn these three core patterns
✅ @lru_cache turns recursive solutions into fast memoized ones
✅ heapq.nlargest/nsmallest for top-K problems without full sort
✅ Binary search template: lo, hi, mid, check, adjust
❌ Don't use sorted() when a O(n) or O(log n) solution exists
❌ Don't mutate input arrays unless told you can
❌ Don't overlook edge cases: empty list, single element, all same values
''',
  quiz: [
    Quiz(question: 'What data structure gives O(1) average-case lookup for the Two Sum problem?', options: [
      QuizOption(text: 'List — using linear search', correct: false),
      QuizOption(text: 'Dictionary — hash-based lookup', correct: true),
      QuizOption(text: 'Sorted list — using binary search', correct: false),
      QuizOption(text: 'Set — membership test', correct: false),
    ]),
    Quiz(question: 'What is the sliding window pattern best used for?', options: [
      QuizOption(text: 'Finding elements at specific indices', correct: false),
      QuizOption(text: 'Efficiently computing results over contiguous subarrays or substrings', correct: true),
      QuizOption(text: 'Sorting arrays in place', correct: false),
      QuizOption(text: 'Recursively dividing problems', correct: false),
    ]),
    Quiz(question: 'What is the time complexity of finding the K largest elements with heapq.nlargest(k, nums)?', options: [
      QuizOption(text: 'O(n²)', correct: false),
      QuizOption(text: 'O(n log k)', correct: true),
      QuizOption(text: 'O(n log n)', correct: false),
      QuizOption(text: 'O(k)', correct: false),
    ]),
  ],
);
