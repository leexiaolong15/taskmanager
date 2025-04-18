import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_app_01/main.dart'; // Sửa tên dự án

void main() {
  testWidgets('UserListScreen displays title and users', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Wait for the FutureBuilder to complete (since UserListScreen uses FutureBuilder).
    await tester.pumpAndSettle();

    // Verify that the title "Danh sách người dùng" is displayed in the AppBar.
    expect(find.text('Danh sách người dùng'), findsOneWidget);

    // Verify that at least one user is displayed (since we have sample data).
    // We can check for one of the sample user names, e.g., "Nguyễn Văn An".
    expect(find.text('Nguyễn Văn An'), findsOneWidget);

    // Optionally, verify that the "Không có người dùng nào" message is not displayed.
    expect(find.text('Không có người dùng nào'), findsNothing);
  });
}