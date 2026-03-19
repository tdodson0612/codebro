import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson31 = Lesson(
  language: 'Python',
  title: 'datetime, time & Dates',
  content: '''
🎯 METAPHOR:
Working with dates is like navigating time zones in a
submarine with no windows.
You need to be precise about WHERE in time you are and
WHICH time zone you're thinking in. A naive datetime is
like a clock with no timezone label — it could be midnight
in Tokyo or midnight in New York, you can't tell. An aware
datetime is like a clock with the city name on it: "midnight,
Tokyo, JST+9." Python's datetime module is your navigation
system — but YOU must decide: naive or aware? And once you
commit to timezone-aware, never mix with naive datetimes
or you'll surface in the wrong port.

📖 EXPLANATION:
Python's datetime module provides date, time, datetime,
timedelta, and timezone classes for working with dates and times.

─────────────────────────────────────
📦 KEY CLASSES
─────────────────────────────────────
date       → year, month, day only
time       → hour, minute, second, microsecond only
datetime   → date + time combined
timedelta  → duration between two datetimes
timezone   → fixed UTC offset
tzinfo     → abstract timezone base class

─────────────────────────────────────
🌍 NAIVE vs AWARE
─────────────────────────────────────
Naive   — no timezone info attached
          Simple, but can't compare across timezones
Aware   — has timezone info (tzinfo attribute)
          Use for global applications

Always use aware datetimes in production!
Use pytz or zoneinfo (Python 3.9+) for full timezone support.

─────────────────────────────────────
🎨 STRFTIME CODES — Formatting
─────────────────────────────────────
%Y   4-digit year           2024
%y   2-digit year           24
%m   month 01-12            03
%d   day 01-31              15
%H   hour 00-23             14
%I   hour 01-12             02
%M   minute 00-59           30
%S   second 00-59           45
%f   microseconds           123456
%p   AM or PM               PM
%A   weekday name           Monday
%a   weekday short          Mon
%B   month name             March
%b   month short            Mar
%j   day of year 001-366    075
%W   week number 00-53      11
%Z   timezone name          UTC
%z   UTC offset             +0530
%c   locale date/time
%x   locale date
%X   locale time

💻 CODE:
from datetime import date, time, datetime, timedelta, timezone
import time as time_module

# Current date and time
today = date.today()
now = datetime.now()
utcnow = datetime.now(tz=timezone.utc)

print(f"Date: {today}")
print(f"Now:  {now}")
print(f"UTC:  {utcnow}")

# Creating specific dates
birthday = date(1990, 6, 15)
launch = datetime(2024, 1, 1, 9, 0, 0)

print(f"Birthday: {birthday}")
print(f"Day of week: {birthday.strftime('%A')}")
print(f"Week number: {birthday.isocalendar().week}")

# Accessing components
print(now.year, now.month, now.day)
print(now.hour, now.minute, now.second)
print(now.weekday())   # 0=Monday ... 6=Sunday
print(now.isoweekday())  # 1=Monday ... 7=Sunday

# Formatting with strftime
print(now.strftime("%Y-%m-%d %H:%M:%S"))       # 2024-03-15 14:30:45
print(now.strftime("%A, %B %d, %Y"))           # Friday, March 15, 2024
print(now.strftime("%I:%M %p"))                # 02:30 PM
print(now.strftime("%d/%m/%Y"))                # 15/03/2024
print(today.isoformat())                       # 2024-03-15 (ISO 8601)

# Parsing strings with strptime
date_str = "15/03/2024"
parsed = datetime.strptime(date_str, "%d/%m/%Y")
print(parsed)

iso_str = "2024-03-15T14:30:45"
parsed2 = datetime.fromisoformat(iso_str)  # Python 3.7+
print(parsed2)

# timedelta — arithmetic on dates
delta = timedelta(days=7, hours=3, minutes=30)
future = now + delta
past = now - timedelta(weeks=2)

print(f"In 7 days: {future.strftime('%Y-%m-%d')}")
print(f"2 weeks ago: {past.strftime('%Y-%m-%d')}")

# Difference between dates
event_date = date(2024, 12, 31)
days_until = (event_date - today).days
print(f"Days until New Year's Eve: {days_until}")

# timedelta breakdown
delta = timedelta(days=100, hours=3, minutes=22, seconds=15)
total_seconds = int(delta.total_seconds())
days, rem = divmod(total_seconds, 86400)
hours, rem = divmod(rem, 3600)
minutes, seconds = divmod(rem, 60)
print(f"{days}d {hours}h {minutes}m {seconds}s")

# Timezone-aware datetimes (Python 3.9+ zoneinfo)
from zoneinfo import ZoneInfo  # Python 3.9+

ny_time = datetime.now(ZoneInfo("America/New_York"))
tokyo_time = datetime.now(ZoneInfo("Asia/Tokyo"))
london_time = datetime.now(ZoneInfo("Europe/London"))

print(f"New York: {ny_time.strftime('%H:%M %Z')}")
print(f"Tokyo:    {tokyo_time.strftime('%H:%M %Z')}")
print(f"London:   {london_time.strftime('%H:%M %Z')}")

# Converting between timezones
ny_aware = datetime(2024, 3, 15, 9, 0, tzinfo=ZoneInfo("America/New_York"))
tokyo_converted = ny_aware.astimezone(ZoneInfo("Asia/Tokyo"))
print(f"9am NY = {tokyo_converted.strftime('%H:%M %Z')} in Tokyo")

# Unix timestamps
timestamp = now.timestamp()   # float seconds since epoch
print(f"Unix timestamp: {timestamp}")
back = datetime.fromtimestamp(timestamp)
print(f"From timestamp: {back}")

# Performance timing
start = time_module.perf_counter()
result = sum(range(1_000_000))
elapsed = time_module.perf_counter() - start
print(f"Computed in {elapsed:.4f}s")

# time.sleep
print("Waiting 0.5 seconds...")
time_module.sleep(0.5)
print("Done!")

# Date comparisons
d1 = date(2024, 1, 1)
d2 = date(2024, 12, 31)
print(d1 < d2)    # True
print(d1 == d2)   # False
dates = [date(2024,3,1), date(2024,1,15), date(2024,6,30)]
print(min(dates))  # 2024-01-15
print(max(dates))  # 2024-06-30
print(sorted(dates))

# Age calculator
def calculate_age(birthdate):
    today = date.today()
    age = today.year - birthdate.year
    if (today.month, today.day) < (birthdate.month, birthdate.day):
        age -= 1
    return age

birth = date(1990, 6, 15)
print(f"Age: {calculate_age(birth)}")

# Business days calculator (weekdays only)
def add_business_days(start, days):
    current = start
    added = 0
    while added < days:
        current += timedelta(days=1)
        if current.weekday() < 5:   # 0-4 = Mon-Fri
            added += 1
    return current

delivery = add_business_days(date.today(), 5)
print(f"5 business days from now: {delivery}")

📝 KEY POINTS:
✅ Use datetime.now(tz=timezone.utc) for UTC-aware datetimes
✅ Use zoneinfo.ZoneInfo (Python 3.9+) for proper timezone handling
✅ strftime formats → string; strptime parses string → datetime
✅ timedelta supports days, seconds, microseconds, hours, weeks
✅ date.isoformat() produces ISO 8601: "2024-03-15"
✅ time.perf_counter() for high-precision timing
❌ Never mix naive and aware datetimes — TypeError
❌ Don't use time.time() for performance measurement — use perf_counter()
❌ datetime.now() without timezone is LOCAL time — be explicit in production
''',
  quiz: [
    Quiz(question: 'What is the difference between a naive and aware datetime?', options: [
      QuizOption(text: 'Naive is faster; aware includes extra metadata', correct: false),
      QuizOption(text: 'Naive has no timezone info; aware includes timezone information', correct: true),
      QuizOption(text: 'Naive datetimes are for dates only; aware includes time', correct: false),
      QuizOption(text: 'They are identical in Python 3.9+', correct: false),
    ]),
    Quiz(question: 'What does datetime.strptime("15/03/2024", "%d/%m/%Y") do?', options: [
      QuizOption(text: 'Formats a datetime object as "15/03/2024"', correct: false),
      QuizOption(text: 'Parses the string "15/03/2024" into a datetime object', correct: true),
      QuizOption(text: 'Validates if "15/03/2024" is a valid date', correct: false),
      QuizOption(text: 'Returns the day, month, and year as separate integers', correct: false),
    ]),
    Quiz(question: 'What does timedelta(days=7) represent?', options: [
      QuizOption(text: 'The date 7 days from today', correct: false),
      QuizOption(text: 'A duration of 7 days that can be added to or subtracted from dates', correct: true),
      QuizOption(text: 'The time difference between two timezones', correct: false),
      QuizOption(text: 'A 7-element list of days', correct: false),
    ]),
  ],
);
