import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson06 = Lesson(
  language: 'Java',
  title: 'Control Flow: if and switch',
  content: """
🎯 METAPHOR:
Control flow is the decision-making brain of your program.
Without it, code runs top-to-bottom like a train on a
single track — no choices, no forks. if/else adds a
railway switch: "If the signal is green, go straight.
If red, divert left." switch is like a train depot with
many labeled platforms: the incoming train's destination
tag (the value) determines which platform it stops at.
Without these decisions, every program would do the same
thing every time — making it useless for real-world problems.

📖 EXPLANATION:

─────────────────────────────────────
if / else if / else:
─────────────────────────────────────
  if (condition) {
      // runs when condition is true
  } else if (anotherCondition) {
      // runs when anotherCondition is true
  } else {
      // runs when all conditions are false
  }

  Conditions must be boolean expressions.
  Unlike some languages, Java requires boolean — not int.
  if (1) { }  // ❌ ERROR in Java (valid in C/C++)

─────────────────────────────────────
TERNARY OPERATOR (inline if):
─────────────────────────────────────
  String result = (score >= 60) ? "Pass" : "Fail";

  Use for simple two-outcome expressions.
  Use if/else for complex logic.

─────────────────────────────────────
switch STATEMENT (classic):
─────────────────────────────────────
  switch (variable) {
      case value1:
          // code
          break;          // ← REQUIRED to prevent fall-through
      case value2:
          // code
          break;
      default:
          // runs if no case matches
  }

  Works with: int, char, String, enum (NOT double/boolean)

  FALL-THROUGH: Without break, execution CONTINUES into the
  next case. This is occasionally useful but usually a bug.

─────────────────────────────────────
switch EXPRESSION (Java 14+ — modern):
─────────────────────────────────────
  String day = switch (dayNum) {
      case 1 -> "Monday";
      case 2 -> "Tuesday";
      case 3 -> "Wednesday";
      case 4 -> "Thursday";
      case 5 -> "Friday";
      case 6, 7 -> "Weekend";   // multiple values!
      default -> "Invalid";
  };

  → Uses -> arrow syntax (no break needed, no fall-through)
  → Can return a value (it's an expression)
  → Multiple values per case with comma
  → yield for multi-line case blocks

─────────────────────────────────────
yield — multi-line switch expression:
─────────────────────────────────────
  int bonus = switch (grade) {
      case "A" -> 1000;
      case "B" -> {
          System.out.println("Good work!");
          yield 500;   // ← return value from block
      }
      default -> 0;
  };

─────────────────────────────────────
PATTERN MATCHING switch (Java 21):
─────────────────────────────────────
  Object obj = getObject();
  String result = switch (obj) {
      case Integer i -> "Integer: " + i;
      case String s  -> "String: " + s;
      case null      -> "null value";
      default        -> "Other: " + obj;
  };

─────────────────────────────────────
WHEN TO USE if vs switch:
─────────────────────────────────────
  if/else:       Range checks, complex conditions,
                 boolean logic, unrelated conditions

  switch:        Single variable with many exact values,
                 enum matching, type dispatching (Java 21)

💻 CODE:
public class ControlFlow {
    public static void main(String[] args) {

        // ─── BASIC if/else ────────────────────────────────
        System.out.println("=== if/else ===");
        int temperature = 28;

        if (temperature > 35) {
            System.out.println("🔥 Extremely hot!");
        } else if (temperature > 25) {
            System.out.println("☀️  Warm and sunny");
        } else if (temperature > 15) {
            System.out.println("🌤  Pleasant");
        } else if (temperature > 5) {
            System.out.println("🧥 Chilly — grab a jacket");
        } else {
            System.out.println("❄️  Freezing!");
        }

        // ─── RANGE GRADING ────────────────────────────────
        System.out.println("\n=== Grade Calculator ===");
        int[] scores = {95, 83, 71, 58, 42};
        for (int score : scores) {
            String grade;
            String comment;
            if (score >= 90) {
                grade = "A";
                comment = "Excellent!";
            } else if (score >= 80) {
                grade = "B";
                comment = "Good job";
            } else if (score >= 70) {
                grade = "C";
                comment = "Average";
            } else if (score >= 60) {
                grade = "D";
                comment = "Needs work";
            } else {
                grade = "F";
                comment = "Must retake";
            }
            System.out.printf("  Score: %3d → %s (%s)%n", score, grade, comment);
        }

        // ─── CLASSIC switch ───────────────────────────────
        System.out.println("\n=== Classic switch ===");
        String season = "SUMMER";
        switch (season) {
            case "SPRING":
                System.out.println("🌸 Flowers blooming");
                break;
            case "SUMMER":
                System.out.println("☀️  Beach time!");
                break;
            case "AUTUMN":
            case "FALL":                          // multiple labels!
                System.out.println("🍂 Leaves falling");
                break;
            case "WINTER":
                System.out.println("❄️  Stay warm");
                break;
            default:
                System.out.println("Unknown season");
        }

        // Fall-through example (intentional):
        System.out.println("\n=== Fall-through (intentional) ===");
        int level = 2;
        switch (level) {
            case 3: System.out.println("Level 3 bonus applied");   // falls through
            case 2: System.out.println("Level 2 content unlocked"); // falls through
            case 1: System.out.println("Level 1 tutorial shown");
                    break;
            default: System.out.println("Invalid level");
        }

        // ─── SWITCH EXPRESSION (modern) ───────────────────
        System.out.println("\n=== Switch Expression (Java 14+) ===");
        for (int day = 1; day <= 7; day++) {
            String dayName = switch (day) {
                case 1 -> "Monday";
                case 2 -> "Tuesday";
                case 3 -> "Wednesday";
                case 4 -> "Thursday";
                case 5 -> "Friday";
                case 6, 7 -> "Weekend \uD83C\uDF89";
                default -> "Unknown";
            };

            String type = switch (day) {
                case 1, 2, 3, 4, 5 -> "Weekday";
                case 6, 7 -> "Weekend";
                default -> "?";
            };
            System.out.printf("  Day %d: %-12s [%s]%n", day, dayName, type);
        }

        // ─── SWITCH WITH yield ────────────────────────────
        System.out.println("\n=== Switch with yield ===");
        String[] grades = {"A", "B", "C", "D", "F"};
        for (String grade : grades) {
            int bonus = switch (grade) {
                case "A" -> 1000;
                case "B" -> 750;
                case "C" -> {
                    System.out.println("  (Average — encouraging bonus)");
                    yield 500;
                }
                case "D" -> 100;
                default  -> 0;
            };
            System.out.printf("  Grade %s → bonus: $%,d%n", grade, bonus);
        }

        // ─── PATTERN MATCHING switch (Java 21) ───────────
        System.out.println("\n=== Pattern Matching switch ===");
        Object[] items = { "hello", 42, 3.14, true, null };
        for (Object item : items) {
            String desc = switch (item) {
                case String s  -> "String of length " + s.length() + ": '" + s + "'";
                case Integer i -> "Integer: " + i + " (doubled: " + (i * 2) + ")";
                case Double d  -> "Double: " + String.format("%.2f", d);
                case Boolean b -> "Boolean: " + (b ? "yes" : "no");
                case null      -> "null — handle carefully!";
                default        -> "Unknown type: " + item.getClass().getSimpleName();
            };
            System.out.println("  " + desc);
        }

        // ─── NESTED if ────────────────────────────────────
        System.out.println("\n=== Nested conditions ===");
        boolean isWeekend = true;
        boolean isRaining = false;
        boolean haveUmbrella = true;

        if (isWeekend) {
            if (isRaining) {
                if (haveUmbrella) {
                    System.out.println("Weekend + rain + umbrella → still going out!");
                } else {
                    System.out.println("Weekend + rain, no umbrella → staying in");
                }
            } else {
                System.out.println("Weekend, no rain → perfect day out!");
            }
        } else {
            System.out.println("Weekday → work first, fun later");
        }
    }
}

📝 KEY POINTS:
✅ Java if conditions MUST be boolean — if(1) is a compile error
✅ Classic switch requires break — missing it causes fall-through
✅ Switch expression (Java 14+) with -> eliminates break and fall-through
✅ Multiple case values with commas: case 6, 7 ->
✅ yield returns a value from a multi-line switch expression block
✅ Pattern matching switch (Java 21) matches on types and values
✅ switch can handle: int, char, String, enum — NOT double or boolean
✅ Fall-through in classic switch is occasionally useful (stacking cases)
❌ Don't forget break in classic switch — a common bug
❌ Don't use switch for range conditions — use if/else instead
❌ Ternary operators nested 3+ levels deep become unreadable fast
❌ if(x = 5) instead of if(x == 5) is an assignment, not comparison
""",
  quiz: [
    Quiz(question: 'What happens in a classic Java switch if you forget the break statement?', options: [
      QuizOption(text: 'Execution falls through to the next case and continues running', correct: true),
      QuizOption(text: 'A compilation error is thrown', correct: false),
      QuizOption(text: 'The switch exits automatically after the first matching case', correct: false),
      QuizOption(text: 'A runtime exception is thrown', correct: false),
    ]),
    Quiz(question: 'Which keyword returns a value from a multi-line switch expression block?', options: [
      QuizOption(text: 'yield', correct: true),
      QuizOption(text: 'return', correct: false),
      QuizOption(text: 'break', correct: false),
      QuizOption(text: 'result', correct: false),
    ]),
    Quiz(question: 'What types can be used in a Java switch statement?', options: [
      QuizOption(text: 'int, char, String, and enum — but NOT double or boolean', correct: true),
      QuizOption(text: 'All primitive types including double and boolean', correct: false),
      QuizOption(text: 'Only int and String', correct: false),
      QuizOption(text: 'Any type that implements Comparable', correct: false),
    ]),
  ],
);
