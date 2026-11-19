import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../services/notes_store.dart';
import '../widgets/note_image.dart';
import 'note_details_screen.dart' show confirmDelete;

/// Used for both creating (note == null) and editing a note.
class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late DateTime _date;
  String? _imagePath;
  bool _saving = false;

  bool get _isEdit => widget.note != null;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.note?.title ?? '');
    _description = TextEditingController(text: widget.note?.description ?? '');
    _date = widget.note?.date ?? DateTime.now();
    _imagePath = widget.note?.imagePath;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await ImagePicker()
          .pickImage(source: source, maxWidth: 1600, imageQuality: 85);
      if (picked == null) return;
      final saved = await persistPickedImage(picked);
      if (mounted) setState(() => _imagePath = saved);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load that photo.')),
      );
    }
  }

  void _showImageOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            if (_imagePath != null)
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded),
                title: const Text('Remove photo'),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _imagePath = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final store = context.read<NotesStore>();
    final nav = Navigator.of(context);

    if (_isEdit) {
      await store.update(widget.note!.copyWith(
        title: _title.text.trim(),
        description: _description.text.trim(),
        date: _date,
        imagePath: _imagePath,
        clearImage: _imagePath == null,
      ));
    } else {
      await store.add(Note(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: _title.text.trim(),
        description: _description.text.trim(),
        date: _date,
        imagePath: _imagePath,
      ));
    }
    nav.pop();
  }

  Future<void> _delete() async {
    final store = context.read<NotesStore>();
    final nav = Navigator.of(context);
    if (await confirmDelete(context)) {
      await store.delete(widget.note!.id);
      // Close the editor and the details screen underneath it.
      nav.pop();
      if (nav.canPop()) nav.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEdit ? 'Edit Note' : 'New Observation',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text('Observation Photo',
                  style: text.labelLarge?.copyWith(color: cs.onSurfaceVariant)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _showImageOptions,
                borderRadius: BorderRadius.circular(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      _imagePath == null
                          ? Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: cs.outlineVariant, width: 2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.photo_camera_rounded,
                                      size: 40, color: cs.onSurfaceVariant),
                                  const SizedBox(height: 8),
                                  Text('Tap to add a photo',
                                      style: text.labelLarge?.copyWith(
                                          color: cs.onSurfaceVariant)),
                                ],
                              ),
                            )
                          : NoteImage(path: _imagePath, height: 240),
                      if (_imagePath != null)
                        Positioned(
                          right: 12,
                          bottom: 12,
                          child: FilledButton.tonalIcon(
                            onPressed: _showImageOptions,
                            icon: const Icon(Icons.photo_camera_rounded),
                            label: const Text('Change Photo'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _title,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Note Title',
                  hintText: 'e.g., Morning Ferns by the Creek',
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Observation Date',
                    prefixIcon: Icon(Icons.calendar_today_rounded),
                  ),
                  child: Text(formatDate(_date)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _description,
                minLines: 5,
                maxLines: 12,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  hintText:
                      'What did you observe? Describe the colors, sounds, and environment...',
                ),
              ),
              if (_isEdit) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cs.errorContainer.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cs.error.withOpacity(0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Danger Zone',
                          style: text.labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                          'Deleting this note is permanent and cannot be undone.',
                          style: text.bodySmall),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        style:
                            FilledButton.styleFrom(backgroundColor: cs.error),
                        onPressed: _delete,
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: const Text('Delete Note'),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48)),
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(_isEdit ? 'Save Changes' : 'Save Note'),
            ),
          ),
        ),
      ),
    );
  }
}
