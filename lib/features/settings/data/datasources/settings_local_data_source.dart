import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<void> saveThemeMode(bool isDark);
  Future<bool?> getThemeMode();
  Future<void> saveFontSize(double size);
  Future<double?> getFontSize();
  Future<void> saveDefaultWpm(int wpm);
  Future<int?> getDefaultWpm();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  static const String _themeModeKey = 'THEME_MODE_KEY';
  static const String _fontSizeKey = 'FONT_SIZE_KEY';
  static const String _defaultWpmKey = 'DEFAULT_WPM_KEY';

  @override
  Future<void> saveThemeMode(bool isDark) async {
    await sharedPreferences.setBool(_themeModeKey, isDark);
  }

  @override
  Future<bool?> getThemeMode() async {
    return sharedPreferences.getBool(_themeModeKey);
  }

  @override
  Future<void> saveFontSize(double size) async {
    await sharedPreferences.setDouble(_fontSizeKey, size);
  }

  @override
  Future<double?> getFontSize() async {
    return sharedPreferences.getDouble(_fontSizeKey);
  }

  @override
  Future<void> saveDefaultWpm(int wpm) async {
    await sharedPreferences.setInt(_defaultWpmKey, wpm);
  }

  @override
  Future<int?> getDefaultWpm() async {
    return sharedPreferences.getInt(_defaultWpmKey);
  }
}
