// lib/ui/lesson_detail.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lesson.dart';
import '../utils/progress_tracker.dart';
import '../utils/bookmark_manager.dart';
import '../utils/xp_manager.dart';
import 'multi_lang_console.dart';

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
  _LessonDetailPageState createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  late Lesson _lesson;
  late int _currentIndex;

  bool _isBookmarked = false;
  bool _isCompleted = false;
  bool _quizSubmitted = false;
  bool _xpAwarded = false;

  Map<int, int> _selectedAnswers = {};
  Map<int, bool> _quizResults = {};

  @override
  void initState() {
    super.initState();
    _lesson = widget.lesson;
    _currentIndex = widget.currentIndex;
    _loadState();
  }

  Future<void> _loadState() async {
    final bookmarked = await BookmarkManager.isBookmarked(
        _lesson.language, _lesson.title);
    final completed = await ProgressTracker.isLessonCompleted(
        _lesson.language, _lesson.title);
    if (mounted) {
      setState(() {
        _isBookmarked = bookmarked;
        _isCompleted = completed;
      });
    }
  }

  void _navigateToLesson(int newIndex) {
    if (newIndex < 0 || newIndex >= widget.allLessonsInLanguage.length) return;
    setState(() {
      _currentIndex = newIndex;
      _lesson = widget.allLessonsInLanguage[newIndex];
      _isBookmarked = false;
      _isCompleted = false;
      _quizSubmitted = false;
      _xpAwarded = false;
      _selectedAnswers = {};
      _quizResults = {};
    });
    _loadState();
  }

  Future<void> _toggleBookmark() async {
    if (_isBookmarked) {
      await BookmarkManager.removeBookmark(_lesson.language, _lesson.title);
    } else {
      await BookmarkManager.bookmarkLesson(_lesson.language, _lesson.title);
    }
    if (mounted) setState(() => _isBookmarked = !_isBookmarked);
  }

  Future<void> _markComplete() async {
    await ProgressTracker.markLessonCompleted(_lesson.language, _lesson.title);
    if (!_xpAwarded) {
      await context.read<XpManager>().awardLessonComplete();
      _xpAwarded = true;
    }
    if (mounted) setState(() => _isCompleted = true);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Lesson complete! +25 XP'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _submitQuiz() {
    if (_selectedAnswers.length < _lesson.quiz.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer all questions before submitting.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    Map<int, bool> results = {};
    for (int i = 0; i < _lesson.quiz.length; i++) {
      final selected = _selectedAnswers[i]!;
      results[i] = _lesson.quiz[i].options[selected].correct;
    }
    setState(() {
      _quizResults = results;
      _quizSubmitted = true;
    });

    final allCorrect = results.values.every((r) => r);
    if (allCorrect && !_isCompleted) {
      _markComplete();
    }
  }

  void _retryQuiz() {
    setState(() {
      _selectedAnswers = {};
      _quizResults = {};
      _quizSubmitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasPrev = _currentIndex > 0;
    final hasNext = _currentIndex < widget.allLessonsInLanguage.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _lesson.language,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarked ? Colors.orange : null,
            ),
            tooltip: _isBookmarked ? 'Remove Bookmark' : 'Bookmark',
            onPressed: _toggleBookmark,
          ),
          IconButton(
            icon: const Icon(Icons.code),
            tooltip: 'Try in Console',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MultiLangConsolePage(
                  initialCode: _lesson.content,
                  language: _lesson.language,
                  lessonTitle: _lesson.title,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            _lesson.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          if (_isCompleted)
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                SizedBox(width: 4),
                Text('Completed',
                    style: TextStyle(color: Colors.green, fontSize: 13)),
              ],
            ),
          const SizedBox(height: 16),
          _buildContentCard(),
          const SizedBox(height: 16),
          if (_lesson.quiz.isNotEmpty) ...[
            _buildQuizSection(),
            const SizedBox(height: 16),
          ],
          if (!_isCompleted && (_lesson.quiz.isEmpty || _quizSubmitted))
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('Mark as Complete'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: _markComplete,
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                  onPressed: hasPrev
                      ? () => _navigateToLesson(_currentIndex - 1)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                  onPressed: hasNext
                      ? () => _navigateToLesson(_currentIndex + 1)
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildContentCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          _lesson.content,
          style: const TextStyle(fontSize: 14, height: 1.6),
        ),
      ),
    );
  }

  Widget _buildQuizSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📝 Quiz',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...List.generate(
                _lesson.quiz.length, (i) => _buildQuizQuestion(i)),
            const SizedBox(height: 12),
            if (!_quizSubmitted)
              ElevatedButton(
                onPressed: _submitQuiz,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                ),
                child: const Text('Submit Answers'),
              )
            else
              Builder(builder: (context) {
                final correct =
                    _quizResults.values.where((r) => r).length;
                final total = _lesson.quiz.length;
                final allCorrect = correct == total;
                return Column(
                  children: [
                    Text(
                      allCorrect
                          ? '🎉 Perfect! $correct/$total correct'
                          : '📊 $correct/$total correct',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: allCorrect ? Colors.green : Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (!allCorrect)
                      OutlinedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry Quiz'),
                        onPressed: _retryQuiz,
                      ),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizQuestion(int questionIndex) {
    final quiz = _lesson.quiz[questionIndex];
    final submitted = _quizSubmitted;
    final selectedOption = _selectedAnswers[questionIndex];
    final isCorrect = _quizResults[questionIndex] ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${questionIndex + 1}. ${quiz.question}',
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          ...List.generate(quiz.options.length, (optIndex) {
            final option = quiz.options[optIndex];
            final isSelected = selectedOption == optIndex;
            final isThisCorrect = option.correct;

            Color? tileColor;
            if (submitted) {
              if (isThisCorrect) {
                tileColor = Colors.green.withOpacity(0.15);
              } else if (isSelected && !isCorrect) {
                tileColor = Colors.red.withOpacity(0.15);
              }
            } else if (isSelected) {
              tileColor = Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(0.1);
            }

            return GestureDetector(
              onTap: submitted
                  ? null
                  : () => setState(
                      () => _selectedAnswers[questionIndex] = optIndex),
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: submitted
                        ? (isThisCorrect
                            ? Colors.green
                            : (isSelected
                                ? Colors.red
                                : Colors.grey.withOpacity(0.3)))
                        : (isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.withOpacity(0.3)),
                    width: isSelected || (submitted && isThisCorrect)
                        ? 1.5
                        : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(option.text,
                          style: const TextStyle(fontSize: 13)),
                    ),
                    if (submitted && isThisCorrect)
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 18),
                    if (submitted && isSelected && !isThisCorrect)
                      const Icon(Icons.cancel,
                          color: Colors.red, size: 18),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}