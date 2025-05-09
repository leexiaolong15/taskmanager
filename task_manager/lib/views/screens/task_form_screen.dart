import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/controllers/user_controller.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/core/result.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  Task? _editing;
  String _title = '';
  String _description = '';
  String _status = 'To Do';
  int _priority = 2; // Medium
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _editing = widget.task;
    if (_editing != null) {
      _title = _editing!.title;
      _description = _editing!.description;
      _status = _editing!.status;
      _priority = _editing!.priority;
      _dueDate = _editing!.dueDate;
    } else {
      _dueDate = DateTime.now().add(const Duration(days: 7));
    }
  }

  int _getPriorityValue(String priority) {
    switch (priority) {
      case 'Low':
        return 1;
      case 'High':
        return 3;
      default:
        return 2; // Medium
    }
  }

  String _getPriorityString(int priority) {
    switch (priority) {
      case 1:
        return 'Low';
      case 3:
        return 'High';
      default:
        return 'Medium';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final currentUser = context.read<UserController>().currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn chưa đăng nhập')),
      );
      return;
    }

    final now = DateTime.now();
    final task = Task(
      id: _editing?.id ?? const Uuid().v4(),
      title: _title,
      description: _description,
      status: _status,
      priority: _priority,
      dueDate: _dueDate,
      createdAt: _editing?.createdAt ?? now,
      updatedAt: now,
      assignedTo: null,
      createdBy: currentUser.id,
      category: null,
      attachments: _editing?.attachments ?? [],
      completed: _status == 'Done',
    );

    final res = await context.read<TaskController>().addOrUpdate(task);

    if (res is Err<Task, Exception>) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${res.error}')),
      );
    } else if (res is Ok<Task, Exception>) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editing == null ? 'Thêm nhiệm vụ' : 'Sửa nhiệm vụ'),
        backgroundColor: Colors.green, // Consistent app bar color
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.green[50], // Very light background
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  validator: (value) => value!.isEmpty ? 'Vui lòng nhập tiêu đề' : null,
                  onSaved: (value) => _title = value!,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  initialValue: _description,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  maxLines: 3,
                  onSaved: (value) => _description = value!,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: _status,
                  items: ['To Do', 'In Progress', 'Done'].map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) => setState(() => _status = value!),
                  decoration: const InputDecoration(
                    labelText: 'Trạng thái',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: _getPriorityString(_priority),
                  items: ['Low', 'Medium', 'High'].map((priority) {
                    return DropdownMenuItem(value: priority, child: Text(priority));
                  }).toList(),
                  onChanged: (value) => setState(() => _priority = _getPriorityValue(value!)),
                  decoration: const InputDecoration(
                    labelText: 'Độ ưu tiên',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  title: const Text('Ngày hạn'),
                  subtitle: Text(_dueDate != null
                      ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                      : 'Chưa chọn'),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _dueDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() => _dueDate = date);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Lưu', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}