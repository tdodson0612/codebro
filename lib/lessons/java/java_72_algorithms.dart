import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson72 = Lesson(
  language: 'Java',
  title: 'Algorithms in Java: Sorting, Searching, and Complexity',
  content: """
🎯 METAPHOR:
An algorithm is a recipe, and complexity is the recipe's
cooking time. "Boil pasta" — time depends on how much
pasta (O(n)). "Find a word in a dictionary" — flipping
pages one by one is O(n); opening to the middle and
halving each time is O(log n). "Check every possible
combination of ingredients" — that's O(2^n) exponential,
a recipe that takes forever for large inputs.
Big O notation captures the SHAPE of growth, not the
exact time. An O(n log n) algorithm that sorts 1 million
items takes about 20 million operations. An O(n²)
algorithm takes 1 trillion — the difference between
seconds and centuries.

📖 EXPLANATION:
Big O notation and the most important algorithms
in a Java developer's practical toolkit.

─────────────────────────────────────
BIG O NOTATION — COMPLEXITY CLASSES:
─────────────────────────────────────
  O(1)          Constant   — HashMap.get(), array index
  O(log n)      Logarithmic— binary search, TreeMap.get()
  O(n)          Linear     — linear search, array scan
  O(n log n)    Linearithmic — TimSort (Arrays.sort), merge sort
  O(n²)         Quadratic  — bubble sort, nested loops
  O(2^n)        Exponential— subset enumeration, naive Fibonacci
  O(n!)         Factorial  — permutation enumeration

  For n = 1,000,000:
  O(1)     →                    1 op
  O(log n) →                   20 ops
  O(n)     →            1,000,000 ops
  O(n log n)→           20,000,000 ops
  O(n²)    →        1,000,000,000,000 ops  (too slow!)

─────────────────────────────────────
SORTING ALGORITHMS:
─────────────────────────────────────
  Algorithm    Average     Best        Worst    Space  Stable
  ──────────────────────────────────────────────────────────
  Bubble       O(n²)       O(n)        O(n²)    O(1)   Yes
  Insertion    O(n²)       O(n)        O(n²)    O(1)   Yes
  Selection    O(n²)       O(n²)       O(n²)    O(1)   No
  Merge        O(n log n)  O(n log n)  O(n log n)O(n)  Yes
  Quick        O(n log n)  O(n log n)  O(n²)    O(log n)No
  Heap         O(n log n)  O(n log n)  O(n log n)O(1)  No
  TimSort      O(n log n)  O(n)        O(n log n)O(n)  Yes ← Java

  Java Arrays.sort() uses:
  → Dual-pivot Quicksort for primitives (fast, not stable)
  → TimSort for objects (stable — maintains equal element order)

─────────────────────────────────────
SEARCHING ALGORITHMS:
─────────────────────────────────────
  Linear search:    O(n) — check each element
  Binary search:    O(log n) — array MUST be sorted
  Hash lookup:      O(1) — HashMap/HashSet
  BST search:       O(log n) — balanced tree

  Arrays.binarySearch(arr, key)  — built-in binary search
  Collections.binarySearch(list, key) — for lists

─────────────────────────────────────
TWO POINTERS PATTERN — O(n):
─────────────────────────────────────
  Used for: pairs summing to target, palindrome check,
  reversing arrays, merging sorted arrays.

  // Find pair summing to target in sorted array:
  int left = 0, right = arr.length - 1;
  while (left < right) {
      int sum = arr[left] + arr[right];
      if (sum == target) return true;
      if (sum < target) left++;
      else right--;
  }

─────────────────────────────────────
SLIDING WINDOW PATTERN — O(n):
─────────────────────────────────────
  Used for: max sum subarray of size k, longest substring,
  minimum window substring.

  // Max sum subarray of size k:
  int windowSum = 0;
  for (int i = 0; i < k; i++) windowSum += arr[i];
  int maxSum = windowSum;
  for (int i = k; i < arr.length; i++) {
      windowSum += arr[i] - arr[i - k];  // slide
      maxSum = Math.max(maxSum, windowSum);
  }

─────────────────────────────────────
DYNAMIC PROGRAMMING — avoid recomputation:
─────────────────────────────────────
  Memoization (top-down):
  Map<Integer, Long> memo = new HashMap<>();
  long fib(int n) {
      if (n <= 1) return n;
      return memo.computeIfAbsent(n, k -> fib(k-1) + fib(k-2));
  }

  Tabulation (bottom-up):
  long[] dp = new long[n+1];
  dp[0] = 0; dp[1] = 1;
  for (int i = 2; i <= n; i++) dp[i] = dp[i-1] + dp[i-2];

─────────────────────────────────────
DIVIDE AND CONQUER — merge sort example:
─────────────────────────────────────
  Divide: split array in half
  Conquer: sort each half recursively
  Combine: merge two sorted halves

  Time: O(n log n), Space: O(n), Stable: yes

💻 CODE:
import java.util.*;
import java.util.stream.*;

public class Algorithms {

    // ─── SORTING IMPLEMENTATIONS ──────────────────────────
    static void insertionSort(int[] arr) {
        for (int i = 1; i < arr.length; i++) {
            int key = arr[i], j = i - 1;
            while (j >= 0 && arr[j] > key) { arr[j+1] = arr[j]; j--; }
            arr[j+1] = key;
        }
    }

    static void mergeSort(int[] arr, int lo, int hi) {
        if (lo >= hi) return;
        int mid = (lo + hi) / 2;
        mergeSort(arr, lo, mid);
        mergeSort(arr, mid+1, hi);
        merge(arr, lo, mid, hi);
    }

    static void merge(int[] arr, int lo, int mid, int hi) {
        int[] temp = Arrays.copyOfRange(arr, lo, hi+1);
        int i = 0, j = mid-lo+1, k = lo;
        while (i <= mid-lo && j <= hi-lo)
            arr[k++] = temp[i] <= temp[j] ? temp[i++] : temp[j++];
        while (i <= mid-lo) arr[k++] = temp[i++];
        while (j <= hi-lo)  arr[k++] = temp[j++];
    }

    // ─── SEARCHING ────────────────────────────────────────
    static int binarySearch(int[] arr, int target) {
        int lo = 0, hi = arr.length - 1;
        while (lo <= hi) {
            int mid = lo + (hi - lo) / 2;  // avoids overflow
            if (arr[mid] == target) return mid;
            if (arr[mid] < target) lo = mid + 1;
            else hi = mid - 1;
        }
        return -1;
    }

    // ─── TWO POINTERS ─────────────────────────────────────
    static boolean hasPairWithSum(int[] sortedArr, int target) {
        int lo = 0, hi = sortedArr.length - 1;
        while (lo < hi) {
            int sum = sortedArr[lo] + sortedArr[hi];
            if (sum == target) return true;
            if (sum < target) lo++; else hi--;
        }
        return false;
    }

    static boolean isPalindrome(String s) {
        int lo = 0, hi = s.length() - 1;
        while (lo < hi) {
            if (s.charAt(lo++) != s.charAt(hi--)) return false;
        }
        return true;
    }

    // ─── SLIDING WINDOW ───────────────────────────────────
    static int maxSumSubarray(int[] arr, int k) {
        int windowSum = 0;
        for (int i = 0; i < k; i++) windowSum += arr[i];
        int maxSum = windowSum;
        for (int i = k; i < arr.length; i++) {
            windowSum += arr[i] - arr[i - k];
            maxSum = Math.max(maxSum, windowSum);
        }
        return maxSum;
    }

    static int longestSubstringWithoutRepeat(String s) {
        Map<Character, Integer> seen = new HashMap<>();
        int maxLen = 0, start = 0;
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (seen.containsKey(c) && seen.get(c) >= start)
                start = seen.get(c) + 1;
            seen.put(c, i);
            maxLen = Math.max(maxLen, i - start + 1);
        }
        return maxLen;
    }

    // ─── DYNAMIC PROGRAMMING ──────────────────────────────
    static int[] coinChange(int[] coins, int amount) {
        int[] dp = new int[amount + 1];
        Arrays.fill(dp, amount + 1);
        dp[0] = 0;
        for (int a = 1; a <= amount; a++) {
            for (int coin : coins) {
                if (coin <= a) dp[a] = Math.min(dp[a], dp[a - coin] + 1);
            }
        }
        return dp;
    }

    static int longestCommonSubsequence(String s1, String s2) {
        int m = s1.length(), n = s2.length();
        int[][] dp = new int[m+1][n+1];
        for (int i = 1; i <= m; i++)
            for (int j = 1; j <= n; j++)
                dp[i][j] = s1.charAt(i-1) == s2.charAt(j-1)
                    ? dp[i-1][j-1] + 1
                    : Math.max(dp[i-1][j], dp[i][j-1]);
        return dp[m][n];
    }

    public static void main(String[] args) {

        // ─── SORTING ──────────────────────────────────────
        System.out.println("=== Sorting ===");
        int[] arr = {5, 2, 8, 1, 9, 3, 7, 4, 6};
        System.out.println("  Original:   " + Arrays.toString(arr));

        int[] ins = arr.clone();
        insertionSort(ins);
        System.out.println("  Insertion:  " + Arrays.toString(ins));

        int[] mrg = arr.clone();
        mergeSort(mrg, 0, mrg.length - 1);
        System.out.println("  Merge:      " + Arrays.toString(mrg));

        int[] jdk = arr.clone();
        Arrays.sort(jdk);
        System.out.println("  Arrays.sort:" + Arrays.toString(jdk));

        // Custom sort with Comparator
        String[] words = {"banana", "apple", "cherry", "fig", "date"};
        Arrays.sort(words, Comparator.comparingInt(String::length).thenComparing(Comparator.naturalOrder()));
        System.out.println("  By len+alpha: " + Arrays.toString(words));

        // ─── SEARCHING ────────────────────────────────────
        System.out.println("\n=== Searching ===");
        int[] sorted = {1,2,3,4,5,6,7,8,9,10};
        System.out.println("  Search 7:  idx=" + binarySearch(sorted, 7));
        System.out.println("  Search 11: idx=" + binarySearch(sorted, 11) + " (not found)");
        System.out.println("  JDK search 5: idx=" + Arrays.binarySearch(sorted, 5));

        // ─── TWO POINTERS ─────────────────────────────────
        System.out.println("\n=== Two Pointers ===");
        int[] pairs = {1, 2, 3, 4, 6, 8, 10};
        System.out.println("  Pair sums to 10: " + hasPairWithSum(pairs, 10));
        System.out.println("  Pair sums to 3:  " + hasPairWithSum(pairs, 3));
        System.out.println("  'racecar' palindrome: " + isPalindrome("racecar"));
        System.out.println("  'hello' palindrome:   " + isPalindrome("hello"));

        // ─── SLIDING WINDOW ───────────────────────────────
        System.out.println("\n=== Sliding Window ===");
        int[] nums = {2, 1, 5, 1, 3, 2};
        System.out.println("  Max sum window k=3: " + maxSumSubarray(nums, 3));
        System.out.println("  Longest unique substr 'abcabcbb': " +
            longestSubstringWithoutRepeat("abcabcbb"));
        System.out.println("  Longest unique substr 'pwwkew': " +
            longestSubstringWithoutRepeat("pwwkew"));

        // ─── DYNAMIC PROGRAMMING ──────────────────────────
        System.out.println("\n=== Dynamic Programming ===");
        int[] coins = {1, 5, 10, 25};
        int[] dp = coinChange(coins, 30);
        System.out.println("  Min coins for 30 cents: " + dp[30]);
        System.out.println("  Min coins for 11 cents: " + dp[11]);

        System.out.println("  LCS('ABCBDAB', 'BDCABA'): " +
            longestCommonSubsequence("ABCBDAB", "BDCABA"));
        System.out.println("  LCS('hello', 'hallo'): " +
            longestCommonSubsequence("hello", "hallo"));

        // ─── COMPLEXITY DEMO ──────────────────────────────
        System.out.println("\n=== Complexity Demonstration ===");
        int N = 100_000;
        long[] testArr = new Random(42).longs(N, 1, 1_000_001).toArray();
        long target = testArr[N/2];

        long t1 = System.nanoTime();
        long found1 = -1;
        for (long x : testArr) if (x == target) { found1 = x; break; }
        long linearNs = System.nanoTime() - t1;

        long[] sorted2 = testArr.clone(); Arrays.sort(sorted2);
        long t2 = System.nanoTime();
        int idx = Arrays.binarySearch(sorted2, target);
        long binaryNs = System.nanoTime() - t2;

        Set<Long> hashSet = new HashSet<>();
        for (long x : testArr) hashSet.add(x);
        long t3 = System.nanoTime();
        boolean found3 = hashSet.contains(target);
        long hashNs = System.nanoTime() - t3;

        System.out.printf("  N=%,d, target=%d%n", N, target);
        System.out.printf("  Linear search:  %,5d ns%n", linearNs);
        System.out.printf("  Binary search:  %,5d ns%n", binaryNs);
        System.out.printf("  Hash lookup:    %,5d ns%n", hashNs);
    }
}

📝 KEY POINTS:
✅ Know Big O: O(1) < O(log n) < O(n) < O(n log n) < O(n²) < O(2^n)
✅ Java Arrays.sort() uses TimSort for objects (stable) and dual-pivot Quicksort for primitives
✅ Binary search requires a SORTED array — use lo + (hi-lo)/2 to avoid overflow
✅ Two pointers: O(n) for pair problems on sorted arrays — avoid O(n²) nested loops
✅ Sliding window: O(n) for subarray/substring problems — avoid O(n²) recomputation
✅ Dynamic programming: trade space for time — memoize overlapping subproblems
✅ LCS and coin change are classic DP problems — understand the recurrence
✅ HashMap lookup is O(1) — 1000x faster than linear search for large datasets
❌ Never use O(n²) sorting for large data — use Arrays.sort() which is O(n log n)
❌ Binary search on unsorted data gives wrong results — always sort first
❌ lo + hi may overflow for large indices — use lo + (hi-lo)/2 instead
❌ Greedy algorithms don't always find the global optimum — use DP when subproblems overlap
""",
  quiz: [
    Quiz(question: 'Why does Java use TimSort for Arrays.sort() with objects but Quicksort for primitives?', options: [
      QuizOption(text: 'TimSort is stable (preserves equal elements\' order) for objects; primitives don\'t have identity so stability isn\'t needed, and Quicksort is faster', correct: true),
      QuizOption(text: 'TimSort handles null values in object arrays; Quicksort cannot', correct: false),
      QuizOption(text: 'Quicksort works with primitive comparison operators; TimSort requires Comparable', correct: false),
      QuizOption(text: 'TimSort uses less memory for large object arrays; Quicksort is more memory-efficient for primitives', correct: false),
    ]),
    Quiz(question: 'What is the sliding window technique used for?', options: [
      QuizOption(text: 'Processing contiguous subarrays/substrings in O(n) by maintaining a window that slides rather than restarting from scratch', correct: true),
      QuizOption(text: 'Displaying portions of large datasets in a GUI without loading all data', correct: false),
      QuizOption(text: 'A parallel processing pattern that assigns work windows to different threads', correct: false),
      QuizOption(text: 'A memory management technique that keeps frequently accessed data in L1 cache', correct: false),
    ]),
    Quiz(question: 'What makes dynamic programming different from simple recursion?', options: [
      QuizOption(text: 'DP stores results of overlapping subproblems (memoization/tabulation) — avoiding redundant recomputation that makes naive recursion exponential', correct: true),
      QuizOption(text: 'DP always uses an iterative loop while recursion uses function call stacks', correct: false),
      QuizOption(text: 'DP is a parallel algorithm; recursion is sequential', correct: false),
      QuizOption(text: 'DP uses more memory; recursion uses more CPU time without exception', correct: false),
    ]),
  ],
);
