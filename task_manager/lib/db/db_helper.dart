import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// DbHelper: Quản lý kết nối SQLite, tạo schema và index.
class DbHelper {
  static const _dbName = 'task_manager.db';
  static const _dbVersion = 1;

  // Bảng users
  static const userTable = 'users';
  static const columnUserId = 'id';
  static const columnUsername = 'username';
  static const columnPassword = 'password';
  static const columnEmail = 'email';
  static const columnAvatar = 'avatar';
  static const columnCreatedAt = 'createdAt';
  static const columnLastActive = 'lastActive';

  // Bảng tasks
  static const taskTable = 'tasks';
  static const columnTaskId = 'id';
  static const columnTitle = 'title';
  static const columnDescription = 'description';
  static const columnStatus = 'status';
  static const columnPriority = 'priority';
  static const columnDueDate = 'dueDate';
  static const columnTaskCreatedAt = 'createdAt';
  static const columnUpdatedAt = 'updatedAt';
  static const columnAssignedTo = 'assignedTo';
  static const columnCreatedBy = 'createdBy';
  static const columnCategory = 'category';
  static const columnAttachments = 'attachments';
  static const columnCompleted = 'completed';

  // Singleton pattern
  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    _database = await openDatabase(path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
    return _database!;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $userTable (
        $columnUserId TEXT PRIMARY KEY,
        $columnUsername TEXT NOT NULL,
        $columnPassword TEXT NOT NULL,
        $columnEmail TEXT NOT NULL,
        $columnAvatar TEXT,
        $columnCreatedAt TEXT NOT NULL,
        $columnLastActive TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $taskTable (
        $columnTaskId TEXT PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnDescription TEXT NOT NULL,
        $columnStatus TEXT NOT NULL,
        $columnPriority INTEGER NOT NULL,
        $columnDueDate TEXT,
        $columnTaskCreatedAt TEXT NOT NULL,
        $columnUpdatedAt TEXT NOT NULL,
        $columnAssignedTo TEXT,
        $columnCreatedBy TEXT NOT NULL,
        $columnCategory TEXT,
        $columnAttachments TEXT,
        $columnCompleted INTEGER NOT NULL
      )
    ''');

    // Index tối ưu
    await db.execute(
        'CREATE INDEX idx_task_title ON $taskTable($columnTitle)'
    );
    await db.execute(
        'CREATE INDEX idx_task_status ON $taskTable($columnStatus)'
    );
  }
}