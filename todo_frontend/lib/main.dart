import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'providers/todo_provider.dart';
import 'screens/todos_screen.dart';
import 'theme/app_theme.dart';

/// PUBLIC_INTERFACE
/// App entrypoint. Loads environment variables and starts the app with providers.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // If .env is missing in CI or other environments, app will fallback to defaults.
  }
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: MaterialApp(
        title: 'Ocean Todo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const TodosScreen(),
      ),
    );
  }
}
