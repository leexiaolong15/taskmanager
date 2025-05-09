import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/db/db_helper.dart';

/// TaskDao: CRUD, search, filter, batch cho bảng tasks
class TaskDao {
  final DbHelper _db = DbHelper.instance; // Sửa ở đây: sử dụng DbHelper.instance

  /// Chuyển Task thành Map để lưu DB
  Map<String, dynamic> _toDbMap(Task t) {
    final m = t.toJson();
    m[DbHelper.columnAttachments] = jsonEncode(t.attachments ?? []);
    m[DbHelper.columnCompleted] = t.completed ? 1 : 0;
    return m;
  }

  /// Chuyển Map từ DB thành Task
  Task _fromDbMap(Map<String, dynamic> m) {
    final data = Map<String, dynamic>.from(m);
    // Handle attachments properly - it could be null, empty string, or JSON string
    if (m[DbHelper.columnAttachments] != null && m[DbHelper.columnAttachments].isNotEmpty) {
      try {
        data['attachments'] = (jsonDecode(m[DbHelper.columnAttachments] as String) as List)
            .cast<String>();
      } catch (e) {
        data['attachments'] = <String>[];
      }
    } else {
      data['attachments'] = <String>[];
    }
    data['completed'] = m[DbHelper.columnCompleted] == 1;
    return Task.fromJson(data);
  }
  /// Thêm mới hoặc cập nhật task
  Future<int> insertTask(Task task) async {
    final db = await _db.database;
    return db.insert(
      DbHelper.taskTable,
      _toDbMap(task),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Lấy task theo ID
  Future<Task?> getTaskById(String id) async {
    final db = await _db.database;
    final maps = await db.query(
      DbHelper.taskTable,
      where: '${DbHelper.columnTaskId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) return _fromDbMap(maps.first);
    return null;
  }

  /// Lấy danh sách tất cả tasks
  Future<List<Task>> getAllTasks() async {
    final db = await _db.database;
    final maps = await db.query(DbHelper.taskTable);
    return maps.map((m) => _fromDbMap(m)).toList();
  }

  /// Cập nhật task
  Future<int> updateTask(Task task) async {
    final db = await _db.database;
    return db.update(
      DbHelper.taskTable,
      _toDbMap(task),
      where: '${DbHelper.columnTaskId} = ?',
      whereArgs: [task.id],
    );
  }

  /// Xóa task theo ID
  Future<int> deleteTask(String id) async {
    final db = await _db.database;
    return db.delete(
      DbHelper.taskTable,
      where: '${DbHelper.columnTaskId} = ?',
      whereArgs: [id],
    );
  }

  /// Tìm kiếm tasks theo từ khóa
  Future<List<Task>> searchTasks(String keyword) async {
    final db = await _db.database;
    final maps = await db.query(
      DbHelper.taskTable,
      where: '${DbHelper.columnTitle} LIKE ? OR ${DbHelper.columnDescription} LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
    );
    return maps.map((m) => _fromDbMap(m)).toList();
  }

  /// Lọc tasks theo status
  Future<List<Task>> filterByStatus(String status) async {
    final db = await _db.database;
    final maps = await db.query(
      DbHelper.taskTable,
      where: '${DbHelper.columnStatus} = ?',
      whereArgs: [status],
    );
    return maps.map((m) => _fromDbMap(m)).toList();
  }

  /// Chèn nhiều task với batch trong transaction
  Future<void> insertTasksBatch(List<Task> tasks) async {
    final db = await _db.database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var t in tasks) batch.insert(DbHelper.taskTable, _toDbMap(t));
      await batch.commit(noResult: true);
    });
  }
}