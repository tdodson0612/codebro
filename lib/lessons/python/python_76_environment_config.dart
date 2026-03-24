import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson76 = Lesson(
  language: 'Python',
  title: 'Environment & Configuration Management',
  content: """
🎯 METAPHOR:
Configuration is like the settings on a professional camera.
A photographer doesn't re-solder circuits to change exposure.
They turn dials (config files, env vars). Your production
server shouldn't require code changes to point at a different
database — it just reads a different DATABASE_URL from the
environment. The code is fixed; the dials change.
Environment variables are the dials for your deployed code,
config files are the saved presets, and secrets management
is locking the camera in a safe between shoots.

📖 EXPLANATION:
Good configuration management separates code from config,
uses environment variables for secrets, and provides
sensible defaults with clear validation.

─────────────────────────────────────
📦 CONFIGURATION SOURCES (priority)
─────────────────────────────────────
1. Command-line arguments (highest priority)
2. Environment variables
3. .env files (local development)
4. Config files (JSON/YAML/TOML)
5. Default values in code (lowest priority)

─────────────────────────────────────
🔑 ENVIRONMENT VARIABLES
─────────────────────────────────────
os.environ["KEY"]           → get (KeyError if missing)
os.environ.get("KEY")       → get or None
os.environ.get("KEY", "d")  → get or default
os.environ.setdefault("K","d") → set if not present

python-dotenv loads .env files:
  pip install python-dotenv
  from dotenv import load_dotenv
  load_dotenv()   # loads .env into os.environ

─────────────────────────────────────
📄 CONFIG FILE FORMATS
─────────────────────────────────────
JSON    → json module (built-in)
TOML    → tomllib (Python 3.11+) / tomli (pip)
YAML    → pyyaml (pip)
INI     → configparser (built-in)
.env    → python-dotenv (pip)

─────────────────────────────────────
🏗️  PYDANTIC SETTINGS (best practice)
─────────────────────────────────────
pip install pydantic-settings

class Settings(BaseSettings):
    database_url: str
    debug: bool = False
    # Reads from env, .env file, and validates

💻 CODE:
import os
import json
import configparser
from pathlib import Path
from dataclasses import dataclass, field
from typing import Optional

# ── ENVIRONMENT VARIABLES ─────────

# Read env vars safely
db_url   = os.environ.get("DATABASE_URL", "sqlite:///dev.db")
debug    = os.environ.get("DEBUG", "false").lower() == "true"
port     = int(os.environ.get("PORT", "8080"))
api_key  = os.environ.get("API_KEY")   # None if not set

# Validate required variables
def require_env(*keys: str) -> dict:
    '''Get required env vars or raise with clear message.'''
    result = {}
    missing = []
    for key in keys:
        val = os.environ.get(key)
        if val is None:
            missing.append(key)
        else:
            result[key] = val
    if missing:
        raise EnvironmentError(
            f"Required environment variables not set: {', '.join(missing)}\\n"
            f"Set them in .env file or system environment."
        )
    return result

# ── .ENV FILE HANDLING ────────────

# .env file format:
DOT_ENV_EXAMPLE = '''
# Development settings
DATABASE_URL=postgresql://localhost/mydb_dev
SECRET_KEY=dev-secret-key-change-in-prod
DEBUG=true
PORT=8000
API_KEY=sk_test_abc123

# Multiline value
DESCRIPTION="A great
multiline value"

# These override system env vars by default? No — dotenv
# respects already-set environment variables unless override=True
'''

# Load .env file (requires: pip install python-dotenv)
DOTENV_USAGE = '''
from dotenv import load_dotenv, dotenv_values

# Load into os.environ
load_dotenv()                    # loads .env in current dir
load_dotenv(".env.production")   # specific file
load_dotenv(override=True)       # override existing env vars

# Load as dict WITHOUT touching os.environ
config = dotenv_values(".env")
print(config["DATABASE_URL"])
'''

# ── JSON CONFIG ───────────────────

# config.json
default_config = {
    "app": {
        "name": "MyApp",
        "version": "1.0.0",
        "debug": False,
    },
    "database": {
        "host": "localhost",
        "port": 5432,
        "name": "mydb",
        "pool_size": 10,
    },
    "logging": {
        "level": "INFO",
        "format": "%(asctime)s %(levelname)s %(message)s",
    },
    "features": {
        "new_ui": False,
        "beta_api": False,
    }
}

# Write default config
config_path = Path("config.json")
if not config_path.exists():
    config_path.write_text(json.dumps(default_config, indent=2))

# Load config with deep merge
def load_config(config_file: str = "config.json") -> dict:
    '''Load config file, falling back to defaults.'''
    config = default_config.copy()
    path = Path(config_file)
    if path.exists():
        user_config = json.loads(path.read_text())
        deep_merge(config, user_config)
    return config

def deep_merge(base: dict, override: dict) -> dict:
    '''Deep merge override into base (modifies base).'''
    for key, value in override.items():
        if key in base and isinstance(base[key], dict) and isinstance(value, dict):
            deep_merge(base[key], value)
        else:
            base[key] = value
    return base

config = load_config()
print(config["app"]["name"])       # MyApp
print(config["database"]["host"])  # localhost

# ── CONFIGPARSER (INI format) ──────

# config.ini format:
# [database]
# host = localhost
# port = 5432
# name = mydb
#
# [logging]
# level = INFO

parser = configparser.ConfigParser()
parser.read_dict({
    "database": {"host": "localhost", "port": "5432"},
    "logging":  {"level": "INFO"},
})

print(parser["database"]["host"])           # localhost
print(parser.getint("database", "port"))    # 5432 (as int!)
print(parser.get("logging", "level"))       # INFO
print(parser.get("missing", "key", fallback="default"))

# ── TOML CONFIG (Python 3.11+) ────

TOML_EXAMPLE = '''
# config.toml
[app]
name = "MyApp"
version = "1.0.0"
debug = false

[database]
host = "localhost"
port = 5432
name = "mydb"
pool_size = 10

[logging]
level = "INFO"
'''

TOML_USAGE = '''
# Python 3.11+
import tomllib

with open("config.toml", "rb") as f:
    config = tomllib.load(f)

print(config["database"]["host"])

# For older Python: pip install tomli
import tomli
with open("config.toml", "rb") as f:
    config = tomli.load(f)
'''

# ── PYDANTIC SETTINGS ─────────────

PYDANTIC_SETTINGS_EXAMPLE = '''
from pydantic_settings import BaseSettings
from pydantic import Field, SecretStr

class DatabaseSettings(BaseSettings):
    host: str = "localhost"
    port: int = 5432
    name: str = "mydb"
    password: SecretStr   # never logged!

    class Config:
        env_prefix = "DB_"   # DB_HOST, DB_PORT, etc.

class AppSettings(BaseSettings):
    app_name: str = "MyApp"
    debug: bool = False
    secret_key: SecretStr
    database: DatabaseSettings = DatabaseSettings()

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"
        case_sensitive = False

# Singleton pattern
_settings: AppSettings | None = None

def get_settings() -> AppSettings:
    global _settings
    if _settings is None:
        _settings = AppSettings()
    return _settings

settings = get_settings()
print(settings.app_name)
print(settings.debug)
# print(settings.secret_key)  → would print "**secret**"
# print(settings.secret_key.get_secret_value())  → actual value
'''

# ── LAYERED CONFIG SYSTEM ─────────

class LayeredConfig:
    '''Config that merges defaults < file < env vars < kwargs.'''

    def __init__(self, config_file: str = None, **overrides):
        self._config = {}

        # Layer 1: defaults
        self._apply_defaults()

        # Layer 2: config file
        if config_file and Path(config_file).exists():
            self._load_file(config_file)

        # Layer 3: environment variables (APP_ prefix)
        self._load_env("APP_")

        # Layer 4: direct overrides
        self._config.update(overrides)

    def _apply_defaults(self):
        self._config.update({
            "debug": False,
            "port": 8080,
            "log_level": "INFO",
        })

    def _load_file(self, path: str):
        with open(path) as f:
            file_config = json.load(f)
        self._config.update(file_config)

    def _load_env(self, prefix: str):
        for key, value in os.environ.items():
            if key.startswith(prefix):
                config_key = key[len(prefix):].lower()
                # Type coercion for known types
                if value.lower() in ("true", "false"):
                    value = value.lower() == "true"
                elif value.isdigit():
                    value = int(value)
                self._config[config_key] = value

    def get(self, key: str, default=None):
        return self._config.get(key, default)

    def __getitem__(self, key: str):
        return self._config[key]

    def __repr__(self):
        return f"LayeredConfig({self._config})"

cfg = LayeredConfig(debug=True)
print(f"debug={cfg['debug']}, port={cfg['port']}")

# ── .GITIGNORE FOR CONFIG ─────────
GITIGNORE_ENTRIES = '''
# Config files with secrets — NEVER commit these
.env
.env.local
.env.production
config.local.json
secrets.yaml

# But DO commit:
# config.example.json  (template with fake values)
# config.json          (if no secrets — just structure)
'''

print("Configuration management examples ready!")
Path("config.json").unlink(missing_ok=True)

📝 KEY POINTS:
✅ Never hardcode secrets — use environment variables
✅ python-dotenv loads .env files — use for local development
✅ .env files must NEVER be committed to version control
✅ Provide a .env.example with fake values as documentation
✅ pydantic-settings is the most robust way to manage settings
✅ Use SecretStr for passwords — prevents accidental logging
✅ Layer configs: defaults → file → env vars → runtime overrides
❌ Committing .env or config files with secrets to git — catastrophic
❌ Reading secrets from config files in production — use env vars or secrets manager
❌ No validation on config values — use pydantic-settings or manual checks
""",
  quiz: [
    Quiz(question: 'What is the correct priority order for configuration sources?', options: [
      QuizOption(text: 'Config files highest, then env vars, then defaults', correct: false),
      QuizOption(text: 'CLI args > env vars > config files > defaults', correct: true),
      QuizOption(text: 'All sources have equal priority', correct: false),
      QuizOption(text: 'Defaults are highest priority to ensure stability', correct: false),
    ]),
    Quiz(question: 'Which file should NEVER be committed to version control?', options: [
      QuizOption(text: 'config.json with application settings', correct: false),
      QuizOption(text: '.env containing secrets and API keys', correct: true),
      QuizOption(text: '.env.example with placeholder values', correct: false),
      QuizOption(text: 'pyproject.toml with build settings', correct: false),
    ]),
    Quiz(question: 'What does pydantic SecretStr do?', options: [
      QuizOption(text: 'Encrypts the string with AES', correct: false),
      QuizOption(text: 'Prevents the secret value from being printed or logged accidentally', correct: true),
      QuizOption(text: 'Stores the string in a hardware security module', correct: false),
      QuizOption(text: 'Hashes the value so it cannot be recovered', correct: false),
    ]),
  ],
);
