import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/storage_keys.dart';
import '../model/note.dart';


class NotesRepository {
  Future<List<Note>> loadNotes() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(StorageKeys.notes);
    if (raw == null || raw.isEmpty) return [];
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map((m) => Note.fromMap(m)).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> saveNotes(List<Note> notes) async {
    final sp = await SharedPreferences.getInstance();
    final jsonList = notes.map((n) => n.toMap()).toList();
    await sp.setString(StorageKeys.notes, jsonEncode(jsonList));
  }
}
