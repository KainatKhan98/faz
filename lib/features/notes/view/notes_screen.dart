import 'package:faz/features/notes/view/widget/note_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/model/note.dart';
import '../viewmodel/notes_viewmodel.dart';


class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotesViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: vm.notes.isEmpty
          ? const _EmptyState()
          : ListView.builder(
        itemCount: vm.notes.length,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (ctx, i) {
          final note = vm.notes[i];
          return NoteCard(
            note: note,
            onTap: () => _showEdit(context, note),
            onDelete: () async {
              await vm.deleteNote(note);
              _showUndoSnackbar(context, vm);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add note'),
        onPressed: () => _showAdd(context),
      ),
    );
  }

  void _showUndoSnackbar(BuildContext context, NotesViewModel vm) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => vm.undoDelete(),
        ),
      ),
    );
  }

  Future<void> _showAdd(BuildContext context) async {
    final vm = context.read<NotesViewModel>();
    final res = await showModalBottomSheet<_NoteResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _NoteEditor(),
    );
    if (res != null) {
      final ok = await vm.addNote(title: res.title, description: res.description);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title cannot be empty')));
      }
    }
  }

  Future<void> _showEdit(BuildContext context, Note note) async {
    final vm = context.read<NotesViewModel>();
    final res = await showModalBottomSheet<_NoteResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _NoteEditor(initialTitle: note.title, initialDescription: note.description),
    );
    if (res != null) {
      final ok = await vm.editNote(note, title: res.title, description: res.description);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title cannot be empty')));
      }
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sticky_note_2_outlined, size: 72, color: cs.outline),
            const SizedBox(height: 12),
            Text('No notes yet', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to create your first note.',
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.outline),
            )
          ],
        ),
      ),
    );
  }
}

class _NoteResult {
  final String title;
  final String description;
  _NoteResult(this.title, this.description);
}

class _NoteEditor extends StatefulWidget {
  final String? initialTitle;
  final String? initialDescription;
  const _NoteEditor({this.initialTitle, this.initialDescription});

  @override
  State<_NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<_NoteEditor> {
  late final TextEditingController titleCtrl;
  late final TextEditingController descCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.initialTitle ?? '');
    descCtrl = TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Wrap(runSpacing: 12, children: [
            Row(
              children: [
                Text(widget.initialTitle == null ? 'Add Note' : 'Edit Note',
                    style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            TextFormField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title', hintText: 'e.g., Grocery list'),
              textInputAction: TextInputAction.next,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
            ),
            TextFormField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Description', hintText: 'Optional details'),
              maxLines: 6,
              minLines: 3,
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context, _NoteResult(titleCtrl.text, descCtrl.text));
                }
              },
            ),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
  }
}
