import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static late SharedPreferences _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static const _wordsFound = 'wordsFound';
  static const _poseWordsFound = 'poseWordsFound';
  static const _wordsNotFound = 'wordsNotFound';

  static Future storeWords(String words) async {
    await _preferences.setString(_wordsFound, words);
  }

  static Future storePoseWords(String words) async {
    await _preferences.setString(_wordsFound, words);
  }

  static Future storeNotWords(String notWords) async {
    await _preferences.setString(_wordsNotFound, notWords);
  }

  static String? getWords() {
    return _preferences.getString(_wordsFound);
  }

  static String? getPoseWords() {
    return _preferences.getString(_poseWordsFound);
  }

  static String? getNotWords() {
    return _preferences.getString(_wordsNotFound);
  }

  static void saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    }
  }

  static Future<dynamic> readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    dynamic obj = prefs.get(key);
    return obj;
  }
}
