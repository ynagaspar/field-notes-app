import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../services/notes_store.dart';
import '../widgets/note_image.dart';
import 'note_editor_screen.dart';

Future<bool> confirmDelete(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete note?'),
      content: const Text('Deleting this note is permanent and cannot be undone.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel')),
        FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return result ?? false;
}

class NoteDetailsScreen extends StatelessWidget {
  final String noteId;

  const NoteDetailsScreen({super.key, required this.noteId});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final Note? note = context.watch<NotesStore>().byId(noteId);

    if (note == null) {
      // Note was deleted; nothing to show.
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Observation Details',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NoteImage(path: note.imagePath, height: 300),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note.title,
                      style: text.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.event_note_rounded,
                          size: 16, color: cs.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text(formatDate(note.date),
                          style: text.labelLarge
                              ?.copyWith(color: cs.onSurfaceVariant)),
                    ],
                  ),
                  const Divider(height: 32),
                  Row(
                    children: [
                      Icon(Icons.subject_rounded, size: 20, color: cs.primary),
                      const SizedBox(width: 8),
                      Text('Description',
                          style: text.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      note.description.isEmpty
                          ? 'No description.'
                          : note.description,
                      style: text.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.edit_rounded),
                  label: const Text('Edit Note'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => NoteEditorScreen(note: note)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: cs.error),
                icon: const Icon(Icons.delete_rounded),
                label: const Text('Delete'),
                onPressed: () async {
                  final store = context.read<NotesStore>();
                  final nav = Navigator.of(context);
                  if (await confirmDelete(context)) {
                    await store.delete(note.id);
                    nav.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
