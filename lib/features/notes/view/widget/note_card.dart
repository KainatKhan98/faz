import 'package:flutter/material.dart';
import '../../../../data/model/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                note.title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface, // adapts to light/dark
                ),
              ),
              const SizedBox(height: 6),

              // Description
              if (note.description.isNotEmpty)
                Text(
                  note.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant, // lighter than title
                  ),
                ),
              const SizedBox(height: 10),

              // Footer
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: cs.outline),
                  const SizedBox(width: 6),
                  Text(
                    _friendly(note.updatedAt),
                    style: textTheme.bodySmall?.copyWith(
                      color: cs.outline,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Delete',
                    icon: Icon(Icons.delete_outline, color: cs.error),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _friendly(DateTime dt) {
    final now = DateTime.now();
    final d = DateTime(dt.year, dt.month, dt.day);
    final today = DateTime(now.year, now.month, now.day);
    final diff = today.difference(d).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}
