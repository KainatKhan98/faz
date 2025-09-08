import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/storage_keys.dart';

class SettingsRepository {
  Future<(ThemeMode, int)> load() async {
    final sp = await SharedPreferences.getInstance();
    final modeStr = sp.getString(StorageKeys.themeMode);
    final seed = sp.getInt(StorageKeys.seedIndex) ?? 0;
    final mode = switch (modeStr) {
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.light,
    };
    return (mode, seed);
  }

  Future<void> saveTheme(ThemeMode mode) async {
    final sp = await SharedPreferences.getInstance();
    final value = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
      _ => 'light',
    };
    await sp.setString(StorageKeys.themeMode, value);
  }

  Future<void> saveSeedIndex(int idx) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(StorageKeys.seedIndex, idx);
  }
}
