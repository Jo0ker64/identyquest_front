import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontProvider extends ChangeNotifier {
    String _currentFont = 'Lexend';

    String get currentFont => _currentFont;

    FontProvider() {
        _loadFontFromPrefs();
    }

    void changeFont(String newFont) {
        _currentFont = newFont;
        _saveFontToPrefs(newFont);
        notifyListeners(); // 🔁 rebuild les widgets qui écoutent
    }

    Future<void> _loadFontFromPrefs() async {
        final prefs = await SharedPreferences.getInstance();
        _currentFont = prefs.getString('selectedFont') ?? 'Lexend';
        notifyListeners();
    }

    Future<void> _saveFontToPrefs(String font) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('selectedFont', font);
    }
}
