import 'package:flutter/material.dart';

import '../../../data/repositories/settings_repo.dart';
class SettingsViewModel extends ChangeNotifier {
  final _repo = SettingsRepository();
  ThemeMode _themeMode = ThemeMode.light;
  int _seedIndex = 0;

  ThemeMode get themeMode => _themeMode;
  int get seedIndex => _seedIndex;

  static const seeds = <Color>[
    Colors.blue,
    Colors.teal,
    Colors.deepPurple,
    Colors.pink,
  ];

  Color get seedColor => seeds[_seedIndex.clamp(0, seeds.length - 1)];

  Future<void> loadPersistedTheme() async {
    final (mode, idx) = await _repo.load();
    _themeMode = mode;
    _seedIndex = idx;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _repo.saveTheme(_themeMode);
    notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    _themeMode = mode;
    await _repo.saveTheme(mode);
    notifyListeners();
  }

  Future<void> changeSeed(int index) async {
    _seedIndex = index;
    await _repo.saveSeedIndex(index);
    notifyListeners();
  }
}
