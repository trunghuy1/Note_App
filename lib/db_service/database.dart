import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy công việc từ Firestore
  Stream<QuerySnapshot> getTask(String collectionName) {
    return _firestore.collection(collectionName).snapshots();
  }

  // Lấy công việc từ SQLite
  Future<List<Map<String, dynamic>>> getTasksFromSQLite(String collectionName) async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'tasks.db');
    var database = await openDatabase(path);
    
    // Lấy công việc từ bảng tương ứng trong SQLite
    return await database.query(collectionName);
  }

  // Thêm công việc mới vào Firestore
  Future<void> addTask(Map<String, dynamic> taskData, String collectionName) async {
    try {
      String id = taskData["id"];
      await _firestore.collection(collectionName).doc(id).set(taskData);
      print('Task added to $collectionName in Firestore');
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  // Thêm công việc mới vào SQLite
  Future<void> addTaskSQLite(Map<String, dynamic> taskData, String collectionName) async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'tasks.db');
    var database = await openDatabase(path);

    // Thêm công việc vào bảng  trong SQLite
    await database.insert(
      collectionName,
      taskData,
      conflictAlgorithm: ConflictAlgorithm.replace, 
    );
    print('Task added to $collectionName in SQLite');
  }

  // Cập nhật công việc trong Firestore
  Future<void> updateTask(String id, String updatedTask) async {
    try {
      await _firestore.collection('PersonalTask').doc(id).update({
        'work': updatedTask,
      });
      print('Task updated in Firestore');
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  // Xóa công việc khỏi Firestore
  Future<void> removeMethod(String id, String collectionName) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
      print('Task removed from $collectionName in Firestore');
    } catch (e) {
      print('Error removing task: $e');
    }
  }

  // Đánh dấu công việc là đã hoàn thành (chuyển từ PersonalTask sang DoneTask)
  Future<void> tickMethod(String id, String collectionName) async {
    try {
      // Lấy công việc từ Firestore
      DocumentSnapshot docSnap = await _firestore.collection(collectionName).doc(id).get();
      Map<String, dynamic> taskData = docSnap.data() as Map<String, dynamic>;

      
      taskData['done'] = true;
      await addToDoneTask(taskData, id);

     
      await removeMethod(id, collectionName);
    } catch (e) {
      print('Error ticking task: $e');
    }
  }

  // Thêm công việc vào collection DoneTask trong Firestore
  Future<void> addToDoneTask(Map<String, dynamic> taskData, String taskId) async {
    try {
      await _firestore.collection('DoneTask').doc(taskId).set(taskData);
      print('Task added to DoneTask in Firestore');
    } catch (e) {
      print('Error adding task to DoneTask: $e');
    }
  }

  // Thêm công việc vào bảng DoneTask trong SQLite
  Future<void> addToDoneTaskSQLite(Map<String, dynamic> taskData) async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'tasks.db');
    var database = await openDatabase(path);

    // Thêm công việc vào bảng DoneTask
    await database.insert(
      'DoneTask',
      taskData,
      conflictAlgorithm: ConflictAlgorithm.replace, 
    );
    print('Task added to DoneTask in SQLite');
  }

  //  tạo cơ sở dữ liệu SQLite
  Future<void> initializeDatabase() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'tasks.db');

    var database = await openDatabase(path, version: 1, onCreate: (db, version) async {
      // Tạo bảng PersonalTask
      await db.execute('''
        CREATE TABLE PersonalTask(
          id TEXT PRIMARY KEY,
          work TEXT,
          done INTEGER
        )
      ''');

      // Tạo bảng DoneTask
      await db.execute('''
        CREATE TABLE DoneTask(
          id TEXT PRIMARY KEY,
          work TEXT,
          done INTEGER
        )
      ''');
    });
    print('Database initialized');
  }
}
Future<void> addTaskToSQLite(Map<String, dynamic> taskData, String collectionName) async {
  // Lấy đường dẫn tới cơ sở dữ liệu
  var dbPath = await getDatabasesPath();
  String path = join(dbPath, 'tasks.db');
  
  // Mở cơ sở dữ liệu SQLite
  var database = await openDatabase(path);

  // Thêm công việc vào bảng tương ứng trong SQLite
  await database.insert(
    collectionName,  // Tên bảng (có thể là 'PersonalTask' hoặc 'DoneTask')
    taskData,        // Dữ liệu công việc cần thêm
    conflictAlgorithm: ConflictAlgorithm.replace, // Thay thế nếu trùng ID
  );

  print('Task added to $collectionName in SQLite');
}
