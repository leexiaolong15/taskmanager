import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../controllers/task_controller.dart';
import '../../core/result.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({Key? key}) : super(key: key);

  String _getPriorityText(int priority) {
    switch (priority) {
      case 1: return 'Thấp';
      case 3: return 'Cao';
      default: return 'Trung bình';
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = ModalRoute.of(context)!.settings.arguments as Task;
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết nhiệm vụ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mô tả:', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(task.description),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Trạng thái:', style: Theme.of(context).textTheme.titleSmall),
                              Text(task.status),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ưu tiên:', style: Theme.of(context).textTheme.titleSmall),
                              Text(_getPriorityText(task.priority)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 16),
                      Text('Ngày hết hạn:', style: Theme.of(context).textTheme.titleSmall),
                      Text('${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}'),
                    ],
                  ],
                ),
              ),
            ),
            if (task.attachments != null && task.attachments!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Tệp đính kèm:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...task.attachments!.map((url) => ListTile(
                leading: const Icon(Icons.attachment),
                title: Text(url),
              )),
            ],
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Chỉnh sửa'),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    '/task_form',
                    arguments: task,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Xóa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
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
                      final result = await context.read<TaskController>().delete(task.id);
                      if (result is Err<void, Exception>) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lỗi: ${result.error}')),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}