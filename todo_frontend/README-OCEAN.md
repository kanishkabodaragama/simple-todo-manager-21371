# Ocean Todo - Flutter Frontend

Modern, minimalist Flutter app styled with "Ocean Professional" theme. It connects to the FastAPI backend at http://localhost:3001 by default (configurable via .env).

Features:
- List todos with pull-to-refresh and filter (All/Active/Completed)
- Floating Action Button to add new todos
- Swipe left to edit, swipe right to delete (with confirmation)
- Optimistic updates for toggle, edit, and delete
- Responsive UI and clean theme

Configuration:
1) Copy .env.example to .env and adjust:
   API_BASE_URL=http://localhost:3001

Run:
- Ensure the backend is running on the configured URL.
- flutter pub get
- flutter run

Project Structure:
- lib/models/todo.dart            -> Data model mapping to backend schema
- lib/services/api_client.dart    -> REST client using http
- lib/providers/todo_provider.dart-> App state and operations
- lib/screens/todos_screen.dart   -> Main screen
- lib/widgets/                     -> Reusable UI components
- lib/theme/app_theme.dart        -> Ocean Professional theme
