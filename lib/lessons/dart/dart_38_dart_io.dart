import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson38 = Lesson(
  language: 'Dart',
  title: 'dart:io — Files, HTTP & Sockets',
  content: '''
🎯 METAPHOR:
dart:io is the physical world interface for Dart.
Everything that involves the real world — reading files
from disk, making HTTP requests over the network, listening
on a socket — goes through dart:io. It's like the arms
and legs of your Dart program: without it, your program
can think (process data) but can't touch anything outside.
Important: dart:io is only available on native Dart
(CLI, server) — not on web (browser). Web apps use dart:html
instead. Think of it as your native-only toolkit.

📖 EXPLANATION:
dart:io provides file system access, HTTP client/server,
sockets, stdin/stdout/stderr, and OS process management.
All I/O operations are async (returning Futures or Streams)
to avoid blocking the event loop.

─────────────────────────────────────
📦 KEY dart:io CLASSES
─────────────────────────────────────
File              → read, write, append files
Directory         → list, create, delete directories
Link              → symbolic links
FileSystemEntity  → base for File, Directory, Link

HttpClient        → make HTTP requests
HttpServer        → create HTTP server
HttpRequest       → incoming request (server side)
HttpResponse      → outgoing response (server side)

Socket            → TCP socket
ServerSocket      → TCP server socket
RawSocket         → low-level socket

Stdin / Stdout / Stderr → standard streams
Process           → run OS processes
Platform          → platform information (OS, CPU, env vars)

─────────────────────────────────────
📄 FILE OPERATIONS
─────────────────────────────────────
File f = File('path/to/file.txt');

// Read (async)
String text = await f.readAsString();
List<int> bytes = await f.readAsBytes();
Stream<String> lines = f.openRead().transform(utf8.decoder).transform(LineSplitter());

// Write (async)
await f.writeAsString('content');
await f.writeAsBytes([104, 101, 108, 108, 111]);

// Check existence
bool exists = await f.exists();

// Metadata
FileStat stat = await f.stat();
stat.modified  → DateTime
stat.size      → int (bytes)
stat.type      → FileSystemEntityType

─────────────────────────────────────
⚠️  DART:IO AVAILABILITY
─────────────────────────────────────
Available on:     Dart CLI, server, Flutter mobile, Flutter desktop
NOT available on: Flutter Web (use dart:html or http package instead)

─────────────────────────────────────
🌐 HTTP CLIENT
─────────────────────────────────────
import 'dart:io';

final client = HttpClient();
final request = await client.getUrl(Uri.parse('https://...'));
final response = await request.close();
final body = await response.transform(utf8.decoder).join();
client.close();

// Better: use the http package (package:http)!
// It's cross-platform and much simpler.

💻 CODE:
import 'dart:io';
import 'dart:async';
import 'dart:convert';

Future<void> main() async {
  // ── FILE OPERATIONS ────────────
  final file = File('example.txt');

  // Write
  await file.writeAsString('Hello, Dart!\nLine 2\nLine 3\n');
  print('Written to ${
file.path}');

  // Read all at once
  String content = await file.readAsString();
  print('Content:\n\$content');

  // Read as bytes
  List<int> bytes = await file.readAsBytes();
  print('Size: ${
bytes.length} bytes');

  // Read line by line (streaming — memory efficient!)
  print('Lines:');
  await file
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .forEach((line) => print('  | \$line'));

  // Append
  await file.writeAsString('Line 4\n', mode: FileMode.append);

  // Check existence
  print('Exists: ${
await file.exists()}');

  // File info
  final stat = await file.stat();
  print('Size: ${
stat.size} bytes');
  print('Modified: ${
stat.modified}');
  print('Type: ${
stat.type}');

  // Copy, rename, delete
  File copy = await file.copy('example_copy.txt');
  print('Copied to: ${
copy.path}');
  await copy.delete();
  print('Copy deleted');

  // ── DIRECTORY OPERATIONS ───────
  final dir = Directory('test_dir');

  // Create (recursive = create parent dirs too)
  await dir.create(recursive: true);
  print('Created directory: ${
dir.path}');

  // Create files in it
  await File('test_dir/a.txt').writeAsString('File A');
  await File('test_dir/b.txt').writeAsString('File B');
  await Directory('test_dir/subdir').create();
  await File('test_dir/subdir/c.txt').writeAsString('File C');

  // List contents
  print('\nDirectory contents:');
  await for (final entity in dir.list()) {
    if (entity is File) print('  FILE: ${
entity.path}');
    if (entity is Directory) print('  DIR:  ${
entity.path}');
  }

  // Recursive listing
  print('\nRecursive contents:');
  await for (final entity in dir.list(recursive: true)) {
    print('  ${
entity.runtimeType}: ${
entity.path}');
  }

  // Clean up
  await dir.delete(recursive: true);
  await file.delete();
  print('Cleanup done');

  // ── STDIN/STDOUT ───────────────
  // Read a line from user (sync — blocks):
  // String? line = stdin.readLineSync();
  // print('You entered: \$line');

  // stdout.write vs print
  stdout.write('No newline here');
  stdout.write('...\n');
  stderr.write('This goes to stderr\n');

  // ── PLATFORM INFO ──────────────
  print('\nPlatform info:');
  print('OS: ${
Platform.operatingSystem}');       // macos/linux/windows
  print('Processors: ${
Platform.numberOfProcessors}');
  print('Dart version: ${
Platform.version}');
  print('Script: ${
Platform.script}');
  print('Executable: ${
Platform.executable}');

  // Environment variables
  final home = Platform.environment['HOME'];
  print('HOME: \$home');

  // ── PROCESS ─────────────────────
  // Run a shell command
  final result = await Process.run('echo', ['Hello from Process!']);
  print('Exit code: ${
result.exitCode}');
  print('Output: ${
result.stdout}');

  // Stream process output
  final process = await Process.start('ls', ['-la']);
  await for (final line in process.stdout.transform(utf8.decoder).transform(LineSplitter())) {
    print('  \$line');
  }

  // ── HTTP CLIENT ────────────────
  // Note: for production, use package:http instead!
  // This shows the low-level dart:io approach:

  // final client = HttpClient();
  // try {
  //   final request = await client.getUrl(
  //     Uri.parse('https://jsonplaceholder.typicode.com/posts/1')
  //   );
  //   final response = await request.close();
  //   final body = await response.transform(utf8.decoder).join();
  //   final json = jsonDecode(body);
  //   print('Post title: ${
json['title']}');
  // } finally {
  //   client.close();
  // }

  // ── HTTP SERVER ─────────────────
  // Simple HTTP server example:
  // (commented out to avoid actually binding a port)

  final serverExample = """
  // Start a server
  final server = await HttpServer.bind('localhost', 8080);
  print('Server on http://localhost:8080');

  await for (HttpRequest request in server) {
    final path = request.uri.path;
    final method = request.method;
    print('Received: \$method \$path');

    request.response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = ContentType.json
      ..write(jsonEncode({'message': 'Hello from Dart!', 'path': path}));
    await request.response.close();
  }
  """;
  print('\nHTTP server example (not run):\n\$serverExample');

  // ── WEBSOCKET ──────────────────
  // WebSocket client:
  // final ws = await WebSocket.connect('ws://example.com/ws');
  // ws.listen((message) => print('Received: \$message'));
  // ws.add('Hello!');
  // await ws.close();

  // ── TEMP FILE/DIR ───────────────
  final temp = await File.fromUri(
    Directory.systemTemp.uri.resolve('dart_example_${
DateTime.now().millisecondsSinceEpoch}.txt')
  );
  await temp.writeAsString('Temporary file');
  print('\nTemp file: ${
temp.path}');
  print('Exists: ${
await temp.exists()}');
  await temp.delete();

  print('\ndart:io examples complete!');
}

// ── FILE UTILITIES ─────────────
Future<int> fileSize(String path) async {
  final stat = await File(path).stat();
  return stat.size;
}

Future<bool> fileExists(String path) => File(path).exists();

Future<void> ensureDir(String path) =>
    Directory(path).create(recursive: true);

// Read JSON file
Future<Map<String, dynamic>> readJson(String path) async {
  final text = await File(path).readAsString();
  return jsonDecode(text) as Map<String, dynamic>;
}

// Write JSON file  
Future<void> writeJson(String path, Object data) async {
  final json = const JsonEncoder.withIndent('  ').convert(data);
  await File(path).writeAsString(json);
}

// Stream large file line by line
Stream<String> readLines(String path) {
  return File(path)
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter());
}

📝 KEY POINTS:
✅ dart:io is native-only — not available in Flutter Web
✅ All File and Directory operations are async (return Future or Stream)
✅ File.openRead().transform(utf8.decoder).transform(LineSplitter()) for streaming reads
✅ FileMode.append adds to existing file content
✅ Directory.list(recursive: true) walks the entire directory tree
✅ Platform.environment gives access to OS environment variables
✅ Process.run() runs a command and waits; Process.start() streams output
✅ For HTTP client in cross-platform code, use package:http instead of HttpClient
❌ Never use synchronous I/O (readAsStringSync()) in async contexts — blocks event loop
❌ dart:io imports will cause compilation failures for web targets
❌ Don't forget to close HttpClient after use — it holds connection pools
''',
  quiz: [
    Quiz(question: 'On which platforms is dart:io available?', options: [
      QuizOption(text: 'All Dart and Flutter platforms including web', correct: false),
      QuizOption(text: 'Native only: Dart CLI, Flutter mobile and desktop (not web)', correct: true),
      QuizOption(text: 'Only on server-side Dart', correct: false),
      QuizOption(text: 'Only on desktop platforms', correct: false),
    ]),
    Quiz(question: 'What is the memory-efficient way to read a large file line by line?', options: [
      QuizOption(text: 'file.readAsString().split("\\n")', correct: false),
      QuizOption(text: 'file.openRead().transform(utf8.decoder).transform(LineSplitter())', correct: true),
      QuizOption(text: 'file.readAsLines()', correct: false),
      QuizOption(text: 'Splitting the file into chunks with file.readAsBytesSync()', correct: false),
    ]),
    Quiz(question: 'What FileMode should you use to add content to an existing file without overwriting?', options: [
      QuizOption(text: 'FileMode.write', correct: false),
      QuizOption(text: 'FileMode.append', correct: true),
      QuizOption(text: 'FileMode.add', correct: false),
      QuizOption(text: 'FileMode.update', correct: false),
    ]),
  ],
);
