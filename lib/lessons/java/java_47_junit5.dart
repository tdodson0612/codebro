import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson47 = Lesson(
  language: 'Java',
  title: 'Testing with JUnit 5',
  content: """
🎯 METAPHOR:
Unit tests are like the safety net under a high-wire
performer. The performer (your code) SHOULD be skilled
enough to walk the wire without falling — and usually is.
But the net is there to catch unexpected falls: edge cases,
bugs introduced during refactoring, interactions you didn't
anticipate. A good test suite is a net with no holes — each
test covers a specific area. When you refactor code and all
tests still pass, you know your net caught every potential
fall. When tests break, the net saved you from shipping
a bug to production. Tests don't slow you down — they speed
you up by making refactoring fearless.

📖 EXPLANATION:
JUnit 5 (Jupiter) is the standard testing framework for Java.
Maven/Gradle pull it in as a test dependency.

─────────────────────────────────────
MAVEN DEPENDENCY:
─────────────────────────────────────
  <dependency>
      <groupId>org.junit.jupiter</groupId>
      <artifactId>junit-jupiter</artifactId>
      <version>5.10.0</version>
      <scope>test</scope>
  </dependency>

─────────────────────────────────────
JUNIT 5 ANNOTATIONS:
─────────────────────────────────────
  @Test              → marks a test method
  @BeforeEach        → runs before every test method
  @AfterEach         → runs after every test method
  @BeforeAll         → runs once before all tests (static)
  @AfterAll          → runs once after all tests (static)
  @Disabled          → skip this test
  @DisplayName       → human-readable test name
  @Nested            → nested test class
  @Tag               → categorize tests ("slow", "integration")
  @RepeatedTest(5)   → run 5 times
  @Timeout(5)        → fail if takes more than 5 seconds
  @TempDir           → provides a temp directory

─────────────────────────────────────
CORE ASSERTIONS (org.junit.jupiter.api.Assertions):
─────────────────────────────────────
  assertEquals(expected, actual)
  assertEquals(expected, actual, "message")
  assertNotEquals(unexpected, actual)
  assertTrue(condition)
  assertFalse(condition)
  assertNull(value)
  assertNotNull(value)
  assertThrows(ExType.class, () -> { code })
  assertDoesNotThrow(() -> { code })
  assertAll(
      () -> assertEquals(a, b),
      () -> assertTrue(c)
  )                → run all assertions, collect failures
  assertArrayEquals(expected, actual)
  assertIterableEquals(expected, actual)
  assertTimeout(Duration.ofSeconds(1), () -> code)

─────────────────────────────────────
PARAMETERIZED TESTS:
─────────────────────────────────────
  @ParameterizedTest
  @ValueSource(ints = {1, 2, 3, 4, 5})
  void testWithInts(int n) { ... }

  @ParameterizedTest
  @CsvSource({"apple, 5", "banana, 6", "cherry, 6"})
  void testWithCsv(String fruit, int expectedLength) {
      assertEquals(expectedLength, fruit.length());
  }

  @ParameterizedTest
  @MethodSource("provideData")
  void testWithMethod(int input, int expected) { ... }

  static Stream<Arguments> provideData() {
      return Stream.of(
          Arguments.of(1, 1),
          Arguments.of(2, 4),
          Arguments.of(3, 9)
      );
  }

─────────────────────────────────────
TEST NAMING CONVENTIONS:
─────────────────────────────────────
  methodName_scenario_expectedResult
  givenX_whenY_thenZ

  @Test
  void add_twoPositiveNumbers_returnsSum() { }

  @Test
  void divide_byZero_throwsArithmeticException() { }

  @Test
  @DisplayName("Empty input returns empty Optional")
  void emptyInput() { }

─────────────────────────────────────
WHAT MAKES A GOOD TEST:
─────────────────────────────────────
  ✅ Tests ONE behavior (not multiple things)
  ✅ Uses AAA pattern: Arrange → Act → Assert
  ✅ Is independent of other tests (no shared mutable state)
  ✅ Is fast (no real I/O, network, or database)
  ✅ Has a descriptive name
  ✅ Tests BEHAVIOR, not implementation

  ❌ Test that always passes (no assertions)
  ❌ Test that tests five things at once
  ❌ Test that depends on another test running first

💻 CODE:
import org.junit.jupiter.api.*;
import org.junit.jupiter.params.*;
import org.junit.jupiter.params.provider.*;
import java.util.*;
import java.util.stream.*;
import java.time.*;

import static org.junit.jupiter.api.Assertions.*;

// ─── CLASS UNDER TEST ─────────────────────────────────
class Calculator {
    public int add(int a, int b) { return a + b; }
    public int subtract(int a, int b) { return a - b; }
    public int multiply(int a, int b) { return a * b; }

    public double divide(double a, double b) {
        if (b == 0) throw new ArithmeticException("Division by zero");
        return a / b;
    }

    public long factorial(int n) {
        if (n < 0) throw new IllegalArgumentException("Negative input");
        if (n == 0 || n == 1) return 1;
        return n * factorial(n - 1);
    }

    public boolean isPrime(int n) {
        if (n < 2) return false;
        for (int i = 2; i <= Math.sqrt(n); i++) {
            if (n % i == 0) return false;
        }
        return true;
    }
}

class StringUtils {
    public String reverse(String s) {
        if (s == null) throw new NullPointerException("Input is null");
        return new StringBuilder(s).reverse().toString();
    }

    public boolean isPalindrome(String s) {
        if (s == null) return false;
        String cleaned = s.toLowerCase().replaceAll("[^a-z0-9]", "");
        return cleaned.equals(new StringBuilder(cleaned).reverse().toString());
    }

    public List<String> splitWords(String sentence) {
        if (sentence == null || sentence.isBlank()) return List.of();
        return Arrays.stream(sentence.trim().split("\\\\s+"))
            .collect(Collectors.toList());
    }
}

// ─── TEST CLASSES ─────────────────────────────────────

class CalculatorTest {
    // SHARED setup
    private Calculator calc;

    @BeforeEach  // runs before EACH test
    void setUp() {
        calc = new Calculator();
        System.out.println("  [Setup] New Calculator created");
    }

    @AfterEach   // runs after EACH test
    void tearDown() {
        System.out.println("  [Teardown] Cleaning up");
    }

    // ─── ADD ──────────────────────────────────────────
    @Test
    @DisplayName("Adding two positive numbers returns their sum")
    void add_twoPositives_returnsSum() {
        // Arrange
        int a = 5, b = 3;
        // Act
        int result = calc.add(a, b);
        // Assert
        assertEquals(8, result, "5 + 3 should equal 8");
    }

    @Test
    void add_negativeNumbers_returnsCorrectSum() {
        assertEquals(-7, calc.add(-3, -4));
        assertEquals(2, calc.add(-3, 5));
        assertEquals(0, calc.add(5, -5));
    }

    @Test
    void add_overflowValues_handledCorrectly() {
        // Test behavior at integer boundaries
        assertEquals(Integer.MIN_VALUE, calc.add(Integer.MAX_VALUE, 1));  // wraps!
    }

    // ─── DIVIDE ───────────────────────────────────────
    @Test
    void divide_normalCase_returnsResult() {
        assertEquals(2.5, calc.divide(5.0, 2.0), 0.001);  // delta for doubles
    }

    @Test
    void divide_byZero_throwsArithmeticException() {
        ArithmeticException ex = assertThrows(
            ArithmeticException.class,
            () -> calc.divide(10, 0),
            "Dividing by zero should throw ArithmeticException"
        );
        assertTrue(ex.getMessage().contains("zero"));
    }

    // ─── FACTORIAL ────────────────────────────────────
    @Test
    void factorial_zeroAndOne_returnsOne() {
        assertAll(
            () -> assertEquals(1, calc.factorial(0)),
            () -> assertEquals(1, calc.factorial(1))
        );
    }

    @Test
    void factorial_negativeInput_throwsIllegalArgument() {
        assertThrows(IllegalArgumentException.class, () -> calc.factorial(-1));
    }

    // ─── PARAMETERIZED TESTS ──────────────────────────
    @ParameterizedTest(name = "{0}! = {1}")
    @CsvSource({
        "0, 1",
        "1, 1",
        "2, 2",
        "3, 6",
        "4, 24",
        "5, 120",
        "10, 3628800"
    })
    void factorial_variousInputs(int n, long expected) {
        assertEquals(expected, calc.factorial(n));
    }

    @ParameterizedTest(name = "{0} is prime: {1}")
    @CsvSource({
        "2, true",
        "3, true",
        "4, false",
        "13, true",
        "15, false",
        "17, true",
        "1, false",
        "0, false"
    })
    void isPrime_variousNumbers(int n, boolean expected) {
        assertEquals(expected, calc.isPrime(n));
    }

    @ParameterizedTest
    @ValueSource(ints = {2, 3, 5, 7, 11, 13, 17, 19, 23})
    void knownPrimes_returnTrue(int prime) {
        assertTrue(calc.isPrime(prime), prime + " should be prime");
    }
}

class StringUtilsTest {
    private StringUtils utils;

    @BeforeEach
    void setUp() { utils = new StringUtils(); }

    // ─── REVERSE ──────────────────────────────────────
    @Test
    @DisplayName("Reversing a simple string")
    void reverse_simpleString_returnsReversed() {
        assertEquals("olleh", utils.reverse("hello"));
        assertEquals("avaJ", utils.reverse("Java"));
    }

    @Test
    void reverse_emptyString_returnsEmpty() {
        assertEquals("", utils.reverse(""));
    }

    @Test
    void reverse_singleChar_returnsSame() {
        assertEquals("a", utils.reverse("a"));
    }

    @Test
    void reverse_null_throwsNullPointer() {
        assertThrows(NullPointerException.class, () -> utils.reverse(null));
    }

    // ─── PALINDROME ───────────────────────────────────
    @ParameterizedTest(name = "''{0}'' is palindrome: {1}")
    @CsvSource({
        "racecar, true",
        "hello, false",
        "A man a plan a canal Panama, true",
        "'Was it a car or a cat I saw', true",
        "java, false",
        "level, true",
        "'', true"
    })
    void isPalindrome_variousCases(String input, boolean expected) {
        assertEquals(expected, utils.isPalindrome(input));
    }

    // ─── SPLIT WORDS ──────────────────────────────────
    @Test
    void splitWords_normalSentence_returnsWords() {
        var result = utils.splitWords("Hello World Java");
        assertIterableEquals(List.of("Hello", "World", "Java"), result);
    }

    @Test
    void splitWords_multipleSpaces_handledCorrectly() {
        var result = utils.splitWords("one  two   three");
        assertEquals(3, result.size());
    }

    @Test
    void splitWords_emptyAndBlank_returnsEmpty() {
        assertAll(
            () -> assertEquals(List.of(), utils.splitWords("")),
            () -> assertEquals(List.of(), utils.splitWords("   ")),
            () -> assertEquals(List.of(), utils.splitWords(null))
        );
    }

    @Test
    @Timeout(1)  // fail if takes more than 1 second
    void splitWords_longInput_completesQuickly() {
        String longSentence = "word ".repeat(10_000).trim();
        var result = utils.splitWords(longSentence);
        assertEquals(10_000, result.size());
    }
}

// ─── NESTED TEST CLASS ────────────────────────────────
class BankAccountTest {
    @Nested
    @DisplayName("Given an account with $100")
    class WithInitialBalance {
        double balance = 100.0;

        @Test
        @DisplayName("Depositing $50 gives $150")
        void deposit() {
            balance += 50.0;
            assertEquals(150.0, balance);
        }

        @Nested
        @DisplayName("When withdrawing $30")
        class AfterWithdraw {
            double balanceAfter = 100.0 - 30.0;

            @Test
            @DisplayName("Balance should be $70")
            void balanceIsCorrect() {
                assertEquals(70.0, balanceAfter);
            }

            @Test
            @DisplayName("Amount withdrawn should be positive")
            void withdrawnPositive() {
                assertTrue(30.0 > 0);
            }
        }
    }
}

// Main — runs tests programmatically for this demo
// In real projects, run via Maven: mvn test
// or Gradle: ./gradlew test
public class JUnit5Testing {
    public static void main(String[] args) {
        System.out.println("JUnit 5 Demo");
        System.out.println("In real projects, run tests with:");
        System.out.println("  Maven:  mvn test");
        System.out.println("  Gradle: ./gradlew test");
        System.out.println("  IDE:    Right-click test class → Run");

        // Manual test execution (demo only)
        System.out.println("\n=== Running tests manually (demo) ===");

        Calculator calc = new Calculator();
        StringUtils utils = new StringUtils();

        // Run assertions as if in tests
        runTest("add(5,3) = 8", () ->
            assert calc.add(5, 3) == 8);
        runTest("divide by zero throws", () -> {
            try { calc.divide(10, 0); assert false; }
            catch (ArithmeticException e) { /* expected */ }
        });
        runTest("factorial(5) = 120", () ->
            assert calc.factorial(5) == 120L);
        runTest("isPrime(17) = true", () ->
            assert calc.isPrime(17));
        runTest("reverse('java') = 'avaj'", () ->
            assert "avaj".equals(utils.reverse("java")));
        runTest("isPalindrome('racecar')", () ->
            assert utils.isPalindrome("racecar"));
        runTest("splitWords returns 3", () ->
            assert utils.splitWords("one two three").size() == 3);

        System.out.println("\n✅ All manual tests passed!");
    }

    static void runTest(String name, Runnable test) {
        try {
            test.run();
            System.out.println("  ✅ " + name);
        } catch (AssertionError e) {
            System.out.println("  ❌ FAILED: " + name);
        } catch (Exception e) {
            System.out.println("  ❌ ERROR: " + name + " — " + e.getMessage());
        }
    }
}

📝 KEY POINTS:
✅ @BeforeEach creates a fresh instance before each test — no shared state
✅ assertAll() runs all assertions and reports all failures at once
✅ assertThrows() checks both the type AND message of exceptions
✅ @ParameterizedTest + @CsvSource eliminates duplicated test methods
✅ @DisplayName provides human-readable test names in reports
✅ @Nested groups related tests and provides context in output
✅ @Timeout fails tests that run too long — protects CI pipeline
✅ Always use delta in assertEquals for double comparisons: assertEquals(2.5, result, 0.001)
✅ Test method naming: methodName_scenario_expectedBehavior
❌ Never share mutable state between tests — each must be independent
❌ Don't put business logic into tests — test behavior, not implementation
❌ Tests with no assertions always pass — useless and dangerous
❌ Don't test private methods — test the public behavior that uses them
""",
  quiz: [
    Quiz(question: 'What is the purpose of assertAll() in JUnit 5?', options: [
      QuizOption(text: 'It runs all assertions and reports all failures at once, unlike individual assertions that stop at the first failure', correct: true),
      QuizOption(text: 'It asserts that all items in a collection satisfy a condition', correct: false),
      QuizOption(text: 'It runs all test methods in the class simultaneously for speed', correct: false),
      QuizOption(text: 'It marks the test as passing if at least one assertion succeeds', correct: false),
    ]),
    Quiz(question: 'What does @BeforeEach do in a JUnit 5 test class?', options: [
      QuizOption(text: 'Runs the annotated method before each test method in the class, creating fresh test state', correct: true),
      QuizOption(text: 'Runs once before all tests in the class (equivalent to @BeforeAll)', correct: false),
      QuizOption(text: 'Marks the method as a test that must run before others', correct: false),
      QuizOption(text: 'Provides setup data injected as parameters to each test', correct: false),
    ]),
    Quiz(question: 'When comparing doubles in JUnit 5, why should you provide a delta?', options: [
      QuizOption(text: 'Floating-point arithmetic is imprecise — assertEquals(2.5, result, 0.001) allows for tiny rounding differences', correct: true),
      QuizOption(text: 'JUnit requires a delta for all numeric comparisons by convention', correct: false),
      QuizOption(text: 'The delta allows the test to pass even if the values differ by more than expected', correct: false),
      QuizOption(text: 'Without a delta, assertEquals compares object references instead of values', correct: false),
    ]),
  ],
);
