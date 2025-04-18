void main() {
  int diemToan = 8;
  int diemVan = 7;
  int tongDiem = 0;
  //Cong diem tung mon
  tongDiem += diemToan;
  tongDiem += diemVan;
  //Diem trung binh
  double diemTrungBinh = tongDiem / 2;
  // Gan diem dat / khong dat
  String? ketQua;
  ketQua ??= 'Chua xet';
  if (diemTrungBinh >= 5) {
    ketQua = 'Dat';
  }
  print('Diem trung binh: $diemTrungBinh');
  print('Ket qua: $ketQua');
}
