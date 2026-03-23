import '../../models/lesson.dart';
import '../../models/quiz.dart';

final javaLesson41 = Lesson(
  language: 'Java',
  title: 'JDBC and Database Access',
  content: """
🎯 METAPHOR:
JDBC is like a universal language translator between Java
and any database. Different databases speak different
dialects — MySQL sounds nothing like PostgreSQL, which
sounds nothing like SQLite. Without JDBC, you'd need
to learn each dialect natively and rewrite your code for
every database you switch to. JDBC provides a single
standard conversation: "Give me a Connection, prepare
a Statement, execute it, read the ResultSet." The specific
dialect-to-SQL translation happens inside the DRIVER —
a library the database vendor provides. You speak JDBC;
the driver translates. Change databases, change the driver,
keep your Java code.

📖 EXPLANATION:
JDBC (Java Database Connectivity) is the standard API for
connecting to relational databases from Java.

─────────────────────────────────────
THE JDBC STACK:
─────────────────────────────────────
  Your Java Code
      ↕ JDBC API (java.sql.*)
  JDBC Driver Manager
      ↕ loads the appropriate driver
  Database Driver (vendor-provided JAR)
      ↕ protocol-specific communication
  Database (MySQL, PostgreSQL, SQLite, H2...)

─────────────────────────────────────
CORE JDBC INTERFACES:
─────────────────────────────────────
  Connection         → represents a DB connection
  Statement          → executes static SQL
  PreparedStatement  → parameterized SQL (preferred)
  CallableStatement  → stored procedures
  ResultSet          → rows returned from a query
  DatabaseMetaData   → DB info (tables, columns...)
  ResultSetMetaData  → column info for a ResultSet

─────────────────────────────────────
THE JDBC WORKFLOW:
─────────────────────────────────────
  1. Load driver (automatic since Java 6 with ServiceLoader)
  2. Get Connection from DriverManager or DataSource
  3. Create PreparedStatement with SQL
  4. Set parameters (bind values)
  5. Execute: executeQuery() for SELECT, executeUpdate() for INSERT/UPDATE/DELETE
  6. Process ResultSet
  7. Close resources (use try-with-resources!)

─────────────────────────────────────
CONNECTION URL FORMATS:
─────────────────────────────────────
  SQLite:     jdbc:sqlite:path/to/database.db
  H2 (mem):   jdbc:h2:mem:testdb
  MySQL:      jdbc:mysql://localhost:3306/mydb
  PostgreSQL: jdbc:postgresql://localhost:5432/mydb
  Oracle:     jdbc:oracle:thin:@localhost:1521:XE

─────────────────────────────────────
PreparedStatement vs Statement:
─────────────────────────────────────
  // ❌ NEVER do this — SQL injection vulnerability!
  String sql = "SELECT * FROM users WHERE name = '" + name + "'";
  Statement stmt = conn.createStatement();
  ResultSet rs = stmt.executeQuery(sql);

  // ✅ ALWAYS use PreparedStatement:
  String sql = "SELECT * FROM users WHERE name = ?";
  PreparedStatement ps = conn.prepareStatement(sql);
  ps.setString(1, name);   // 1-indexed!
  ResultSet rs = ps.executeQuery();

─────────────────────────────────────
TRANSACTION CONTROL:
─────────────────────────────────────
  conn.setAutoCommit(false);      // begin transaction
  try {
      ps.executeUpdate();         // first operation
      ps2.executeUpdate();        // second operation
      conn.commit();              // all or nothing
  } catch (SQLException e) {
      conn.rollback();            // undo both
      throw e;
  }

─────────────────────────────────────
DATASOURCE — production connection pooling:
─────────────────────────────────────
  Real apps use a connection pool (HikariCP, c3p0):
  Pool keeps N connections open and reuses them.

  HikariConfig config = new HikariConfig();
  config.setJdbcUrl("jdbc:postgresql://localhost/mydb");
  config.setMaximumPoolSize(10);
  DataSource ds = new HikariDataSource(config);

  try (Connection conn = ds.getConnection()) {
      // use conn, returned to pool when closed
  }

💻 CODE:
import java.sql.*;

// Using H2 in-memory database (no setup required for demos)
// H2 is a pure Java SQL database — perfect for learning and testing

public class JDBCDemo {

    static final String URL      = "jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1";
    static final String USER     = "sa";
    static final String PASSWORD = "";

    // ─── TABLE SETUP ──────────────────────────────────
    static void setupDatabase(Connection conn) throws SQLException {
        try (Statement stmt = conn.createStatement()) {
            // Create tables
            stmt.execute("""
                CREATE TABLE IF NOT EXISTS departments (
                    id   INTEGER PRIMARY KEY AUTO_INCREMENT,
                    name VARCHAR(100) NOT NULL UNIQUE
                )
                """);

            stmt.execute("""
                CREATE TABLE IF NOT EXISTS employees (
                    id         INTEGER PRIMARY KEY AUTO_INCREMENT,
                    name       VARCHAR(100) NOT NULL,
                    email      VARCHAR(200) UNIQUE,
                    dept_id    INTEGER REFERENCES departments(id),
                    salary     DECIMAL(10,2) NOT NULL,
                    hired_date DATE NOT NULL
                )
                """);

            // Seed departments
            stmt.execute("""
                INSERT INTO departments (name) VALUES
                ('Engineering'), ('Marketing'), ('HR'), ('Finance')
                """);

            // Seed employees
            stmt.execute("""
                INSERT INTO employees (name, email, dept_id, salary, hired_date) VALUES
                ('Alice Chen',  'alice@corp.com',   1, 95000.00, '2018-03-15'),
                ('Bob Smith',   'bob@corp.com',     2, 72000.00, '2020-07-01'),
                ('Carol Davis', 'carol@corp.com',   1, 110000.00,'2016-11-20'),
                ('Dave Wilson', 'dave@corp.com',    3, 65000.00, '2021-01-10'),
                ('Eve Johnson', 'eve@corp.com',     1,  88000.00,'2019-05-22'),
                ('Frank Lee',   'frank@corp.com',   4,  78000.00,'2017-09-08'),
                ('Grace Kim',   'grace@corp.com',   2,  74000.00,'2022-02-14'),
                ('Henry Brown', 'henry@corp.com',   1, 120000.00,'2015-06-30')
                """);
        }
        System.out.println("  Database initialized ✅");
    }

    // ─── BASIC SELECT ─────────────────────────────────
    static void demoSelect(Connection conn) throws SQLException {
        System.out.println("\n=== SELECT — Read all employees ===");

        String sql = "SELECT e.*, d.name AS dept FROM employees e " +
                     "JOIN departments d ON e.dept_id = d.id " +
                     "ORDER BY e.name";

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            System.out.printf("  %-15s %-10s %10s %-12s%n",
                "Name", "Dept", "Salary", "Hired");
            System.out.println("  " + "─".repeat(50));

            while (rs.next()) {
                System.out.printf("  %-15s %-10s %10s %-12s%n",
                    rs.getString("name"),
                    rs.getString("dept"),
                    String.format("$%,.0f", rs.getDouble("salary")),
                    rs.getDate("hired_date").toString());
            }
        }
    }

    // ─── PARAMETERIZED QUERY ──────────────────────────
    static void demoParameterized(Connection conn) throws SQLException {
        System.out.println("\n=== PreparedStatement — Parameterized queries ===");

        // Query by department
        String byDeptSQL = """
                SELECT e.name, e.salary
                FROM employees e
                JOIN departments d ON e.dept_id = d.id
                WHERE d.name = ?
                ORDER BY e.salary DESC
                """;

        try (PreparedStatement ps = conn.prepareStatement(byDeptSQL)) {
            for (String dept : new String[]{"Engineering", "Marketing"}) {
                ps.setString(1, dept);  // safe — no SQL injection!
                try (ResultSet rs = ps.executeQuery()) {
                    System.out.println("  " + dept + ":");
                    while (rs.next()) {
                        System.out.printf("    %-15s \$%,.0f%n",
                            rs.getString("name"), rs.getDouble("salary"));
                    }
                }
            }
        }

        // Range query
        String rangeSQL = "SELECT name, salary FROM employees WHERE salary BETWEEN ? AND ?";
        try (PreparedStatement ps = conn.prepareStatement(rangeSQL)) {
            ps.setDouble(1, 80_000);
            ps.setDouble(2, 110_000);
            try (ResultSet rs = ps.executeQuery()) {
                System.out.println("  Salary range\$80k-$110k:");
                while (rs.next()) {
                    System.out.printf("    %-15s \$%,.0f%n",
                        rs.getString("name"), rs.getDouble("salary"));
                }
            }
        }
    }

    // ─── INSERT, UPDATE, DELETE ───────────────────────
    static void demoCUD(Connection conn) throws SQLException {
        System.out.println("\n=== INSERT / UPDATE / DELETE ===");

        // INSERT
        String insertSQL = "INSERT INTO employees (name, email, dept_id, salary, hired_date) VALUES (?, ?, ?, ?, ?)";
        int newId;
        try (PreparedStatement ps = conn.prepareStatement(insertSQL,
                Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, "Ivy Park");
            ps.setString(2, "ivy@corp.com");
            ps.setInt(3, 1);
            ps.setDouble(4, 92_000.00);
            ps.setDate(5, Date.valueOf("2023-09-01"));
            int rows = ps.executeUpdate();
            System.out.println("  INSERT: " + rows + " row(s) affected");

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                newId = generatedKeys.next() ? generatedKeys.getInt(1) : -1;
                System.out.println("  Generated key: " + newId);
            }
        }

        // UPDATE
        String updateSQL = "UPDATE employees SET salary = salary * 1.1 WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(updateSQL)) {
            ps.setInt(1, newId);
            int rows = ps.executeUpdate();
            System.out.println("  UPDATE: " + rows + " row(s) affected (10% raise)");
        }

        // Verify update
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT name, salary FROM employees WHERE id = ?")) {
            ps.setInt(1, newId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    System.out.printf("  Verified: %s now earns\$%,.0f%n",
                        rs.getString("name"), rs.getDouble("salary"));
                }
            }
        }

        // DELETE
        try (PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM employees WHERE id = ?")) {
            ps.setInt(1, newId);
            int rows = ps.executeUpdate();
            System.out.println("  DELETE: " + rows + " row(s) affected");
        }
    }

    // ─── TRANSACTIONS ─────────────────────────────────
    static void demoTransactions(Connection conn) throws SQLException {
        System.out.println("\n=== Transactions ===");

        conn.setAutoCommit(false);
        try {
            // Operation 1: give Alice a raise
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE employees SET salary = salary + 5000 WHERE name = ?")) {
                ps.setString(1, "Alice Chen");
                int rows = ps.executeUpdate();
                System.out.println("  Op1: Updated " + rows + " row");
            }

            // Operation 2: record in a log table (simulated)
            // If this fails, both operations roll back
            System.out.println("  Op2: Simulated log entry");

            conn.commit();
            System.out.println("  ✅ Transaction committed");
        } catch (SQLException e) {
            conn.rollback();
            System.out.println("  ❌ Transaction rolled back: " + e.getMessage());
            throw e;
        } finally {
            conn.setAutoCommit(true);
        }
    }

    // ─── AGGREGATE QUERIES ────────────────────────────
    static void demoAggregates(Connection conn) throws SQLException {
        System.out.println("\n=== Aggregate Queries ===");

        String sql = """
                SELECT d.name AS dept,
                       COUNT(*) AS headcount,
                       AVG(e.salary) AS avg_salary,
                       MAX(e.salary) AS max_salary,
                       MIN(e.salary) AS min_salary
                FROM employees e
                JOIN departments d ON e.dept_id = d.id
                GROUP BY d.name
                ORDER BY avg_salary DESC
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            System.out.printf("  %-15s %9s %12s %12s %12s%n",
                "Dept", "Headcount", "Avg Salary", "Max Salary", "Min Salary");
            System.out.println("  " + "─".repeat(65));

            while (rs.next()) {
                System.out.printf("  %-15s %9d %12s %12s %12s%n",
                    rs.getString("dept"),
                    rs.getInt("headcount"),
                    String.format("$%,.0f", rs.getDouble("avg_salary")),
                    String.format("$%,.0f", rs.getDouble("max_salary")),
                    String.format("$%,.0f", rs.getDouble("min_salary")));
            }
        }
    }

    public static void main(String[] args) {
        // Note: requires H2 dependency on classpath
        // Maven: <dependency><groupId>com.h2database</groupId>
        //        <artifactId>h2</artifactId><version>2.2.224</version></dependency>
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD)) {
            System.out.println("=== JDBC with H2 In-Memory Database ===");
            System.out.println("  Connected: " + conn.getMetaData().getURL());
            System.out.println("  Driver: " + conn.getMetaData().getDriverName());

            setupDatabase(conn);
            demoSelect(conn);
            demoParameterized(conn);
            demoCUD(conn);
            demoTransactions(conn);
            demoAggregates(conn);

        } catch (SQLException e) {
            System.out.println("❌ Database error: " + e.getMessage());
            System.out.println("  (If H2 is not on classpath, add the dependency)");
            System.out.println("  SQLState: " + e.getSQLState());
        }
    }
}

📝 KEY POINTS:
✅ ALWAYS use PreparedStatement — never String concatenation for SQL (injection risk)
✅ Parameters in PreparedStatement are 1-indexed (setString(1, ...) not 0)
✅ Use try-with-resources for Connection, Statement, and ResultSet
✅ setAutoCommit(false) + commit()/rollback() for multi-step transactions
✅ RETURN_GENERATED_KEYS flag retrieves auto-generated primary keys after insert
✅ executeQuery() for SELECT; executeUpdate() for INSERT/UPDATE/DELETE
✅ Use a connection pool (HikariCP) in production — not raw DriverManager
✅ ResultSet is 1-indexed too: rs.getString(1) or rs.getString("column_name")
❌ NEVER concatenate user input into SQL strings — SQL injection is a critical vulnerability
❌ Don't forget to close ResultSet, Statement, and Connection (use try-with-resources)
❌ Don't call commit() inside a loop — batch the changes and commit once
❌ DriverManager is for demos/simple apps — use DataSource in production
""",
  quiz: [
    Quiz(question: 'Why should you always use PreparedStatement instead of Statement for user input?', options: [
      QuizOption(text: 'PreparedStatement uses parameterized queries that prevent SQL injection — unsafe input cannot alter the SQL structure', correct: true),
      QuizOption(text: 'PreparedStatement is faster because it caches the query plan', correct: false),
      QuizOption(text: 'Statement does not support parameters — you must use PreparedStatement for any variable data', correct: false),
      QuizOption(text: 'PreparedStatement automatically validates input types before sending to the database', correct: false),
    ]),
    Quiz(question: 'What does conn.setAutoCommit(false) do in JDBC?', options: [
      QuizOption(text: 'Begins a manual transaction — changes are not committed until you call commit() or rollback()', correct: true),
      QuizOption(text: 'Makes the connection read-only — no write operations are allowed', correct: false),
      QuizOption(text: 'Disables automatic driver reconnection on connection loss', correct: false),
      QuizOption(text: 'Batches all statements and sends them to the database at once', correct: false),
    ]),
    Quiz(question: 'What is the preferred approach to database connections in production Java applications?', options: [
      QuizOption(text: 'A connection pool like HikariCP via DataSource — reuses connections efficiently', correct: true),
      QuizOption(text: 'DriverManager.getConnection() called for every database request', correct: false),
      QuizOption(text: 'A single shared static Connection object reused by all threads', correct: false),
      QuizOption(text: 'One Connection per user session, closed when the session ends', correct: false),
    ]),
  ],
);
