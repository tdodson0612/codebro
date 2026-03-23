import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson43 = Lesson(
  language: 'Java',
  title: 'Regular Expressions',
  content: """
🎯 METAPHOR:
A regular expression is like a metal cookie cutter applied
to a sea of text. The cutter has a very specific shape —
"three digits, then a dash, then four digits" — and you
drag it across the text. Wherever the shape FITS, you've
found a match (a phone number). You can use the cutter
to find things (find all phone numbers), to cut them out
(extract them), to replace them with something else
(redact phone numbers), or to split the text wherever
the cutter fits (split by any whitespace). The cutter's
shape is the regex pattern — a tiny language inside Java
for describing text patterns.

📖 EXPLANATION:
Java's regex support lives in java.util.regex.
Two main classes: Pattern (compiled regex) and Matcher.

─────────────────────────────────────
REGEX BUILDING BLOCKS:
─────────────────────────────────────
  CHARACTERS:
  .         → any character except newline
  \\d        → digit [0-9]
  \\D        → non-digit
  \\w        → word char [a-zA-Z0-9_]
  \\W        → non-word char
  \\s        → whitespace (space, tab, newline)
  \\S        → non-whitespace
  \\n \\t \\r → newline, tab, carriage return

  CHARACTER CLASSES:
  [abc]     → a, b, or c
  [^abc]    → NOT a, b, or c
  [a-z]     → lowercase letter
  [A-Z]     → uppercase letter
  [0-9]     → digit (same as \\d)
  [a-zA-Z]  → any letter

  QUANTIFIERS:
  *         → 0 or more
  +         → 1 or more
  ?         → 0 or 1 (optional)
  {n}       → exactly n times
  {n,}      → at least n times
  {n,m}     → between n and m times

  Greedy vs lazy:
  .+        → greedy: matches as much as possible
  .+?       → lazy:   matches as little as possible

  ANCHORS:
  ^         → start of string (or line with MULTILINE)
 \$         → end of string (or line with MULTILINE)
  \\b        → word boundary
  \\B        → non-word boundary

  GROUPS AND ALTERNATION:
  (abc)     → capturing group
  (?:abc)   → non-capturing group
  a|b       → a OR b
  (a|b)+    → one or more of (a or b)

─────────────────────────────────────
JAVA REGEX API:
─────────────────────────────────────
  // Compile once, reuse (efficient):
  Pattern pattern = Pattern.compile("\\\\d{3}-\\\\d{4}");
  Matcher matcher = pattern.matcher(input);

  matcher.matches()          → entire string must match
  matcher.find()             → find next occurrence
  matcher.group()            → text of last match
  matcher.group(n)           → text of group n
  matcher.start()            → start index of match
  matcher.end()              → end index of match
  matcher.replaceAll("sub")  → replace all matches
  matcher.replaceFirst("sub")→ replace first match
  matcher.results()          → Stream<MatchResult> (Java 9)

  // Quick String methods (don't compile Pattern):
  str.matches("regex")       → entire string matches
  str.replaceAll("r", "s")   → replace all
  str.replaceFirst("r","s")  → replace first
  str.split("regex")         → split into array

─────────────────────────────────────
COMMON REGEX PATTERNS:
─────────────────────────────────────
  Email:      [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\\\.[a-zA-Z]{2,}
  Phone:      \\\\+?[0-9]{1,3}[-. ]?\\\\(?[0-9]{3}\\\\)?[-. ]?[0-9]{3}[-. ]?[0-9]{4}
  URL:        https?://[\\\\w.-]+(?:\\\\.[\\\\w.-]+)+[\\\\w./-]*
  IPv4:       \\\\d{1,3}\\\\.\\\\d{1,3}\\\\.\\\\d{1,3}\\\\.\\\\d{1,3}
  Date:       \\\\d{4}-\\\\d{2}-\\\\d{2}
  Integer:    -?\\\\d+
  Decimal:    -?\\\\d+\\\\.?\\\\d*
  Hex color:  #[0-9A-Fa-f]{6}
  Whitespace: \\\\s+
  Empty line: ^\\\\s*\$

─────────────────────────────────────
FLAGS:
─────────────────────────────────────
  Pattern.CASE_INSENSITIVE   → (?i)  ignore case
  Pattern.MULTILINE          → (?m)  ^ and\$ match lines
  Pattern.DOTALL             → (?s)  . matches newline too
  Pattern.COMMENTS           → (?x)  allow whitespace/comments
  Pattern.LITERAL            → treat pattern as literal

💻 CODE:
import java.util.regex.*;
import java.util.*;
import java.util.stream.*;

public class RegularExpressions {

    // ─── PRECOMPILED PATTERNS ─────────────────────────
    static final Pattern EMAIL   = Pattern.compile(
        "[a-zA-Z0-9._%+\\\\-]+@[a-zA-Z0-9.\\\\-]+\\\\.[a-zA-Z]{2,}");
    static final Pattern PHONE   = Pattern.compile(
        "\\\\(?\\\\d{3}\\\\)?[-.\\\\s]?\\\\d{3}[-.\\\\s]?\\\\d{4}");
    static final Pattern DATE    = Pattern.compile(
        "\\\\d{4}[-/]\\\\d{2}[-/]\\\\d{2}");
    static final Pattern INTEGER = Pattern.compile("-?\\\\d+");

    public static void main(String[] args) {

        // ─── BASIC MATCHING ───────────────────────────────
        System.out.println("=== Basic Matching ===");
        String[] words = {"hello", "Hello123", "JAVA", "java_dev", "123"};

        Pattern alpha     = Pattern.compile("[a-zA-Z]+");
        Pattern alphaNum  = Pattern.compile("[a-zA-Z0-9_]+");
        Pattern allLower  = Pattern.compile("[a-z]+");

        for (String word : words) {
            System.out.printf("  %-12s alpha=%-5s alphaNum=%-5s allLower=%s%n",
                word,
                alpha.matcher(word).matches(),
                alphaNum.matcher(word).matches(),
                allLower.matcher(word).matches());
        }

        // ─── FIND (SEARCH IN TEXT) ────────────────────────
        System.out.println("\n=== Finding Matches ===");
        String text = """
                Contact us at support@example.com or sales@company.org.
                Call (555) 123-4567 or 555-987-6543.
                Schedule: 2024-01-15, 2024-06-30, or 2024-12-25.
                Prices:\$10,\$250, and\$1999.
                """;

        // Find all emails
        System.out.println("  Emails found:");
        Matcher emailMatcher = EMAIL.matcher(text);
        while (emailMatcher.find()) {
            System.out.println("    " + emailMatcher.group() +
                " at [" + emailMatcher.start() + "-" + emailMatcher.end() + "]");
        }

        // Find all phone numbers
        System.out.println("  Phones found:");
        Matcher phoneMatcher = PHONE.matcher(text);
        while (phoneMatcher.find()) {
            System.out.println("    " + phoneMatcher.group());
        }

        // Find all dates
        System.out.println("  Dates found:");
        DATE.matcher(text).results()   // Java 9+ — Stream<MatchResult>
            .map(MatchResult::group)
            .forEach(d -> System.out.println("    " + d));

        // Find all prices (\$ + digits)
        System.out.println("  Prices found:");
        Pattern pricePattern = Pattern.compile("\\\\$\\\\d+");
        pricePattern.matcher(text).results()
            .map(MatchResult::group)
            .forEach(p -> System.out.println("    " + p));

        // ─── GROUPS AND CAPTURING ─────────────────────────
        System.out.println("\n=== Capturing Groups ===");

        // Named groups
        Pattern datePattern = Pattern.compile(
            "(?<year>\\\\d{4})-(?<month>\\\\d{2})-(?<day>\\\\d{2})");

        String[] dates = {"2024-01-15", "2023-12-31", "2025-06-01"};
        for (String date : dates) {
            Matcher m = datePattern.matcher(date);
            if (m.matches()) {
                System.out.printf("  %s → year=%s, month=%s, day=%s%n",
                    date, m.group("year"), m.group("month"), m.group("day"));
            }
        }

        // Numbered groups: extract name and domain from email
        Pattern emailParts = Pattern.compile("([^@]+)@([^.]+)\\\\.(.+)");
        String[] emails = {"terry@gmail.com", "alice@company.org", "bob@example.co.uk"};
        System.out.println("\n  Email parts:");
        for (String email : emails) {
            Matcher m = emailParts.matcher(email);
            if (m.matches()) {
                System.out.printf("    %-25s user=%s domain=%s tld=%s%n",
                    email, m.group(1), m.group(2), m.group(3));
            }
        }

        // ─── REPLACE ──────────────────────────────────────
        System.out.println("\n=== Replace ===");
        String html = "<p>Hello <b>World</b>!</p><span>Java regex</span>";

        // Remove HTML tags
        String noTags = html.replaceAll("<[^>]+>", "");
        System.out.println("  Strip HTML: " + noTags);

        // Replace with group reference
        String formatted = "2024-01-15 was a Monday, 2024-06-30 was a Sunday";
        String reordered = formatted.replaceAll(
            "(\\\\d{4})-(\\\\d{2})-(\\\\d{2})",
            "$3/$2/$1");   // DD/MM/YYYY
        System.out.println("  Reorder date: " + reordered);

        // Redact emails
        String message = "Email john@example.com and jane@test.org about the project";
        String redacted = EMAIL.matcher(message).replaceAll("[REDACTED]");
        System.out.println("  Redacted: " + redacted);

        // ─── SPLIT ────────────────────────────────────────
        System.out.println("\n=== Split ===");

        // Split on various whitespace
        String csv = "one,  two,   three  ,four";
        String[] parts = csv.split(",\\\\s*");  // comma + optional spaces
        System.out.println("  CSV split: " + Arrays.toString(parts));

        // Split log line
        String log = "2024-01-15 14:30:00 [ERROR] Database connection failed";
        String[] logParts = log.split("\\\\s+", 4);  // limit 4 parts
        System.out.printf("  Date: %s, Time: %s, Level: %s, Msg: %s%n",
            logParts[0], logParts[1], logParts[2], logParts[3]);

        // ─── VALIDATION ───────────────────────────────────
        System.out.println("\n=== Validation ===");
        String[] testEmails = {
            "terry@example.com", "bad@", "@nodomain.com",
            "alice.bob@company.co.uk", "nospaces @test.com"
        };
        for (String email : testEmails) {
            boolean valid = EMAIL.matcher(email).matches();
            System.out.printf("  %-30s %s%n", email, valid ? "✅" : "❌");
        }

        // ─── CASE-INSENSITIVE SEARCH ──────────────────────
        System.out.println("\n=== Flags ===");
        String content = "Java JAVA java JaVa is GREAT";
        Pattern caseInsensitive = Pattern.compile("java", Pattern.CASE_INSENSITIVE);
        long count = caseInsensitive.matcher(content).results().count();
        System.out.println("  Case-insensitive 'java' count: " + count);

        // Multiline
        String multiline = "first line\nsecond line\nthird line";
        Pattern lineStart = Pattern.compile("^\\\\w+", Pattern.MULTILINE);
        List<String> firstWords = lineStart.matcher(multiline).results()
            .map(MatchResult::group)
            .collect(Collectors.toList());
        System.out.println("  First word each line: " + firstWords);
    }
}

📝 KEY POINTS:
✅ Compile Pattern once and reuse — Pattern.compile() is expensive
✅ Use raw strings or escape backslashes: \\\\d in Java string = \\d in regex
✅ matcher.find() searches anywhere; matcher.matches() requires full match
✅ Use named groups (?<name>...) for readable group extraction
✅ matcher.results() returns Stream<MatchResult> (Java 9+) — use with streams
✅ Use\$1,\$2 in replaceAll() to reference captured groups
✅ Pattern.CASE_INSENSITIVE flag (or (?i) inline) for case-insensitive match
✅ Split with limit: split("regex", n) creates at most n parts
❌ Don't use str.matches() in a loop — it compiles the pattern every time
❌ Catastrophic backtracking: nested quantifiers on overlapping patterns can hang forever
❌ In Java strings: to match a digit use "\\\\d" (4 backslashes → 2 → \\d in regex)
❌ Don't validate complex input with a single giant regex — use multiple simple patterns
""",
  quiz: [
    Quiz(question: 'What is the difference between matcher.matches() and matcher.find()?', options: [
      QuizOption(text: 'matches() requires the entire string to match the pattern; find() searches for the pattern anywhere in the string', correct: true),
      QuizOption(text: 'find() is case-sensitive; matches() ignores case by default', correct: false),
      QuizOption(text: 'matches() returns a boolean; find() returns the matched text', correct: false),
      QuizOption(text: 'They are identical — matches() just calls find() internally', correct: false),
    ]),
    Quiz(question: 'Why should you use a precompiled Pattern instead of String.matches() in a loop?', options: [
      QuizOption(text: 'String.matches() compiles the pattern on every call — precompiling with Pattern.compile() avoids this overhead', correct: true),
      QuizOption(text: 'String.matches() cannot handle groups; Pattern is required for that', correct: false),
      QuizOption(text: 'Pattern provides thread safety; String.matches() is not thread-safe', correct: false),
      QuizOption(text: 'Pattern.matches() is required for patterns containing quantifiers', correct: false),
    ]),
    Quiz(question: 'How do you reference a captured group in a replaceAll() replacement string?', options: [
      QuizOption(text: 'Use\$1,\$2 etc.: "([\\\\d]+)-([\\\\d]+)" replaced with "$2-$1" swaps the two numbers', correct: true),
      QuizOption(text: 'Use \\\\1, \\\\2 etc.: the same backreference syntax as in the pattern', correct: false),
      QuizOption(text: 'Use {1}, {2} etc.: curly brace syntax for group references', correct: false),
      QuizOption(text: 'Groups cannot be referenced in replacement strings — use Matcher.group() instead', correct: false),
    ]),
  ],
);
