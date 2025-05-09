import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/controllers/user_controller.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/views/widgets/task_tile.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _searchQuery = '';
  String _filterStatus = 'All';
  final List<String> _statusFilters = ['All', 'To Do', 'In Progress', 'Done'];

  @override
  void initState() {
    super.initState();
    // Load tasks when the screen is displayed
    Future.microtask(() {
      context.read<TaskController>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskController = context.watch<TaskController>();
    final userController = context.watch<UserController>();

    // Check if the user is logged in
    if (userController.currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý nhiệm vụ'),
          backgroundColor: Colors.grey[300], // Neutral app bar color
        ),
        body: const Center(
          child: Text(
            'Vui lòng đăng nhập để xem danh sách nhiệm vụ',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    // Filter tasks based on search and filter
    List<Task> filteredTasks = taskController.tasks;
    if (_searchQuery.isNotEmpty) {
      filteredTasks = filteredTasks
          .where((task) => task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_filterStatus != 'All') {
      filteredTasks = filteredTasks.where((task) => task.status == _filterStatus).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách nhiệm vụ', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green, // Consistent app bar color
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              userController.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: Container(
        color: Colors.green[50], // Very light background
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Tìm kiếm',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _filterStatus,
                    items: _statusFilters.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _filterStatus = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: taskController.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : taskController.errorMessage != null
                  ? Center(child: Text('Lỗi: ${taskController.errorMessage}'))
                  : filteredTasks.isEmpty
                  ? const Center(child: Text('Không có nhiệm vụ nào.'))
                  : ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return TaskTile(
                    task: task,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskFormScreen(task: task),
                        ),
                      );
                    },
                    onDelete: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Xác nhận xóa'),
                          content: const Text('Bạn có chắc muốn xóa nhiệm vụ này?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Xóa'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await taskController.delete(task.id);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TaskFormScreen()),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}