import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson38 = Lesson(
  language: 'Java',
  title: 'Networking and HTTP',
  content: """
🎯 METAPHOR:
Java networking is like the postal system. A socket is
your mailbox — it has an address (IP + port) where messages
arrive and from which you send. TCP is certified mail —
guaranteed delivery, correct order, confirmation of receipt.
UDP is a postcard — fast, cheap, but you're not guaranteed
it arrives and there's no order. The HttpClient is like
a courier service — you describe what you want (GET this
URL, POST this data), hand it off, and it handles all the
envelope-stuffing, routing, and delivery protocol for you.

📖 EXPLANATION:
Java networking covers low-level socket programming and
the modern HttpClient API. Most applications use HttpClient.

─────────────────────────────────────
JAVA NETWORKING STACK:
─────────────────────────────────────
  java.net.http.HttpClient  → modern HTTP/1.1 and HTTP/2 (Java 11)
  java.net.URL              → legacy URL handling
  java.net.URLConnection    → legacy HTTP connections
  java.net.Socket           → low-level TCP socket
  java.net.ServerSocket     → TCP server socket
  java.net.DatagramSocket   → UDP socket
  java.net.InetAddress      → IP address lookup

─────────────────────────────────────
HttpClient (Java 11) — modern HTTP:
─────────────────────────────────────
  // Create client (reuse for multiple requests!)
  HttpClient client = HttpClient.newBuilder()
      .version(HttpClient.Version.HTTP_2)
      .connectTimeout(Duration.ofSeconds(10))
      .followRedirects(HttpClient.Redirect.NORMAL)
      .build();

  // Build a request:
  HttpRequest request = HttpRequest.newBuilder()
      .uri(URI.create("https://api.example.com/users"))
      .header("Authorization", "Bearer token123")
      .header("Content-Type", "application/json")
      .GET()                     // or .POST(body), .PUT(body)
      .timeout(Duration.ofSeconds(30))
      .build();

  // Send synchronously:
  HttpResponse<String> response = client.send(request,
      HttpResponse.BodyHandlers.ofString());
  int status = response.statusCode();      // 200, 404, etc.
  String body = response.body();           // response body

  // Send asynchronously:
  CompletableFuture<HttpResponse<String>> future =
      client.sendAsync(request,
          HttpResponse.BodyHandlers.ofString());
  future.thenApply(HttpResponse::body)
        .thenAccept(System.out::println);

─────────────────────────────────────
REQUEST BODY PUBLISHERS:
─────────────────────────────────────
  HttpRequest.BodyPublishers.ofString("{\"name\":\"Terry\"}")
  HttpRequest.BodyPublishers.ofFile(Path.of("data.json"))
  HttpRequest.BodyPublishers.noBody()  // for GET/DELETE

─────────────────────────────────────
RESPONSE BODY HANDLERS:
─────────────────────────────────────
  HttpResponse.BodyHandlers.ofString()         // String
  HttpResponse.BodyHandlers.ofFile(path)       // save to file
  HttpResponse.BodyHandlers.ofByteArray()      // byte[]
  HttpResponse.BodyHandlers.ofLines()          // Stream<String>
  HttpResponse.BodyHandlers.discarding()       // discard body

─────────────────────────────────────
LOW-LEVEL SOCKETS:
─────────────────────────────────────
  // TCP Client:
  try (Socket socket = new Socket("host", 8080)) {
      PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
      BufferedReader in = new BufferedReader(
          new InputStreamReader(socket.getInputStream()));
      out.println("Hello Server!");
      String response = in.readLine();
  }

  // TCP Server:
  try (ServerSocket server = new ServerSocket(8080)) {
      while (true) {
          Socket client = server.accept();   // blocks until connection
          new Thread(() -> handleClient(client)).start();
      }
  }

─────────────────────────────────────
InetAddress — IP lookup:
─────────────────────────────────────
  InetAddress google = InetAddress.getByName("google.com");
  System.out.println(google.getHostAddress()); // "142.250.x.x"

  InetAddress local = InetAddress.getLocalHost();
  System.out.println(local.getHostName());

─────────────────────────────────────
URL — legacy (use HttpClient instead):
─────────────────────────────────────
  URL url = new URL("https://api.github.com/users/java");
  HttpURLConnection conn = (HttpURLConnection) url.openConnection();
  conn.setRequestMethod("GET");
  int code = conn.getResponseCode();
  // Read with BufferedReader(new InputStreamReader(conn.getInputStream()))

  Prefer HttpClient for all new code.

💻 CODE:
import java.net.*;
import java.net.http.*;
import java.io.*;
import java.time.*;
import java.util.concurrent.*;

public class NetworkingHTTP {
    public static void main(String[] args) throws Exception {

        // ─── InetAddress ──────────────────────────────────
        System.out.println("=== InetAddress ===");
        try {
            InetAddress localhost = InetAddress.getLocalHost();
            System.out.println("  Hostname:  " + localhost.getHostName());
            System.out.println("  Local IP:  " + localhost.getHostAddress());
            System.out.println("  Is loopback: " + localhost.isLoopbackAddress());

            InetAddress loopback = InetAddress.getByName("127.0.0.1");
            System.out.println("  127.0.0.1 loopback: " + loopback.isLoopbackAddress());
        } catch (UnknownHostException e) {
            System.out.println("  Could not resolve host: " + e.getMessage());
        }

        // ─── HttpClient — REAL API CALL ────────────────────
        System.out.println("\n=== HttpClient ===");

        HttpClient client = HttpClient.newBuilder()
            .version(HttpClient.Version.HTTP_2)
            .connectTimeout(Duration.ofSeconds(10))
            .followRedirects(HttpClient.Redirect.NORMAL)
            .build();

        // GET request to a real public API
        HttpRequest getRequest = HttpRequest.newBuilder()
            .uri(URI.create("https://httpbin.org/get?lang=java&version=21"))
            .header("Accept", "application/json")
            .header("User-Agent", "Java/21 HttpClient")
            .GET()
            .timeout(Duration.ofSeconds(15))
            .build();

        try {
            System.out.println("  Sending GET to httpbin.org/get...");
            HttpResponse<String> response = client.send(getRequest,
                HttpResponse.BodyHandlers.ofString());

            System.out.println("  Status: " + response.statusCode());
            System.out.println("  HTTP version: " + response.version());

            // Print selected headers
            response.headers().map().entrySet().stream()
                .filter(e -> e.getKey().equalsIgnoreCase("content-type") ||
                             e.getKey().equalsIgnoreCase("content-length"))
                .forEach(e -> System.out.println("  Header: " + e.getKey() + ": " + e.getValue()));

            // Print truncated body
            String body = response.body();
            System.out.println("  Body (first 200 chars):");
            System.out.println("  " + body.substring(0, Math.min(200, body.length())) + "...");

        } catch (IOException | InterruptedException e) {
            System.out.println("  Request failed: " + e.getMessage());
            System.out.println("  (Network may not be available in this environment)");
        }

        // ─── POST request (simulated) ─────────────────────
        System.out.println("\n  POST request (simulated — not sent):");
        String jsonBody = """
                {
                    "name": "Terry",
                    "email": "terry@example.com",
                    "role": "developer"
                }
                """;

        HttpRequest postRequest = HttpRequest.newBuilder()
            .uri(URI.create("https://api.example.com/users"))
            .header("Content-Type", "application/json")
            .header("Authorization", "Bearer eyJhbGciOiJIUzI1NiJ9...")
            .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
            .timeout(Duration.ofSeconds(30))
            .build();

        System.out.println("  Method:  " + postRequest.method());
        System.out.println("  URI:     " + postRequest.uri());
        System.out.println("  Headers: " + postRequest.headers().map().entrySet().stream()
            .map(e -> e.getKey() + "=" + e.getValue())
            .reduce((a, b) -> a + ", " + b).orElse(""));

        // ─── ASYNC HTTP (simulated) ───────────────────────
        System.out.println("\n=== Async HttpClient ===");
        System.out.println("  (Simulating async pattern — not sending real requests)");

        // Pattern demonstration
        HttpRequest asyncReq = HttpRequest.newBuilder()
            .uri(URI.create("https://api.example.com/data"))
            .GET()
            .build();

        // In real code:
        // CompletableFuture<HttpResponse<String>> future =
        //     client.sendAsync(asyncReq, HttpResponse.BodyHandlers.ofString());
        // future
        //     .thenApply(HttpResponse::body)
        //     .thenApply(body -> parseJson(body))
        //     .thenAccept(data -> updateUI(data))
        //     .exceptionally(ex -> { log(ex); return null; });

        System.out.println("  CompletableFuture pattern:");
        CompletableFuture<String> simulated = CompletableFuture
            .supplyAsync(() -> {
                // Simulate network delay
                try { Thread.sleep(100); } catch (InterruptedException e) {}
                return "{\"status\": \"ok\", \"data\": [1, 2, 3]}";
            })
            .thenApply(body -> "Parsed: " + body.replace("{", "< ").replace("}", " >"))
            .exceptionally(ex -> "Error: " + ex.getMessage());

        System.out.println("  Result: " + simulated.get(5, TimeUnit.SECONDS));

        // ─── TCP SOCKET (echo server simulation) ──────────
        System.out.println("\n=== TCP Socket (echo server) ===");

        // Start a tiny echo server in a thread
        ExecutorService pool = Executors.newCachedThreadPool();
        int port = 9876;
        CountDownLatch serverReady = new CountDownLatch(1);

        pool.submit(() -> {
            try (ServerSocket server = new ServerSocket(port)) {
                serverReady.countDown();
                try (Socket client = server.accept();
                     BufferedReader in = new BufferedReader(
                         new InputStreamReader(client.getInputStream()));
                     PrintWriter out = new PrintWriter(
                         client.getOutputStream(), true)) {

                    String line;
                    while ((line = in.readLine()) != null && !line.equals("QUIT")) {
                        out.println("ECHO: " + line);
                    }
                }
            } catch (IOException e) { /* server done */ }
        });

        serverReady.await(1, TimeUnit.SECONDS);

        // TCP Client
        try (Socket socket = new Socket("localhost", port);
             PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
             BufferedReader in  = new BufferedReader(
                 new InputStreamReader(socket.getInputStream()))) {

            String[] messages = {"Hello Server!", "Java Networking", "Test 123"};
            for (String msg : messages) {
                out.println(msg);
                String reply = in.readLine();
                System.out.println("  Sent: " + msg);
                System.out.println("  Got:  " + reply);
            }
            out.println("QUIT");
        } catch (IOException e) {
            System.out.println("  Socket error: " + e.getMessage());
        }

        pool.shutdown();
        System.out.println("  TCP echo demo complete");
    }
}

📝 KEY POINTS:
✅ HttpClient (Java 11) is the modern choice — supports HTTP/2 and async
✅ Reuse HttpClient across requests — it manages connection pools internally
✅ sendAsync() returns CompletableFuture — chain with thenApply/thenAccept
✅ BodyPublishers and BodyHandlers define how to send/receive the body
✅ Always set timeouts on HTTP requests to prevent hanging indefinitely
✅ ServerSocket.accept() blocks until a client connects — handle in a thread
✅ TCP sockets need explicit stream management with try-with-resources
✅ InetAddress resolves hostnames to IP addresses
❌ Don't use HttpURLConnection in new code — HttpClient replaces it
❌ Don't create a new HttpClient per request — it's expensive (pool)
❌ HTTP responses always have a body — always read or discard it to free connections
❌ Sockets are not thread-safe — each client connection needs its own thread
""",
  quiz: [
    Quiz(question: 'What is the advantage of using HttpClient.sendAsync() over sendAsync()?', options: [
      QuizOption(text: 'sendAsync() returns a CompletableFuture and does not block the calling thread', correct: true),
      QuizOption(text: 'sendAsync() is more reliable and retries automatically on failure', correct: false),
      QuizOption(text: 'sendAsync() supports HTTP/2 while send() only supports HTTP/1.1', correct: false),
      QuizOption(text: 'sendAsync() is faster because it skips SSL verification', correct: false),
    ]),
    Quiz(question: 'Why should you reuse HttpClient instances across requests?', options: [
      QuizOption(text: 'HttpClient manages a connection pool — reusing it enables connection reuse and is more efficient', correct: true),
      QuizOption(text: 'HttpClient is a singleton — Java only allows one per application', correct: false),
      QuizOption(text: 'Creating multiple clients causes port conflicts on the local machine', correct: false),
      QuizOption(text: 'HttpClient stores authentication tokens — a new client would need to re-authenticate', correct: false),
    ]),
    Quiz(question: 'What does ServerSocket.accept() do?', options: [
      QuizOption(text: 'Blocks the calling thread until a client connects, then returns a Socket for that connection', correct: true),
      QuizOption(text: 'Sends an HTTP 200 OK response to any incoming request automatically', correct: false),
      QuizOption(text: 'Starts listening for connections without blocking the thread', correct: false),
      QuizOption(text: 'Accepts all queued connections at once and returns a list of Sockets', correct: false),
    ]),
  ],
);
