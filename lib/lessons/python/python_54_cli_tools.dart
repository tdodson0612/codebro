import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson54 = Lesson(
  language: 'Python',
  title: 'CLI Tools with argparse & click',
  content: '''
🎯 METAPHOR:
Building a CLI tool is like designing a control panel for
your code. Instead of editing the source file to change
behavior, you give users clearly labeled dials and buttons:
"--input FILE", "--verbose", "--count 5". The control panel
documents itself (--help), validates inputs, and routes
everything to the right function. argparse is the standard
library panel — reliable, but verbose to configure.
click is the modern designer panel — decorators make it
elegant and the user experience is polished.

📖 EXPLANATION:
argparse: Python's built-in argument parser.
click: third-party, decorator-based, more ergonomic.
Both let you turn Python scripts into proper CLI tools.

─────────────────────────────────────
📦 ARGPARSE — BUILT-IN
─────────────────────────────────────
import argparse

parser = argparse.ArgumentParser(description="My tool")

# Positional argument (required)
parser.add_argument("filename")

# Optional flag (--verbose / -v)
parser.add_argument("--verbose", "-v", action="store_true")

# Option with value (--output FILE)
parser.add_argument("--output", "-o", default="out.txt")

# Typed option
parser.add_argument("--count", "-n", type=int, default=10)

# Choices
parser.add_argument("--format", choices=["json","csv","txt"])

# Multiple values
parser.add_argument("--files", nargs="+")  # one or more

args = parser.parse_args()

─────────────────────────────────────
🖱️  CLICK — DECORATOR-BASED
─────────────────────────────────────
pip install click

import click

@click.command()
@click.argument("filename")
@click.option("--output", "-o", default="out.txt")
@click.option("--verbose", "-v", is_flag=True)
@click.option("--count", "-n", default=10, type=int)
def main(filename, output, verbose, count):
    """Process FILENAME and write to OUTPUT."""
    click.echo(f"Processing {filename}")

if __name__ == "__main__":
    main()

─────────────────────────────────────
🏗️  CLICK ADVANCED FEATURES
─────────────────────────────────────
Groups: @click.group() for subcommands (git-style)
Prompts: @click.option("--name", prompt=True)
Password: @click.option("--pw", prompt=True, hide_input=True)
File args: click.File("r") — auto-opens and closes
Path args: click.Path(exists=True) — validates existence
Progress bar: with click.progressbar(items) as bar:
Colors: click.style("text", fg="green", bold=True)
Echo: click.echo() / click.secho() (styled echo)

─────────────────────────────────────
📦 ENTRY POINTS
─────────────────────────────────────
In pyproject.toml:
[project.scripts]
my-tool = "mypackage.cli:main"

Then: pip install -e .  → available as "my-tool" command

💻 CODE:
import argparse
import sys
import os
from pathlib import Path

# ── ARGPARSE ──────────────────────

def build_parser():
    parser = argparse.ArgumentParser(
        prog="mytool",
        description="A comprehensive file processing tool",
        epilog="Example: mytool input.txt --output result.json --verbose",
        formatter_class=argparse.RawDescriptionHelpFormatter
    )

    # Positional argument
    parser.add_argument(
        "input",
        help="Input file to process"
    )

    # Optional with default
    parser.add_argument(
        "--output", "-o",
        default="-",           # "-" convention = stdout
        help="Output file (default: stdout)"
    )

    # Flag
    parser.add_argument(
        "--verbose", "-v",
        action="store_true",
        help="Enable verbose output"
    )

    # Counted flag (-vvv = very verbose)
    parser.add_argument(
        "--verbosity",
        action="count",
        default=0,
        help="Increase verbosity (use multiple times)"
    )

    # Typed option
    parser.add_argument(
        "--count", "-n",
        type=int,
        default=10,
        metavar="N",
        help="Number of lines to process (default: 10)"
    )

    # Choices
    parser.add_argument(
        "--format", "-f",
        choices=["json", "csv", "txt", "xml"],
        default="txt",
        help="Output format"
    )

    # Multiple values
    parser.add_argument(
        "--tags",
        nargs="*",
        default=[],
        help="Tags to apply"
    )

    # Boolean store_false
    parser.add_argument(
        "--no-color",
        action="store_false",
        dest="color",
        help="Disable color output"
    )

    # Version
    parser.add_argument(
        "--version", "-V",
        action="version",
        version="%(prog)s 1.0.0"
    )

    return parser

# Subcommands (git-style)
def build_subcommand_parser():
    parser = argparse.ArgumentParser(prog="gitlike")
    subparsers = parser.add_subparsers(dest="command", required=True)

    # 'add' subcommand
    add_parser = subparsers.add_parser("add", help="Add files")
    add_parser.add_argument("files", nargs="+")
    add_parser.add_argument("--dry-run", action="store_true")

    # 'commit' subcommand
    commit_parser = subparsers.add_parser("commit", help="Commit changes")
    commit_parser.add_argument("-m", "--message", required=True)
    commit_parser.add_argument("--amend", action="store_true")

    # 'log' subcommand
    log_parser = subparsers.add_parser("log", help="Show history")
    log_parser.add_argument("--oneline", action="store_true")
    log_parser.add_argument("-n", type=int, default=10)

    return parser

# Simulated main function
def run_tool(args):
    if args.verbose:
        print(f"Input:  {args.input}")
        print(f"Output: {args.output}")
        print(f"Format: {args.format}")
        print(f"Count:  {args.count}")
        print(f"Tags:   {args.tags}")

    # Handle output destination
    if args.output == "-":
        out = sys.stdout
    else:
        out = open(args.output, "w")

    try:
        # Simulate processing
        out.write(f"Processed {args.input} in {args.format} format\\n")
        for i in range(min(args.count, 5)):
            out.write(f"Line {i+1}\\n")
    finally:
        if out is not sys.stdout:
            out.close()

# Test it
parser = build_parser()
# args = parser.parse_args(["input.txt", "--verbose", "--format", "json"])
# run_tool(args)

# ── CLICK ─────────────────────────
# pip install click

# import click
#
# @click.group()
# @click.version_option("2.0.0")
# @click.option("--debug/--no-debug", default=False, envvar="APP_DEBUG")
# @click.pass_context
# def cli(ctx, debug):
#     """My CLI application."""
#     ctx.ensure_object(dict)
#     ctx.obj["debug"] = debug
#     if debug:
#         click.echo("Debug mode ON", err=True)
#
# @cli.command()
# @click.argument("filename", type=click.Path(exists=True))
# @click.option("--output", "-o", type=click.File("w"), default="-")
# @click.option("--count", "-n", default=10, show_default=True)
# @click.option("--format", type=click.Choice(["json","csv","txt"]), default="txt")
# @click.option("--verbose", "-v", is_flag=True)
# @click.pass_obj
# def process(obj, filename, output, count, format, verbose):
#     """Process FILENAME."""
#     if verbose or obj["debug"]:
#         click.secho(f"Processing {filename}", fg="green")
#     with click.progressbar(range(count), label="Processing") as bar:
#         for i in bar:
#             pass   # simulate work
#     output.write(f"Done processing {filename}\\n")
#     click.secho("✅ Complete!", fg="green", bold=True)
#
# @cli.command()
# @click.option("--name", prompt="Your name", help="Name to greet")
# @click.option("--count", "-n", default=1, help="Times to greet")
# def greet(name, count):
#     """Greet NAME."""
#     for _ in range(count):
#         click.echo(f"Hello, {click.style(name, fg='cyan', bold=True)}!")
#
# @cli.command("db-init")
# @click.option("--url", envvar="DATABASE_URL", required=True)
# @click.confirmation_option(prompt="This will reset the database. Continue?")
# def db_init(url):
#     """Initialize the database."""
#     click.echo(f"Connecting to {url}...")
#
# if __name__ == "__main__":
#     cli()

# ── RICH — BEAUTIFUL CLI OUTPUT ────
# pip install rich
# from rich.console import Console
# from rich.table import Table
# from rich.progress import track
# from rich import print as rprint
#
# console = Console()
# console.print("[bold green]Success![/bold green]")
# console.print_exception()
#
# table = Table(title="Users")
# table.add_column("Name", style="cyan")
# table.add_column("Score", justify="right", style="green")
# table.add_row("Alice", "92")
# table.add_row("Bob", "78")
# console.print(table)
#
# for item in track(range(100), description="Processing..."):
#     pass   # shows a progress bar

# ── PYPROJECT.TOML ENTRY POINTS ────

ENTRY_POINTS_EXAMPLE = """
[project.scripts]
# Makes "mytool" available as a command after pip install
mytool = "mypackage.cli:main"

# git-style multi-command tool
myapp = "mypackage.cli:cli"

# Multiple entry points
myapp-server = "mypackage.server:serve"
myapp-worker = "mypackage.worker:run"
"""

print("CLI tool examples ready!")
print("Run with: python script.py --help")

📝 KEY POINTS:
✅ Always add a --help/-h description to every argument
✅ Use choices= to restrict option values and auto-validate
✅ Use nargs="+" for one-or-more; nargs="*" for zero-or-more
✅ click is more ergonomic than argparse for complex CLIs
✅ Define entry points in pyproject.toml for installable commands
✅ Use envvar= in click to support both env vars and flags
✅ rich library for beautiful formatted terminal output
❌ Don't call sys.exit() in library functions — only in CLI entry points
❌ Don't hardcode paths — let the user specify them as arguments
❌ Always test --help output — it's what users see first
''',
  quiz: [
    Quiz(question: 'What does "action=\'store_true\'" do in argparse?', options: [
      QuizOption(text: 'Stores the string "True" as the argument value', correct: false),
      QuizOption(text: 'Makes the flag store True when present, False when absent', correct: true),
      QuizOption(text: 'Requires the user to explicitly pass --flag=True', correct: false),
      QuizOption(text: 'Makes the argument required', correct: false),
    ]),
    Quiz(question: 'What is the convention when setting default="-" for an --output argument?', options: [
      QuizOption(text: 'The output is disabled', correct: false),
      QuizOption(text: '"-" represents stdout — output goes to the terminal', correct: true),
      QuizOption(text: 'A file named "-" is created', correct: false),
      QuizOption(text: 'It means the argument is optional', correct: false),
    ]),
    Quiz(question: 'What does nargs="+" mean in argparse?', options: [
      QuizOption(text: 'The argument expects exactly one value', correct: false),
      QuizOption(text: 'The argument expects one or more values (stored as a list)', correct: true),
      QuizOption(text: 'The argument value is added to an existing list', correct: false),
      QuizOption(text: 'The argument is required and typed', correct: false),
    ]),
  ],
);
