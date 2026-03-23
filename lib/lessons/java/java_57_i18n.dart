import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson57 = Lesson(
  language: 'Java',
  title: 'Internationalization (i18n)',
  content: """
🎯 METAPHOR:
Internationalization is like designing a restaurant menu
that works in 50 countries. The food is the same — the
information is identical — but the language, the currency
format, the date format, and the number format change
per locale. In Germany, the number 1.234,56 means
one thousand two hundred thirty four point fifty six.
In the US, 1,234.56 means the same thing. The restaurant
(your app) needs to present the same data differently
based on where the diner sits. Java's i18n stack handles
this automatically once you tell it the locale.

📖 EXPLANATION:
i18n stands for Internationalization (18 letters between
the i and n). l10n stands for Localization.

─────────────────────────────────────
LOCALE — the foundation:
─────────────────────────────────────
  A Locale represents a language + region combination.

  Locale.getDefault()              → system locale
  Locale.US                        → en_US
  Locale.UK                        → en_GB
  Locale.GERMANY                   → de_DE
  Locale.JAPAN                     → ja_JP
  Locale.FRANCE                    → fr_FR
  Locale.CHINA                     → zh_CN

  new Locale("fr")                 → French (any region)
  new Locale("fr", "CA")           → French Canada
  Locale.of("fr", "CA")            → Java 19+ (preferred)

  // List all available locales:
  Locale.getAvailableLocales()

─────────────────────────────────────
NumberFormat — numbers and currency:
─────────────────────────────────────
  NumberFormat nf = NumberFormat.getInstance(locale);
  NumberFormat cf = NumberFormat.getCurrencyInstance(locale);
  NumberFormat pf = NumberFormat.getPercentInstance(locale);

  nf.format(1234567.89)  → "1,234,567.89" (US)
                            "1.234.567,89" (Germany)
  cf.format(99.99)       → "$99.99"  (US)
                            "99,99 €" (Germany)
  pf.format(0.857)       → "85.7%"  (US)

  // Parse:
  Number n = nf.parse("1.234.567,89");  // Germany format → 1234567.89

─────────────────────────────────────
DateTimeFormatter — locale-aware dates:
─────────────────────────────────────
  DateTimeFormatter dtf = DateTimeFormatter
      .ofLocalizedDate(FormatStyle.LONG)
      .withLocale(Locale.FRANCE);

  LocalDate.now().format(dtf)  → "15 janvier 2024" (French)

  FormatStyle:
  FULL    → Tuesday, January 15, 2024
  LONG    → January 15, 2024
  MEDIUM  → Jan 15, 2024
  SHORT   → 1/15/24

─────────────────────────────────────
ResourceBundle — translatable strings:
─────────────────────────────────────
  Properties files per locale:
  messages.properties          → default (English)
  messages_fr.properties       → French
  messages_de.properties       → German
  messages_ja.properties       → Japanese

  In messages.properties:
    greeting = Hello, {0}!
    farewell = Goodbye!
    items.count = You have {0} items.

  In messages_fr.properties:
    greeting = Bonjour, {0}!
    farewell = Au revoir!
    items.count = Vous avez {0} articles.

  // Usage:
  ResourceBundle bundle = ResourceBundle.getBundle("messages", Locale.FRANCE);
  String greeting = bundle.getString("greeting");
  // With MessageFormat for substitution:
  String msg = MessageFormat.format(greeting, "Terry");

─────────────────────────────────────
MessageFormat — parameterized messages:
─────────────────────────────────────
  String pattern = "At {0,time}, on {1,date}, {2} visited {3}.";
  MessageFormat.format(pattern,
      new Date(), new Date(), "Alice", "Paris");
  // → "At 2:30 PM, on January 15, 2024, Alice visited Paris."

  Choice format (pluralization):
  String pattern = "{0} {0,choice,0#files|1#file|1<files}";
  MessageFormat.format(pattern, 0)  → "0 files"
  MessageFormat.format(pattern, 1)  → "1 file"
  MessageFormat.format(pattern, 5)  → "5 files"

─────────────────────────────────────
Collator — locale-aware string sorting:
─────────────────────────────────────
  Collator collator = Collator.getInstance(Locale.GERMANY);
  collator.compare("ä", "b");   // ä comes before b in German

  // Sorting a list with locale-aware order:
  list.sort(collator);

─────────────────────────────────────
String.format() — locale matters:
─────────────────────────────────────
  // US locale: 1,234.56
  String.format(Locale.US, "%,.2f", 1234.56)

  // Germany: 1.234,56
  String.format(Locale.GERMANY, "%,.2f", 1234.56)

  Always specify locale in format when output may be seen
  by users from different regions.

💻 CODE:
import java.text.*;
import java.time.*;
import java.time.format.*;
import java.util.*;
import java.util.stream.*;

public class Internationalization {
    public static void main(String[] args) {

        // ─── LOCALE BASICS ───────────────────────────────
        System.out.println("=== Locale Information ===");
        Locale[] locales = {
            Locale.US, Locale.UK, Locale.GERMANY,
            Locale.FRANCE, Locale.JAPAN, Locale.CHINA
        };
        for (Locale loc : locales) {
            System.out.printf("  %-8s %-20s %-15s%n",
                loc.toString(),
                loc.getDisplayName(Locale.ENGLISH),
                loc.getDisplayLanguage(loc));
        }

        // ─── NUMBER FORMATTING ────────────────────────────
        System.out.println("\n=== Number Formatting ===");
        double number = 1_234_567.89;
        for (Locale loc : locales) {
            String formatted = NumberFormat.getInstance(loc).format(number);
            System.out.printf("  %-10s → %s%n", loc, formatted);
        }

        // ─── CURRENCY FORMATTING ──────────────────────────
        System.out.println("\n=== Currency Formatting ===");
        double amount = 9999.99;
        for (Locale loc : locales) {
            String formatted = NumberFormat.getCurrencyInstance(loc).format(amount);
            System.out.printf("  %-10s → %s%n", loc, formatted);
        }

        // ─── PERCENT FORMATTING ───────────────────────────
        System.out.println("\n=== Percent Formatting ===");
        double percent = 0.8567;
        for (Locale loc : new Locale[]{Locale.US, Locale.GERMANY, Locale.FRANCE}) {
            System.out.printf("  %-10s → %s%n", loc,
                NumberFormat.getPercentInstance(loc).format(percent));
        }

        // ─── DATE FORMATTING ──────────────────────────────
        System.out.println("\n=== Date Formatting ===");
        LocalDate date = LocalDate.of(2024, 6, 15);
        for (FormatStyle style : FormatStyle.values()) {
            DateTimeFormatter fmt = DateTimeFormatter
                .ofLocalizedDate(style).withLocale(Locale.US);
            System.out.printf("  %-8s → %s%n", style, date.format(fmt));
        }

        System.out.println("\n  Same date in different locales (LONG style):");
        for (Locale loc : locales) {
            DateTimeFormatter fmt = DateTimeFormatter
                .ofLocalizedDate(FormatStyle.LONG).withLocale(loc);
            System.out.printf("  %-10s → %s%n", loc, date.format(fmt));
        }

        // ─── MESSAGE FORMAT ───────────────────────────────
        System.out.println("\n=== MessageFormat ===");
        String template = "Hello, {0}! You have {1} new messages.";
        System.out.println("  " + MessageFormat.format(template, "Alice", 5));
        System.out.println("  " + MessageFormat.format(template, "Bob",   1));

        // With date and time
        String dateTemplate = "On {0,date,long} at {0,time,short}, {1} logged in.";
        System.out.println("  " + MessageFormat.format(dateTemplate, new Date(), "Terry"));

        // Choice format (pluralization)
        String choiceTemplate = "You have {0} {0,choice,0#items|1#item|1<items} in your cart.";
        for (int count : new int[]{0, 1, 2, 10}) {
            System.out.println("  " + MessageFormat.format(choiceTemplate, count));
        }

        // ─── RESOURCE BUNDLE (simulated) ─────────────────
        System.out.println("\n=== ResourceBundle (simulated) ===");
        // In real apps: put in src/main/resources/messages.properties
        // Here we show the usage pattern:
        System.out.println("  Usage pattern:");
        System.out.println("    ResourceBundle bundle = ResourceBundle.getBundle(");
        System.out.println("        \"messages\", Locale.FRANCE);");
        System.out.println("    String greeting = bundle.getString(\"greeting\");");
        System.out.println("    // → reads from messages_fr.properties");

        // Simulate with a manual map
        Map<String, Map<String, String>> bundles = Map.of(
            "en", Map.of("greeting", "Hello!", "farewell", "Goodbye!"),
            "fr", Map.of("greeting", "Bonjour!", "farewell", "Au revoir!"),
            "de", Map.of("greeting", "Hallo!", "farewell", "Auf Wiedersehen!"),
            "ja", Map.of("greeting", "こんにちは！", "farewell", "さようなら！")
        );

        System.out.println("\n  Simulated translations:");
        for (var entry : new TreeMap<>(bundles).entrySet()) {
            System.out.printf("  %-4s: greeting='%s'  farewell='%s'%n",
                entry.getKey(),
                entry.getValue().get("greeting"),
                entry.getValue().get("farewell"));
        }

        // ─── COLLATOR — LOCALE-AWARE SORTING ─────────────
        System.out.println("\n=== Locale-aware Sorting ===");
        List<String> names = Arrays.asList("Ångström", "Zebra", "äpfel", "Apple", "über", "zoo");

        // Default sort (uses Unicode code points)
        names.sort(Comparator.naturalOrder());
        System.out.println("  Unicode order: " + names);

        // German locale sort (ä sorts after a, etc.)
        Collator germanCollator = Collator.getInstance(Locale.GERMANY);
        names.sort(germanCollator);
        System.out.println("  German order:  " + names);

        // English locale sort
        Collator englishCollator = Collator.getInstance(Locale.US);
        names.sort(englishCollator);
        System.out.println("  English order: " + names);

        // ─── LOCALE-SPECIFIC STRING FORMAT ───────────────
        System.out.println("\n=== Locale-specific String.format() ===");
        double price = 1234.56;
        System.out.printf("  US:      %s%n", String.format(Locale.US,      "%,.2f", price));
        System.out.printf("  Germany: %s%n", String.format(Locale.GERMANY, "%,.2f", price));
        System.out.printf("  France:  %s%n", String.format(Locale.FRANCE,  "%,.2f", price));
    }
}

📝 KEY POINTS:
✅ Locale represents a language+region: Locale.US, Locale.GERMANY, Locale.JAPAN
✅ NumberFormat.getCurrencyInstance(locale) formats currency correctly per locale
✅ DateTimeFormatter.ofLocalizedDate(style).withLocale(locale) formats dates per locale
✅ MessageFormat.format() substitutes {0}, {1}, {0,date}, {0,choice,...} parameters
✅ ResourceBundle loads locale-specific .properties files automatically
✅ Collator sorts Strings correctly per locale (e.g. ä in German sorts after a)
✅ Always pass Locale to String.format() when output is user-facing
✅ {0,choice,0#items|1#item|1<items} in MessageFormat handles pluralization
❌ Don't use System.out.printf() with locale-sensitive numbers without specifying locale
❌ Don't hardcode date/number formats as strings — use the format APIs
❌ new Locale("fr") is deprecated in Java 19+ — use Locale.of("fr") instead
❌ ResourceBundle caches bundles — call ResourceBundle.clearCache() if files changed
""",
  quiz: [
    Quiz(question: 'What does NumberFormat.getCurrencyInstance(Locale.GERMANY).format(9.99) produce?', options: [
      QuizOption(text: 'A German-formatted currency string like "9,99 €" with the Euro symbol and comma as decimal separator', correct: true),
      QuizOption(text: '$9.99 — currency format always uses the dollar sign', correct: false),
      QuizOption(text: 'EUR 9.99 — the ISO currency code followed by the amount', correct: false),
      QuizOption(text: '9.99 — getCurrencyInstance() only formats the number, not the symbol', correct: false),
    ]),
    Quiz(question: 'What is a ResourceBundle used for in Java?', options: [
      QuizOption(text: 'Loading locale-specific text strings from .properties files for multi-language support', correct: true),
      QuizOption(text: 'Bundling application resources (images, sounds) into a single archive', correct: false),
      QuizOption(text: 'Providing thread-local storage for locale settings', correct: false),
      QuizOption(text: 'Managing database connection pools across different regions', correct: false),
    ]),
    Quiz(question: 'What does the Collator class provide that String.compareTo() does not?', options: [
      QuizOption(text: 'Locale-aware string comparison — correctly handles special characters and alphabetical order per language', correct: true),
      QuizOption(text: 'A faster comparison algorithm using hardware acceleration', correct: false),
      QuizOption(text: 'Case-insensitive comparison built-in without extra configuration', correct: false),
      QuizOption(text: 'The ability to compare strings of different character encodings', correct: false),
    ]),
  ],
);
