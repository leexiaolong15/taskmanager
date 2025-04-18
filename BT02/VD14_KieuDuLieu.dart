void main() {
  // int: Kiểu số nguyên
  int x = 100;

  // double: Kiểu số thực
  double y = 3.14;

  // num: có thể chứa số nguyên hoặc số thực
  num z = 3.14;
  num t = 293;

  // Chuyển chuỗi sang số nguyên
  var one = int.parse("1");
  print(one == 1 ? "True" : "False");

  // Chuyển chuỗi sang số thực
  var onePointOne = double.parse("1.1");
  print(onePointOne == 1.1 ? "True" : "False");

  // Số nguyên => Chuỗi
  String oneAsString = 1.toString();
  print(oneAsString);

  // Số thực => Chuỗi
  String piAsString = 3.14159.toStringAsFixed(2);
  print(piAsString);
}
