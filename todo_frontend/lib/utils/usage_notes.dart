library usage_notes;

/// PUBLIC_INTERFACE
/// Usage notes for backend connectivity:
///
/// - Base URL is read from .env via key: API_BASE_URL
/// - Fallback is http://localhost:3001
/// - Endpoints used match the backend OpenAPI:
///   - GET    /todos
///   - POST   /todos
///   - PUT    /todos/{id}
///   - DELETE /todos/{id}
///   - DELETE /todos?confirm=false
///
/// Emulator/device hints:
/// - Android emulator: http://10.0.2.2:3001
/// - iOS simulator:   http://localhost:3001
/// - Physical device: http://<your-machine-ip>:3001
