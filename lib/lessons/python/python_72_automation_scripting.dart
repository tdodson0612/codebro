import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson72 = Lesson(
  language: 'Python',
  title: 'Python for Automation & Scripting',
  content: '''
🎯 METAPHOR:
Automation scripts are like a tireless digital intern.
The intern (your script) never gets bored, never misclicks,
never forgets a step. You train them once by writing the
script, and then they can rename 10,000 files in seconds,
send 500 personalized emails without fatigue, monitor
a folder and react to new files, or scrape a website daily.
The key is that every repetitive manual task you do
can be coded once and run forever.

📖 EXPLANATION:
Python excels at automation: file system operations,
running system commands, scheduled tasks, web scraping,
email sending, and GUI automation.

─────────────────────────────────────
🗂️  FILE SYSTEM AUTOMATION
─────────────────────────────────────
pathlib.Path    → modern cross-platform file operations
shutil          → copy, move, delete trees
glob            → pattern-based file finding
watchdog (pip)  → watch filesystem for changes

─────────────────────────────────────
⚙️  SYSTEM COMMANDS
─────────────────────────────────────
subprocess.run()   → run any shell command
subprocess.Popen() → run process, stream output

─────────────────────────────────────
⏰ SCHEDULING
─────────────────────────────────────
schedule (pip)     → run tasks on a schedule
APScheduler (pip)  → more powerful scheduler
cron               → OS-level scheduling (Unix)
Task Scheduler     → OS-level (Windows)
time.sleep()       → simple delay

─────────────────────────────────────
📧 EMAIL
─────────────────────────────────────
smtplib   → send email (built-in)
email     → build email messages (built-in)
yagmail   → simple Gmail automation (pip)

─────────────────────────────────────
🌐 WEB SCRAPING
─────────────────────────────────────
urllib     → basic HTTP (built-in)
requests   → HTTP client (pip)
BeautifulSoup (bs4) → HTML parsing (pip)
selenium   → browser automation (pip)
scrapy     → full scraping framework (pip)
playwright → modern browser automation (pip)

💻 CODE:
import os
import shutil
import subprocess
import glob
from pathlib import Path
from datetime import datetime
import re

# ── FILE SYSTEM AUTOMATION ─────────

# Organize files in a directory by extension
def organize_downloads(source_dir: str):
    """Move files into subdirectories by type."""
    source = Path(source_dir)
    if not source.exists():
        print(f"Directory not found: {source_dir}")
        return

    # Extension → folder mapping
    categories = {
        "images":     {".jpg", ".jpeg", ".png", ".gif", ".bmp", ".svg", ".webp"},
        "documents":  {".pdf", ".doc", ".docx", ".txt", ".md", ".csv", ".xlsx"},
        "videos":     {".mp4", ".mkv", ".avi", ".mov", ".wmv"},
        "audio":      {".mp3", ".wav", ".flac", ".m4a", ".ogg"},
        "code":       {".py", ".js", ".ts", ".html", ".css", ".java", ".cpp"},
        "archives":   {".zip", ".tar", ".gz", ".rar", ".7z"},
    }

    moved = 0
    for file in source.iterdir():
        if not file.is_file():
            continue
        ext = file.suffix.lower()
        for folder, extensions in categories.items():
            if ext in extensions:
                dest_dir = source / folder
                dest_dir.mkdir(exist_ok=True)
                dest = dest_dir / file.name
                if dest.exists():
                    stem = file.stem
                    dest = dest_dir / f"{stem}_{datetime.now().strftime('%H%M%S')}{ext}"
                shutil.move(str(file), str(dest))
                moved += 1
                break

    print(f"Organized {moved} files")

# Batch rename files
def batch_rename(directory: str, pattern: str, replacement: str):
    """Rename all files matching pattern using regex."""
    path = Path(directory)
    renamed = 0
    for file in path.glob("*"):
        if file.is_file():
            new_name = re.sub(pattern, replacement, file.name)
            if new_name != file.name:
                file.rename(file.parent / new_name)
                print(f"  {file.name} → {new_name}")
                renamed += 1
    print(f"Renamed {renamed} files")

# Example: rename IMG_001.jpg to photo_001.jpg
# batch_rename("./photos", r"^IMG_", "photo_")

# Find duplicate files by hash
def find_duplicates(directory: str) -> dict:
    """Find files with identical content."""
    import hashlib
    hashes = {}
    for file in Path(directory).rglob("*"):
        if not file.is_file():
            continue
        md5 = hashlib.md5(file.read_bytes()).hexdigest()
        hashes.setdefault(md5, []).append(file)

    return {h: files for h, files in hashes.items() if len(files) > 1}

# Backup modified files
def backup_changed_files(source: str, backup: str, since: datetime = None):
    """Copy files modified after 'since' to backup directory."""
    src = Path(source)
    dst = Path(backup)
    dst.mkdir(parents=True, exist_ok=True)

    count = 0
    for file in src.rglob("*"):
        if not file.is_file():
            continue
        if since and datetime.fromtimestamp(file.stat().st_mtime) < since:
            continue
        rel_path = file.relative_to(src)
        dest = dst / rel_path
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(str(file), str(dest))
        count += 1

    print(f"Backed up {count} files to {backup}")

# ── SYSTEM COMMANDS ────────────────

import subprocess

def run_command(cmd: list, capture=True) -> tuple[int, str, str]:
    """Run a command and return (returncode, stdout, stderr)."""
    result = subprocess.run(
        cmd,
        capture_output=capture,
        text=True,
        timeout=30
    )
    return result.returncode, result.stdout, result.stderr

# Get disk usage
code, stdout, stderr = run_command(["df", "-h"])
if code == 0:
    print("Disk usage:")
    print(stdout[:300])

# List Python processes
code, stdout, _ = run_command(["ps", "aux"])
python_procs = [line for line in stdout.split("\\n") if "python" in line.lower()]
print(f"Python processes: {len(python_procs)}")

# Git automation
def git_status(repo_path: str) -> str:
    code, stdout, _ = run_command(["git", "-C", repo_path, "status", "--porcelain"])
    return stdout

def git_pull(repo_path: str) -> bool:
    code, stdout, stderr = run_command(["git", "-C", repo_path, "pull"])
    print(stdout or stderr)
    return code == 0

# ── EMAIL AUTOMATION ──────────────

EMAIL_EXAMPLE = """
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
import os

def send_email(
    to: str | list,
    subject: str,
    body: str,
    html: str = None,
    attachments: list[str] = None
):
    '''Send email via Gmail SMTP.'''
    smtp_user = os.environ["GMAIL_USER"]
    smtp_pass = os.environ["GMAIL_APP_PASSWORD"]  # App Password, not account pw!

    msg = MIMEMultipart("alternative")
    msg["Subject"] = subject
    msg["From"] = smtp_user
    msg["To"] = to if isinstance(to, str) else ", ".join(to)

    msg.attach(MIMEText(body, "plain"))
    if html:
        msg.attach(MIMEText(html, "html"))

    if attachments:
        for path in attachments:
            with open(path, "rb") as f:
                part = MIMEApplication(f.read(), Name=os.path.basename(path))
            part["Content-Disposition"] = f'attachment; filename="{os.path.basename(path)}"'
            msg.attach(part)

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as smtp:
        smtp.login(smtp_user, smtp_pass)
        recipients = [to] if isinstance(to, str) else to
        smtp.sendmail(smtp_user, recipients, msg.as_string())

    print(f"Email sent to {to}")

# Send a report
send_email(
    to="boss@company.com",
    subject="Daily Sales Report",
    body="Please find the daily report attached.",
    html="<h1>Daily Report</h1><p>All numbers look good!</p>",
    attachments=["report.csv", "chart.png"]
)
"""

# ── WEB SCRAPING ──────────────────

SCRAPING_EXAMPLE = """
import requests
from bs4 import BeautifulSoup
import time
import random

def scrape_page(url: str, delay: float = 1.0) -> BeautifulSoup:
    '''Fetch and parse a web page politely.'''
    headers = {
        "User-Agent": "Mozilla/5.0 (compatible; PythonBot/1.0)"
    }
    time.sleep(delay + random.uniform(0, 0.5))  # be polite!
    resp = requests.get(url, headers=headers, timeout=10)
    resp.raise_for_status()
    return BeautifulSoup(resp.text, "html.parser")

def scrape_quotes(url: str = "https://quotes.toscrape.com") -> list[dict]:
    '''Example: scrape quotes from quotes.toscrape.com'''
    quotes = []
    page = 1

    while True:
        soup = scrape_page(f"{url}/page/{page}/")
        items = soup.select(".quote")
        if not items:
            break

        for item in items:
            quotes.append({
                "text": item.select_one(".text").get_text(strip=True),
                "author": item.select_one(".author").get_text(strip=True),
                "tags": [t.get_text() for t in item.select(".tag")],
            })

        next_btn = soup.select_one(".next a")
        if not next_btn:
            break
        page += 1

    return quotes

# quotes = scrape_quotes()
# for q in quotes[:3]:
#     print(f'"{q["text"]}" — {q["author"]}')
"""

# ── SCHEDULING ────────────────────

SCHEDULE_EXAMPLE = """
import schedule
import time

def daily_report():
    print(f"[{datetime.now()}] Running daily report...")
    # generate_report()

def cleanup_temp():
    print("Cleaning up temp files...")
    # shutil.rmtree("/tmp/myapp", ignore_errors=True)

def check_health():
    print("Checking service health...")

# Define schedule
schedule.every().day.at("09:00").do(daily_report)
schedule.every().hour.do(check_health)
schedule.every(10).minutes.do(cleanup_temp)
schedule.every().monday.at("08:00").do(lambda: print("Weekly digest!"))

# Run the scheduler
print("Scheduler running. Press Ctrl+C to stop.")
while True:
    schedule.run_pending()
    time.sleep(30)
"""

# ── WATCHDOG — MONITOR FILESYSTEM ──

WATCHDOG_EXAMPLE = """
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import time

class FileHandler(FileSystemEventHandler):
    def on_created(self, event):
        if not event.is_directory:
            print(f"New file: {event.src_path}")
            process_new_file(event.src_path)

    def on_modified(self, event):
        if not event.is_directory:
            print(f"Modified: {event.src_path}")

    def on_deleted(self, event):
        print(f"Deleted: {event.src_path}")

# Watch a directory
observer = Observer()
observer.schedule(FileHandler(), path="/watch/inbox", recursive=False)
observer.start()
print("Watching /watch/inbox for new files...")
try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    observer.stop()
observer.join()
"""

print("Automation examples ready!")
print("Key libraries: pathlib, shutil, subprocess, smtplib, schedule, watchdog, bs4")

📝 KEY POINTS:
✅ pathlib.Path is the modern way to handle all file system operations
✅ shutil handles high-level file ops: copy, move, delete directories
✅ subprocess.run(list, shell=False) is safe — never use shell=True with user input
✅ Always add delays when scraping — respect robots.txt and rate limits
✅ Use app passwords (not account passwords) for Gmail SMTP
✅ schedule library is simple; use APScheduler for complex job requirements
✅ watchdog monitors the filesystem without polling in a tight loop
❌ Don't scrape sites that prohibit it in their terms of service
❌ Don't hardcode credentials — use environment variables
❌ subprocess with shell=True is a security risk — use the list form
''',
  quiz: [
    Quiz(question: 'What is the safest way to run a shell command in Python?', options: [
      QuizOption(text: 'os.system("command")', correct: false),
      QuizOption(text: 'subprocess.run(["command", "arg"], shell=False)', correct: true),
      QuizOption(text: 'exec("command")', correct: false),
      QuizOption(text: 'subprocess.run("command arg", shell=True)', correct: false),
    ]),
    Quiz(question: 'What does shutil.move() do?', options: [
      QuizOption(text: 'Copies a file and leaves the original', correct: false),
      QuizOption(text: 'Moves or renames a file or directory', correct: true),
      QuizOption(text: 'Creates a symbolic link', correct: false),
      QuizOption(text: 'Compresses a file', correct: false),
    ]),
    Quiz(question: 'Why should you add delays between scraping requests?', options: [
      QuizOption(text: 'Python requires delays for HTTP requests', correct: false),
      QuizOption(text: 'To avoid overloading the server and to behave like a respectful client', correct: true),
      QuizOption(text: 'Delays make parsing HTML more accurate', correct: false),
      QuizOption(text: 'To avoid SSL certificate errors', correct: false),
    ]),
  ],
);
