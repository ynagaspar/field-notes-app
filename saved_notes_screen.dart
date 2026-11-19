import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/notes_store.dart';
import '../widgets/note_card.dart';
import 'note_details_screen.dart';

class SavedNotesScreen extends StatefulWidget {
  const SavedNotesScreen({super.key});

  @override
  State<SavedNotesScreen> createState() => _SavedNotesScreenState();
}

class _SavedNotesScreenState extends State<SavedNotesScreen> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final all = context.watch<NotesStore>().notes;
    final q = _query.trim().toLowerCase();
    final notes = q.isEmpty
        ? all
        : all
            .where((n) =>
                n.title.toLowerCase().contains(q) ||
                n.description.toLowerCase().contains(q))
            .toList();

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Field Notes',
                      style: text.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold, color: cs.primary)),
                  Text('Your outdoor observations',
                      style: text.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: _search,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search your notes...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _search.clear();
                            setState(() => _query = '');
                          },
                        ),
                  isDense: true,
                ),
              ),
            ),
            Expanded(
              child: notes.isEmpty
                  ? Center(
                      child: Text(
                        all.isEmpty
                            ? 'No observations yet'
                            : 'No notes match "$_query"',
                        style: text.bodyMedium
                            ?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 96),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: notes.length,
                      itemBuilder: (_, i) => NoteCard(
                        note: notes[i],
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                NoteDetailsScreen(noteId: notes[i].id),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
