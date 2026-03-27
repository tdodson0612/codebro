import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/quiz.dart';
import '../utils/xp_manager.dart';
import '../utils/sound_manager.dart';

class QuizPage extends StatefulWidget {
  final List<Quiz> quizzes;
  final String language;
  final String lessonTitle;

  const QuizPage({
    Key? key,
    required this.quizzes,
    required this.language,
    required this.lessonTitle,
  }) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  int currentIndex = 0;
  int score = 0;
  bool? answeredCorrect;
  int? selectedOptionIndex;
  int _totalXpEarned = 0;

  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  Future<void> _checkAnswer(bool correct, int optionIndex) async {
    if (answeredCorrect != null) return;

    setState(() {
      answeredCorrect = correct;
      selectedOptionIndex = optionIndex;
    });

    if (correct) {
      await SoundManager.playCorrect();
      score++;
      if (!mounted) return;
      final xpManager = context.read<XpManager>();
      await xpManager.awardCorrectAnswer();
      _totalXpEarned += XpManager.xpPerCorrectAnswer;
    } else {
      await SoundManager.playWrong();
      _shakeController.forward(from: 0);
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    if (currentIndex < widget.quizzes.length - 1) {
      setState(() {
        currentIndex++;
        answeredCorrect = null;
        selectedOptionIndex = null;
      });
    } else {
      await _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    if (!mounted) return;
    final xpManager = context.read<XpManager>();
    final isPerfect = score == widget.quizzes.length;

    if (isPerfect) {
      final levelsUp = await xpManager.awardPerfectQuiz();
      _totalXpEarned += XpManager.xpPerfectQuiz;
      await SoundManager.playLevelUp();
      if (mounted && levelsUp > 0) {
        _showLevelUpSnackbar(xpManager.progress.level);
      }
    } else {
      await SoundManager.playComplete();
    }

    if (mounted) _showResultDialog();
  }

  void _showLevelUpSnackbar(int level) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('🎉 ', style: TextStyle(fontSize: 20)),
            Text('Level Up! You are now Level\$level',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.amber[700],
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showResultDialog() {
    final isPerfect = score == widget.quizzes.length;
    final passed = score >= widget.quizzes.length / 2;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isPerfect ? '🏆' : passed ? '⭐' : '📚',
                      style: const TextStyle(fontSize: 64))
                  .animate()
                  .scale(duration: 500.ms, curve: Curves.elasticOut)
                  .fadeIn(),

              const SizedBox(height: 12),

              Text(
                isPerfect
                    ? 'Perfect Score!'
                    : passed
                        ? 'Well Done!'
                        : 'Keep Practicing!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isPerfect
                      ? Colors.amber[600]
                      : passed
                          ? Colors.green
                          : Colors.blue,
                ),
              ),

              const SizedBox(height: 8),

              Text('\$score /\\${
widget.quizzes.length} correct',
                  style: const TextStyle(fontSize: 18)),

              const SizedBox(height: 12),

              // XP earned badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.amber.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt,
                        color: Colors.amber, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '+\$_totalXpEarned XP earned',
                      style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold),
                    ),
                    if (isPerfect) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('BONUS!',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          currentIndex = 0;
                          score = 0;
                          answeredCorrect = null;
                          selectedOptionIndex = null;
                          _totalXpEarned = 0;
                        });
                      },
                      child: const Text('Try Again'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _optionBgColor(int index, QuizOption option) {
    if (answeredCorrect == null) return Colors.transparent;
    if (option.correct) return Colors.green.withValues(alpha: 0.25);
    if (index == selectedOptionIndex) {
      return Colors.red.withValues(alpha: 0.2);
    }
    return Colors.transparent;
  }

  Color _optionBorderColor(int index, QuizOption option) {
    if (answeredCorrect == null) {
      return Colors.grey.withValues(alpha: 0.3);
    }
    if (option.correct) return Colors.green;
    if (index == selectedOptionIndex) return Colors.red;
    return Colors.grey.withValues(alpha: 0.2);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quizzes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(child: Text('No quiz questions available.')),
      );
    }

    final quiz = widget.quizzes[currentIndex];
    final progressVal =
        (currentIndex + 1) / widget.quizzes.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('\${widget.lessonTitle} Quiz'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progressVal,
            backgroundColor: Colors.grey[800],
            color: Colors.greenAccent,
            minHeight: 4,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _shakeController,
        builder: (context, child) {
          final shake = answeredCorrect == false
              ? (0.5 -
                      (_shakeController.value - 0.5).abs()) *
                  10
              : 0.0;
          return Transform.translate(
              offset: Offset(shake, 0), child: child);
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question${
currentIndex + 1} of${
widget.quizzes.length}',
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: 13),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 16),
                      const SizedBox(width: 4),
                      Text('\$score correct',
                          style: TextStyle(
                              color: Colors.grey[400], fontSize: 13)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                quiz.question,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.4),
              )
                  .animate(key: ValueKey(currentIndex))
                  .fadeIn(duration: 300.ms)
                  .slideX(begin: -0.05, end: 0),

              const SizedBox(height: 28),

              ...quiz.options.asMap().entries.map((entry) {
                final idx = entry.key;
                final option = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: _optionBgColor(idx, option),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _optionBorderColor(idx, option),
                        width: 1.5,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: answeredCorrect != null
                          ? null
                          : () => _checkAnswer(option.correct, idx),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey
                                    .withValues(alpha: 0.15),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + idx),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(option.text,
                                  style:
                                      const TextStyle(fontSize: 15)),
                            ),
                            if (answeredCorrect != null &&
                                option.correct)
                              const Icon(Icons.check_circle,
                                  color: Colors.green, size: 20),
                            if (answeredCorrect != null &&
                                idx == selectedOptionIndex &&
                                !option.correct)
                              const Icon(Icons.cancel,
                                  color: Colors.red, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                    .animate(
                        key: ValueKey('\$currentIndex-\$idx'))
                    .fadeIn(
                        duration: 300.ms,
                        delay:
                            Duration(milliseconds: idx * 80))
                    .slideX(begin: 0.05, end: 0);
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }
}