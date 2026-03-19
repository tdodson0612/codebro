import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/settings_manager.dart';
import '../utils/xp_manager.dart';
import '../utils/progress_tracker.dart';
import '../utils/bookmark_manager.dart';
import '../data/lessons.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsManager>();
    final xpManager = context.watch<XpManager>();
    final progress = xpManager.progress;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _sectionHeader('Appearance'),
          _card(children: [
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
              subtitle:
                  const Text('Switch between dark and light theme'),
              value: settings.darkMode,
              onChanged: (val) => settings.setDarkMode(val),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Font Size'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(
                    min: 11,
                    max: 20,
                    divisions: 9,
                    value: settings.fontSize,
                    label: '${settings.fontSize.toInt()}px',
                    onChanged: (val) => settings.setFontSize(val),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'Preview: Hello, World!',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: settings.fontSize,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),

          _sectionHeader('Sound'),
          _card(children: [
            SwitchListTile(
              secondary: const Icon(Icons.volume_up),
              title: const Text('Sound Effects'),
              subtitle: const Text(
                  'Play sounds for correct/wrong answers'),
              value: settings.soundEnabled,
              onChanged: (val) {
                settings.setSoundEnabled(val);
              },
            ),
          ]),

          _sectionHeader('Your Progress'),
          _card(children: [
            ListTile(
              leading:
                  const Icon(Icons.bolt, color: Colors.amber),
              title: const Text('Total XP'),
              trailing: Text(
                '${progress.xp} XP',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.emoji_events,
                  color: Colors.amber),
              title: const Text('Level'),
              trailing: Text(
                'Level ${progress.level} · ${progress.levelTitle}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Text('🔥',
                  style: TextStyle(fontSize: 22)),
              title: const Text('Current Streak'),
              trailing: Text(
                '${progress.streak} days',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ]),

          _sectionHeader('Reset'),
          _card(children: [
            ListTile(
              leading: const Icon(Icons.refresh,
                  color: Colors.orange),
              title: const Text('Reset Lesson Progress'),
              subtitle: const Text(
                  'Clear all completed lesson markers'),
              onTap: () => _confirmReset(
                context,
                title: 'Reset Lesson Progress?',
                body:
                    'This will unmark all completed lessons across all languages.',
                onConfirm: () async {
                  for (final language
                      in LessonData.allLessons.keys) {
                    await ProgressTracker.resetProgress(language);
                  }
                },
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.bookmark_remove,
                  color: Colors.orange),
              title: const Text('Clear All Bookmarks'),
              subtitle:
                  const Text('Remove all saved bookmarks'),
              onTap: () => _confirmReset(
                context,
                title: 'Clear All Bookmarks?',
                body:
                    'This will remove all bookmarked lessons.',
                onConfirm: () async {
                  for (final language
                      in LessonData.allLessons.keys) {
                    final bookmarks =
                        await BookmarkManager.getBookmarks(
                            language);
                    for (final title in bookmarks) {
                      await BookmarkManager.removeBookmark(
                          language, title);
                    }
                  }
                },
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.delete_forever,
                  color: Colors.red),
              title: const Text('Reset All XP & Streak',
                  style: TextStyle(color: Colors.red)),
              subtitle:
                  const Text('This cannot be undone'),
              onTap: () => _confirmReset(
                context,
                title: 'Reset XP & Streak?',
                body:
                    'Your XP, level, and streak will all be reset to zero.',
                onConfirm: () async {
                  await xpManager.resetAll();
                },
                destructive: true,
              ),
            ),
          ]),

          const SizedBox(height: 20),
          Center(
            child: Text(
              'CodeBro v1.0.0',
              style: TextStyle(
                  color: Colors.grey[600], fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 6),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: Column(children: children),
    );
  }

  Future<void> _confirmReset(
    BuildContext context, {
    required String title,
    required String body,
    required Future<void> Function() onConfirm,
    bool destructive = false,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: destructive
                ? ElevatedButton.styleFrom(
                    backgroundColor: Colors.red)
                : null,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await onConfirm();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Done!')),
        );
      }
    }
  }
}