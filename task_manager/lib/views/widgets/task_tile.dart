import 'package:flutter/material.dart';
import '../../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap, onDelete;

  const TaskTile({
    Key? key,
    required this.task,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (task.status) {
      case 'Done': return Colors.green;
      case 'In Progress': return Colors.orange;
      case 'Cancelled': return Colors.red;
      default: return Colors.blue;
    }
  }

  IconData _getPriorityIcon() {
    switch (task.priority) {
      case 1: return Icons.low_priority;
      case 3: return Icons.priority_high;
      default: return Icons.horizontal_rule;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(),
          child: Icon(
            task.completed ? Icons.check : _getPriorityIcon(),
            color: Colors.white,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: task.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.status),
            if (task.dueDate != null)
              Text(
                'Hạn: ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                style: TextStyle(
                  color: task.dueDate!.isBefore(DateTime.now()) && !task.completed
                      ? Colors.red
                      : null,
                ),
              ),
          ],
        ),
        onTap: onTap,
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}