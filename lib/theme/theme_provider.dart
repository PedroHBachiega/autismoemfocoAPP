import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme';
  static const String _highContrastKey = 'highContrast';

  bool _isDark = false;
  bool _isHighContrast = false;

  bool get isDark => _isDark;
  bool get isHighContrast => _isHighContrast;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get currentTheme {
    if (_isHighContrast) return AppTheme.highContrastTheme;
    if (_isDark) return AppTheme.darkTheme;
    return AppTheme.lightTheme;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check if preferences exist, otherwise use system brightness
    if (prefs.containsKey(_themeKey)) {
      _isDark = prefs.getString(_themeKey) == 'dark';
    } else {
      final dispatcher = WidgetsBinding.instance.platformDispatcher;
      _isDark = dispatcher.platformBrightness == Brightness.dark;
    }
    
    _isHighContrast = prefs.getString(_highContrastKey) == 'true';
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    if (_isHighContrast) {
      _isHighContrast = false; // Disable high contrast if manually toggling normal theme
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, _isDark ? 'dark' : 'light');
    await prefs.setString(_highContrastKey, 'false');
    notifyListeners();
  }

  Future<void> toggleHighContrast() async {
    _isHighContrast = !_isHighContrast;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_highContrastKey, _isHighContrast ? 'true' : 'false');
    if (_isHighContrast) {
      _isDark = true;
      await prefs.setString(_themeKey, 'dark');
    }
    notifyListeners();
  }
}
