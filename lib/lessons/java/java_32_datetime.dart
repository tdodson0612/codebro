import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson32 = Lesson(
  language: 'Java',
  title: 'The DateTime API (java.time)',
  content: """
🎯 METAPHOR:
Java's old Date and Calendar classes were like a broken
clock that runs backwards on Tuesdays. Developers had to
work around months being 0-indexed, Date being mutable,
and Calendar being thread-unsafe. The java.time API
(introduced in Java 8) is the new precision Swiss watch:
every class is immutable, dates and times are clearly
separated, time zones are explicit, and the API reads
like natural language. "Give me the date 10 days from
now" is literally: LocalDate.now().plusDays(10). Clean,
readable, correct.

📖 EXPLANATION:
The java.time package was designed by the author of Joda-Time
and replaces the broken java.util.Date and java.util.Calendar.

─────────────────────────────────────
CORE CLASSES:
─────────────────────────────────────
  LocalDate        → date only (2024-01-15)
  LocalTime        → time only (14:30:00)
  LocalDateTime    → date + time (2024-01-15T14:30:00)
  ZonedDateTime    → date + time + timezone
  Instant          → machine time (epoch seconds)
  Duration         → amount of time (hours, minutes, seconds)
  Period           → calendar-based amount (years, months, days)
  ZoneId           → timezone identifier ("America/New_York")
  ZoneOffset       → UTC offset (+05:30)
  YearMonth        → year and month (2024-01)
  MonthDay         → recurring date (--12-25)
  DayOfWeek        → MONDAY, TUESDAY, ... (enum)
  Month            → JANUARY, FEBRUARY, ... (enum)

─────────────────────────────────────
LocalDate:
─────────────────────────────────────
  LocalDate today = LocalDate.now();
  LocalDate birthday = LocalDate.of(1990, Month.JUNE, 15);
  LocalDate parsed = LocalDate.parse("2024-01-15");

  today.getYear()         → 2024
  today.getMonth()        → JANUARY (enum)
  today.getMonthValue()   → 1
  today.getDayOfMonth()   → 15
  today.getDayOfWeek()    → MONDAY (enum)
  today.getDayOfYear()    → 15

  today.plusDays(7)       → 7 days later
  today.minusMonths(3)    → 3 months ago
  today.withYear(2025)    → same day, different year
  today.isLeapYear()      → true/false
  today.lengthOfMonth()   → 31 (days in this month)

  today.isBefore(other)   → comparison
  today.isAfter(other)
  today.isEqual(other)

─────────────────────────────────────
LocalTime and LocalDateTime:
─────────────────────────────────────
  LocalTime now = LocalTime.now();
  LocalTime alarm = LocalTime.of(7, 30);        // 07:30:00
  LocalTime precise = LocalTime.of(14, 45, 30); // 14:45:30

  LocalDateTime dt = LocalDateTime.of(today, alarm);
  LocalDateTime fromStr = LocalDateTime.parse("2024-01-15T14:30:00");

─────────────────────────────────────
ZonedDateTime and Instant:
─────────────────────────────────────
  // Specific timezone:
  ZonedDateTime nyc = ZonedDateTime.now(ZoneId.of("America/New_York"));
  ZonedDateTime london = ZonedDateTime.now(ZoneId.of("Europe/London"));

  // Machine time (for databases, logging):
  Instant now = Instant.now();
  long epochSec = now.getEpochSecond();
  Instant later = now.plusSeconds(3600);

─────────────────────────────────────
Duration and Period:
─────────────────────────────────────
  Duration d = Duration.ofHours(2).plusMinutes(30);
  Duration between = Duration.between(startTime, endTime);
  between.toMinutes()   → total minutes
  between.toHours()     → total hours

  Period p = Period.ofDays(10);
  Period between2 = Period.between(date1, date2);
  between2.getDays()    → day component
  between2.getMonths()  → month component

─────────────────────────────────────
DateTimeFormatter:
─────────────────────────────────────
  DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
  String formatted = today.format(fmt);  → "15/01/2024"
  LocalDate parsed = LocalDate.parse("15/01/2024", fmt);

  // ISO standard formats (built-in):
  DateTimeFormatter.ISO_LOCAL_DATE     → "2024-01-15"
  DateTimeFormatter.ISO_LOCAL_DATE_TIME→ "2024-01-15T14:30:00"
  DateTimeFormatter.ISO_INSTANT        → "2024-01-15T14:30:00Z"

  // Localized:
  DateTimeFormatter.ofLocalizedDate(FormatStyle.LONG)

💻 CODE:
import java.time.*;
import java.time.format.*;
import java.time.temporal.*;

public class DateTimeAPI {
    public static void main(String[] args) {

        // ─── LocalDate ────────────────────────────────────
        System.out.println("=== LocalDate ===");
        LocalDate today     = LocalDate.now();
        LocalDate birthday  = LocalDate.of(1990, Month.JUNE, 15);
        LocalDate christmas = LocalDate.of(today.getYear(), 12, 25);

        System.out.printf("  Today:      %s (%s)%n", today, today.getDayOfWeek());
        System.out.printf("  Birthday:   %s%n", birthday);
        System.out.printf("  Christmas:  %s%n", christmas);

        // Arithmetic
        LocalDate nextWeek  = today.plusWeeks(1);
        LocalDate lastMonth = today.minusMonths(1);
        LocalDate nextYear  = today.withYear(today.getYear() + 1);
        System.out.printf("  Next week:  %s%n", nextWeek);
        System.out.printf("  Last month: %s%n", lastMonth);
        System.out.printf("  Next year:  %s%n", nextYear);

        // Days until Christmas
        long daysToChristmas = today.until(christmas, ChronoUnit.DAYS);
        if (daysToChristmas < 0) {
            christmas = christmas.plusYears(1);
            daysToChristmas = today.until(christmas, ChronoUnit.DAYS);
        }
        System.out.printf("  Days to Christmas: %d%n", daysToChristmas);

        // Age calculation
        Period age = Period.between(birthday, today);
        System.out.printf("  Age: %d years, %d months, %d days%n",
            age.getYears(), age.getMonths(), age.getDays());

        // Year info
        System.out.printf("  Days in this month: %d%n", today.lengthOfMonth());
        System.out.printf("  Days in this year:  %d%n", today.lengthOfYear());
        System.out.printf("  Is leap year: %s%n", today.isLeapYear());

        // ─── LocalTime ────────────────────────────────────
        System.out.println("\n=== LocalTime ===");
        LocalTime now       = LocalTime.now();
        LocalTime alarm     = LocalTime.of(7, 30);
        LocalTime meeting   = LocalTime.of(14, 45, 30);
        LocalTime midnight  = LocalTime.MIDNIGHT;
        LocalTime noon      = LocalTime.NOON;

        System.out.printf("  Now:      %s%n", now);
        System.out.printf("  Alarm:    %s%n", alarm);
        System.out.printf("  Meeting:  %s%n", meeting);

        Duration untilMeeting = Duration.between(now, meeting);
        if (untilMeeting.isNegative()) untilMeeting = untilMeeting.plusHours(24);
        System.out.printf("  Until meeting: %dh %dm%n",
            untilMeeting.toHours(), untilMeeting.toMinutesPart());

        System.out.printf("  Midnight: %s | Noon: %s%n", midnight, noon);

        // ─── LocalDateTime ────────────────────────────────
        System.out.println("\n=== LocalDateTime ===");
        LocalDateTime nowDT    = LocalDateTime.now();
        LocalDateTime event    = LocalDateTime.of(today, meeting);
        LocalDateTime deadline = LocalDateTime.parse("2025-12-31T23:59:59");

        System.out.printf("  Now:      %s%n", nowDT);
        System.out.printf("  Event:    %s%n", event);
        System.out.printf("  Deadline: %s%n", deadline);

        Duration toDeadline = Duration.between(nowDT, deadline);
        System.out.printf("  Days to deadline: %d%n", toDeadline.toDays());

        // ─── ZonedDateTime ────────────────────────────────
        System.out.println("\n=== ZonedDateTime & Time Zones ===");
        ZonedDateTime nyc    = ZonedDateTime.now(ZoneId.of("America/New_York"));
        ZonedDateTime london = ZonedDateTime.now(ZoneId.of("Europe/London"));
        ZonedDateTime tokyo  = ZonedDateTime.now(ZoneId.of("Asia/Tokyo"));

        DateTimeFormatter zoneFmt = DateTimeFormatter.ofPattern("HH:mm zzz");
        System.out.printf("  New York: %s%n", nyc.format(zoneFmt));
        System.out.printf("  London:   %s%n", london.format(zoneFmt));
        System.out.printf("  Tokyo:    %s%n", tokyo.format(zoneFmt));

        // Convert between zones
        ZonedDateTime nycConvertedToTokyo = nyc.withZoneSameInstant(ZoneId.of("Asia/Tokyo"));
        System.out.printf("  NYC time in Tokyo: %s%n", nycConvertedToTokyo.format(zoneFmt));

        // Instant
        Instant instant = Instant.now();
        System.out.printf("  Epoch seconds: %d%n", instant.getEpochSecond());
        System.out.printf("  Instant: %s%n", instant);

        // ─── FORMATTING AND PARSING ───────────────────────
        System.out.println("\n=== Formatting & Parsing ===");
        LocalDate date = LocalDate.of(2024, 6, 15);

        // Custom patterns
        String[] patterns = {
            "dd/MM/yyyy",
            "MMMM d, yyyy",
            "E, MMM d",
            "yyyy-MM-dd",
            "d MMM yyyy",
            "MM-dd-yy"
        };

        for (String pattern : patterns) {
            DateTimeFormatter fmt = DateTimeFormatter.ofPattern(pattern);
            System.out.printf("  %-20s → %s%n", pattern, date.format(fmt));
        }

        // Parsing
        String[] datesToParse = {"15/06/2024", "June 15, 2024", "2024-06-15"};
        String[] parserPatterns = {"dd/MM/yyyy", "MMMM d, yyyy", "yyyy-MM-dd"};
        System.out.println("\n  Parsing dates:");
        for (int i = 0; i < datesToParse.length; i++) {
            LocalDate parsed = LocalDate.parse(datesToParse[i],
                DateTimeFormatter.ofPattern(parserPatterns[i]));
            System.out.printf("    '%s' → %s%n", datesToParse[i], parsed);
        }

        // ─── PRACTICAL: BUSINESS DAYS ─────────────────────
        System.out.println("\n=== Practical: Next 5 Business Days ===");
        LocalDate cursor = today;
        int count = 0;
        while (count < 5) {
            cursor = cursor.plusDays(1);
            if (cursor.getDayOfWeek() != DayOfWeek.SATURDAY &&
                cursor.getDayOfWeek() != DayOfWeek.SUNDAY) {
                System.out.printf("  %d. %s (%s)%n",
                    ++count, cursor, cursor.getDayOfWeek());
            }
        }

        // ─── DURATION AND PERIOD ──────────────────────────
        System.out.println("\n=== Duration vs Period ===");
        LocalDate projectStart = today;
        LocalDate projectEnd   = today.plusMonths(6).plusDays(15);

        Period projectPeriod = Period.between(projectStart, projectEnd);
        System.out.printf("  Project duration (Period): %d months, %d days%n",
            projectPeriod.getMonths(), projectPeriod.getDays());

        LocalDateTime startDT = LocalDateTime.of(today, LocalTime.of(9, 0));
        LocalDateTime endDT   = LocalDateTime.of(today, LocalTime.of(17, 30));
        Duration workDay = Duration.between(startDT, endDT);
        System.out.printf("  Work day (Duration): %dh %dm%n",
            workDay.toHours(), workDay.toMinutesPart());
    }
}

📝 KEY POINTS:
✅ All java.time classes are IMMUTABLE — all operations return new instances
✅ LocalDate for date only; LocalTime for time only; LocalDateTime for both
✅ Use ZonedDateTime or Instant when time zones matter
✅ Instant is for machine-readable timestamps (databases, APIs)
✅ Period measures calendar-based time (years/months/days)
✅ Duration measures time-based intervals (hours/minutes/seconds)
✅ DateTimeFormatter is thread-safe and reusable (unlike SimpleDateFormat)
✅ ChronoUnit.DAYS.between() computes exact days between two dates
✅ plusDays/minusMonths/withYear are the arithmetic methods on date/time types
❌ Never use java.util.Date or java.util.Calendar in new code — use java.time
❌ SimpleDateFormat is NOT thread-safe — DateTimeFormatter is
❌ Month values are 1-12 in java.time (unlike java.util.Calendar's 0-11)
❌ Don't ignore time zones for distributed systems — always use ZonedDateTime
""",
  quiz: [
    Quiz(question: 'What is the key design difference between java.time classes and java.util.Date?', options: [
      QuizOption(text: 'java.time classes are immutable — all operations return new instances; java.util.Date is mutable', correct: true),
      QuizOption(text: 'java.time is faster; java.util.Date is more accurate', correct: false),
      QuizOption(text: 'java.time only works with UTC; java.util.Date supports all time zones', correct: false),
      QuizOption(text: 'java.util.Date supports arithmetic; java.time does not', correct: false),
    ]),
    Quiz(question: 'What is the difference between Duration and Period?', options: [
      QuizOption(text: 'Duration measures time in hours/minutes/seconds; Period measures in calendar years/months/days', correct: true),
      QuizOption(text: 'Duration is for dates; Period is for times', correct: false),
      QuizOption(text: 'Period is exact; Duration is approximate', correct: false),
      QuizOption(text: 'They are identical — just different naming conventions', correct: false),
    ]),
    Quiz(question: 'What should you use for storing timestamps in a database?', options: [
      QuizOption(text: 'Instant — it represents a point in machine time independent of time zone', correct: true),
      QuizOption(text: 'LocalDateTime — it stores both date and time without ambiguity', correct: false),
      QuizOption(text: 'LocalDate — dates are always unambiguous', correct: false),
      QuizOption(text: 'ZoneId — it contains all timezone information needed', correct: false),
    ]),
  ],
);
