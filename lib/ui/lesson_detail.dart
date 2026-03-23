import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/lesson.dart';
import '../utils/progress_tracker.dart';
import '../utils/xp_manager.dart';
import '../utils/settings_manager.dart';
import '../utils/sound_manager.dart';
import 'multi_lang_console.dart';
import 'quiz_page.dart';

class LessonDetailPage extends StatefulWidget {
  final Lesson lesson;
  final List<Lesson> allLessonsInLanguage;
  final int currentIndex;

  const LessonDetailPage({
    Key? key,
    required this.lesson,
    required this.allLessonsInLanguage,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  bool completed = false;
  bool _justCompleted = false;

  bool get hasNext =>
      widget.currentIndex < widget.allLessonsInLanguage.length - 1;
  bool get hasPrev => widget.currentIndex > 0;

  Lesson get nextLesson =>
      widget.allLessonsInLanguage[widget.currentIndex + 1];
  Lesson get prevLesson =>
      widget.allLessonsInLanguage[widget.currentIndex - 1];

  @override
  void initState() {
    super.initState();
    _checkCompletion();
  }

  Future<void> _checkCompletion() async {
    final done = await ProgressTracker.isLessonCompleted(
        widget.lesson.language, widget.lesson.title);
    if (mounted) setState(() => completed = done);
  }

  Future<void> _markCompleted() async {
    if (completed) return;
    await ProgressTracker.markLessonCompleted(
        widget.lesson.language, widget.lesson.title);

    if (!mounted) return;
    final xpManager = context.read<XpManager>();
    final levelsUp = await xpManager.awardLessonComplete();

    await SoundManager.playComplete();

    if (!mounted) return;
    setState(() {
      completed = true;
      _justCompleted = true;
    });

    if (levelsUp > 0) {
      _showLevelUpDialog(xpManager.progress.level);
    }
  }

  void _showLevelUpDialog(int newLevel) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 60))
                  .animate()
                  .scale(duration: 400.ms, curve: Curves.elasticOut),
              const SizedBox(height: 12),
              Text(
                'Level Up!',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[600]),
              ),
              const SizedBox(height: 8),
              Text('You reached Level\$newLevel',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Awesome!'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToLesson(Lesson lesson, int index) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => LessonDetailPage(
          lesson: lesson,
          allLessonsInLanguage: widget.allLessonsInLanguage,
          currentIndex: index,
        ),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fontSize = context.watch<SettingsManager>().fontSize;
    final total = widget.allLessonsInLanguage.length;
    final current = widget.currentIndex + 1;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.lesson.language,
                style: TextStyle(fontSize: 12, color: Colors.grey[300])),
            Text(widget.lesson.title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          if (completed)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.check_circle, color: Colors.greenAccent),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Text('Lesson\$current of\$total',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[500])),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: current / total,
                      minHeight: 6,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Code content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0D1117)
                      : const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(
                    widget.lesson.content,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: fontSize,
                      color: Colors.greenAccent[100],
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Try Code / Take Quiz buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.code, size: 18),
                    label: const Text('Try Code'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiLangConsolePage(
                          initialCode: widget.lesson.content,
                          language: widget.lesson.language,
                          lessonTitle: widget.lesson.title,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.quiz, size: 18),
                    label: const Text('Take Quiz'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizPage(
                            quizzes: widget.lesson.quiz,
                            language: widget.lesson.language,
                            lessonTitle: widget.lesson.title,
                          ),
                        ),
                      ).then((_) => _markCompleted());
                    },
                  ),
                ),
              ],
            ),
          ),

          // Completed banner + Next Lesson button
          if (completed)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Column(
                children: [
                  if (_justCompleted)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: Colors.green.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 18),
                          SizedBox(width: 8),
                          Text('+25 XP  ·  Lesson Complete!',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.2, end: 0),
                  if (hasNext) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_forward),
                        label: Text(
                          'Next:\${nextLesson.title}',
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                          padding:
                              const EdgeInsets.symmetric(vertical: 13),
                        ),
                        onPressed: () => _navigateToLesson(
                            nextLesson, widget.currentIndex + 1),
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                  ],
                ],
              ),
            ),

          // Prev / Skip nav
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            child: Row(
              children: [
                if (hasPrev)
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Previous'),
                      onPressed: () => _navigateToLesson(
                          prevLesson, widget.currentIndex - 1),
                    ),
                  ),
                if (hasPrev && hasNext && !completed)
                  const SizedBox(width: 8),
                if (hasNext && !completed)
                  Expanded(
                    child: OutlinedButton.icon(
                      icon:
                          const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('Skip'),
                      onPressed: () => _navigateToLesson(
                          nextLesson, widget.currentIndex + 1),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}