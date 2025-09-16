import 'dart:convert';

/// PUBLIC_INTERFACE
class Todo {
  /// Unique identifier (UUID string) for the todo
  final String id;

  /// Short title of the todo item
  final String title;

  /// Detailed description of the todo item (optional)
  final String? description;

  /// Whether the todo is completed
  final bool completed;

  /// Optional due date for the todo (ISO 8601)
  final DateTime? dueDate;

  /// Creation timestamp (UTC)
  final DateTime createdAt;

  /// Last update timestamp (UTC)
  final DateTime updatedAt;

  Todo({
    required this.id,
    required this.title,
    this.description,
    this.completed = false,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  /// PUBLIC_INTERFACE
  /// Parses a Todo from backend JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      completed: (json['completed'] as bool?) ?? false,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// PUBLIC_INTERFACE
  /// Converts a Todo to JSON map (for update requests)
  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'due_date': dueDate?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  /// PUBLIC_INTERFACE
  /// Converts a Todo to JSON map (for create requests)
  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'due_date': dueDate?.toIso8601String(),
    }..removeWhere((key, value) => value == null);
  }

  /// PUBLIC_INTERFACE
  /// Copy with updated fields
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => jsonEncode({
        'id': id,
        'title': title,
        'description': description,
        'completed': completed,
        'due_date': dueDate?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      });
}
