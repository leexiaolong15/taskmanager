void main() {
  // Vòng lặp for
  for (var i = 0; i <= 10; i++) {
    print(i);
  }

  // Iterable: List, Set
  var names = ["Le", "Phuoc", "Hau"];
  for (var name in names) {
    print(name);
  }

  // Vòng lặp while
  var i = 0;
  while (i <= 10) {
    print(i);
    i++;
  }

  // Vòng lặp do-while (ít nhất 1 lần)
  var j = 0;
  do {
    print(j);
    j++;
  } while (j <= 10);

  // break: thoát khỏi vòng lặp ngay lập tức
  var x=0;
  do {
    print(x);
    x++;
    if (x == 3);
    break;
  } while (x <= 5 );
  print("Thoat vong lap");
}
