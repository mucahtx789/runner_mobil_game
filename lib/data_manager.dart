import 'package:shared_preferences/shared_preferences.dart';

class DataManager {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Temel Kayıt Sistemi
  static Future<void> saveData(String key, dynamic value) async {
    if (value is int) await _prefs.setInt(key, value);
    if (value is String) await _prefs.setString(key, value);
    if (value is bool) await _prefs.setBool(key, value);

    // NOT: Google Play Games bağlandığında Cloud Save buraya tetiklenecek
    // if (GooglePlayService.isConnected) { GooglePlayService.cloudSync(key, value); }
  }

  // Getter Metodları
  static int getGold() => _prefs.getInt('gold') ?? 0;
  static int getHighScore() => _prefs.getInt('highscore') ?? 0;
  static int getLevel() => _prefs.getInt('level') ?? 1;
  static String getLanguage() => _prefs.getString('lang') ?? 'en';

  // Altın Ekleme (Mevcut olanın üstüne ekler)
  static Future<void> addGold(int amount) async {
    int currentGold = getGold();
    await saveData('gold', currentGold + amount);
  }

  // Rekor Güncelleme
  static Future<void> updateHighScore(int newScore) async {
    if (newScore > getHighScore()) {
      await saveData('highscore', newScore);
      // if (GooglePlayService.isConnected) { GooglePlayService.updateLeaderboard(newScore); }
    }
  }
}