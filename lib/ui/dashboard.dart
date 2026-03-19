import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/lessons.dart';
import '../models/lesson.dart';
import '../utils/progress_tracker.dart';
import '../utils/bookmark_manager.dart';
import '../utils/xp_manager.dart';
import 'lesson_detail.dart';
import 'multi_lang_console.dart';
import 'settings_page.dart';

// Language icon mapping
const Map<String, IconData> languageIcons = {
  'C': Icons.memory,
  'C++': Icons.settings_input_component,
  'C#': Icons.window,
  'Python': Icons.psychology,
  'Java': Icons.coffee,
  'Kotlin': Icons.android,
  'JavaScript': Icons.web,
  'HTML': Icons.html,
  'CSS': Icons.brush,
};

const Map<String, Color> languageColors = {
  'C': Color(0xFF5C6BC0),
  'C++': Color(0xFF1565C0),
  'C#': Color(0xFF6A1B9A),
  'Python': Color(0xFF2E7D32),
  'Java': Color(0xFFBF360C),
  'Kotlin': Color(0xFF6200EA),
  'JavaScript': Color(0xFFF9A825),
  'HTML': Color(0xFFE64A19),
  'CSS': Color(0xFF0277BD),
};

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Map<String, List<Lesson>> allLessons = LessonData.allLessons;
  Map<String, List<String>> bookmarksByLanguage = {};
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAllBookmarks();
  }

  Future<void> loadAllBookmarks() async {
    Map<String, List<String>> result = {};
    for (var language in allLessons.keys) {
      result[language] = await BookmarkManager.getBookmarks(language);
    }
    if (mounted) setState(() => bookmarksByLanguage = result);
  }

  List<Lesson> get _searchResults {
    if (_searchQuery.isEmpty) return [];
    final query = _searchQuery.toLowerCase();
    List<Lesson> results = [];
    for (var lessons in allLessons.values) {
      for (var lesson in lessons) {
        if (lesson.title.toLowerCase().contains(query) ||
            lesson.language.toLowerCase().contains(query) ||
            lesson.content.toLowerCase().contains(query)) {
          results.add(lesson);
        }
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final xpManager = context.watch<XpManager>();
    final progress = xpManager.progress;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CodeBro', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
        actions: [
          // XP display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bolt, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${progress.xp} XP',
                    style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          // Streak display
          Padding(
            padding: const EdgeInsets.only(right: 4, top: 8, bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    '${progress.streak}',
                    style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SettingsPage()),
            ).then((_) => setState(() {})),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search lessons...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          // Main content
          Expanded(
            child: _searchQuery.isNotEmpty
                ? _buildSearchResults()
                : ListView(
                    padding: const EdgeInsets.only(bottom: 20),
                    children: [
                      _buildXpCard(progress),
                      _buildGlobalProgressWidget(),
                      _buildBookmarksSection(),
                      ...allLessons.keys.map((lang) => _buildLanguageSection(lang)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildXpCard(progress) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[700],
                  child: Text(
                    '${progress.level}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        progress.levelTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Level ${progress.level} · ${progress.xp} XP total',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 20)),
                    Text(
                      '${progress.streak} day streak',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress.levelProgress.clamp(0.0, 1.0),
                      backgroundColor: Colors.grey[300],
                      color: Colors.amber,
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${progress.xpIntoCurrentLevel}/${progress.xpForNextLevel} XP',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlobalProgressWidget() {
    return FutureBuilder<double>(
      future: GlobalProgress.getOverallProgress(),
      builder: (context, snapshot) {
        double prog = snapshot.data ?? 0;
        return Card(
          margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Overall Progress',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: prog,
                    backgroundColor: Colors.grey[300],
                    color: Colors.blueAccent,
                    minHeight: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text('${(prog * 100).toStringAsFixed(1)}% of all lessons completed',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    final results = _searchResults;
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey[600]),
            const SizedBox(height: 12),
            Text('No lessons found for "$_searchQuery"',
                style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final lesson = results[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: languageColors[lesson.language] ?? Colors.blue,
              child: Icon(languageIcons[lesson.language] ?? Icons.code,
                  color: Colors.white, size: 18),
            ),
            title: Text(lesson.title),
            subtitle: Text(lesson.language,
                style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => _openLesson(context, lesson),
          ),
        );
      },
    );
  }

  Widget _buildBookmarksSection() {
    List<Widget> bookmarkTiles = [];
    for (var language in bookmarksByLanguage.keys) {
      final bookmarks = bookmarksByLanguage[language] ?? [];
      for (var lessonTitle in bookmarks) {
        final lessons = allLessons[language] ?? [];
        final matchIndex = lessons.indexWhere((l) => l.title == lessonTitle);
        if (matchIndex == -1) continue;
        final lesson = lessons[matchIndex];
        bookmarkTiles.add(ListTile(
          leading: CircleAvatar(
            backgroundColor: languageColors[language] ?? Colors.orange,
            child: Icon(languageIcons[language] ?? Icons.bookmark,
                color: Colors.white, size: 16),
          ),
          title: Text(lesson.title),
          subtitle: Text(language, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.code, size: 20),
                onPressed: () => _openConsole(context, lesson),
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_remove, size: 20, color: Colors.orange),
                onPressed: () async {
                  await BookmarkManager.removeBookmark(language, lessonTitle);
                  await loadAllBookmarks();
                },
              ),
            ],
          ),
          onTap: () => _openLesson(context, lesson),
        ));
      }
    }

    if (bookmarkTiles.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: const Icon(Icons.bookmarks, color: Colors.orange),
        title: const Text('Bookmarks', style: TextStyle(fontWeight: FontWeight.bold)),
        children: bookmarkTiles,
      ),
    );
  }

  Widget _buildLanguageSection(String language) {
    final lessons = allLessons[language] ?? [];
    final color = languageColors[language] ?? Colors.blue;
    final icon = languageIcons[language] ?? Icons.code;

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: FutureBuilder<double>(
        future: ProgressUtils.getLanguageProgress(language),
        builder: (context, snapshot) {
          double prog = snapshot.data ?? 0;
          int completed = (prog * lessons.length).round();
          return ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            title: Text(language,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: prog,
                    backgroundColor: Colors.grey[300],
                    color: color,
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 2),
                Text('$completed / ${lessons.length} lessons',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ],
            ),
            children: lessons
                .map((lesson) => _buildLessonTile(context, language, lesson, color))
                .toList(),
          );
        },
      ),
    );
  }

  Widget _buildLessonTile(
      BuildContext context, String language, Lesson lesson, Color color) {
    return FutureBuilder<bool>(
      future: ProgressTracker.isLessonCompleted(language, lesson.title),
      builder: (context, snapshot) {
        bool done = snapshot.data ?? false;
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          leading: Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? Colors.green : Colors.grey,
            size: 22,
          ),
          title: Text(lesson.title, style: const TextStyle(fontSize: 14)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.bookmark_border, size: 20),
                tooltip: 'Bookmark',
                onPressed: () async {
                  await BookmarkManager.bookmarkLesson(language, lesson.title);
                  await loadAllBookmarks();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Bookmarked: ${lesson.title}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.code, size: 20),
                tooltip: 'Try Code',
                onPressed: () => _openConsole(context, lesson),
              ),
              IconButton(
                icon: Icon(Icons.school, size: 20, color: color),
                tooltip: 'Open Lesson',
                onPressed: () => _openLesson(context, lesson),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openConsole(BuildContext context, Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiLangConsolePage(
          initialCode: lesson.content,
          language: lesson.language,
          lessonTitle: lesson.title,
        ),
      ),
    );
  }

  void _openLesson(BuildContext context, Lesson lesson) {
    // Find the lesson's index and the full list for next/prev navigation
    final lessons = allLessons[lesson.language] ?? [];
    final index = lessons.indexWhere((l) => l.title == lesson.title);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LessonDetailPage(
          lesson: lesson,
          allLessonsInLanguage: lessons,
          currentIndex: index,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}