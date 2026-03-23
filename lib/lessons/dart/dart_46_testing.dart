import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson46 = Lesson(
  language: 'Dart',
  title: 'Testing in Dart (package:test)',
  content: '''
🎯 METAPHOR:
Tests are like quality control inspectors on an assembly line.
Every function (product) has a specification (expected behavior).
The inspector (test) checks the product matches the spec.
expect() is the inspector's clipboard — they compare
"what we got" versus "what we expected." group() organizes
inspectors by department. setUp() is the shift briefing —
run before every inspection. Good tests catch defects
before they reach the customer (production). Test-Driven
Development is designing the spec BEFORE building the product.

📖 EXPLANATION:
package:test is Dart's testing framework. It provides
test(), group(), expect(), setUp()/tearDown(), async testing,
mocking patterns, and test runner integration.
Run tests with: dart test

─────────────────────────────────────
📦 SETUP
─────────────────────────────────────
pubspec.yaml:
  dev_dependencies:
    test: ^1.24.0
    mockito: ^5.4.0      # for mocking
    build_runner: ^2.4.0 # for mockito codegen

File naming: test/my_feature_test.dart
Run: dart test
     dart test test/my_feature_test.dart
     dart test --reporter expanded

─────────────────────────────────────
🔑 CORE API
─────────────────────────────────────
test('description', () { ... })     → single test
group('name', () { tests })         → group tests
setUp(() { ... })                   → run before each test
tearDown(() { ... })                → run after each test
setUpAll(() { ... })                → run once before group
tearDownAll(() { ... })             → run once after group

expect(actual, matcher)             → assertion
throwsA(isA<ExceptionType>())       → expect exception
isTrue / isFalse                    → bool matchers
equals(value)                       → equality matcher
contains(value)                     → containment
hasLength(n)                        → length matcher
isNull / isNotNull                  → null matchers

─────────────────────────────────────
⚡ MATCHERS
─────────────────────────────────────
equals(value)
isNull / isNotNull
isTrue / isFalse
isA<Type>()
isNot(matcher)
lessThan(n) / greaterThan(n)
inClosedOpenRange(min, max)
contains(element)
hasLength(n)
isEmpty / isNotEmpty
startsWith(s) / endsWith(s)
matches(regex)
throwsA(matcher)
throwsArgumentError / throwsStateError
prints(matcher)

─────────────────────────────────────
🔄 ASYNC TESTING
─────────────────────────────────────
test('async test', () async {
  final result = await myAsyncFn();
  expect(result, equals('expected'));
});

// Fake async (no real waiting):
import 'package:fake_async/fake_async.dart';
fakeAsync((fake) {
  Timer(Duration(seconds: 10), callback);
  fake.elapse(Duration(seconds: 10));  // instant!
  expect(callback.callCount, 1);
});

─────────────────────────────────────
🎭 MOCKING WITH MOCKITO
─────────────────────────────────────
@GenerateMocks([MyService])  // generate mock class
MockMyService mock = MockMyService();
when(mock.fetchData()).thenReturn('test data');
when(mock.fetchData()).thenAnswer((_) async => 'async data');
verify(mock.fetchData()).called(1);
verifyNever(mock.deleteAll());

💻 CODE:
// test/calculator_test.dart

// In a real project:
// import 'package:test/test.dart';
// import '../lib/calculator.dart';

void main() {
  // ── BASIC TESTS ────────────────
  print('Test file structure example:');

  final testStructure = """
import 'package:test/test.dart';

void main() {
  // ── BASIC TEST ─────────────────
  test('add works for positive numbers', () {
    expect(add(2, 3), equals(5));
    expect(add(0, 0), equals(0));
    expect(add(-1, 1), equals(0));
  });

  test('divide throws on zero divisor', () {
    expect(() => divide(10, 0), throwsA(isA<ArgumentError>()));
  });

  // ── GROUPED TESTS ──────────────
  group('Calculator', () {
    late Calculator calc;

    setUp(() {
      calc = Calculator();  // fresh instance for each test
    });

    group('addition', () {
      test('adds two positive numbers', () {
        expect(calc.add(3, 4), equals(7));
      });

      test('adds negative numbers', () {
        expect(calc.add(-3, -4), equals(-7));
      });

      test('identity: adding zero', () {
        expect(calc.add(5, 0), equals(5));
        expect(calc.add(0, 5), equals(5));
      });
    });

    group('division', () {
      test('divides evenly', () {
        expect(calc.divide(10, 2), equals(5.0));
      });

      test('throws ArgumentError for zero divisor', () {
        expect(
          () => calc.divide(10, 0),
          throwsA(
            isA<ArgumentError>()
                .having((e) => e.message, 'message', contains('zero'))
          ),
        );
      });
    });

    group('memory', () {
      test('stores and recalls value', () {
        calc.memStore(42);
        expect(calc.memRecall(), equals(42));
      });

      test('memory starts at zero', () {
        expect(calc.memRecall(), equals(0.0));
      });

      test('memory cleared with memClear', () {
        calc.memStore(99);
        calc.memClear();
        expect(calc.memRecall(), equals(0.0));
      });
    });
  });

  // ── ASYNC TESTS ────────────────
  group('ApiService', () {
    test('fetchUser returns user data', () async {
      final service = ApiService();
      final user = await service.fetchUser(1);
      expect(user, isNotNull);
      expect(user!.name, isA<String>());
      expect(user.name, isNotEmpty);
    });

    test('fetchUser returns null for missing ID', () async {
      final service = ApiService();
      final user = await service.fetchUser(99999);
      expect(user, isNull);
    });

    test('fetchUser throws on network error', () async {
      final service = ApiService(baseUrl: 'http://invalid-url.test');
      expect(
        () => service.fetchUser(1),
        throwsA(isA<Exception>()),
      );
    });
  });

  // ── COLLECTION MATCHERS ────────
  test('list operations', () {
    final list = [1, 2, 3, 4, 5];
    
    expect(list, hasLength(5));
    expect(list, contains(3));
    expect(list, isNot(contains(6)));
    expect(list, containsAll([1, 3, 5]));
    expect(list.first, equals(1));
    expect(list.last, equals(5));
    expect(list, everyElement(lessThan(10)));
    expect(list, anyElement(greaterThan(3)));
  });

  test('string matchers', () {
    final str = 'Hello, Dart!';
    
    expect(str, startsWith('Hello'));
    expect(str, endsWith('!'));
    expect(str, contains('Dart'));
    expect(str, hasLength(12));
    expect(str, matches(RegExp(r'^Hello')));
  });

  test('map matchers', () {
    final map = {'a': 1, 'b': 2};
    
    expect(map, containsKey('a'));
    expect(map, containsValue(2));
    expect(map, hasLength(2));
  });

  // ── MATCHER COMBINATORS ────────
  test('combining matchers', () {
    int n = 7;
    
    expect(n, allOf(greaterThan(0), lessThan(10)));
    expect(n, anyOf(equals(7), equals(11)));
    expect(n, isNot(equals(8)));
  });

  // ── SETUPTEARDOWN ──────────────
  group('with database', () {
    late MockDatabase db;

    setUpAll(() async {
      // Run once before all tests in group
      print('Setting up test database...');
      // await setupTestDatabase();
    });

    setUp(() {
      // Run before each test
      db = MockDatabase();
    });

    tearDown(() {
      // Run after each test
      db.close();
    });

    tearDownAll(() async {
      // Run once after all tests
      // await cleanupTestDatabase();
    });

    test('inserts a record', () {
      db.insert({'id': 1, 'name': 'Alice'});
      expect(db.count(), equals(1));
    });

    test('finds a record', () {
      db.insert({'id': 1, 'name': 'Alice'});
      final result = db.find(1);
      expect(result?['name'], equals('Alice'));
    });
  });

  // ── SKIP AND ONLY ──────────────
  test('this test is skipped', () {
    fail('Should not run');
  }, skip: 'Not implemented yet');

  // Run only this test during development:
  // test('focused test', () { ... }, solo: true);

  // ── TAGS ─────────────────────
  test('fast unit test', () {
    expect(1 + 1, equals(2));
  }, tags: 'unit');

  test('slow integration test', () async {
    await Future.delayed(Duration(milliseconds: 100));
    expect(true, isTrue);
  }, tags: 'integration');
  // Run only unit tests: dart test -t unit
  // Skip integration:   dart test -x integration
}
""";
  print(testStructure);

  // ── MOCKITO EXAMPLE ────────────
  final mockitoExample = """
// With @GenerateMocks annotation:
// Run: dart run build_runner build

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([UserRepository])
import 'user_service_test.mocks.dart';

void main() {
  group('UserService', () {
    late MockUserRepository mockRepo;
    late UserService service;

    setUp(() {
      mockRepo = MockUserRepository();
      service = UserService(mockRepo);
    });

    test('getUser calls repository', () async {
      when(mockRepo.findById('1'))
          .thenAnswer((_) async => User(id: '1', name: 'Alice'));

      final user = await service.getUser('1');
      
      expect(user?.name, equals('Alice'));
      verify(mockRepo.findById('1')).called(1);
    });

    test('getUser returns null for missing user', () async {
      when(mockRepo.findById(any)).thenAnswer((_) async => null);

      final user = await service.getUser('missing-id');
      
      expect(user, isNull);
    });

    test('deleteUser throws when user not found', () async {
      when(mockRepo.findById(any)).thenAnswer((_) async => null);

      expect(
        () => service.deleteUser('missing'),
        throwsA(isA<UserNotFoundException>()),
      );
    });
  });
}
""";
  print('\nMockito example:\n\$mockitoExample');
}

📝 KEY POINTS:
✅ dart test runs all files matching test/**_test.dart
✅ group() organizes related tests; setUp()/tearDown() run around each test
✅ expect(actual, matcher) — many matchers available from package:test
✅ Async tests use async/await normally — test() supports async functions
✅ skip: 'reason' skips a test; tags: 'tag' labels tests for filtering
✅ throwsA(isA<ExceptionType>()) verifies exceptions are thrown
✅ Mockito with @GenerateMocks generates mock classes at build time
✅ Run specific tests: dart test -n "test name pattern"
❌ Don't share mutable state between tests — always use setUp() for fresh instances
❌ Don't rely on test execution order — each test must be independent
❌ setUpAll/tearDownAll are for expensive one-time setup — use sparingly
''',
  quiz: [
    Quiz(question: 'What is the correct way to test that a function throws an ArgumentError?', options: [
      QuizOption(text: 'expect(myFn(), throwsArgumentError)', correct: false),
      QuizOption(text: 'expect(() => myFn(), throwsA(isA<ArgumentError>()))', correct: true),
      QuizOption(text: 'try { myFn(); } catch (e) { expect(e, isA<ArgumentError>()); }', correct: false),
      QuizOption(text: 'assert(() => myFn() throws ArgumentError)', correct: false),
    ]),
    Quiz(question: 'What is the difference between setUp() and setUpAll() in package:test?', options: [
      QuizOption(text: 'setUp() is for groups; setUpAll() is for individual tests', correct: false),
      QuizOption(text: 'setUp() runs before EACH test; setUpAll() runs ONCE before all tests in the group', correct: true),
      QuizOption(text: 'They are identical', correct: false),
      QuizOption(text: 'setUpAll() is only for async setup', correct: false),
    ]),
    Quiz(question: 'How do you run only tests tagged with "unit" using dart test?', options: [
      QuizOption(text: 'dart test --type unit', correct: false),
      QuizOption(text: 'dart test -t unit', correct: true),
      QuizOption(text: 'dart test --filter=unit', correct: false),
      QuizOption(text: 'dart test unit_tests/', correct: false),
    ]),
  ],
);
