import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/todo_form_dialog.dart';
import '../widgets/todo_tile.dart';

/// PUBLIC_INTERFACE
class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  bool? _filterCompleted;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TodoProvider>().fetchTodos());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();
    final todos = provider.todos.where((t) {
      if (_filterCompleted == null) return true;
      return t.completed == _filterCompleted;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Todos'),
        actions: [
          PopupMenuButton<bool?>(
            tooltip: 'Filter',
            icon: const Icon(Icons.filter_list),
            onSelected: (value) => setState(() => _filterCompleted = value),
            itemBuilder: (ctx) => [
              CheckedPopupMenuItem<bool?>(
                value: null,
                checked: _filterCompleted == null,
                child: const Text('All'),
              ),
              CheckedPopupMenuItem<bool?>(
                value: false,
                checked: _filterCompleted == false,
                child: const Text('Active'),
              ),
              CheckedPopupMenuItem<bool?>(
                value: true,
                checked: _filterCompleted == true,
                child: const Text('Completed'),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: provider.fetchTodos,
        child: provider.loading && provider.todos.isEmpty
            ? const _LoadingState()
            : todos.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: todos.length,
                    itemBuilder: (ctx, index) {
                      final todo = todos[index];
                      return TodoTile(
                        todo: todo,
                        onToggle: () => provider.toggleCompleted(todo),
                        onEdit: () => showTodoFormDialog(
                          context: context,
                          initial: todo,
                          onSubmit: ({required title, String? description, DateTime? dueDate}) {
                            provider.editTodo(todo, title: title, description: description, dueDate: dueDate);
                          },
                        ),
                        onDelete: () => provider.removeTodo(todo),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add'),
        onPressed: () {
          showTodoFormDialog(
            context: context,
            onSubmit: ({required String title, String? description, DateTime? dueDate}) {
              provider.addTodo(title: title, description: description, dueDate: dueDate);
            },
          );
        },
      ),
      bottomNavigationBar: _ErrorBar(message: provider.error),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: CircularProgressIndicator(),
      ),
    );
    }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      children: [
        const SizedBox(height: 80),
        Icon(Icons.task_alt_rounded, size: 72, color: Colors.blue.shade300),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'No todos yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'Tap the + button to add your first task',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }
}

class _ErrorBar extends StatelessWidget {
  final String? message;

  const _ErrorBar({this.message});

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFF1F2),
        border: Border(top: BorderSide(color: Color(0xFFFEE2E2))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message!)),
            ),
            child: const Text('DETAILS'),
          ),
        ],
      ),
    );
  }
}
