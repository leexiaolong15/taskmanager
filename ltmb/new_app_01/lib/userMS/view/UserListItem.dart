import "dart:io";
import "package:new_app_01/userMS/db/UserDatabaseHelper.dart";
import "package:new_app_01/userMS/model/User.dart";
import "package:new_app_01/userMS/view/UserDetailScreen.dart";
import "package:new_app_01/userMS/view/EditUserScreen.dart"; // Thêm import này
import "package:flutter/material.dart";

class UserListItem extends StatelessWidget {
  final User user;
  final VoidCallback onDelete;
  final Function(User) onEdit;

  const UserListItem({
    Key? key,
    required this.user,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          backgroundImage: user.avatar != null
              ? FileImage(File(user.avatar!))
              : null,
          child: user.avatar == null
              ? Text(user.name.substring(0, 1).toUpperCase())
              : null,
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () async {
                final updatedUser = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserScreen(user: user), // Sử dụng EditUserScreen
                  ),
                );
                if (updatedUser == true) { // Kiểm tra kết quả trả về
                  onEdit(user); // Gọi onEdit để cập nhật danh sách
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Xác nhận xóa'),
                    content: const Text('Bạn có chắc chắn muốn xóa người dùng này?'),
                    actions: [
                      TextButton(
                        child: const Text('Hủy'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text('Xóa'),
                        onPressed: () {
                          onDelete();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailScreen(user: user),
            ),
          );
        },
      ),
    );
  }
}