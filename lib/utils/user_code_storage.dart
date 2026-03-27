import 'package:shared_preferences/shared_preferences.dart';

class UserCodeStorage {
  static Future<void> saveCode(String language, String lesson, String code) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('\$language-\$lesson-code', code);
  }

  static Future<String> loadCode(String language, String lesson, String defaultCode) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('\$language-\$lesson-code') ?? defaultCode;
  }

  static Future<void> clearCode(String language, String lesson) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('\$language-\$lesson-code');
  }
}
