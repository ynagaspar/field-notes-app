import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';

/// Holds all notes in memory and persists them to local storage.
class NotesStore extends ChangeNotifier {
  static const _key = 'notes_v1';

  final List<Note> _notes = [];

  List<Note> get notes => List.unmodifiable(_notes);

  Note? byId(String id) {
    for (final n in _notes) {
      if (n.id == id) return n;
    }
    return null;
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw != null && raw.isNotEmpty) {
        _notes
          ..clear()
          ..addAll(Note.decodeList(raw));
        _sort();
      }
    } catch (e) {
      debugPrint('Failed to load notes: $e');
    }
    notifyListeners();
  }

  Future<void> add(Note note) async {
    _notes.add(note);
    _sort();
    notifyListeners();
    await _save();
  }

  Future<void> update(Note note) async {
    final i = _notes.indexWhere((n) => n.id == note.id);
    if (i == -1) return;
    _notes[i] = note;
    _sort();
    notifyListeners();
    await _save();
  }

  Future<void> delete(String id) async {
    _notes.removeWhere((n) => n.id == id);
    notifyListeners();
    await _save();
  }

  void _sort() => _notes.sort((a, b) => b.date.compareTo(a.date));

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, Note.encodeList(_notes));
    } catch (e) {
      debugPrint('Failed to save notes: $e');
    }
  }
}
