import 'package:flutter/material.dart';

import '../../../data/model/note.dart';
import '../../../data/repositories/notes_repositories.dart';

class NotesViewModel extends ChangeNotifier {
  final _repo = NotesRepository();

  final _notes = <Note>[];
  List<Note> get notes => List.unmodifiable(_notes);

  Note? _lastDeleted; // <-- make this a field, not a getter
  int? _lastDeletedIndex;

  Future<void> init() async {
    final stored = await _repo.loadNotes();
    _notes
      ..clear()
      ..addAll(stored);
    notifyListeners();
  }

  Future<void> _persist() => _repo.saveNotes(_notes);

  Future<bool> addNote({required String title, String description = ''}) async {
    if (title.trim().isEmpty) return false;
    final note = Note(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      description: description.trim(),
      updatedAt: DateTime.now(),
    );
    _notes.insert(0, note);
    await _persist();
    notifyListeners();
    return true;
  }

  Future<bool> editNote(Note note, {required String title, required String description}) async {
    if (title.trim().isEmpty) return false;
    final idx = _notes.indexWhere((n) => n.id == note.id);
    if (idx == -1) return false;
    _notes[idx] = note.copyWith(
      title: title.trim(),
      description: description.trim(),
      updatedAt: DateTime.now(),
    );
    // Move to top when edited
    final updated = _notes.removeAt(idx);
    _notes.insert(0, updated);
    await _persist();
    notifyListeners();
    return true;
  }

  Future<void> deleteNote(Note note) async {
    _lastDeletedIndex = _notes.indexWhere((n) => n.id == note.id);
    if (_lastDeletedIndex == -1) return;
    _lastDeleted = _notes.removeAt(_lastDeletedIndex!); // ✅ now works
    await _persist();
    notifyListeners();
  }

  Future<void> undoDelete() async {
    if (_lastDeleted == null || _lastDeletedIndex == null) return;
    _notes.insert(_lastDeletedIndex!, _lastDeleted!);
    _lastDeleted = null;
    _lastDeletedIndex = null;
    await _persist();
    notifyListeners();
  }
}
