import '../../models/lesson.dart';
import '../../models/quiz.dart';

final pythonLesson50 = Lesson(
  language: 'Python',
  title: 'Data Science & Scientific Computing Overview',
  content: """
🎯 METAPHOR:
Python's data science stack is like a professional kitchen.
NumPy is your sharp chef's knife — everything goes through it,
fast and precise. pandas is your mise en place station —
everything organized, labeled, easy to grab. Matplotlib is
your plating station — turning raw food into visual art.
scikit-learn is your cookbook of proven recipes.
Together they form a kitchen where you can process
millions of data points as smoothly as a Michelin-star
kitchen handles a dinner service.

📖 EXPLANATION:
Python dominates data science through a rich ecosystem:
NumPy (numerical), pandas (data manipulation),
Matplotlib/Seaborn (visualization), scikit-learn (ML).

─────────────────────────────────────
📦 THE STACK
─────────────────────────────────────
numpy      → fast arrays, linear algebra, math
pandas     → DataFrames, data manipulation
matplotlib → plotting and visualization
seaborn    → statistical data visualization
scipy      → scientific algorithms
scikit-learn → machine learning
statsmodels → statistical models
jupyter    → interactive notebooks

pip install numpy pandas matplotlib seaborn scikit-learn

─────────────────────────────────────
⚡ NUMPY — NUMERICAL ARRAYS
─────────────────────────────────────
numpy.ndarray — fast, typed, multi-dimensional array
  • Vectorized operations (no Python loops!)
  • Broadcasting — operations on different shapes
  • Universal functions (ufuncs) — apply to arrays

─────────────────────────────────────
📊 PANDAS — DATA MANIPULATION
─────────────────────────────────────
Series   → 1D labeled array
DataFrame → 2D table (rows + columns)

Operations: filter, group, merge, pivot, resample
Read from: CSV, Excel, JSON, SQL, Parquet, HTML

─────────────────────────────────────
📈 MATPLOTLIB — VISUALIZATION
─────────────────────────────────────
Line plots, scatter plots, bar charts, histograms,
heatmaps, subplots, 3D plots, animations.

─────────────────────────────────────
🤖 SCIKIT-LEARN — MACHINE LEARNING
─────────────────────────────────────
Consistent API: fit(), predict(), transform()
Classification, Regression, Clustering
Model selection, pipelines, preprocessing

💻 CODE:
# ── NUMPY ─────────────────────────
import numpy as np

# Array creation
a = np.array([1, 2, 3, 4, 5])
b = np.array([[1,2,3],[4,5,6],[7,8,9]])   # 2D
zeros = np.zeros((3, 4))
ones  = np.ones((2, 3), dtype=float)
eye   = np.eye(3)          # identity matrix
rng   = np.arange(0, 10, 0.5)   # like range but numpy
lin   = np.linspace(0, 1, 100)  # 100 evenly spaced vals
rand  = np.random.rand(3, 3)    # random 3x3 matrix
norm  = np.random.randn(1000)   # standard normal distribution

# Array properties
print(b.shape)    # (3, 3)
print(b.dtype)    # int64
print(b.ndim)     # 2
print(b.size)     # 9

# Vectorized operations (NO loops needed!)
x = np.array([1, 2, 3, 4, 5])
print(x * 2)        # [2, 4, 6, 8, 10]
print(x ** 2)       # [1, 4, 9, 16, 25]
print(np.sqrt(x))   # element-wise sqrt
print(x @ x)        # dot product: 55

# Broadcasting
a = np.array([[1,2,3],[4,5,6]])   # shape (2,3)
b = np.array([10, 20, 30])        # shape (3,)
print(a + b)   # broadcasts b across each row:
               # [[11,22,33],[14,25,36]]

# Indexing and slicing
m = np.random.randint(0, 100, (4, 4))
print(m[0])         # first row
print(m[:, 0])      # first column
print(m[1:3, 1:3])  # 2x2 submatrix

# Boolean indexing
nums = np.array([1, -2, 3, -4, 5, -6])
positive = nums[nums > 0]
print(positive)   # [1, 3, 5]

# Statistical operations
data = np.random.randn(1000)
print(f"Mean: {data.mean():.4f}")
print(f"Std:  {data.std():.4f}")
print(f"Min:  {data.min():.4f}")
print(f"Max:  {data.max():.4f}")
print(f"Median: {np.median(data):.4f}")

# Linear algebra
A = np.array([[2,1],[5,3]])
b_vec = np.array([8, 17])
x = np.linalg.solve(A, b_vec)  # solve Ax = b
print(f"Solution: {x}")    # [7. -6.]  (2*7 + 1*(-6) = 8 ✓)

eigenvalues, eigenvectors = np.linalg.eig(A)
print(f"Eigenvalues: {eigenvalues}")

# ── PANDAS ────────────────────────
import pandas as pd

# Create DataFrame
df = pd.DataFrame({
    "name":   ["Alice", "Bob", "Carol", "Dave", "Eve"],
    "age":    [30, 25, 35, 28, 22],
    "score":  [92, 78, 88, 65, 95],
    "dept":   ["Eng", "Mkt", "Eng", "HR", "Eng"],
    "active": [True, True, False, True, True],
})

print(df.head(3))    # first 3 rows
print(df.shape)      # (5, 5)
print(df.dtypes)     # column types
print(df.describe()) # statistics

# Selecting
print(df["name"])                     # Series (column)
print(df[["name", "score"]])          # DataFrame (multiple cols)
print(df.loc[0])                      # row by label
print(df.iloc[0:3])                   # rows by index
print(df.loc[df["score"] > 80])       # filtered rows

# Filtering
active_eng = df[(df["active"]) & (df["dept"] == "Eng")]
print(active_eng)

# Adding columns
df["grade"] = df["score"].apply(lambda s: "A" if s >= 90 else "B" if s >= 80 else "C")
df["score_normalized"] = (df["score"] - df["score"].mean()) / df["score"].std()

# GroupBy
dept_stats = df.groupby("dept").agg({
    "score": ["mean", "min", "max"],
    "name":  "count"
}).round(2)
print(dept_stats)

# Sorting
print(df.sort_values("score", ascending=False))

# Handling missing data
df_with_na = pd.DataFrame({"a": [1, None, 3], "b": [4, 5, None]})
print(df_with_na.isnull().sum())    # count NaN per column
print(df_with_na.fillna(0))         # fill NaN with 0
print(df_with_na.dropna())          # drop rows with any NaN

# Read/write data
# df.to_csv("data.csv", index=False)
# df = pd.read_csv("data.csv")
# df.to_json("data.json", orient="records")
# df = pd.read_excel("data.xlsx")

# Merge DataFrames (like SQL JOIN)
df1 = pd.DataFrame({"id": [1,2,3], "name": ["A","B","C"]})
df2 = pd.DataFrame({"id": [1,2,4], "score": [90,85,70]})
merged = df1.merge(df2, on="id", how="left")
print(merged)

# Pivot table
pivot = df.pivot_table(
    values="score", index="dept", aggfunc=["mean","count"]
)
print(pivot)

# ── MATPLOTLIB (BASICS) ───────────
import matplotlib
matplotlib.use("Agg")   # non-interactive backend
import matplotlib.pyplot as plt

fig, axes = plt.subplots(2, 2, figsize=(10, 8))

# Line plot
x = np.linspace(0, 2*np.pi, 100)
axes[0,0].plot(x, np.sin(x), "b-", label="sin(x)")
axes[0,0].plot(x, np.cos(x), "r--", label="cos(x)")
axes[0,0].set_title("Trig Functions")
axes[0,0].legend()

# Bar chart
depts = df.groupby("dept")["score"].mean()
axes[0,1].bar(depts.index, depts.values, color=["blue","green","orange"])
axes[0,1].set_title("Avg Score by Dept")

# Histogram
scores = np.random.normal(75, 10, 1000)
axes[1,0].hist(scores, bins=30, color="purple", alpha=0.7)
axes[1,0].set_title("Score Distribution")

# Scatter plot
x_data = np.random.randn(100)
y_data = x_data * 0.8 + np.random.randn(100) * 0.5
axes[1,1].scatter(x_data, y_data, alpha=0.5, c="teal")
axes[1,1].set_title("Correlation Scatter")

plt.tight_layout()
plt.savefig("plots.png", dpi=100)
print("Plot saved to plots.png")
plt.close()

# ── SCIKIT-LEARN OVERVIEW ──────────
# pip install scikit-learn
# from sklearn.model_selection import train_test_split
# from sklearn.preprocessing import StandardScaler
# from sklearn.linear_model import LogisticRegression
# from sklearn.metrics import classification_report
#
# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
# scaler = StandardScaler()
# X_train = scaler.fit_transform(X_train)
# X_test  = scaler.transform(X_test)
# model = LogisticRegression()
# model.fit(X_train, y_train)
# y_pred = model.predict(X_test)
# print(classification_report(y_test, y_pred))

📝 KEY POINTS:
✅ NumPy vectorized operations are 100-1000x faster than Python loops
✅ pandas DataFrame is the workhouse of data science
✅ Use .loc for label-based indexing, .iloc for integer position
✅ Always chain: filter → groupby → agg for efficient analysis
✅ matplotlib.subplots for multiple plots in one figure
✅ scikit-learn's API is consistent: fit(), predict(), transform()
❌ Don't iterate over DataFrame rows with for row in df — use vectorized ops
❌ Avoid chained indexing df["a"]["b"] — use df.loc[:,"a"] for safety
❌ Don't load huge datasets into pandas — use chunked reading or Polars
""",
  quiz: [
    Quiz(question: 'Why are NumPy vectorized operations faster than Python loops?', options: [
      QuizOption(text: 'NumPy runs in multiple threads automatically', correct: false),
      QuizOption(text: 'NumPy operations are implemented in C and operate on typed arrays without Python overhead', correct: true),
      QuizOption(text: 'NumPy uses GPU acceleration by default', correct: false),
      QuizOption(text: 'NumPy only works with small datasets', correct: false),
    ]),
    Quiz(question: 'What is the difference between df.loc and df.iloc?', options: [
      QuizOption(text: 'loc is faster; iloc is more flexible', correct: false),
      QuizOption(text: 'loc uses label-based indexing; iloc uses integer position indexing', correct: true),
      QuizOption(text: 'They are identical — just different names', correct: false),
      QuizOption(text: 'loc is for rows; iloc is for columns', correct: false),
    ]),
    Quiz(question: 'What does broadcasting mean in NumPy?', options: [
      QuizOption(text: 'Sending arrays over a network', correct: false),
      QuizOption(text: 'Performing operations between arrays of different shapes by implicitly expanding dimensions', correct: true),
      QuizOption(text: 'Broadcasting changes array values to a new type', correct: false),
      QuizOption(text: 'Copying an array to multiple memory locations for speed', correct: false),
    ]),
  ],
);
