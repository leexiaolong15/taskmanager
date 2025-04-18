/*
  Typedefs là một cách ngắn gọn để tạo ra các allas (bí danh) cho các loại dữ liệu.
  Điều này giúp mã nguồn trở nên rõ ràng và dễ đọc hơn, đặc biệt khi làm việc với các loại dữ liệu phức tạp.
*/

import 'dart:ffi';

typedef IntList = List<int>;

typedef ListMapper<X> = Map<X, List<X>>;

void main() {
  List<int> l1 = [1, 2, 3, 4, 5];
  print(l1);
  IntList l2 = [1, 2, 3, 4, 5];
  Map<String, List<String>> m1 = {}; // Khá dài
  ListMapper<String> m2 = {}; // m1 và m2 cùng kiểu
}
