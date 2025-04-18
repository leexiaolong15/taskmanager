import 'dart:io';

void main() {
  // Nhập tên người dùng
  stdout.write("Nhap ten nguoi dung: ");
  String name = stdin.readLineSync()!;

  // Nhập tuổi người dùng
  stdout.write("Nhap tuoi nguoi dung: ");
  int age = int.parse(stdin.readLineSync()!);

  print("Xin chao: $name, tuoi cua ban la: $age");
}
