import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../core/result.dart';
import '../services/user_service.dart';

/// UserController: quản lý state và gọi UserService để xử lý login/register.
class UserController extends ChangeNotifier {
  final UserService _service = UserService();
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Đăng nhập
  Future<Result<User, Exception>> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final result = await _service.login(username, password);
      if (result is Ok<User, Exception>) {
        _currentUser = result.value;
        notifyListeners();
      }
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return Err(Exception(e.toString()));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Đăng ký
  Future<Result<User, Exception>> register({
    required String username,
    required String password,
    required String email,
    String? avatarUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final result = await _service.register(
        username: username,
        password: password,
        email: email,
        avatarUrl: avatarUrl,
      );
      if (result is Ok<User, Exception>) {
        _currentUser = result.value;
        notifyListeners();
      }
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return Err(Exception(e.toString()));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Đăng xuất
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}