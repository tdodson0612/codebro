import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson39 = Lesson(
  language: 'Python',
  title: 'Testing with unittest & pytest',
  content: """
🎯 METAPHOR:
Tests are like a pre-flight checklist for a pilot.
Before every takeoff, the pilot checks the same list —
engine, fuel, instruments, controls — every single time,
even on flights they've done a thousand times. Tests are
your pre-flight checklist for code. Every time you make
a change, the tests confirm: "All systems still working."
Without tests, you're taking off hoping nothing broke.
With tests, you KNOW. The checklist is never annoying
when your plane is in the air.

📖 EXPLANATION:
Testing ensures code works correctly and stays working
as you make changes. Python has unittest (built-in) and
pytest (third-party, more powerful and popular).

─────────────────────────────────────
🧪 TYPES OF TESTS
─────────────────────────────────────
Unit tests     → test one function/method in isolation
Integration    → test multiple components together
End-to-end     → test the entire system
Regression     → test that old bugs don't return
Property-based → test with random inputs (hypothesis)

─────────────────────────────────────
📦 UNITTEST — BUILT-IN
─────────────────────────────────────
class TestMyCode(unittest.TestCase):
    def setUp(self):       # runs before each test
    def tearDown(self):    # runs after each test
    def test_xxx(self):    # test methods must start with test_

Assert methods:
  assertEqual(a, b)        → a == b
  assertNotEqual(a, b)     → a != b
  assertTrue(x)            → bool(x) is True
  assertFalse(x)           → bool(x) is False
  assertIs(a, b)           → a is b
  assertIsNone(x)          → x is None
  assertIn(a, b)           → a in b
  assertRaises(Exc)        → code raises Exc
  assertAlmostEqual(a,b,places=7) → floats
  assertGreater(a, b)      → a > b
  assertIsInstance(a, type)

─────────────────────────────────────
🔥 PYTEST — THE PREFERRED TOOL
─────────────────────────────────────
pip install pytest

No class needed — plain functions starting with test_
Uses regular assert — pytest shows detailed failures
Fixtures (@pytest.fixture) replace setUp/tearDown
Parametrize runs tests with multiple inputs
Markers tag tests: @pytest.mark.slow, @pytest.mark.xfail

─────────────────────────────────────
🎭 MOCKING
─────────────────────────────────────
from unittest.mock import Mock, MagicMock, patch
Replace real objects with fake ones for isolation.
patch() replaces a name temporarily.
Mock.assert_called_with() verifies calls.

💻 CODE:
import unittest
from unittest.mock import Mock, MagicMock, patch, call

# ── THE CODE BEING TESTED ──────────

def add(a, b):
    return a + b

def divide(a, b):
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b

class BankAccount:
    def __init__(self, owner: str, balance: float = 0):
        self.owner = owner
        self._balance = balance
        self._transactions = []

    @property
    def balance(self):
        return self._balance

    def deposit(self, amount: float) -> float:
        if amount <= 0:
            raise ValueError("Deposit must be positive")
        self._balance += amount
        self._transactions.append(("deposit", amount))
        return self._balance

    def withdraw(self, amount: float) -> float:
        if amount <= 0:
            raise ValueError("Withdrawal must be positive")
        if amount > self._balance:
            raise ValueError("Insufficient funds")
        self._balance -= amount
        self._transactions.append(("withdraw", amount))
        return self._balance

    def transaction_count(self) -> int:
        return len(self._transactions)

# ── UNITTEST ──────────────────────

class TestAdd(unittest.TestCase):
    def test_add_positive(self):
        self.assertEqual(add(2, 3), 5)

    def test_add_negative(self):
        self.assertEqual(add(-1, -2), -3)

    def test_add_zero(self):
        self.assertEqual(add(0, 0), 0)

class TestDivide(unittest.TestCase):
    def test_divide_normal(self):
        self.assertAlmostEqual(divide(10, 3), 3.3333333, places=6)

    def test_divide_by_zero(self):
        with self.assertRaises(ValueError) as ctx:
            divide(10, 0)
        self.assertIn("zero", str(ctx.exception).lower())

    def test_divide_returns_float(self):
        result = divide(10, 4)
        self.assertIsInstance(result, float)

class TestBankAccount(unittest.TestCase):

    def setUp(self):
        '''Runs before EACH test method.'''
        self.account = BankAccount("Alice", 100.0)

    def tearDown(self):
        '''Runs after EACH test method.'''
        pass  # cleanup if needed

    def test_initial_balance(self):
        self.assertEqual(self.account.balance, 100.0)

    def test_deposit_increases_balance(self):
        self.account.deposit(50)
        self.assertEqual(self.account.balance, 150.0)

    def test_withdraw_decreases_balance(self):
        self.account.withdraw(30)
        self.assertEqual(self.account.balance, 70.0)

    def test_deposit_negative_raises(self):
        with self.assertRaises(ValueError):
            self.account.deposit(-10)

    def test_overdraft_raises(self):
        with self.assertRaises(ValueError) as ctx:
            self.account.withdraw(200)
        self.assertIn("Insufficient", str(ctx.exception))

    def test_transaction_count(self):
        self.account.deposit(10)
        self.account.withdraw(5)
        self.assertEqual(self.account.transaction_count(), 2)

    def test_initial_transaction_count(self):
        self.assertEqual(self.account.transaction_count(), 0)

# ── MOCKING ───────────────────────

class EmailService:
    def send(self, to: str, subject: str, body: str) -> bool:
        # Would actually send an email
        return True

class NotificationService:
    def __init__(self, email_service: EmailService):
        self.email_service = email_service

    def notify_deposit(self, account: BankAccount, amount: float):
        self.email_service.send(
            to="user@example.com",
            subject="Deposit received",
            body=f"\\\${amount} deposited to {account.owner}'s account"
        )

class TestNotificationService(unittest.TestCase):
    def setUp(self):
        self.mock_email = Mock(spec=EmailService)
        self.notifier = NotificationService(self.mock_email)
        self.account = BankAccount("Bob", 0)

    def test_notify_deposit_calls_send(self):
        self.notifier.notify_deposit(self.account, 100)
        self.mock_email.send.assert_called_once()

    def test_notify_deposit_correct_args(self):
        self.notifier.notify_deposit(self.account, 50)
        self.mock_email.send.assert_called_once_with(
            to="user@example.com",
            subject="Deposit received",
            body="\\\$50 deposited to Bob's account"
        )

# patch() — temporarily replace a module-level name
class TestWithPatch(unittest.TestCase):
    @patch("builtins.print")
    def test_print_called(self, mock_print):
        print("Hello")
        mock_print.assert_called_once_with("Hello")

# ── PYTEST-STYLE (shown as comments) ──
# These would be in test_mycode.py and run with: pytest

# def test_add():
#     assert add(2, 3) == 5
#     assert add(-1, 1) == 0
#
# def test_divide_by_zero():
#     import pytest
#     with pytest.raises(ValueError, match="zero"):
#         divide(10, 0)
#
# @pytest.fixture
# def account():
#     return BankAccount("Alice", 100)
#
# def test_deposit(account):
#     account.deposit(50)
#     assert account.balance == 150
#
# @pytest.mark.parametrize("a,b,expected", [
#     (2, 3, 5),
#     (-1, 1, 0),
#     (0, 0, 0),
#     (100, -50, 50),
# ])
# def test_add_parametrized(a, b, expected):
#     assert add(a, b) == expected

# Run tests
if __name__ == "__main__":
    # Run from command line: python -m pytest test_file.py -v
    # Run with unittest:
    unittest.main(verbosity=2)

📝 KEY POINTS:
✅ Tests are crucial — write them from the start, not after
✅ Each test should test ONE thing — one assertion per test ideally
✅ setUp/tearDown run before/after EVERY test method
✅ assertRaises context manager: with self.assertRaises(Exception):
✅ Mock replaces real dependencies — tests run without real DB/network
✅ @patch temporarily replaces module-level objects during tests
✅ pytest is easier and more powerful than unittest for new code
❌ Don't test implementation details — test behavior and outcomes
❌ Don't share state between tests — each test must be independent
❌ Avoid "happy path only" — test error cases and edge cases too
""",
  quiz: [
    Quiz(question: 'What does unittest.TestCase.setUp() do?', options: [
      QuizOption(text: 'Runs once when the test class is created', correct: false),
      QuizOption(text: 'Runs before EACH individual test method in the class', correct: true),
      QuizOption(text: 'Runs after all tests in the class are complete', correct: false),
      QuizOption(text: 'Initializes the test runner', correct: false),
    ]),
    Quiz(question: 'What is the purpose of using Mock objects in tests?', options: [
      QuizOption(text: 'To make tests run faster by skipping assertions', correct: false),
      QuizOption(text: 'To replace real dependencies so tests run without real network/DB/services', correct: true),
      QuizOption(text: 'To automatically generate test data', correct: false),
      QuizOption(text: 'To mock Python built-in types like list and dict', correct: false),
    ]),
    Quiz(question: 'What is the correct way to test that a function raises an exception?', options: [
      QuizOption(text: 'try: func() except Exception: pass', correct: false),
      QuizOption(text: 'with self.assertRaises(ExceptionType): func()', correct: true),
      QuizOption(text: 'assert func() == Exception', correct: false),
      QuizOption(text: 'self.assertEqual(func(), None)', correct: false),
    ]),
  ],
);
