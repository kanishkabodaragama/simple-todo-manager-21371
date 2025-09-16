import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/todo.dart';

/// Simple wrapper around HTTP exceptions for cleaner error handling.
class ApiException implements Exception {
  final int? statusCode;
  final String message;

  ApiException({this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// PUBLIC_INTERFACE
class ApiClient {
  ApiClient._internal();

  static final ApiClient instance = ApiClient._internal();

  /// PUBLIC_INTERFACE
  /// Returns the base URL from env or defaults to localhost:3001
  String get baseUrl {
    final envBase = dotenv.env['API_BASE_URL'];
    // If running on an emulator/device, users may need to adjust this value.
    return envBase?.trim().isNotEmpty == true ? envBase!.trim() : 'http://localhost:3001';
  }

  Map<String, String> get _jsonHeaders => {
        HttpHeaders.contentTypeHeader: 'application/json',
      };

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    return Uri.parse('$baseUrl$path').replace(queryParameters: query?.map((k, v) => MapEntry(k, '$v')));
  }

  /// PUBLIC_INTERFACE
  Future<List<Todo>> listTodos({bool? completed, int skip = 0, int limit = 50}) async {
    final query = <String, dynamic>{
      'skip': skip,
      'limit': limit,
    };
    if (completed != null) query['completed'] = completed;

    final res = await http.get(_uri('/todos', query));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data.map((e) => Todo.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw ApiException(statusCode: res.statusCode, message: 'Failed to load todos');
  }

  /// PUBLIC_INTERFACE
  Future<Todo> createTodo({
    required String title,
    String? description,
    bool completed = false,
    DateTime? dueDate,
  }) async {
    final body = jsonEncode({
      'title': title,
      'description': description,
      'completed': completed,
      'due_date': dueDate?.toIso8601String(),
    }..removeWhere((key, value) => value == null));

    final res = await http.post(_uri('/todos'), headers: _jsonHeaders, body: body);
    if (res.statusCode == 201 || res.statusCode == 200) {
      return Todo.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw ApiException(statusCode: res.statusCode, message: 'Failed to create todo');
  }

  /// PUBLIC_INTERFACE
  Future<Todo> updateTodo(String id, Map<String, dynamic> payload) async {
    final res = await http.put(_uri('/todos/$id'), headers: _jsonHeaders, body: jsonEncode(payload));
    if (res.statusCode == 200) {
      return Todo.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw ApiException(statusCode: res.statusCode, message: 'Failed to update todo');
  }

  /// PUBLIC_INTERFACE
  Future<void> deleteTodo(String id) async {
    final res = await http.delete(_uri('/todos/$id'));
    if (res.statusCode == 200) {
      return;
    }
    throw ApiException(statusCode: res.statusCode, message: 'Failed to delete todo');
  }

  /// PUBLIC_INTERFACE
  Future<void> deleteAll({bool confirm = false}) async {
    final res = await http.delete(_uri('/todos', {'confirm': confirm}));
    if (res.statusCode == 200) {
      return;
    }
    throw ApiException(statusCode: res.statusCode, message: 'Failed to delete all todos');
  }

  /// PUBLIC_INTERFACE
  Future<Todo> getTodo(String id) async {
    final res = await http.get(_uri('/todos/$id'));
    if (res.statusCode == 200) {
      return Todo.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
    }
    throw ApiException(statusCode: res.statusCode, message: 'Failed to get todo');
  }
}
