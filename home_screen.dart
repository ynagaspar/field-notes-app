import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/notes_store.dart';
import '../widgets/note_card.dart';
import 'note_details_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onViewAll;

  const HomeScreen({super.key, required this.onAdd, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final notes = context.watch<NotesStore>().notes;
    final recent = notes.take(4).toList();

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Field Notes',
                              style: text.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF2E7D32))),
                          const SizedBox(height: 4),
                          Text("Welcome back, Ma'am!",
                              style: text.bodyMedium
                                  ?.copyWith(color: const Color(0xFF558B2F))),
                        ],
                      ),
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFFC8E6C9),
                        child: Text('Me',
                            style: TextStyle(
                                color: Color(0xFF1B5E20),
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Material(
                    color: const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: onAdd,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.add_a_photo_rounded,
                                  color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('New Observation',
                                      style: text.titleMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('Record your latest outdoor find',
                                      style: text.labelMedium?.copyWith(
                                          color: Colors.white70)),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded,
                                color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Notes',
                          style: text.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      TextButton(
                          onPressed: onViewAll, child: const Text('View All')),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (recent.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(Icons.eco_rounded, size: 48, color: cs.outline),
                          const SizedBox(height: 12),
                          Text('No observations yet',
                              style: text.titleMedium),
                          const SizedBox(height: 4),
                          Text('Tap "Add Note" to record your first find.',
                              style: text.bodySmall
                                  ?.copyWith(color: cs.onSurfaceVariant)),
                        ],
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: recent.length,
                      itemBuilder: (_, i) => NoteCard(
                        note: recent[i],
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                NoteDetailsScreen(noteId: recent[i].id),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb_outline_rounded,
                            color: cs.onSurfaceVariant),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Tip: Include weather conditions in your descriptions for better context later.',
                            style: text.bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 72),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
