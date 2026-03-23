import '../../models/lesson.dart';
import '../../models/quiz.dart';

final csharpLesson77 = Lesson(
  language: 'C#',
  title: 'Configuration and App Settings',
  content: """
🎯 METAPHOR:
Configuration is like the settings menu of your application.
Some settings come from the factory (appsettings.json —
your defaults). Some come from the local store (environment
variables — the deployment environment overrides). Some
come from the manager's override (command-line arguments —
highest priority). The configuration system layers them all,
with later sources winning, so you can have sensible defaults
that the environment can override without changing code.

📖 EXPLANATION:
Microsoft.Extensions.Configuration provides a unified
configuration system with multiple sources and priorities.

CONFIGURATION SOURCES (ascending priority):
  appsettings.json           base settings
  appsettings.{env}.json     environment-specific overrides
  Environment variables      deployment overrides
  Command-line arguments     highest priority
  User secrets (dev only)    local dev secrets (not committed)
  Azure Key Vault            production secrets

─────────────────────────────────────
IConfiguration API:
─────────────────────────────────────
  config["Key"]                simple key access
  config["Section:Key"]        nested key (colon separator)
  config.GetSection("X")       get a configuration section
  config.GetValue<T>("Key")    typed get with optional default
  section.Bind(myObject)       populate an object from section
  section.Get<T>()             deserialize section to T

─────────────────────────────────────
IOPTIONS VARIANTS:
─────────────────────────────────────
  IOptions<T>          singleton — read once at startup
  IOptionsSnapshot<T>  scoped — re-reads per request
  IOptionsMonitor<T>   live reload when config file changes

─────────────────────────────────────
ENVIRONMENT VARIABLE NAMING:
─────────────────────────────────────
  Colon (:) in config path → double underscore (__) in env vars
  Database:ConnectionString → Database__ConnectionString

💻 CODE:
using System;
using System.IO;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

// ─── SETTINGS CLASSES ─────────────────────────────────
class DatabaseSettings
{
    public string ConnectionString { get; set; }
    public int MaxPoolSize { get; set; } = 100;
    public int CommandTimeout { get; set; } = 30;
}

class EmailSettings
{
    public string SmtpHost { get; set; }
    public int SmtpPort { get; set; } = 587;
    public string FromAddress { get; set; }
    public bool UseSsl { get; set; } = true;
}

// ─── SERVICE USING IOptions<T> ────────────────────────
class EmailService
{
    private readonly EmailSettings _settings;

    public EmailService(IOptions<EmailSettings> options)
    {
        _settings = options.Value;
    }

    public void SendEmail(string to, string subject)
    {
        Console.WriteLine(\$"Sending via {_settings.SmtpHost}:{_settings.SmtpPort}");
        Console.WriteLine(\$"  From: {_settings.FromAddress}");
        Console.WriteLine(\$"  To: {to}, Subject: {subject}");
    }
}

class Program
{
    static void Main(string[] args)
    {
        // ─── CREATE SAMPLE appsettings.json ───────────────
        const string appSettings = @"
{
    ""AppName"": ""MyApp"",
    ""Environment"": ""Development"",
    ""Database"": {
        ""ConnectionString"": ""Server=localhost;Database=mydb"",
        ""MaxPoolSize"": 50,
        ""CommandTimeout"": 60
    },
    ""Email"": {
        ""SmtpHost"": ""smtp.example.com"",
        ""SmtpPort"": 587,
        ""FromAddress"": ""app@example.com"",
        ""UseSsl"": true
    },
    ""Logging"": {
        ""LogLevel"": {
            ""Default"": ""Information"",
            ""Microsoft"": ""Warning""
        }
    }
}";
        File.WriteAllText("appsettings.json", appSettings);

        // ─── BUILD CONFIGURATION ───────────────────────────
        IConfiguration config = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
            .AddJsonFile("appsettings.Development.json", optional: true)
            .AddEnvironmentVariables()    // overrides JSON
            .AddCommandLine(args)         // overrides everything
            .Build();

        // ─── READ VALUES ───────────────────────────────────
        Console.WriteLine("=== Reading Configuration ===");
        string appName = config["AppName"];
        Console.WriteLine(\$"AppName: {appName}");

        // Nested key with colon separator:
        string connStr = config["Database:ConnectionString"];
        Console.WriteLine(\$"DB: {connStr}");

        // Typed get with default:
        int maxPool = config.GetValue<int>("Database:MaxPoolSize", defaultValue: 100);
        Console.WriteLine(\$"MaxPoolSize: {maxPool}");

        bool debug = config.GetValue<bool>("Debug", defaultValue: false);
        Console.WriteLine(\$"Debug (missing key, default): {debug}");

        // ─── BIND TO TYPED CLASS ───────────────────────────
        Console.WriteLine("\n=== Binding to Typed Classes ===");

        // Option 1: Bind() populates an existing object
        var dbSettings = new DatabaseSettings();
        config.GetSection("Database").Bind(dbSettings);
        Console.WriteLine(\$"ConnectionString: {dbSettings.ConnectionString}");
        Console.WriteLine(\$"CommandTimeout: {dbSettings.CommandTimeout}s");

        // Option 2: Get<T>() creates and populates a new object
        var emailSettings = config.GetSection("Email").Get<EmailSettings>();
        Console.WriteLine(\$"SMTP: {emailSettings.SmtpHost}:{emailSettings.SmtpPort}");
        Console.WriteLine(\$"SSL: {emailSettings.UseSsl}");

        // ─── DEPENDENCY INJECTION WITH IOptions<T> ────────
        Console.WriteLine("\n=== IOptions<T> with DI ===");

        var services = new ServiceCollection();

        // Register configuration
        services.AddSingleton<IConfiguration>(config);

        // Bind config sections to Options:
        services.Configure<DatabaseSettings>(config.GetSection("Database"));
        services.Configure<EmailSettings>(config.GetSection("Email"));

        // Register services:
        services.AddTransient<EmailService>();

        var provider = services.BuildServiceProvider();

        // Use service — EmailSettings injected via IOptions<EmailSettings>:
        var emailSvc = provider.GetRequiredService<EmailService>();
        emailSvc.SendEmail("alice@example.com", "Welcome!");

        // Direct IOptions access:
        var dbOpts = provider.GetRequiredService<IOptions<DatabaseSettings>>();
        Console.WriteLine(\$"\nFrom IOptions — MaxPoolSize: {dbOpts.Value.MaxPoolSize}");

        // ─── ENVIRONMENT VARIABLE OVERRIDE ────────────────
        Console.WriteLine("\n=== Environment Variable Override ===");
        Console.WriteLine("Set env var: Database__ConnectionString=Server=prod;...");
        Console.WriteLine("Double underscore __ maps to colon : in config path");

        string envOverride = Environment.GetEnvironmentVariable("Database__ConnectionString");
        if (envOverride != null)
            Console.WriteLine(\$"Env override active: {envOverride}");
        else
            Console.WriteLine("(No env override set — using appsettings.json value)");

        // ─── CONFIGURATION SECTIONS ───────────────────────
        Console.WriteLine("\n=== Iterating Config Sections ===");
        var loggingSection = config.GetSection("Logging:LogLevel");
        foreach (var child in loggingSection.GetChildren())
        {
            Console.WriteLine(\$"  {child.Key}: {child.Value}");
        }

        // ─── VALIDATION WITH OPTIONS ───────────────────────
        Console.WriteLine("\n=== Options Validation (pattern) ===");
        services.AddOptions<DatabaseSettings>()
            .Bind(config.GetSection("Database"))
            .Validate(db =>
            {
                if (string.IsNullOrWhiteSpace(db.ConnectionString))
                    return false;
                if (db.MaxPoolSize < 1 || db.MaxPoolSize > 1000)
                    return false;
                return true;
            }, "Database configuration is invalid");

        Console.WriteLine("Validation configured — throws OptionsValidationException");
        Console.WriteLine("if validation fails on first IOptions<T>.Value access");

        // ─── USER SECRETS (dev only) ───────────────────────
        Console.WriteLine("\n=== User Secrets ===");
        Console.WriteLine("In development, add to ConfigurationBuilder:");
        Console.WriteLine("  .AddUserSecrets<Program>()");
        Console.WriteLine("Then set secrets with:");
        Console.WriteLine("  dotnet user-secrets set 'Database:Password' 'dev-password'");
        Console.WriteLine("Stored in: ~/.microsoft/usersecrets/<guid>/secrets.json");
        Console.WriteLine("NEVER committed to source control!");

        // Cleanup:
        File.Delete("appsettings.json");
    }
}

📝 KEY POINTS:
✅ Configuration sources layer — later sources override earlier ones
✅ Use IOptions<T> to inject typed settings into services via DI
✅ Colon (:) in config path → double underscore (__) in environment variables
✅ GetValue<T>("Key", defaultValue) is safe — returns default if key missing
✅ Use User Secrets for local dev secrets — never commit secrets to source control
✅ AddOptions<T>().Validate(...) adds startup validation for misconfiguration
✅ IOptionsMonitor<T> enables live config reload without restarting the app
❌ Never put production secrets in appsettings.json — use env vars or Key Vault
❌ Don't read IConfiguration directly deep in services — prefer IOptions<T>
❌ Don't create new ConfigurationBuilder() inside a request — build once at startup
""",
  quiz: [
    Quiz(question: 'How do you represent the nested config key "Database:ConnectionString" as an environment variable?', options: [
      QuizOption(text: 'Database__ConnectionString — double underscore replaces the colon', correct: true),
      QuizOption(text: 'Database.ConnectionString — dot notation', correct: false),
      QuizOption(text: 'DATABASE_CONNECTIONSTRING — uppercase with underscore', correct: false),
      QuizOption(text: 'Database-ConnectionString — hyphen separator', correct: false),
    ]),
    Quiz(question: 'What is the difference between IOptions<T> and IOptionsMonitor<T>?', options: [
      QuizOption(text: 'IOptions<T> is read once at startup (singleton); IOptionsMonitor<T> reflects live config file changes', correct: true),
      QuizOption(text: 'IOptionsMonitor<T> is read-only; IOptions<T> allows modifying settings at runtime', correct: false),
      QuizOption(text: 'They are identical — different names for the same interface', correct: false),
      QuizOption(text: 'IOptions<T> is for JSON only; IOptionsMonitor<T> works with all sources', correct: false),
    ]),
    Quiz(question: 'Which configuration source has the highest priority in the default setup?', options: [
      QuizOption(text: 'Command-line arguments — they override all other sources', correct: true),
      QuizOption(text: 'appsettings.json — it is the primary configuration file', correct: false),
      QuizOption(text: 'Environment variables — deployment settings take priority', correct: false),
      QuizOption(text: 'All sources have equal priority — last one registered wins', correct: false),
    ]),
  ],
);