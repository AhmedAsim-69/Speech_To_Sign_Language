import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static late SharedPreferences _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static const _wordsFound = 'wordsFound';
  static const _wordsNotFound = 'wordsNotFound';
  static const _keyCity = 'keyCity';

  static Future storeWords(String words) async {
    await _preferences.setString(_wordsFound, words);
  }

  static Future storeNotWords(String notWords) async {
    await _preferences.setString(_wordsNotFound, notWords);
  }

  static String? getWords() {
    return _preferences.getString(_wordsFound);
  }

  static String? getNotWords() {
    return _preferences.getString(_wordsNotFound);
  }
}
