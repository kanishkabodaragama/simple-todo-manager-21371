import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';
import '../theme/app_theme.dart';

typedef TodoAction = void Function();

/// PUBLIC_INTERFACE
class TodoTile extends StatelessWidget {
  final Todo todo;
  final TodoAction onToggle;
  final TodoAction onEdit;
  final TodoAction onDelete;

  const TodoTile({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dueText = todo.dueDate != null ? 'Due ${DateFormat.yMMMd().format(todo.dueDate!.toLocal())}' : null;

    return Dismissible(
      key: ValueKey(todo.id),
      background: _slideLeftBackground(),
      secondaryBackground: _slideRightBackground(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEdit();
          return false;
        } else {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Delete todo?'),
              content: const Text('This action cannot be undone.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
          if (confirmed == true) {
            onDelete();
            return true;
          }
          return false;
        }
      },
      child: Card(
        child: ListTile(
          leading: Checkbox(
            value: todo.completed,
            onChanged: (_) => onToggle(),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.completed ? TextDecoration.lineThrough : null,
              color: todo.completed ? Colors.grey.shade500 : AppColors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((todo.description ?? '').trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    todo.description!.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              if (dueText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.event, size: 16, color: AppColors.secondary),
                      const SizedBox(width: 6),
                      Text(
                        dueText,
                        style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          trailing: IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: onEdit,
          ),
        ),
      ),
    );
  }

  Widget _slideLeftBackground() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(14)),
      child: const Row(
        children: [
          Icon(Icons.edit, color: AppColors.primary),
          SizedBox(width: 8),
          Text('Edit', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _slideRightBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(14)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Delete', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
          SizedBox(width: 8),
          Icon(Icons.delete_forever, color: AppColors.error),
        ],
      ),
    );
  }
}
