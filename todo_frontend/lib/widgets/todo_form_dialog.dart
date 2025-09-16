import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';

/// PUBLIC_INTERFACE
Future<void> showTodoFormDialog({
  required BuildContext context,
  Todo? initial,
  required void Function({
    required String title,
    String? description,
    DateTime? dueDate,
  }) onSubmit,
  String? titleText,
}) {
  final titleController = TextEditingController(text: initial?.title ?? '');
  final descController = TextEditingController(text: initial?.description ?? '');
  DateTime? dueDateValue = initial?.dueDate;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      final viewInsets = MediaQuery.of(ctx).viewInsets.bottom;
      return Padding(
        padding: EdgeInsets.only(bottom: viewInsets),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      titleText ?? (initial == null ? 'Add Todo' : 'Edit Todo'),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter a concise title',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Add more details (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Due date (optional)'),
                        child: InkWell(
                          onTap: () async {
                            final now = DateTime.now();
                            final picked = await showDatePicker(
                              context: ctx,
                              firstDate: DateTime(now.year - 1),
                              lastDate: DateTime(now.year + 3),
                              initialDate: dueDateValue ?? now,
                            );
                            if (picked != null) {
                              setState(() => dueDateValue = DateTime(
                                    picked.year,
                                    picked.month,
                                    picked.day,
                                  ));
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              dueDateValue != null ? DateFormat.yMMMd().format(dueDateValue!) : 'Not set',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Clear date',
                      onPressed: () => setState(() => dueDateValue = null),
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      final title = titleController.text.trim();
                      final desc = descController.text.trim().isEmpty ? null : descController.text.trim();
                      if (title.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(content: Text('Title is required')),
                        );
                        return;
                      }
                      onSubmit(title: title, description: desc, dueDate: dueDateValue);
                      Navigator.pop(ctx);
                    },
                    label: Text(initial == null ? 'Create' : 'Save changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
