import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson24 = Lesson(
  language: 'Java',
  title: 'Lists, Sets, and Maps In Depth',
  content: """
🎯 METAPHOR:
If the Collections overview was the menu at a restaurant,
this lesson is the recipes. Lists are like a numbered
ticket queue — each ticket has a position, and you can
ask for "ticket number 5" directly. Sets are like a guest
list where every name appears ONCE — try to add the same
name twice and it's just ignored. Maps are like a phone
book — look up a NAME (key) and get a NUMBER (value)
instantly. Each has its own language, its own rules,
and its own most powerful operations. Mastering these
three gives you the tools to model almost any real-world
data structure.

📖 EXPLANATION:

─────────────────────────────────────
LIST — ordered, index-based:
─────────────────────────────────────
  Key operations:
  list.get(i)           → element at index i
  list.set(i, e)        → replace at index i
  list.add(i, e)        → insert at index i (shifts others)
  list.remove(i)        → remove at index i
  list.remove(obj)      → remove first occurrence of obj
  list.indexOf(obj)     → first index of obj (-1 if absent)
  list.lastIndexOf(obj) → last index
  list.subList(from,to) → view of portion [from, to)
  list.sort(comparator) → sort in place
  list.listIterator()   → bidirectional iterator

  SORTING:
  list.sort(null)                        // natural order
  list.sort(Comparator.reverseOrder())   // reverse
  list.sort(Comparator.comparing(Person::getName))
  list.sort(Comparator.comparing(Person::getAge)
            .thenComparing(Person::getName))

─────────────────────────────────────
SET — unique elements:
─────────────────────────────────────
  set.add(e)            → true if added, false if dup
  set.remove(e)         → remove if present
  set.contains(e)       → membership check
  set.size()
  
  SET MATH:
  a.retainAll(b)        → intersection (a = a ∩ b)
  a.addAll(b)           → union       (a = a ∪ b)
  a.removeAll(b)        → difference  (a = a − b)
  a.containsAll(b)      → is b a subset of a?

  TreeSet extra:
  treeSet.first()       → smallest
  treeSet.last()        → largest
  treeSet.headSet(e)    → elements < e
  treeSet.tailSet(e)    → elements >= e
  treeSet.subSet(f,t)   → elements in [f, t)
  treeSet.floor(e)      → largest element <= e
  treeSet.ceiling(e)    → smallest element >= e

─────────────────────────────────────
MAP — key-value pairs:
─────────────────────────────────────
  map.put(k, v)              → add/replace
  map.get(k)                 → value or null
  map.getOrDefault(k, def)   → value or default
  map.putIfAbsent(k, v)      → only add if key absent
  map.containsKey(k)         → key membership
  map.containsValue(v)       → value membership
  map.remove(k)              → remove by key
  map.keySet()               → Set<K> of all keys
  map.values()               → Collection<V> of all values
  map.entrySet()             → Set<Map.Entry<K,V>>
  map.forEach((k,v) -> ...)  → iterate key-value pairs
  map.merge(k, v, fn)        → merge existing and new value
  map.computeIfAbsent(k, fn) → compute and store if absent
  map.replaceAll((k,v) -> v2)→ update all values

  TreeMap extras:
  treeMap.firstKey() / lastKey()
  treeMap.headMap(k) / tailMap(k) / subMap(f,t)
  treeMap.floorKey(k) / ceilingKey(k)

💻 CODE:
import java.util.*;
import java.util.stream.*;

record Student(String name, int grade, String major) implements Comparable<Student> {
    @Override public int compareTo(Student other) {
        return Integer.compare(this.grade, other.grade);
    }
}

public class ListsSetsMaps {
    public static void main(String[] args) {

        // ─── LIST IN DEPTH ─────────────────────────────────
        System.out.println("=== List Operations ===");
        List<Student> students = new ArrayList<>(Arrays.asList(
            new Student("Alice",   92, "CS"),
            new Student("Bob",     78, "Math"),
            new Student("Charlie", 95, "CS"),
            new Student("Diana",   85, "Physics"),
            new Student("Eve",     88, "CS"),
            new Student("Frank",   71, "Math")
        ));

        // Sort by grade descending, then by name
        students.sort(Comparator.comparingInt(Student::grade).reversed()
            .thenComparing(Student::name));
        System.out.println("Sorted (grade desc, then name):");
        students.forEach(s -> System.out.printf(
            "  %-10s %3d  %s%n", s.name(), s.grade(), s.major()));

        // subList view
        List<Student> topStudents = students.subList(0, 3);
        System.out.println("Top 3: " + topStudents.stream()
            .map(Student::name).collect(Collectors.joining(", ")));

        // indexOf, set, remove
        List<String> colors = new ArrayList<>(
            Arrays.asList("red", "green", "blue", "green", "red"));
        System.out.println("\nColors: " + colors);
        System.out.println("indexOf(green): " + colors.indexOf("green"));
        System.out.println("lastIndexOf(red): " + colors.lastIndexOf("red"));
        colors.set(1, "yellow");
        colors.add(2, "purple");
        System.out.println("After set+insert: " + colors);
        colors.remove("green");   // removes first "green"
        System.out.println("After remove green: " + colors);

        // ─── SET IN DEPTH ─────────────────────────────────
        System.out.println("\n=== Set Operations ===");

        // Deduplication
        List<String> withDups = Arrays.asList(
            "java", "python", "java", "kotlin", "python", "java");
        Set<String> unique = new LinkedHashSet<>(withDups);
        System.out.println("Original: " + withDups);
        System.out.println("Unique:   " + unique);

        // Set math
        Set<String> team1  = new HashSet<>(Arrays.asList("Alice","Bob","Charlie","Diana"));
        Set<String> team2  = new HashSet<>(Arrays.asList("Charlie","Diana","Eve","Frank"));
        
        Set<String> intersection = new HashSet<>(team1);
        intersection.retainAll(team2);
        System.out.println("\nTeam1: " + team1);
        System.out.println("Team2: " + team2);
        System.out.println("Both teams (∩): " + intersection);

        Set<String> union = new HashSet<>(team1);
        union.addAll(team2);
        System.out.println("Either team (∪): " + union);

        Set<String> onlyTeam1 = new HashSet<>(team1);
        onlyTeam1.removeAll(team2);
        System.out.println("Only team1 (−): " + onlyTeam1);

        // TreeSet — sorted, range queries
        TreeSet<Integer> scores = new TreeSet<>(
            Arrays.asList(45, 92, 78, 65, 88, 71, 95, 55, 82));
        System.out.println("\nAll scores (sorted): " + scores);
        System.out.println("Passing (>=70):      " + scores.tailSet(70));
        System.out.println("At risk (<60):       " + scores.headSet(60));
        System.out.println("B range (80-89):     " + scores.subSet(80, 90));
        System.out.println("Closest below 80:    " + scores.floor(79));
        System.out.println("Closest above 80:    " + scores.ceiling(80));

        // ─── MAP IN DEPTH ─────────────────────────────────
        System.out.println("\n=== Map Operations ===");

        // Frequency count
        String text = "the quick brown fox jumps over the lazy dog";
        Map<Character, Integer> freq = new TreeMap<>();
        for (char c : text.toCharArray()) {
            if (c != ' ') {
                freq.merge(c, 1, Integer::sum);   // elegant frequency counting
            }
        }
        System.out.println("Letter frequencies:");
        freq.forEach((c, count) ->
            System.out.printf("  %c: %2d  %s%n", c, count, "*".repeat(count)));

        // Grouping
        Map<String, List<Student>> byMajor = new HashMap<>();
        for (Student s : students) {
            byMajor.computeIfAbsent(s.major(), k -> new ArrayList<>()).add(s);
        }
        System.out.println("\nStudents by major:");
        new TreeMap<>(byMajor).forEach((major, stds) -> {
            System.out.println("  " + major + ":");
            stds.forEach(s -> System.out.printf("    %s (%d)%n", s.name(), s.grade()));
        });

        // Average per group
        System.out.println("\nAverage grade by major:");
        byMajor.forEach((major, stds) -> {
            double avg = stds.stream().mapToInt(Student::grade).average().orElse(0);
            System.out.printf("  %-10s %.1f%n", major, avg);
        });

        // TreeMap for sorted map operations
        TreeMap<String, Integer> stock = new TreeMap<>();
        stock.put("Apple",  150); stock.put("Banana",  45);
        stock.put("Cherry",  20); stock.put("Date",    80);
        stock.put("Elderberry", 5); stock.put("Fig",   30);

        System.out.println("\nStock (sorted): " + stock);
        System.out.println("Products A-C: " + stock.headMap("D"));
        System.out.println("Low stock (<25): ");
        stock.entrySet().stream()
            .filter(e -> e.getValue() < 25)
            .forEach(e -> System.out.printf("  %s: %d%n", e.getKey(), e.getValue()));

        // replaceAll — update all values
        stock.replaceAll((k, v) -> (int)(v * 1.1));  // 10% restock
        System.out.println("After 10% restock: " + stock);
    }
}

📝 KEY POINTS:
✅ List: use get(i), set(i,e), add(i,e), remove(i) for index-based access
✅ Sort with Comparator.comparing(lambda).reversed().thenComparing(lambda)
✅ subList(from, to) returns a VIEW — changes affect the original list
✅ Set math: retainAll(∩), addAll(∪), removeAll(−), containsAll(subset)
✅ TreeSet: sorted, use headSet/tailSet/subSet for range queries
✅ map.merge(key, 1, Integer::sum) is the idiom for frequency counting
✅ map.computeIfAbsent(key, k -> new ArrayList<>()) creates if absent
✅ map.getOrDefault(key, 0) safely gets with a fallback
✅ TreeMap: sorted by key, supports headMap/tailMap/subMap/floorKey/ceilingKey
❌ subList() is a view — remove/add on it modifies the original list
❌ Don't modify a collection while iterating it — use removeIf() instead
❌ HashMap has no guaranteed iteration order — use LinkedHashMap if order matters
❌ TreeSet/TreeMap require elements to be Comparable or need a Comparator
""",
  quiz: [
    Quiz(question: 'What does set.retainAll(other) do?', options: [
      QuizOption(text: 'Modifies the set to keep only elements that are also in other — computes intersection', correct: true),
      QuizOption(text: 'Returns a new set with elements from both sets — computes union', correct: false),
      QuizOption(text: 'Removes all elements from other that exist in the set', correct: false),
      QuizOption(text: 'Retains only elements NOT in other — computes complement', correct: false),
    ]),
    Quiz(question: 'What does map.merge(key, 1, Integer::sum) do?', options: [
      QuizOption(text: 'If the key exists, it adds 1 to the existing value; if not, it inserts 1', correct: true),
      QuizOption(text: 'It replaces the existing value with 1 regardless of whether the key exists', correct: false),
      QuizOption(text: 'It merges two maps together using the sum function', correct: false),
      QuizOption(text: 'It removes the key if the new merged value is zero', correct: false),
    ]),
    Quiz(question: 'What does TreeSet.tailSet(70) return?', options: [
      QuizOption(text: 'A view of all elements in the TreeSet that are greater than or equal to 70', correct: true),
      QuizOption(text: 'All elements less than 70', correct: false),
      QuizOption(text: 'The 70 largest elements in the set', correct: false),
      QuizOption(text: 'Elements from index 70 to the end', correct: false),
    ]),
  ],
);
