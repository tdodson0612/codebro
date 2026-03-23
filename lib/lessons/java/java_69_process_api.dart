import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson69 = Lesson(
  language: 'Java',
  title: 'Process API: Running External Programs',
  content: """
🎯 METAPHOR:
The Process API is like a staffing agency manager who
can hire temporary workers (external processes) to do
specific jobs. You describe the job (command + arguments),
tell them where to work (working directory), set up their
environment (env vars), and whether to connect their
walkie-talkie to yours (inherit I/O vs redirect). The
worker does their job, reports back their results
(stdout, exit code), and is dismissed. ProcessHandle
is the agency's HR system — it lets you look up any
worker currently on the floor (any running process on
the OS), see what they're doing, and terminate them.

📖 EXPLANATION:
The Process API lets Java programs launch and interact
with external OS processes. Enhanced significantly in Java 9.

─────────────────────────────────────
PROCESSBUILDER — creating processes:
─────────────────────────────────────
  ProcessBuilder pb = new ProcessBuilder("ls", "-la");
  pb.directory(new File("/tmp"));           // working directory
  pb.environment().put("MY_VAR", "value");  // env vars
  pb.redirectErrorStream(true);             // merge stderr into stdout

  Process process = pb.start();

  // Read output:
  String output = new String(process.getInputStream().readAllBytes());

  // Wait for completion:
  int exitCode = process.waitFor();
  boolean ok = process.waitFor(5, TimeUnit.SECONDS);  // with timeout

  // Check while running:
  process.isAlive()
  process.pid()
  process.destroy()         // SIGTERM
  process.destroyForcibly() // SIGKILL

─────────────────────────────────────
REDIRECT OPTIONS:
─────────────────────────────────────
  // Inherit from JVM process (console I/O):
  pb.inheritIO();

  // Redirect to/from file:
  pb.redirectInput(inputFile)
  pb.redirectOutput(outputFile)
  pb.redirectError(errorFile)

  // Redirect output, append to file:
  pb.redirectOutput(ProcessBuilder.Redirect.appendTo(file))

  // Discard output:
  pb.redirectOutput(ProcessBuilder.Redirect.DISCARD)

─────────────────────────────────────
PIPELINE — chain processes (Java 9+):
─────────────────────────────────────
  // Equivalent to: ls | grep .java | wc -l
  List<ProcessBuilder> pipeline = List.of(
      new ProcessBuilder("ls"),
      new ProcessBuilder("grep", ".java"),
      new ProcessBuilder("wc", "-l")
  );
  List<Process> processes = ProcessBuilder.startPipeline(pipeline);
  Process last = processes.get(processes.size() - 1);
  String result = new String(last.getInputStream().readAllBytes());

─────────────────────────────────────
PROCESSHANDLE — introspect running processes (Java 9+):
─────────────────────────────────────
  // Current process:
  ProcessHandle current = ProcessHandle.current();
  long pid = current.pid();
  Optional<String> command = current.info().command();

  // Find a process by PID:
  Optional<ProcessHandle> ph = ProcessHandle.of(pid);

  // All processes:
  ProcessHandle.allProcesses()
      .filter(p -> p.info().command()
          .map(c -> c.contains("java")).orElse(false))
      .forEach(p -> System.out.println(p.pid() + ": " + p.info().command()));

  // Terminate:
  ph.ifPresent(p -> p.destroy());

  // Wait for termination (returns CompletableFuture):
  ph.ifPresent(p -> p.onExit().thenAccept(
      ph2 -> System.out.println("Process " + ph2.pid() + " exited")));

─────────────────────────────────────
ProcessHandle.Info — process metadata:
─────────────────────────────────────
  ProcessHandle.Info info = ProcessHandle.current().info();
  info.command()           → Optional<String> (executable path)
  info.arguments()         → Optional<String[]>
  info.commandLine()       → Optional<String>
  info.startInstant()      → Optional<Instant>
  info.totalCpuDuration()  → Optional<Duration>
  info.user()              → Optional<String>

─────────────────────────────────────
RUNTIME.exec() — legacy (prefer ProcessBuilder):
─────────────────────────────────────
  // Legacy — don't use for new code:
  Process p = Runtime.getRuntime().exec("ls -la");

  // ProcessBuilder is better: handles spaces in args,
  // working directory, env vars, stream redirection cleanly.

💻 CODE:
import java.io.*;
import java.util.*;
import java.util.concurrent.*;
import java.time.*;

public class ProcessAPIDemo {
    public static void main(String[] args) throws Exception {

        // ─── CURRENT PROCESS ──────────────────────────────
        System.out.println("=== Current Process Info ===");
        ProcessHandle current = ProcessHandle.current();
        System.out.println("  PID:     " + current.pid());
        current.info().command().ifPresent(c ->
            System.out.println("  Command: " + c));
        current.info().startInstant().ifPresent(s ->
            System.out.println("  Started: " + s));
        current.info().user().ifPresent(u ->
            System.out.println("  User:    " + u));

        // ─── RUNNING A SIMPLE COMMAND ─────────────────────
        System.out.println("\n=== Running External Command ===");

        // Cross-platform: use 'java -version'
        ProcessBuilder pb = new ProcessBuilder("java", "-version");
        pb.redirectErrorStream(true);  // merge stderr into stdout
        Process process = pb.start();

        String output = new String(process.getInputStream().readAllBytes());
        int exitCode = process.waitFor();
        System.out.println("  java -version output:");
        Arrays.stream(output.split("\n"))
            .forEach(l -> System.out.println("  " + l));
        System.out.println("  Exit code: " + exitCode);

        // ─── ECHO COMMAND ─────────────────────────────────
        System.out.println("\n=== Simple Echo ===");
        boolean isWindows = System.getProperty("os.name").toLowerCase().contains("windows");

        ProcessBuilder echoPb = isWindows
            ? new ProcessBuilder("cmd", "/c", "echo", "Hello from subprocess!")
            : new ProcessBuilder("echo", "Hello from subprocess!");

        echoPb.redirectErrorStream(true);
        Process echoProc = echoPb.start();
        System.out.println("  " + new String(echoProc.getInputStream().readAllBytes()).trim());
        echoProc.waitFor();

        // ─── PROCESS WITH TIMEOUT ─────────────────────────
        System.out.println("\n=== Process with Timeout ===");
        // A command that runs for a bit
        ProcessBuilder sleepPb = isWindows
            ? new ProcessBuilder("timeout", "/t", "10")
            : new ProcessBuilder("sleep", "10");

        Process sleepProc = sleepPb.start();
        System.out.println("  Process started (PID=" + sleepProc.pid() + ")");

        boolean finished = sleepProc.waitFor(200, TimeUnit.MILLISECONDS);
        System.out.println("  Finished in 200ms? " + finished);

        if (!finished) {
            sleepProc.destroyForcibly();
            System.out.println("  Forcibly terminated!");
            sleepProc.waitFor();
        }
        System.out.println("  Exit code: " + sleepProc.exitValue());

        // ─── ENVIRONMENT VARIABLES ────────────────────────
        System.out.println("\n=== Custom Environment ===");
        ProcessBuilder envPb = isWindows
            ? new ProcessBuilder("cmd", "/c", "echo %MY_CUSTOM_VAR%")
            : new ProcessBuilder("sh", "-c", "echo $MY_CUSTOM_VAR");

        envPb.environment().put("MY_CUSTOM_VAR", "Hello from Java!");
        envPb.redirectErrorStream(true);

        Process envProc = envPb.start();
        String envOutput = new String(envProc.getInputStream().readAllBytes()).trim();
        System.out.println("  Custom var: " + envOutput);
        envProc.waitFor();

        // ─── WORKING DIRECTORY ────────────────────────────
        System.out.println("\n=== Working Directory ===");
        File tmpDir = new File(System.getProperty("java.io.tmpdir"));
        ProcessBuilder pwdPb = isWindows
            ? new ProcessBuilder("cmd", "/c", "cd")
            : new ProcessBuilder("pwd");
        pwdPb.directory(tmpDir);
        pwdPb.redirectErrorStream(true);

        Process pwdProc = pwdPb.start();
        System.out.println("  PWD: " + new String(pwdProc.getInputStream().readAllBytes()).trim());
        pwdProc.waitFor();

        // ─── PROCESSHANDLE — ALL JAVA PROCESSES ───────────
        System.out.println("\n=== ProcessHandle — Running Java Processes ===");
        ProcessHandle.allProcesses()
            .filter(ph -> ph.info().command()
                .map(c -> c.toLowerCase().contains("java"))
                .orElse(false))
            .limit(5)
            .forEach(ph -> {
                String cmd = ph.info().command().orElse("unknown");
                System.out.printf("  PID %-8d: %s%n", ph.pid(),
                    cmd.length() > 50 ? "..." + cmd.substring(cmd.length() - 47) : cmd);
            });

        // ─── ASYNC PROCESS COMPLETION ─────────────────────
        System.out.println("\n=== Async Process Completion ===");
        ProcessBuilder asyncPb = isWindows
            ? new ProcessBuilder("cmd", "/c", "timeout /t 1 /nobreak >nul && echo done")
            : new ProcessBuilder("sh", "-c", "sleep 0.5 && echo done");
        asyncPb.redirectErrorStream(true);
        Process asyncProc = asyncPb.start();

        CompletableFuture<String> result = asyncProc.onExit()
            .thenApply(p -> {
                try {
                    return new String(p.getInputStream().readAllBytes()).trim();
                } catch (IOException e) {
                    return "error: " + e.getMessage();
                }
            });

        System.out.println("  Waiting for async process...");
        System.out.println("  Result: " + result.get(3, TimeUnit.SECONDS));
    }
}

📝 KEY POINTS:
✅ ProcessBuilder is preferred over Runtime.getRuntime().exec() — handles spaces, env, cwd
✅ redirectErrorStream(true) merges stderr into stdout — one stream to read
✅ process.waitFor(timeout, unit) prevents hanging on slow/stuck processes
✅ process.destroyForcibly() sends SIGKILL — use destroy() (SIGTERM) first when possible
✅ Pass command as separate strings, NOT as one string: new ProcessBuilder("ls", "-la")
✅ ProcessHandle.current().pid() gets the JVM's own process ID
✅ ProcessHandle.allProcesses() streams all running OS processes
✅ process.onExit() returns CompletableFuture<Process> — async process completion
✅ pb.directory(file) sets the working directory; pb.environment() sets env vars
❌ Don't pass "ls -la" as a single string — spaces in args need separate strings
❌ Don't forget to waitFor() — zombie processes accumulate if not waited on
❌ process.getInputStream() is the process's STDOUT (confusing naming)
❌ Not reading stdout can cause deadlock — process fills buffer and blocks
""",
  quiz: [
    Quiz(question: 'Why should you pass command arguments as separate strings in ProcessBuilder?', options: [
      QuizOption(text: 'Spaces in a single string are NOT split into arguments — "ls -la" is treated as one argument, not two', correct: true),
      QuizOption(text: 'Separate strings allow each argument to be encrypted independently', correct: false),
      QuizOption(text: 'ProcessBuilder requires at least 3 separate strings for valid commands', correct: false),
      QuizOption(text: 'Single string commands only work on Unix — Windows requires separate strings', correct: false),
    ]),
    Quiz(question: 'What does process.getInputStream() return?', options: [
      QuizOption(text: 'The standard output (stdout) of the process — the name is confusing since it reads from the process', correct: true),
      QuizOption(text: 'The standard input (stdin) stream for sending data TO the process', correct: false),
      QuizOption(text: 'The error stream (stderr) of the process', correct: false),
      QuizOption(text: 'A stream for reading the process\'s exit code and status', correct: false),
    ]),
    Quiz(question: 'What can happen if you don\'t read a process\'s stdout when it produces large output?', options: [
      QuizOption(text: 'The process fills its output buffer, blocks waiting for it to be read, causing deadlock', correct: true),
      QuizOption(text: 'The output is silently discarded and the process continues normally', correct: false),
      QuizOption(text: 'The process terminates automatically with exit code 1', correct: false),
      QuizOption(text: 'Java throws a BufferOverflowException when the output exceeds 4KB', correct: false),
    ]),
  ],
);
