/* 
  Chuỗi là một tập hợp ký tự UTF-16
*/

void main() {
  var s1 = "Nguyen Van A";
  var s2 = 'Nguyen Van A';

  // Chèn giá trị của một biểu thức, biến hóa vào trong chuỗi: ${....}
  double diemToan = 8.5;
  double diemVan = 9.0;
  var s3 = "Xin chào $s1, bạn đã đạt tổng điểm là: ${diemToan + diemVan}";
  print(s3);

  //Tạo ra chuỗi nằm ở nhiều dòng
  var s4 = '''
      Dòng 1
      Dòng 2
      Dòng 3
''';

  var s5 = """
      Dòng 1
      Dòng 2
      Dòng 3
""";

  // Chèn ký tự đặc biệt
  var s6 = "Đây là một đoạn \n văn bản!";
  print(s6);

  var s7 = r"Đây là một đoạn \n văn bản!"; //raw
  print(s7);

  var s8 = "Chuỗi 1 " + "Chuỗi 2";
  print(s8);

  var s9 =
      'Chuỗi '
      "này là "
      "một "
      'chuỗi';
  print(s9);
}
