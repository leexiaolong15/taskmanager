import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../db/dao/user_dao.dart';
import '../core/result.dart';

class UserService {
  final UserDao _userDao = UserDao();

  Future<User?> getUserByUsername(String username) async {
    return await _userDao.getUserByUsername(username);
  }

  Future<Result<User, Exception>> login(String username, String password) async {
    try {
      final user = await _userDao.getUserByUsername(username);
      if (user == null) return Err(Exception('Tài khoản không tồn tại'));
      if (user.password != password) return Err(Exception('Sai mật khẩu'));
      return Ok(user);
    } catch (e) {
      return Err(Exception(e.toString()));
    }
  }

  Future<Result<User, Exception>> register({
    required String username,
    required String password,
    required String email,
    String? avatarUrl,
  }) async {
    try {
      final existing = await _userDao.getUserByUsername(username);
      if (existing != null) return Err(Exception('Tên đăng nhập đã tồn tại'));

      // Tạo user mới với UUID
      final user = User(
        id: const Uuid().v4(),
        username: username,
        password: password,
        email: email,
        avatar: avatarUrl,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );

      await _userDao.insertUser(user);
      return Ok(user);
    } catch (e) {
      return Err(Exception(e.toString()));
    }
  }
}