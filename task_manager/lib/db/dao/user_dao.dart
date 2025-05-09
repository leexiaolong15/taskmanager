import 'package:sqflite/sqflite.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/db/db_helper.dart';

/// UserDao: CRUD operations cho bảng users
class UserDao {
  final DbHelper _db = DbHelper.instance; // Sửa ở đây: sử dụng DbHelper.instance

  /// Thêm mới hoặc cập nhật user
  Future<int> insertUser(User user) async {
    final db = await _db.database;
    return db.insert(
      DbHelper.userTable,
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Lấy user theo ID
  Future<User?> getUserById(String id) async {
    final db = await _db.database;
    final maps = await db.query(
      DbHelper.userTable,
      where: '${DbHelper.columnUserId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) return User.fromJson(maps.first);
    return null;
  }

  /// Lấy danh sách tất cả users
  Future<List<User>> getAllUsers() async {
    final db = await _db.database;
    final maps = await db.query(DbHelper.userTable);
    return maps.map((m) => User.fromJson(m)).toList();
  }

  /// Cập nhật user
  Future<int> updateUser(User user) async {
    final db = await _db.database;
    return db.update(
      DbHelper.userTable,
      user.toJson(),
      where: '${DbHelper.columnUserId} = ?',
      whereArgs: [user.id],
    );
  }

  /// Xóa user theo ID
  Future<int> deleteUser(String id) async {
    final db = await _db.database;
    return db.delete(
      DbHelper.userTable,
      where: '${DbHelper.columnUserId} = ?',
      whereArgs: [id],
    );
  }

  /// Thêm phương thức getUserByUsername
  Future<User?> getUserByUsername(String username) async {
    final db = await _db.database;
    final maps = await db.query(
      DbHelper.userTable,
      where: '${DbHelper.columnUsername} = ?',
      whereArgs: [username],
    );
    if (maps.isNotEmpty) return User.fromJson(maps.first);
    return null;
  }
}