import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson50 = Lesson(
  language: 'Dart',
  title: 'Essential Dart & Flutter Packages',
  content: '''
🎯 METAPHOR:
The Dart package ecosystem is like a hardware store stocked
by thousands of expert craftspeople. You're building a house
(your app) and you don't need to forge your own nails (write
an HTTP client from scratch). Grab the best-reviewed nail gun
(dio), the finest measuring tape (intl for formatting), and
the smartest blueprint holder (riverpod for state management).
pub.dev is the store; pubspec.yaml is your shopping list;
dart pub get is the delivery truck. Understanding which
packages are the industry standard for each category saves
you weeks of work.

📖 EXPLANATION:
pub.dev (pub.dev) is Dart's package repository with 40,000+
packages. Every serious Dart/Flutter project uses a curated
set of packages. This lesson covers the essential packages
every Dart/Flutter developer should know.

─────────────────────────────────────
🌐 HTTP & NETWORKING
─────────────────────────────────────
http (^1.0.0)
  → Simple HTTP client by the Dart team
  → Good for basic REST calls

dio (^5.0.0)
  → Feature-rich HTTP client
  → Interceptors, transformers, cancellation, timeout
  → Industry standard for Flutter networking

─────────────────────────────────────
📦 JSON & SERIALIZATION
─────────────────────────────────────
json_annotation + json_serializable → code-gen (see lesson 49)
freezed + freezed_annotation        → immutable models
dart_mappable                       → alternative to freezed

─────────────────────────────────────
🗃️  LOCAL STORAGE
─────────────────────────────────────
shared_preferences   → key-value store (simple settings)
hive / hive_flutter  → fast NoSQL box database
isar                 → powerful reactive database
drift                → SQLite ORM with streams
sqflite              → raw SQLite access

─────────────────────────────────────
🔄 STATE MANAGEMENT
─────────────────────────────────────
riverpod (^2.0)      → the current gold standard
  provider           → simpler, older
  bloc / flutter_bloc → BLoC pattern, event-driven
  get_it             → service locator / DI container
  getx               → all-in-one (routing, state, DI)

─────────────────────────────────────
🔗 DEPENDENCY INJECTION
─────────────────────────────────────
get_it               → service locator
injectable           → get_it + code generation
riverpod             → DI + state in one

─────────────────────────────────────
📡 REAL-TIME & STREAMS
─────────────────────────────────────
web_socket_channel   → WebSocket client
firebase_core +      → Firebase suite
  cloud_firestore
  firebase_auth
  firebase_storage

─────────────────────────────────────
🔐 SECURITY & AUTH
─────────────────────────────────────
flutter_secure_storage  → encrypted storage
local_auth              → biometric authentication
dart_jsonwebtoken       → JWT encoding/decoding

─────────────────────────────────────
🌍 INTERNATIONALIZATION
─────────────────────────────────────
intl                 → date/number/currency formatting
flutter_localizations → i18n for Flutter
easy_localization    → YAML-based translations

─────────────────────────────────────
🧪 TESTING
─────────────────────────────────────
test                 → core test framework (built-in)
mockito              → mocking with code gen
mocktail             → mocking without code gen
faker                → generate fake test data

─────────────────────────────────────
🛠️  UTILITIES
─────────────────────────────────────
collection           → powerful collection utilities
rxdart               → reactive extensions for Dart streams
dartz                → functional programming (Option, Either)
logger               → beautiful console logging
path                 → cross-platform path operations
equatable            → value equality without codegen
meta                 → annotations (@immutable, @protected)

💻 CODE:
// ── HTTP PACKAGE ──────────────────
/*
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> httpExample() async {
  // GET
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    print('Title: \${
data['title']}');
  }

  // POST
  final postResponse = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'title': 'New Post', 'body': 'Content', 'userId': 1}),
  );
  print('Created: \${
postResponse.statusCode}');
}
*/

// ── DIO PACKAGE ───────────────────
/*
import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 10),
  headers: {'Accept': 'application/json'},
));

// Interceptors (like middleware)
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    options.headers['Authorization'] = 'Bearer \${
getToken()}';
    return handler.next(options);
  },
  onResponse: (response, handler) {
    print('Response: \${
response.statusCode}');
    return handler.next(response);
  },
  onError: (error, handler) {
    if (error.response?.statusCode == 401) {
      // refresh token and retry
    }
    return handler.next(error);
  },
));

Future<void> dioExample() async {
  try {
    final response = await dio.get<Map<String, dynamic>>('/users/1');
    print(response.data!['name']);

    // POST with model
    final created = await dio.post('/users', data: {'name': 'Alice'});
    print(created.statusCode);

    // Download file with progress
    await dio.download(
      '/files/large.zip',
      '/local/path/large.zip',
      onReceiveProgress: (received, total) {
        print('\${
(received / total * 100).toStringAsFixed(1)}%');
      },
    );
  } on DioException catch (e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        print('Connection timed out');
      case DioExceptionType.badResponse:
        print('Bad response: \${
e.response?.statusCode}');
      default:
        print('Error: \${
e.message}');
    }
  }
}
*/

// ── RIVERPOD ──────────────────────
/*
import 'package:riverpod/riverpod.dart';

// Simple state provider
final counterProvider = StateProvider<int>((ref) => 0);

// Computed provider (auto-updates when counterProvider changes)
final doubleProvider = Provider<int>((ref) {
  return ref.watch(counterProvider) * 2;
});

// Async provider (handles loading/error states)
final usersProvider = FutureProvider<List<User>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/users');
  return (response.data as List).map((j) => User.fromJson(j)).toList();
});

// Notifier (complex state logic)
class CartNotifier extends Notifier<List<Product>> {
  @override
  List<Product> build() => [];

  void add(Product product) => state = [...state, product];
  void remove(String id) => state = state.where((p) => p.id != id).toList();
  void clear() => state = [];
}

final cartProvider = NotifierProvider<CartNotifier, List<Product>>(() {
  return CartNotifier();
});

// In a Widget (Flutter):
// Consumer(
//   builder: (context, ref, child) {
//     final count = ref.watch(counterProvider);
//     return Text('\$count');
//   },
// );
*/

// ── GET_IT (SERVICE LOCATOR) ──────
/*
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Singletons (one instance ever)
  getIt.registerSingleton<ApiClient>(ApiClient());
  getIt.registerSingleton<Database>(Database());

  // Lazy singletons (created when first needed)
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(getIt<ApiClient>()),
  );

  // Factories (new instance each time)
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(getIt<UserRepository>()),
  );
}

// Usage anywhere:
final apiClient = getIt<ApiClient>();
final repo = getIt<UserRepository>();
*/

// ── INTL FORMATTING ───────────────
/*
import 'package:intl/intl.dart';

void intlExample() {
  final now = DateTime.now();

  // Date formatting
  print(DateFormat('MMMM d, y').format(now));       // March 15, 2024
  print(DateFormat('dd/MM/yyyy').format(now));       // 15/03/2024
  print(DateFormat('EEEE').format(now));             // Friday
  print(DateFormat.yMMMd().format(now));             // Mar 15, 2024
  print(DateFormat.Hm().format(now));                // 14:30

  // Number formatting
  print(NumberFormat('#,##0.00').format(1234567.89));  // 1,234,567.89
  print(NumberFormat.currency(symbol: '\$').format(9.99));  // \$9.99
  print(NumberFormat.compact().format(1234567));       // 1.2M
  print(NumberFormat.percentPattern().format(0.857)); // 86%

  // Relative time (needs message extraction setup)
  // print(Intl.message('Hello', name: 'hello'));
}
*/

// ── EQUATABLE ─────────────────────
/*
import 'package:equatable/equatable.dart';

// Without equatable: User(id: 1) != User(id: 1) (reference equality)
// With equatable: User(id: 1) == User(id: 1) (value equality)

class User extends Equatable {
  final String id;
  final String name;
  final int age;

  const User({required this.id, required this.name, required this.age});

  @override
  List<Object?> get props => [id, name, age];  // fields to compare

  // copyWith is optional but recommended
  User copyWith({String? id, String? name, int? age}) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    age: age ?? this.age,
  );
}

// Now:
final u1 = User(id: '1', name: 'Alice', age: 30);
final u2 = User(id: '1', name: 'Alice', age: 30);
print(u1 == u2);  // true (via Equatable)
*/

// ── COLLECTION PACKAGE ────────────
/*
import 'package:collection/collection.dart';

void collectionExample() {
  final list = [1, 2, 3, 4, 5];

  // groupBy
  final grouped = groupBy([1, 2, 3, 4, 5, 6], (n) => n % 2 == 0 ? 'even' : 'odd');
  print(grouped);  // {odd: [1, 3, 5], even: [2, 4, 6]}

  // minBy / maxBy
  final people = [('Alice', 30), ('Bob', 25), ('Carol', 35)];
  final youngest = minBy(people, (p) => p.\$2);
  print(youngest);  // (Bob, 25)

  // first / lastWhereOrNull (null instead of throw)
  final nums = [1, 2, 3, 4, 5];
  print(nums.firstWhereOrNull((n) => n > 10));  // null (no throw!)

  // Deep equality for collections
  const deepEq = DeepCollectionEquality();
  print(deepEq.equals([1, [2, 3]], [1, [2, 3]]));  // true

  // sorted (returns new sorted list)
  print(nums.sorted((a, b) => b.compareTo(a)));  // [5, 4, 3, 2, 1]
}
*/

void main() {
  print("""
Essential Dart Package Categories:
───────────────────────────────────
Networking:    http, dio
JSON:          json_serializable, freezed
Local storage: shared_preferences, hive, isar, drift
State:         riverpod, bloc, get_it
Auth/Security: flutter_secure_storage, local_auth
i18n:          intl, easy_localization
Testing:       mockito, mocktail, faker
Utilities:     collection, equatable, logger, rxdart

Browse all packages at: https://pub.dev
""");
}

📝 KEY POINTS:
✅ pub.dev is Dart's package repository — check popularity and pub points
✅ dio is the industry standard HTTP client for Flutter — not the basic http package
✅ riverpod is the current gold standard for Flutter state management
✅ get_it is a simple, effective service locator for dependency injection
✅ intl handles date/number/currency formatting with locale support
✅ equatable eliminates the need to manually implement == and hashCode
✅ collection package extends List/Iterable with groupBy, minBy, sortedBy etc.
✅ Always check pub.dev scores: likes, pub points, and popularity
❌ Don't add packages you don't need — each adds to compile time and app size
❌ Don't use outdated packages — check when they were last published
❌ Don't mix state management solutions — pick one and be consistent
''',
  quiz: [
    Quiz(question: 'What advantage does dio have over the basic http package?', options: [
      QuizOption(text: 'dio is built into Dart; http is third-party', correct: false),
      QuizOption(text: 'dio provides interceptors, request cancellation, timeouts, and a richer API', correct: true),
      QuizOption(text: 'dio is faster for small requests', correct: false),
      QuizOption(text: 'dio supports HTTPS; http only supports HTTP', correct: false),
    ]),
    Quiz(question: 'What does equatable do for Dart classes?', options: [
      QuizOption(text: 'Makes classes immutable automatically', correct: false),
      QuizOption(text: 'Provides value-based == and hashCode based on a props list — without code generation', correct: true),
      QuizOption(text: 'Generates copyWith methods', correct: false),
      QuizOption(text: 'Converts classes to JSON automatically', correct: false),
    ]),
    Quiz(question: 'What is riverpod used for in Flutter?', options: [
      QuizOption(text: 'HTTP networking', correct: false),
      QuizOption(text: 'State management and dependency injection', correct: true),
      QuizOption(text: 'Routing and navigation', correct: false),
      QuizOption(text: 'Database access', correct: false),
    ]),
  ],
);
