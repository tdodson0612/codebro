import '../../models/lesson.dart';
import '../../models/quiz.dart';

final dartLesson51 = Lesson(
  language: 'Dart',
  title: 'Dart CLI Tools & Scripting',
  content: '''
🎯 METAPHOR:
Writing a CLI tool in Dart is like setting up a smart command
center. The keyboard (stdin) accepts orders. The screen (stdout)
displays results. The alarm system (stderr) reports problems.
Environment variables are the configuration panel pre-set
when the center opens. Command-line arguments are the
specific orders given at activation time. The exit code
is the mission status report: 0 means success, anything
else means something went wrong. Dart's dart:io library
gives you full access to this command center.

📖 EXPLANATION:
Dart runs natively on the command line. dart:io provides
stdin/stdout/stderr, process spawning, file system access,
and environment variables. The args package handles
argument parsing. dart compile exe compiles to a native
self-contained binary.

─────────────────────────────────────
📐 READING INPUT & OUTPUT
─────────────────────────────────────
import 'dart:io';

stdout.write('Enter name: ');
String? name = stdin.readLineSync();
print('Hello, \$name!');

stderr.writeln('Error: something went wrong');

exit(0);   // success
exit(1);   // failure

─────────────────────────────────────
⚙️  ENVIRONMENT & ARGUMENTS
─────────────────────────────────────
// Command-line arguments
void main(List<String> args) {
  print('Args: \$args');
}

// Environment variables
String? path = Platform.environment['PATH'];
String home = Platform.environment['HOME'] ?? '/';

// Platform info
print(Platform.operatingSystem);  // linux / macos / windows
print(Platform.numberOfProcessors);
print(Platform.version);

─────────────────────────────────────
📦 ARGS PACKAGE
─────────────────────────────────────
pub add args

final parser = ArgParser()
  ..addFlag('verbose', abbr: 'v', defaultsTo: false)
  ..addOption('output', abbr: 'o', defaultsTo: 'output.txt')
  ..addMultiOption('files', abbr: 'f');

final results = parser.parse(arguments);
bool verbose = results['verbose'] as bool;
String output = results['output'] as String;

─────────────────────────────────────
🔧 RUNNING PROCESSES
─────────────────────────────────────
import 'dart:io';

// Simple: run and wait
ProcessResult result = await Process.run('ls', ['-la']);
print(result.stdout);

// Streaming: show output as it runs
Process process = await Process.start('dart', ['analyze']);
process.stdout.pipe(stdout);
await process.exitCode;

// Shell commands
await Process.run('bash', ['-c', 'echo hello | tr a-z A-Z']);

─────────────────────────────────────
📦 COMPILING TO NATIVE BINARY
─────────────────────────────────────
dart compile exe bin/mytool.dart -o mytool
./mytool --help

The compiled binary:
  → No Dart SDK required to run
  → Fast startup (AOT compiled)
  → Distributable as a single file

─────────────────────────────────────
📁 FILE OPERATIONS IN CLI
─────────────────────────────────────
dart:io + pathlib:
  Directory.current    → current working directory
  File(path).readAsStringSync()
  File(path).writeAsStringSync(content)
  Directory(path).listSync()

💻 CODE:
import 'dart:io';
import 'dart:convert';

// ── BASIC I/O ─────────────────────

void basicIOExample() {
  // stdout — normal output
  stdout.writeln('Hello from Dart CLI!');
  stdout.write('Enter your name: ');

  // stdin — read user input
  final name = stdin.readLineSync(encoding: utf8) ?? 'World';
  print('Hello, \$name!');

  // stderr — error output (doesn't mix with stdout)
  stderr.writeln('Warning: this is stderr');

  // Exit codes
  // exit(0);    // success — uncomment to actually exit
  // exit(1);    // general error
  // exit(2);    // misuse of command
}

// ── COMMAND-LINE ARGUMENTS ────────

// Run: dart run bin/tool.dart --verbose -o output.txt file1.txt file2.txt
void parseArgsManually(List<String> args) {
  bool verbose = false;
  String? output;
  List<String> files = [];

  for (int i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--verbose':
      case '-v':
        verbose = true;
      case '--output':
      case '-o':
        output = args[++i];
      default:
        files.add(args[i]);
    }
  }

  print('verbose: \$verbose');
  print('output:  \$output');
  print('files:   \$files');
}

// ── USING args PACKAGE ────────────

// pubspec.yaml:
//   dependencies:
//     args: ^2.4.0

/*
import 'package:args/args.dart';
import 'package:args/command_runner.dart';

void argsPackageExample(List<String> arguments) {
  final parser = ArgParser()
    ..addFlag('verbose',
        abbr: 'v',
        negatable: false,
        help: 'Enable verbose output')
    ..addFlag('dry-run',
        abbr: 'n',
        help: 'Show what would be done without doing it')
    ..addOption('output',
        abbr: 'o',
        defaultsTo: 'output.txt',
        help: 'Output file path')
    ..addOption('format',
        allowed: ['json', 'yaml', 'text'],
        defaultsTo: 'text',
        help: 'Output format')
    ..addMultiOption('exclude',
        abbr: 'x',
        help: 'Patterns to exclude')
    ..addSeparator('Flags:')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show this help');

  try {
    final results = parser.parse(arguments);

    if (results['help'] as bool) {
      print('Usage: mytool [options] [files]');
      print(parser.usage);
      exit(0);
    }

    final verbose = results['verbose'] as bool;
    final output = results['output'] as String;
    final format = results['format'] as String;
    final rest = results.rest;  // positional args after options

    if (verbose) print('Verbose mode enabled');
    print('Output: \$output, Format: \$format');
    print('Files: \$rest');

  } on FormatException catch (e) {
    stderr.writeln('Error: \${e.message}');
    print(parser.usage);
    exit(1);
  }
}

// Command pattern for complex CLIs:
class BuildCommand extends Command {
  @override
  String get name => 'build';

  @override
  String get description => 'Build the project';

  BuildCommand() {
    argParser.addFlag('release', help: 'Build in release mode');
  }

  @override
  void run() {
    final isRelease = argResults!['release'] as bool;
    print('Building\${isRelease ? ' in release mode' : ''}...');
  }
}

void commandRunnerExample(List<String> args) {
  final runner = CommandRunner('mytool', 'A CLI tool for doing things')
    ..addCommand(BuildCommand());
    // ..addCommand(TestCommand())
    // ..addCommand(CleanCommand());

  runner.run(args).catchError((error) {
    stderr.writeln(error);
    exit(1);
  });
}
*/

// ── ENVIRONMENT VARIABLES ─────────

void envExample() {
  // Read environment variables
  final path = Platform.environment['PATH'] ?? 'not set';
  final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '/';
  final dartSdk = Platform.environment['DART_SDK'];
  final apiKey = Platform.environment['API_KEY'];

  print('HOME: \$home');
  print('PATH length: \${path.length}');
  print('DART_SDK: \$dartSdk');
  print('API_KEY: \${apiKey != null ? '***set***' : 'not set'}');

  // Platform info
  print('OS: \${Platform.operatingSystem}');
  print('OS version: \${Platform.operatingSystemVersion}');
  print('Processors: \${Platform.numberOfProcessors}');
  print('Script: \${Platform.script.path}');
  print('Dart version: \${Platform.version}');
  print('Is Windows: \${Platform.isWindows}');
  print('Is macOS: \${Platform.isMacOS}');
  print('Is Linux: \${Platform.isLinux}');
}

// ── RUNNING CHILD PROCESSES ───────

Future<void> processExample() async {
  // Run and capture output
  final result = await Process.run(
    'dart',
    ['--version'],
    runInShell: true,
  );

  print('Exit code: \${result.exitCode}');
  print('stdout: \${result.stdout}');
  if (result.stderr.isNotEmpty) print('stderr: \${result.stderr}');

  // Stream output in real-time
  print('Running dart analyze...');
  final process = await Process.start(
    'dart',
    ['analyze', '--fatal-infos'],
    runInShell: true,
  );

  // Pipe output to our stdout/stderr
  process.stdout
      .transform(utf8.decoder)
      .listen((line) => stdout.write(line));
  process.stderr
      .transform(utf8.decoder)
      .listen((line) => stderr.write(line));

  final exitCode = await process.exitCode;
  print('dart analyze exited with: \$exitCode');

  // Interactive process (write to stdin)
  final interactive = await Process.start('cat', []);
  interactive.stdin.writeln('Hello from Dart!');
  await interactive.stdin.flush();
  await interactive.stdin.close();
  final output = await interactive.stdout.transform(utf8.decoder).join();
  print('cat output: \$output');
}

// ── FILE SYSTEM ───────────────────

void fileSystemCLIExample() {
  // Current directory
  print('CWD: \${Directory.current.path}');

  // List directory contents
  final dir = Directory.current;
  for (final entity in dir.listSync()) {
    final type = entity is File ? 'F' : 'D';
    print('\$type  \${entity.path.split(Platform.pathSeparator).last}');
  }

  // Read a file
  final file = File('pubspec.yaml');
  if (file.existsSync()) {
    print(file.readAsStringSync());
  }

  // Write a file
  File('output.txt').writeAsStringSync('Hello from CLI!\n');

  // Temp file
  final temp = File('\${Directory.systemTemp.path}/dart_\${DateTime.now().millisecondsSinceEpoch}.tmp');
  temp.writeAsStringSync('temporary data');
  print('Temp file: \${temp.path}');
  temp.deleteSync();
}

// ── PROGRESS INDICATOR ────────────

void progressExample() async {
  final items = List.generate(10, (i) => 'item_\$i');
  int done = 0;

  for (final item in items) {
    await Future.delayed(const Duration(milliseconds: 100));
    done++;
    final pct = (done / items.length * 100).round();
    // Use \\r to overwrite current line
    stdout.write('\\rProcessing \$item... \$pct%');
  }
  print('\\nDone!');
}

void main(List<String> args) async {
  print('=== Dart CLI Demo ===\n');

  envExample();

  print('\n=== Processes ===');
  await processExample();

  print('\nDart CLI tools compile with:');
  print('  dart compile exe bin/tool.dart -o tool');
  print('  Then distribute the single binary!');
}

📝 KEY POINTS:
✅ stdin.readLineSync() blocks and reads a line from user input
✅ stderr.writeln() writes errors — keeps them separate from normal output
✅ exit(0) = success; exit(1+) = error — always set meaningful exit codes
✅ Platform.environment is a Map<String, String> of all environment variables
✅ Process.run() captures output; Process.start() streams it
✅ dart compile exe produces a self-contained native binary (no SDK needed)
✅ The args package simplifies flag/option parsing with --help generation
✅ Platform.isWindows/isMacOS/isLinux for OS-specific behavior
❌ Don't mix stdout and stderr output — errors go to stderr
❌ stdin.readLineSync() returns null at EOF — always handle the null case
❌ Never hardcode file paths with / — use Platform.pathSeparator or path package
''',
  quiz: [
    Quiz(question: 'What is the correct exit code for a successful CLI program?', options: [
      QuizOption(text: '1 — indicating one operation completed', correct: false),
      QuizOption(text: '0 — by convention, zero means success', correct: true),
      QuizOption(text: 'Any non-negative number', correct: false),
      QuizOption(text: 'The program does not need to call exit()', correct: false),
    ]),
    Quiz(question: 'What does dart compile exe do?', options: [
      QuizOption(text: 'Compiles Dart to JavaScript for the web', correct: false),
      QuizOption(text: 'Creates a self-contained native binary that runs without the Dart SDK', correct: true),
      QuizOption(text: 'Creates a .class file like Java', correct: false),
      QuizOption(text: 'Optimizes the Dart source code', correct: false),
    ]),
    Quiz(question: 'What is the difference between Process.run() and Process.start()?', options: [
      QuizOption(text: 'Process.run() is async; Process.start() is synchronous', correct: false),
      QuizOption(text: 'Process.run() waits and captures all output; Process.start() streams output in real-time', correct: true),
      QuizOption(text: 'Process.start() can only run shell scripts', correct: false),
      QuizOption(text: 'They are identical', correct: false),
    ]),
  ],
);
