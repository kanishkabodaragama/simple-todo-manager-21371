import 'package:flutter/foundation.dart';

import '../models/todo.dart';
import '../services/api_client.dart';

/// PUBLIC_INTERFACE
class TodoProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient.instance;

  List<Todo> _todos = [];
  bool _loading = false;
  String? _error;

  List<Todo> get todos => _todos;
  bool get loading => _loading;
  String? get error => _error;

  /// PUBLIC_INTERFACE
  Future<void> fetchTodos() async {
    _setLoading(true);
    try {
      _todos = await _api.listTodos(limit: 200);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// PUBLIC_INTERFACE
  Future<void> addTodo({
    required String title,
    String? description,
    bool completed = false,
    DateTime? dueDate,
  }) async {
    _setLoading(true);
    try {
      final created = await _api.createTodo(
        title: title,
        description: description,
        completed: completed,
        dueDate: dueDate,
      );
      _todos = [created, ..._todos];
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// PUBLIC_INTERFACE
  Future<void> toggleCompleted(Todo todo) async {
    final idx = _todos.indexWhere((t) => t.id == todo.id);
    if (idx == -1) return;

    // Optimistic update
    final updatedLocal = todo.copyWith(completed: !todo.completed);
    _todos[idx] = updatedLocal;
    notifyListeners();
    try {
      final updated = await _api.updateTodo(todo.id, {'completed': updatedLocal.completed});
      _todos[idx] = updated;
      _error = null;
    } catch (e) {
      // rollback
      _todos[idx] = todo;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// PUBLIC_INTERFACE
  Future<void> editTodo(Todo todo, {required String title, String? description, DateTime? dueDate}) async {
    final idx = _todos.indexWhere((t) => t.id == todo.id);
    if (idx == -1) return;

    // Optimistic update
    final updatedLocal = todo.copyWith(title: title, description: description, dueDate: dueDate);
    _todos[idx] = updatedLocal;
    notifyListeners();
    try {
      final updated = await _api.updateTodo(todo.id, updatedLocal.toUpdateJson());
      _todos[idx] = updated;
      _error = null;
      notifyListeners();
    } catch (e) {
      // rollback
      _todos[idx] = todo;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// PUBLIC_INTERFACE
  Future<void> removeTodo(Todo todo) async {
    final idx = _todos.indexWhere((t) => t.id == todo.id);
    if (idx == -1) return;
    final removed = _todos[idx];
    _todos.removeAt(idx);
    notifyListeners();

    try {
      await _api.deleteTodo(removed.id);
      _error = null;
    } catch (e) {
      // rollback
      _todos.insert(idx, removed);
      _error = e.toString();
      notifyListeners();
    }
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
