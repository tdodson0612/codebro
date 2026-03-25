import '../../models/lesson.dart';
import '../../models/quiz.dart';

final kotlinLesson39 = Lesson(
  language: 'Kotlin',
  title: 'Testing in Kotlin',
  content: """
🎯 METAPHOR:
Testing is like building a safety net under a high-wire act.
The performers (your functions) should be skilled enough to
walk the wire without the net — but the net is there to
catch falls before the audience (users in production) sees
a disaster. Each test is one section of net. Unit tests
catch small individual falls. Integration tests catch falls
when multiple performers interact. The more net you have,
the more confidently you can try new stunts (refactoring)
without fearing catastrophic failure. No net = constant fear.
Full net = fearless innovation.

📖 EXPLANATION:
Kotlin has excellent testing support. The primary testing
frameworks for Kotlin are:
  • JUnit 5 — the standard JVM testing framework
  • Kotest — Kotlin-native testing framework with DSL
  • MockK — Kotlin mocking library (like Mockito but idiomatic)
  • kotlinx-coroutines-test — for testing coroutines

─────────────────────────────────────
JUNIT 5 WITH KOTLIN:
─────────────────────────────────────
  class CalculatorTest {

      @Test
      fun \`addition returns correct result\`() {
          val calc = Calculator()
          assertEquals(5, calc.add(2, 3))
      }

      @Test
      fun \`division by zero throws\`() {
          assertThrows<ArithmeticException> {
              Calculator().divide(10, 0)
          }
      }
  }

Note: Kotlin test function names can use backtick syntax
for readable names with spaces and special characters.

─────────────────────────────────────
COMMON JUNIT 5 ASSERTIONS:
─────────────────────────────────────
  assertEquals(expected, actual)
  assertNotEquals(unexpected, actual)
  assertTrue(condition)
  assertFalse(condition)
  assertNull(value)
  assertNotNull(value)
  assertThrows<ExceptionType> { }
  assertDoesNotThrow { }
  assertAll { ... }          // run multiple assertions
  assertEquals(expected, actual, "failure message")

─────────────────────────────────────
KOTEST — Kotlin-native DSL:
─────────────────────────────────────
  class CalculatorSpec : StringSpec({
      "addition works correctly" {
          Calculator().add(2, 3) shouldBe 5
      }

      "division by zero throws ArithmeticException" {
          shouldThrow<ArithmeticException> {
              Calculator().divide(10, 0)
          }
      }
  })

Kotest matchers:
  shouldBe / shouldNotBe
  shouldBeNull / shouldNotBeNull
  shouldContain / shouldNotContain
  shouldBeGreaterThan / shouldBeLessThan
  shouldThrow<T> { }
  shouldBeInstanceOf<T>()

─────────────────────────────────────
MOCKK — mocking in Kotlin:
─────────────────────────────────────
  val repo = mockk<UserRepository>()

  // Define behavior
  every { repo.getUser(1) } returns User(1, "Terry", "t@t.com")
  every { repo.getUser(any()) } returns null

  // Verify calls
  verify { repo.getUser(1) }
  verify(exactly = 2) { repo.saveUser(any()) }

  // Relaxed mock — returns default values
  val mock = mockk<UserRepository>(relaxed = true)

  // Spy — wrap real object
  val spy = spyk(RealUserRepository())

─────────────────────────────────────
TESTING COROUTINES:
─────────────────────────────────────
  class CoroutineTest {
      @Test
      fun \`suspend function returns correct result\`() = runTest {
          val result = mySuspendFunction()
          assertEquals("expected", result)
      }

      @Test
      fun \`flow emits correct values\`() = runTest {
          val values = myFlow().toList()
          assertEquals(listOf(1, 2, 3), values)
      }
  }

  runTest is from kotlinx-coroutines-test — it advances
  virtual time so delay() is instant in tests.

─────────────────────────────────────
TEST STRUCTURE — AAA Pattern:
─────────────────────────────────────
  @Test
  fun \`withdraw reduces balance correctly\`() {
      // Arrange — set up state
      val account = BankAccount("Terry", 1000.0)

      // Act — perform the action
      account.withdraw(300.0)

      // Assert — verify the result
      assertEquals(700.0, account.balance)
  }

─────────────────────────────────────
PARAMETERIZED TESTS:
─────────────────────────────────────
  @ParameterizedTest
  @ValueSource(ints = [2, 4, 6, 8, 10])
  fun \`even numbers are recognized\`(n: Int) {
      assertTrue(n % 2 == 0)
  }

  @ParameterizedTest
  @CsvSource("1,1,2", "2,3,5", "10,20,30")
  fun \`addition is correct\`(a: Int, b: Int, expected: Int) {
      assertEquals(expected, a + b)
  }

─────────────────────────────────────
WHAT MAKES A GOOD TEST:
─────────────────────────────────────
  ✅ Tests ONE thing
  ✅ Has a clear, descriptive name
  ✅ Is independent of other tests
  ✅ Is fast (no real network/file calls — use mocks)
  ✅ Tests BEHAVIOR not implementation
  ✅ Has one reason to fail

💻 CODE:
// ─── Code under test ────────────────────────────────

data class Product(val id: Int, val name: String, val price: Double, val inStock: Boolean)

interface ProductRepository {
    fun findById(id: Int): Product?
    fun findAll(): List<Product>
    fun save(product: Product): Boolean
}

class ProductService(private val repository: ProductRepository) {
    fun getProduct(id: Int): Product {
        return repository.findById(id) ?: throw NoSuchElementException("Product \$id not found")
    }

    fun getAvailable(): List<Product> {
        return repository.findAll().filter { it.inStock }
    }

    fun applyDiscount(product: Product, discountPercent: Double): Product {
        require(discountPercent in 0.0..100.0) { "Discount must be 0-100%" }
        val discountedPrice = product.price * (1 - discountPercent / 100)
        return product.copy(price = discountedPrice)
    }

    fun getTotalInventoryValue(): Double {
        return repository.findAll()
            .filter { it.inStock }
            .sumOf { it.price }
    }
}

// ─── Test helpers (inline mocks for this demo) ───────

class FakeProductRepository(private val products: MutableList<Product> = mutableListOf()) : ProductRepository {
    override fun findById(id: Int): Product? = products.find { it.id == id }
    override fun findAll(): List<Product> = products.toList()
    override fun save(product: Product): Boolean {
        products.removeIf { it.id == product.id }
        products.add(product)
        return true
    }
}

// ─── Demonstration of test assertions ────────────────

fun runTests() {
    var passed = 0
    var failed = 0

    fun test(name: String, block: () -> Unit) {
        try {
            block()
            println("✅ PASS: \$name")
            passed++
        } catch (e: AssertionError) {
            println("❌ FAIL: \$name — ${
e.message}")
            failed++
        } catch (e: Exception) {
            println("❌ ERROR: \$name — ${
e.javaClass.simpleName}: ${
e.message}")
            failed++
        }
    }

    fun assertEquals(expected: Any?, actual: Any?) {
        if (expected != actual) throw AssertionError("Expected \$expected but got \$actual")
    }

    fun assertTrue(condition: Boolean, msg: String = "Expected true") {
        if (!condition) throw AssertionError(msg)
    }

    fun assertThrows(block: () -> Unit) {
        try {
            block()
            throw AssertionError("Expected exception was not thrown")
        } catch (_: AssertionError) { throw it }
        catch (_: Exception) { /* expected */ }
    }

    // ─── TESTS ───────────────────────────────────────

    val products = mutableListOf(
        Product(1, "Keyboard", 79.99, true),
        Product(2, "Mouse", 29.99, true),
        Product(3, "Monitor", 299.99, false),
        Product(4, "Headphones", 149.99, true)
    )
    val repo = FakeProductRepository(products)
    val service = ProductService(repo)

    // getProduct tests
    test("getProduct returns product for valid ID") {
        val product = service.getProduct(1)
        assertEquals("Keyboard", product.name)
        assertEquals(79.99, product.price)
    }

    test("getProduct throws for invalid ID") {
        assertThrows { service.getProduct(999) }
    }

    // getAvailable tests
    test("getAvailable returns only in-stock products") {
        val available = service.getAvailable()
        assertEquals(3, available.size)
        assertTrue(available.all { it.inStock }, "All available products must be in stock")
        assertTrue(available.none { it.id == 3 }, "Monitor (out of stock) should not be included")
    }

    // applyDiscount tests
    test("applyDiscount reduces price correctly") {
        val keyboard = Product(1, "Keyboard", 100.0, true)
        val discounted = service.applyDiscount(keyboard, 20.0)
        assertEquals(80.0, discounted.price)
        assertEquals("Keyboard", discounted.name)  // name unchanged
    }

    test("applyDiscount with 0% does not change price") {
        val product = Product(1, "Widget", 50.0, true)
        val result = service.applyDiscount(product, 0.0)
        assertEquals(50.0, result.price)
    }

    test("applyDiscount with 100% sets price to 0") {
        val product = Product(1, "Widget", 50.0, true)
        val result = service.applyDiscount(product, 100.0)
        assertEquals(0.0, result.price)
    }

    test("applyDiscount throws for invalid discount") {
        val product = Product(1, "Widget", 50.0, true)
        assertThrows { service.applyDiscount(product, 150.0) }
    }

    // inventory value test
    test("getTotalInventoryValue sums in-stock products") {
        val expected = 79.99 + 29.99 + 149.99  // keyboard + mouse + headphones
        val actual = service.getTotalInventoryValue()
        assertTrue(Math.abs(expected - actual) < 0.001, "Expected \$expected, got \$actual")
    }

    println("\\n=== Results: \$passed passed, \$failed failed ===")
}

fun main() = runTests()

📝 KEY POINTS:
✅ Use backtick function names for readable test descriptions
✅ Follow AAA pattern: Arrange → Act → Assert
✅ Tests should be independent — no shared mutable state between tests
✅ Use fake/stub implementations for repositories in unit tests
✅ Parameterized tests eliminate duplicated test logic
✅ runTest from coroutines-test makes delay() instant in tests
✅ Mock frameworks (MockK) define behavior and verify calls
✅ Test names should describe BEHAVIOR, not implementation
❌ Don't test implementation details — test observable behavior
❌ Avoid real network calls, database access, or file I/O in unit tests
❌ Don't share mutable state across test cases — causes flaky tests
❌ A test with no assertion is not a test — it will always pass
""",
  quiz: [
    Quiz(question: 'What is the AAA pattern in testing?', options: [
      QuizOption(text: 'Arrange (set up), Act (perform action), Assert (verify result)', correct: true),
      QuizOption(text: 'Annotate, Automate, Analyze — the three phases of test-driven development', correct: false),
      QuizOption(text: 'Atomic, Atomic, Assert — ensuring each test is isolated', correct: false),
      QuizOption(text: 'A shorthand for assertAll, assertAny, and assertAtLeast', correct: false),
    ]),
    Quiz(question: 'Why is runTest used instead of runBlocking when testing coroutines?', options: [
      QuizOption(text: 'runTest controls virtual time so delay() calls complete instantly, making tests fast', correct: true),
      QuizOption(text: 'runTest provides better error messages for coroutine failures', correct: false),
      QuizOption(text: 'runBlocking is not allowed inside test functions', correct: false),
      QuizOption(text: 'runTest automatically retries flaky coroutine tests up to 3 times', correct: false),
    ]),
    Quiz(question: 'What makes a good unit test?', options: [
      QuizOption(text: 'It tests one behavior, is fast, is independent, and has a clear descriptive name', correct: true),
      QuizOption(text: 'It covers as many code paths as possible in a single test function', correct: false),
      QuizOption(text: 'It tests against real databases and services to ensure accuracy', correct: false),
      QuizOption(text: 'It is at least 50 lines long to ensure thorough coverage', correct: false),
    ]),
  ],
);
