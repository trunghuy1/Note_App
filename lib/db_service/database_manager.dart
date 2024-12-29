import 'firebase_service.dart';
import 'sqlite_service.dart';

class DatabaseManager {
  final FirebaseService _firebaseService = FirebaseService();
  final SQLiteService _sqliteService = SQLiteService();

  // Add data to both Firebase and SQLite
  Future<void> addPersonalTask(Map<String, dynamic> userPersonalMap, String id) async {
    await _firebaseService.addPersonalTask(userPersonalMap, id);
    userPersonalMap['id'] = id;
    userPersonalMap['done'] = 0; 
    await _sqliteService.addPersonalTask(userPersonalMap);
  }

  // Update task in both Firebase and SQLite
  Future<void> updateTask(String id, String updatedTask) async {
    await _firebaseService.updateTask(id, updatedTask);
    await _sqliteService.updateTask(id, {"work": updatedTask});
  }

  // Remove task from both Firebase and SQLite
  Future<void> removeTask(String id, String task) async {
    await _firebaseService.removeTask(id, task);
    await _sqliteService.deleteTask(id, task);
  }
}
