import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_frontend/main.dart';

void main() {
  testWidgets('Shows app bar title', (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();
    expect(find.text('Your Todos'), findsOneWidget);
  });

  testWidgets('Has FAB to add', (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());
    await tester.pump();
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
