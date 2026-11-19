import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'note_editor_screen.dart';
import 'saved_notes_screen.dart';

/// Bottom navigation between Home and Saved Notes, with an "add" button.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  void _openCreate() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const NoteEditorScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(
            onAdd: _openCreate,
            onViewAll: () => setState(() => _index = 1),
          ),
          const SavedNotesScreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreate,
        icon: const Icon(Icons.add),
        label: const Text('Add Note'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.sticky_note_2_outlined),
              selectedIcon: Icon(Icons.sticky_note_2_rounded),
              label: 'Notes'),
        ],
      ),
    );
  }
}
