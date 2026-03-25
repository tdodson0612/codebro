import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson52 = Lesson(
  language: 'Dart',
  title: 'Dart on the Server: shelf & dart_frog',
  content: '''
🎯 METAPHOR:
Running Dart on the server is like hiring the same architect
to design both the building (Flutter app) and the construction
company headquarters (backend API). The architect already
knows all your blueprints (models), your building codes
(business logic), and your measurement standards (data formats).
Instead of context-switching between Dart and Node.js or Python,
you share the same codebase, models, and tools. shelf is the
low-level foundation — you build what you need. dart_frog is
the fully-furnished framework — routes come pre-built.

📖 EXPLANATION:
Dart runs well on the server via dart:io. The shelf package
is Dart's most popular HTTP framework — minimal, composable,
and production-ready. dart_frog is a higher-level framework
built on shelf. Both can be compiled to native executables.

─────────────────────────────────────
📦 SHELF
─────────────────────────────────────
pub add shelf shelf_router shelf_static

Key concepts:
  Handler:    Function that takes Request → Response
  Middleware: Wraps a handler to add behavior
  Pipeline:   Chain of middleware + final handler
  Router:     shelf_router maps paths to handlers

─────────────────────────────────────
🔀 HANDLER SIGNATURE
─────────────────────────────────────
typedef Handler = FutureOr<Response> Function(Request request);

Response handler(Request request) {
  return Response.ok('Hello!');
}

// Async:
Future<Response> asyncHandler(Request request) async {
  final data = await fetchData();
  return Response.ok(jsonEncode(data));
}

─────────────────────────────────────
🔗 MIDDLEWARE
─────────────────────────────────────
Middleware logRequests = (Handler inner) {
  return (Request request) async {
    print('[LOG] ${
request.method} ${
request.url}');
    final response = await inner(request);
    print('[LOG] ${
response.statusCode}');
    return response;
  };
};

const pipeline = Pipeline()
  .addMiddleware(logRequests)
  .addHandler(myRouter);

─────────────────────────────────────
📁 SHELF_ROUTER
─────────────────────────────────────
final router = Router()
  ..get('/', rootHandler)
  ..get('/users', listUsers)
  ..get('/users/<id>', getUser)
  ..post('/users', createUser)
  ..put('/users/<id>', updateUser)
  ..delete('/users/<id>', deleteUser);

// Path parameters are string by default:
// /users/<id|[0-9]+>  → only matches integers

─────────────────────────────────────
🚀 DART_FROG
─────────────────────────────────────
dart pub global activate dart_frog_cli
dart_frog create my_server
dart_frog dev   → development with hot reload!

File-system routing (like Next.js):
  routes/index.dart        → GET /
  routes/users/index.dart  → GET /users
  routes/users/[id].dart   → GET /users/:id

─────────────────────────────────────
📦 COMPILING TO PRODUCTION
─────────────────────────────────────
dart compile exe bin/server.dart -o server
./server

# Docker:
FROM scratch
COPY server /server
EXPOSE 8080
CMD ["/server"]
# Tiny container — no runtime needed!

💻 CODE:
// ── MINIMAL SHELF SERVER ──────────

/*
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';

// ── Handlers ──────────────────────

Response rootHandler(Request request) {
  return Response.ok(
    jsonEncode({'message': 'Dart shelf server running!', 'version': '1.0.0'}),
    headers: {'content-type': 'application/json'},
  );
}

Future<Response> listUsers(Request request) async {
  final users = [
    {'id': 1, 'name': 'Alice', 'email': 'alice@ex.com'},
    {'id': 2, 'name': 'Bob',   'email': 'bob@ex.com'},
  ];

  // Query params
  final nameFilter = request.url.queryParameters['name'];
  final filtered = nameFilter == null
      ? users
      : users.where((u) => u['name'].toString().contains(nameFilter)).toList();

  return Response.ok(
    jsonEncode(filtered),
    headers: {'content-type': 'application/json'},
  );
}

Future<Response> getUser(Request request, String id) async {
  final userId = int.tryParse(id);
  if (userId == null) {
    return Response.badRequest(
      body: jsonEncode({'error': 'Invalid user id'}),
      headers: {'content-type': 'application/json'},
    );
  }

  // Simulate DB lookup
  if (userId > 2) {
    return Response.notFound(
      jsonEncode({'error': 'User \$id not found'}),
      headers: {'content-type': 'application/json'},
    );
  }

  return Response.ok(
    jsonEncode({'id': userId, 'name': 'User \$userId'}),
    headers: {'content-type': 'application/json'},
  );
}

Future<Response> createUser(Request request) async {
  try {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;

    if (!data.containsKey('name') || !data.containsKey('email')) {
      return Response(
        400,
        body: jsonEncode({'error': 'name and email required'}),
        headers: {'content-type': 'application/json'},
      );
    }

    final newUser = {'id': 3, 'name': data['name'], 'email': data['email']};
    return Response(
      201,
      body: jsonEncode(newUser),
      headers: {'content-type': 'application/json'},
    );
  } catch (e) {
    return Response(400,
      body: jsonEncode({'error': 'Invalid JSON'}),
      headers: {'content-type': 'application/json'},
    );
  }
}

// ── Middleware ─────────────────────

Middleware logger() {
  return (Handler inner) {
    return (Request request) async {
      final start = DateTime.now();
      final response = await inner(request);
      final duration = DateTime.now().difference(start);
      print('${
response.statusCode} ${
request.method} ${
request.url} (${
duration.inMilliseconds}ms)');
      return response;
    };
  };
}

Middleware cors() {
  return createMiddleware(
    requestHandler: (request) {
      if (request.method == 'OPTIONS') {
        return Response.ok(
          '',
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization',
          },
        );
      }
      return null;
    },
    responseHandler: (response) {
      return response.change(headers: {
        'Access-Control-Allow-Origin': '*',
      });
    },
  );
}

Middleware authenticate() {
  return (Handler inner) {
    return (Request request) async {
      final token = request.headers['authorization'];
      if (token == null || !token.startsWith('Bearer ')) {
        return Response.unauthorized(
          jsonEncode({'error': 'Unauthorized'}),
          headers: {'content-type': 'application/json'},
        );
      }
      // Validate token...
      return inner(request);
    };
  };
}

// ── Router ────────────────────────

final _router = Router()
  ..get('/',           rootHandler)
  ..get('/users',      listUsers)
  ..get('/users/<id>', getUser)
  ..post('/users',     createUser);

// Protected routes
final _protectedRouter = Router()
  ..delete('/users/<id>', deleteUser);

Future<Response> deleteUser(Request request, String id) async {
  return Response.ok(jsonEncode({'deleted': id}),
      headers: {'content-type': 'application/json'});
}

// ── Main ──────────────────────────

Future<void> main() async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;

  final handler = Pipeline()
      .addMiddleware(cors())
      .addMiddleware(logger())
      .addHandler(Cascade()
          .add(_router)
          .add(Pipeline()
              .addMiddleware(authenticate())
              .addHandler(_protectedRouter))
          .handler);

  final server = await io.serve(handler, InternetAddress.anyIPv4, port);
  print('Server listening on ${
server.address.host}:${
server.port}');

  // Graceful shutdown
  ProcessSignal.sigint.watch().listen((_) async {
    await server.close();
    exit(0);
  });
}
*/

// ── DART_FROG EXAMPLE ─────────────
/*
// routes/index.dart
import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  return Response.json(body: {'message': 'Hello from dart_frog!'});
}

// routes/users/[id].dart
import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context, String id) {
  return switch (context.request.method) {
    HttpMethod.get => _getUser(context, id),
    HttpMethod.put => _updateUser(context, id),
    HttpMethod.delete => _deleteUser(context, id),
    _ => Response(statusCode: 405),
  };
}

Response _getUser(RequestContext context, String id) {
  return Response.json(body: {'id': id, 'name': 'User \$id'});
}

Response _updateUser(RequestContext context, String id) {
  return Response.json(body: {'updated': id});
}

Response _deleteUser(RequestContext context, String id) {
  return Response.json(statusCode: 204, body: {});
}
*/

// ── WEBSOCKETS ────────────────────
/*
import 'dart:io';

void webSocketExample() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print('WebSocket server on port 8080');

  await for (final request in server) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      final socket = await WebSocketTransformer.upgrade(request);
      socket.listen(
        (data) {
          print('Received: \$data');
          socket.add('Echo: \$data');
        },
        onDone: () => print('Client disconnected'),
        onError: (e) => print('Error: \$e'),
      );
    }
  }
}
*/

void main() {
  print("""
Dart Server Options:
─────────────────────────────────────
shelf            → low-level, composable HTTP
dart_frog        → higher-level, file-based routing
grpc             → Google RPC framework
conduit          → full-featured MVC framework

Getting started with shelf:
  dart pub add shelf shelf_router
  dart run bin/server.dart

Getting started with dart_frog:
  dart pub global activate dart_frog_cli
  dart_frog create my_api
  cd my_api
  dart_frog dev

Compile to native for deployment:
  dart compile exe bin/server.dart -o server
  ./server
""");
}

📝 KEY POINTS:
✅ shelf builds HTTP servers from simple Handler functions: Request → Response
✅ Middleware wraps handlers to add logging, auth, CORS, etc.
✅ Pipeline chains middleware: Pipeline().addMiddleware(m).addHandler(h)
✅ shelf_router maps URL patterns to handlers with path parameters
✅ dart_frog gives file-system routing and hot reload for development
✅ Dart servers compile to small, fast native binaries with no runtime
✅ Share models/business logic between Flutter app and Dart backend
✅ Middleware uses the createMiddleware() helper for clean request/response hooks
❌ Don't forget to set Content-Type: application/json headers on JSON responses
❌ shelf handlers must return FutureOr<Response> — never throw without catching
❌ Don't use blocking I/O (like File.readAsStringSync) inside request handlers
''',
  quiz: [
    Quiz(question: 'What is a shelf Handler in Dart?', options: [
      QuizOption(text: 'A class that manages HTTP connections', correct: false),
      QuizOption(text: 'A function that takes a Request and returns a Response (or Future<Response>)', correct: true),
      QuizOption(text: 'A middleware that handles errors', correct: false),
      QuizOption(text: 'The HTTP server itself', correct: false),
    ]),
    Quiz(question: 'What advantage does Dart on the server give Flutter developers?', options: [
      QuizOption(text: 'Dart servers are faster than Node.js in all benchmarks', correct: false),
      QuizOption(text: 'Code and models can be shared between the Flutter frontend and the Dart backend', correct: true),
      QuizOption(text: 'Dart is the only language that works with Flutter', correct: false),
      QuizOption(text: 'Dart servers have built-in database support', correct: false),
    ]),
    Quiz(question: 'What does dart_frog add on top of shelf?', options: [
      QuizOption(text: 'WebSocket support', correct: false),
      QuizOption(text: 'File-system-based routing and hot reload for development', correct: true),
      QuizOption(text: 'A built-in ORM', correct: false),
      QuizOption(text: 'GraphQL support', correct: false),
    ]),
  ],
);
