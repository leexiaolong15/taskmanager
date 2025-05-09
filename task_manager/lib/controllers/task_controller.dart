import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../db/dao/task_dao.dart';
import '../core/result.dart';

class TaskController extends ChangeNotifier {
  final TaskDao _dao = TaskDao();
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _dao.getAllTasks();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Result<Task, Exception>> addOrUpdate(Task task) async {
    try {
      await _dao.insertTask(task);
      await loadTasks();
      return Ok(task);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return Err(Exception(e.toString()));
    }
  }

  Future<Result<void, Exception>> delete(String id) async {
    try {
      await _dao.deleteTask(id);
      await loadTasks();
      return Ok(null);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return Err(Exception(e.toString()));
    }
  }
}