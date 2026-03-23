import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson42 = Lesson(
  language: 'Java',
  title: 'BigDecimal, BigInteger, and Math',
  content: """
🎯 METAPHOR:
double arithmetic is like measuring with a rubber ruler —
close enough for most things, but it stretches and
compresses unpredictably at the microscopic level.
"0.1 + 0.2 = 0.30000000000000004" is the rubber ruler
lying to you. For everyday calculations, this doesn't
matter. But for MONEY — where 0.00000000000000004 of
a cent eventually becomes a real dollar through rounding —
this matters enormously. BigDecimal is the precision laser
micrometer: exact, unwavering, but heavier and slower
to operate. Use double when you need speed and rough
answers. Use BigDecimal when every decimal place counts.

📖 EXPLANATION:

─────────────────────────────────────
WHY double FAILS FOR MONEY:
─────────────────────────────────────
  System.out.println(0.1 + 0.2);
  // Output: 0.30000000000000004  ← NOT 0.3!

  Binary floating-point cannot exactly represent 0.1 or 0.2.
  The error accumulates with each operation.

  In finance, banking, accounting, and taxes:
  → Always use BigDecimal, never double/float.

─────────────────────────────────────
BigDecimal — exact decimal arithmetic:
─────────────────────────────────────
  // Creating BigDecimal:
  BigDecimal a = new BigDecimal("0.1");      // ✅ from String
  BigDecimal b = new BigDecimal("0.2");      // ✅ from String
  BigDecimal c = BigDecimal.valueOf(0.1);    // ✅ from double (goes through String)
  BigDecimal d = new BigDecimal(0.1);        // ❌ imprecise! stores double's value

  a.add(b)           → 0.3 (exact!)
  a.subtract(b)      → -0.1
  a.multiply(b)      → 0.02
  a.divide(b, 2, RoundingMode.HALF_UP)  → 0.50

  // Scale = number of decimal places
  new BigDecimal("10.00").scale()   → 2
  new BigDecimal("10").scale()      → 0

  // Rounding modes:
  HALF_UP    → round towards nearest neighbor; ties go up (5 rounds up)
  HALF_DOWN  → ties go down
  HALF_EVEN  → banker's rounding (ties go to even digit)
  FLOOR      → round towards negative infinity
  CEILING    → round towards positive infinity
  UP         → away from zero
  DOWN       → towards zero (truncate)

  ALWAYS specify RoundingMode in divide() — else ArithmeticException!

─────────────────────────────────────
BigDecimal COMPARISON:
─────────────────────────────────────
  // ❌ equals() considers scale: 1.0 ≠ 1.00
  new BigDecimal("1.0").equals(new BigDecimal("1.00"));  // false!

  // ✅ Use compareTo() for value equality:
  new BigDecimal("1.0").compareTo(new BigDecimal("1.00")); // 0 (equal)

─────────────────────────────────────
BigInteger — arbitrary precision integers:
─────────────────────────────────────
  // For values beyond Long.MAX_VALUE (9.2 × 10^18):
  BigInteger huge = new BigInteger("12345678901234567890123456789");
  BigInteger a = BigInteger.valueOf(Long.MAX_VALUE);
  BigInteger b = a.multiply(a);   // would overflow long!

  // Operations:
  a.add(b), a.subtract(b), a.multiply(b)
  a.divide(b), a.remainder(b), a.pow(n)
  a.gcd(b)                // greatest common divisor
  a.isProbablePrime(100)  // primality test
  a.bitCount()            // number of set bits
  BigInteger.TWO, BigInteger.TEN, BigInteger.ZERO, BigInteger.ONE

─────────────────────────────────────
java.lang.Math — utility methods:
─────────────────────────────────────
  Math.abs(x)            → absolute value
  Math.max(a, b)         → maximum
  Math.min(a, b)         → minimum
  Math.pow(base, exp)    → base^exp
  Math.sqrt(x)           → square root
  Math.cbrt(x)           → cube root
  Math.floor(x)          → round down
  Math.ceil(x)           → round up
  Math.round(x)          → round to nearest int
  Math.log(x)            → natural log (ln)
  Math.log10(x)          → log base 10
  Math.sin/cos/tan(x)    → trig (radians)
  Math.random()          → [0.0, 1.0)
  Math.PI                → π
  Math.E                 → e (Euler's number)

  // Safe arithmetic (throws on overflow):
  Math.addExact(a, b)
  Math.multiplyExact(a, b)
  Math.subtractExact(a, b)

💻 CODE:
import java.math.*;
import java.util.*;
import java.util.stream.*;

public class BigNumbers {
    public static void main(String[] args) {

        // ─── FLOATING POINT PROBLEM ───────────────────────
        System.out.println("=== Floating Point Precision Problem ===");
        double d1 = 0.1 + 0.2;
        System.out.println("  double:     0.1 + 0.2 = " + d1);
        System.out.println("  double:     0.1 + 0.2 == 0.3? " + (d1 == 0.3));

        BigDecimal bd1 = new BigDecimal("0.1");
        BigDecimal bd2 = new BigDecimal("0.2");
        BigDecimal bd3 = bd1.add(bd2);
        System.out.println("  BigDecimal: 0.1 + 0.2 = " + bd3);
        System.out.println("  BigDecimal: equals 0.3? " + (bd3.compareTo(new BigDecimal("0.3")) == 0));

        // Classic currency accumulation error
        System.out.println("\n=== Currency Accumulation ===");
        double doubleSum = 0.0;
        BigDecimal bdSum = BigDecimal.ZERO;
        for (int i = 0; i < 100; i++) {
            doubleSum += 0.1;
            bdSum = bdSum.add(new BigDecimal("0.1"));
        }
        System.out.printf("  double:     0.1 × 100 = %.20f%n", doubleSum);
        System.out.println("  BigDecimal: 0.1 × 100 = " + bdSum);
        System.out.println("  Error in double: " + (doubleSum - 10.0) + " (should be 0!)");

        // ─── BIGDECIMAL OPERATIONS ────────────────────────
        System.out.println("\n=== BigDecimal Operations ===");
        BigDecimal price    = new BigDecimal("29.99");
        BigDecimal quantity = new BigDecimal("5");
        BigDecimal discount = new BigDecimal("0.15");
        BigDecimal taxRate  = new BigDecimal("0.08");

        BigDecimal subtotal    = price.multiply(quantity);
        BigDecimal discounted  = subtotal.multiply(BigDecimal.ONE.subtract(discount));
        BigDecimal tax         = discounted.multiply(taxRate);
        BigDecimal total       = discounted.add(tax);
        BigDecimal rounded     = total.setScale(2, RoundingMode.HALF_UP);

        System.out.println("  Price per item:   \$" + price);
        System.out.println("  Quantity:          " + quantity);
        System.out.println("  Subtotal:         \$" + subtotal);
        System.out.println("  After 15% discount:\$" + discounted);
        System.out.println("  Tax (8%):         \$" + tax);
        System.out.println("  Total:            \$" + total);
        System.out.println("  Rounded to cents: \$" + rounded);

        // Division with rounding
        System.out.println("\n=== BigDecimal Division ===");
        BigDecimal[] numerators   = { new BigDecimal("10"), new BigDecimal("1"), new BigDecimal("2") };
        BigDecimal[] denominators = { new BigDecimal("3"),  new BigDecimal("7"), new BigDecimal("3") };

        for (int i = 0; i < numerators.length; i++) {
            BigDecimal result = numerators[i].divide(denominators[i], 10, RoundingMode.HALF_UP);
            System.out.printf("  %s / %s = %s (10dp, HALF_UP)%n",
                numerators[i], denominators[i], result);
        }

        // Rounding modes
        System.out.println("\n=== Rounding Modes ===");
        BigDecimal[] values = {
            new BigDecimal("2.55"), new BigDecimal("2.545"),
            new BigDecimal("-2.55"), new BigDecimal("2.500")
        };
        RoundingMode[] modes = {
            RoundingMode.HALF_UP, RoundingMode.HALF_DOWN,
            RoundingMode.HALF_EVEN, RoundingMode.FLOOR, RoundingMode.CEILING
        };

        System.out.printf("  %-12s", "Value");
        for (RoundingMode mode : modes) System.out.printf(" %-12s", mode);
        System.out.println();

        for (BigDecimal val : values) {
            System.out.printf("  %-12s", val);
            for (RoundingMode mode : modes) {
                System.out.printf(" %-12s", val.setScale(1, mode));
            }
            System.out.println();
        }

        // ─── BIGINTEGER ───────────────────────────────────
        System.out.println("\n=== BigInteger ===");

        // Factorial of large numbers
        BigInteger factorial = BigInteger.ONE;
        for (int i = 2; i <= 50; i++) {
            factorial = factorial.multiply(BigInteger.valueOf(i));
        }
        System.out.println("  50! = " + factorial);
        System.out.println("  50! digits: " + factorial.toString().length());

        // Fibonacci
        BigInteger[] fib = new BigInteger[100];
        fib[0] = BigInteger.ZERO;
        fib[1] = BigInteger.ONE;
        for (int i = 2; i < 100; i++) {
            fib[i] = fib[i-1].add(fib[i-2]);
        }
        System.out.println("  fib(99) = " + fib[99]);

        // Powers
        BigInteger power = BigInteger.TWO.pow(100);
        System.out.println("  2^100 = " + power);

        // GCD
        BigInteger a = new BigInteger("123456789");
        BigInteger b = new BigInteger("987654321");
        System.out.println("  GCD(" + a + ", " + b + ") = " + a.gcd(b));

        // Primality test
        BigInteger prime = new BigInteger("999999937");
        System.out.println("  " + prime + " is probable prime: " +
            prime.isProbablePrime(100));

        // ─── Math CLASS ───────────────────────────────────
        System.out.println("\n=== java.lang.Math ===");
        System.out.printf("  PI:         %.10f%n", Math.PI);
        System.out.printf("  E:          %.10f%n", Math.E);
        System.out.printf("  sqrt(2):    %.10f%n", Math.sqrt(2));
        System.out.printf("  cbrt(27):   %.4f%n",  Math.cbrt(27));
        System.out.printf("  pow(2,10):  %.0f%n",  Math.pow(2, 10));
        System.out.printf("  log(E):     %.4f%n",  Math.log(Math.E));
        System.out.printf("  log10(100): %.4f%n",  Math.log10(100));
        System.out.printf("  sin(PI/6):  %.4f (=0.5)%n", Math.sin(Math.PI / 6));
        System.out.printf("  cos(PI/3):  %.4f (=0.5)%n", Math.cos(Math.PI / 3));
        System.out.printf("  abs(-42):   %d%n",    Math.abs(-42));
        System.out.printf("  max(3,7):   %d%n",    Math.max(3, 7));

        // Safe arithmetic — throws on overflow
        System.out.println("\n=== Safe Arithmetic ===");
        try {
            int result = Math.addExact(Integer.MAX_VALUE, 1);
        } catch (ArithmeticException e) {
            System.out.println("  addExact overflow: " + e.getMessage());
        }

        long safeResult = Math.multiplyExact(1_000_000L, 1_000_000L);
        System.out.println("  multiplyExact(1M, 1M) = " + safeResult + " ✅");

        // Statistics
        System.out.println("\n=== Statistical calculations ===");
        double[] data = {12.5, 15.3, 9.8, 22.1, 18.7, 11.2, 14.9, 20.4};
        double mean = Arrays.stream(data).average().orElse(0);
        double variance = Arrays.stream(data)
            .map(x -> Math.pow(x - mean, 2))
            .average().orElse(0);
        double stdDev = Math.sqrt(variance);
        double max = Arrays.stream(data).max().orElse(0);
        double min = Arrays.stream(data).min().orElse(0);

        System.out.printf("  Data: %s%n", Arrays.toString(data));
        System.out.printf("  Mean:    %.2f%n", mean);
        System.out.printf("  StdDev:  %.2f%n", stdDev);
        System.out.printf("  Min/Max: %.2f / %.2f%n", min, max);
        System.out.printf("  Range:   %.2f%n", max - min);
    }
}

📝 KEY POINTS:
✅ Use BigDecimal for any monetary or financial calculation — never double
✅ Create BigDecimal from String: new BigDecimal("0.1") — not from double
✅ Use compareTo() for BigDecimal equality — not equals() (scale matters)
✅ Always specify RoundingMode in divide() — otherwise ArithmeticException for repeating decimals
✅ HALF_EVEN (banker's rounding) is the preferred financial rounding mode
✅ BigInteger handles numbers beyond Long.MAX_VALUE (9.2 × 10^18)
✅ Math.addExact/multiplyExact throw on overflow — safer than silent wrapping
✅ Math.random() returns [0.0, 1.0) — prefer java.util.Random for seeded random
❌ Never use new BigDecimal(0.1) — passes the imprecise double value, not "0.1"
❌ BigDecimal is IMMUTABLE — add/multiply etc. return new instances
❌ Don't use == or equals() for BigDecimal value comparison — use compareTo()
❌ BigDecimal and BigInteger are significantly slower than primitives — only when needed
""",
  quiz: [
    Quiz(question: 'Why does new BigDecimal(0.1) produce an imprecise result?', options: [
      QuizOption(text: 'It captures the double\'s binary representation of 0.1, which is not exactly 0.1 — use new BigDecimal("0.1") instead', correct: true),
      QuizOption(text: 'BigDecimal requires integer inputs — decimals must be passed as strings', correct: false),
      QuizOption(text: 'The double overload of the constructor is deprecated and always returns 0', correct: false),
      QuizOption(text: 'Java rounds the double to 2 decimal places before creating BigDecimal', correct: false),
    ]),
    Quiz(question: 'Why use compareTo() instead of equals() when comparing two BigDecimal values?', options: [
      QuizOption(text: 'equals() considers scale — 1.0 and 1.00 are not equal; compareTo() treats them as equal (returns 0)', correct: true),
      QuizOption(text: 'equals() throws an exception for BigDecimal; compareTo() is the safe alternative', correct: false),
      QuizOption(text: 'compareTo() is significantly faster than equals() for large decimal values', correct: false),
      QuizOption(text: 'equals() only works for BigInteger, not BigDecimal', correct: false),
    ]),
    Quiz(question: 'What does RoundingMode.HALF_EVEN do?', options: [
      QuizOption(text: 'Rounds ties (0.5) toward the nearest even digit — also known as banker\'s rounding', correct: true),
      QuizOption(text: 'Rounds all numbers to the nearest even integer regardless of decimal', correct: false),
      QuizOption(text: 'Alternates between rounding up and down for successive tie-breaking operations', correct: false),
      QuizOption(text: 'Rounds toward zero when the digit is even, away from zero when odd', correct: false),
    ]),
  ],
);
