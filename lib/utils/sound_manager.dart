import 'package:audioplayers/audioplayers.dart';

// SETUP:
// Create assets/sounds/ folder and add:
//   correct.mp3, wrong.mp3, levelup.mp3, complete.mp3
// Free sounds available at freesound.org or zapsplat.com

class SoundManager {
  static final AudioPlayer _player = AudioPlayer();
  static bool enabled = true;

  static Future<void> playCorrect() async {
    if (!enabled) return;
    try {
      await _player.play(AssetSource('sounds/correct.mp3'));
    } catch (_) {}
  }

  static Future<void> playWrong() async {
    if (!enabled) return;
    try {
      await _player.play(AssetSource('sounds/wrong.mp3'));
    } catch (_) {}
  }

  static Future<void> playLevelUp() async {
    if (!enabled) return;
    try {
      await _player.play(AssetSource('sounds/levelup.mp3'));
    } catch (_) {}
  }

  static Future<void> playComplete() async {
    if (!enabled) return;
    try {
      await _player.play(AssetSource('sounds/complete.mp3'));
    } catch (_) {}
  }
}