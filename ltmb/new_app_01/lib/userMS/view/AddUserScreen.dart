import 'package:new_app_01/userMS/db/UserDatabaseHelper.dart'; // Sửa từ app_02 thành user_management_app
import 'package:new_app_01/userMS/model/User.dart'; // Sửa từ app_02 thành user_management_app
import 'package:new_app_01/userMS/view/UserForm.dart'; // Sửa từ app_02 thành user_management_app
import 'package:flutter/material.dart';

class AddUserScreen extends StatelessWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserForm(
      onSave: (User user) async {
        try {
          await UserDatabaseHelper.instance.createUser(user);
          Navigator.pop(context, true); // Return true to indicate a new user was added

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Thêm người dùng thành công'),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi thêm người dùng: $e'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.pop(context, false);
        }
      },
    );
  }
}