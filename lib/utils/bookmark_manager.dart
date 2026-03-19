import 'package:shared_preferences/shared_preferences.dart';

class BookmarkManager {
  static Future<void> bookmarkLesson(String language, String lessonTitle) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList('$language-bookmarks') ?? [];
    if (!bookmarks.contains(lessonTitle)) {
      bookmarks.add(lessonTitle);
    }
    prefs.setStringList('$language-bookmarks', bookmarks);
  }

  static Future<void> removeBookmark(String language, String lessonTitle) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList('$language-bookmarks') ?? [];
    bookmarks.remove(lessonTitle);
    prefs.setStringList('$language-bookmarks', bookmarks);
  }

  static Future<List<String>> getBookmarks(String language) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('$language-bookmarks') ?? [];
  }

  static Future<bool> isBookmarked(String language, String lessonTitle) async {
    final bookmarks = await getBookmarks(language);
    return bookmarks.contains(lessonTitle);
  }
}
