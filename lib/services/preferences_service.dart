import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyAmount = 'last_quiz_amount';
  static const String _keyDifficulty = 'last_quiz_difficulty';
  static const String _keyType = 'last_quiz_type';
  static const String _keyTimer = 'last_quiz_timer';
  static const String _keyCategoryId = 'last_quiz_category_id';
  static const String _keyNickname = 'player_nickname';

  static Future<void> saveConfig({
    required int amount,
    required String difficulty,
    required String type,
    required int timerDurationSeconds,
    int? categoryId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAmount, amount);
    await prefs.setString(_keyDifficulty, difficulty);
    await prefs.setString(_keyType, type);
    await prefs.setInt(_keyTimer, timerDurationSeconds);
    if (categoryId != null) {
      await prefs.setInt(_keyCategoryId, categoryId);
    }
  }

  static Future<Map<String, dynamic>> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'amount': prefs.getInt(_keyAmount) ?? 10,
      'difficulty': prefs.getString(_keyDifficulty) ?? 'any',
      'type': prefs.getString(_keyType) ?? 'any',
      'timerDurationSeconds': prefs.getInt(_keyTimer) ?? 20,
      'categoryId': prefs.getInt(_keyCategoryId),
    };
  }

  static Future<void> saveNickname(String nickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNickname, nickname.trim());
  }

  static Future<String?> loadNickname() async {
    final prefs = await SharedPreferences.getInstance();
    final nickname = prefs.getString(_keyNickname)?.trim();
    if (nickname == null || nickname.isEmpty) {
      return null;
    }
    return nickname;
  }
}
