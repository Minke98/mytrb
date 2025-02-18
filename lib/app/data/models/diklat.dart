class Diklat {
  String? id;
  String? uc;
  String? ucJenisDiklat;
  String? kodeDiklat;
  String? namaDiklat;
  String? biayaDaftar;
  String? biayaKesehatan;
  String? biaya;
  String? lamaDiklat;
  String? isExist;
  String? checkKesehatan;

  Diklat({
    this.id,
    this.uc,
    this.ucJenisDiklat,
    this.kodeDiklat,
    this.namaDiklat,
    this.biayaDaftar,
    this.biayaKesehatan,
    this.biaya,
    this.lamaDiklat,
    this.isExist,
    this.checkKesehatan,
  });

  factory Diklat.fromJson(Map<String, dynamic> json) {
    return Diklat(
      id: json['id'] as String,
      uc: json['uc']as String,
      ucJenisDiklat: json['uc_jenis_diklat']as String,
      kodeDiklat: json['kode_diklat']as String,
      namaDiklat: json['nama_diklat']as String,
      biayaDaftar: json['biaya_daftar']as String,
      biayaKesehatan: json['biaya_kesehatan']as String,
      biaya: json['biaya']as String,
      lamaDiklat: json['lama_diklat']as String,
      isExist: json['is_exist']as String,
      checkKesehatan: json['check_kesehatan']as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uc': uc,
      'uc_jenis_diklat': ucJenisDiklat,
      'kode_diklat': kodeDiklat,
      'nama_diklat': namaDiklat,
      'biaya_daftar': biayaDaftar,
      'biaya_kesehatan': biayaKesehatan,
      'biaya': biaya,
      'lama_diklat': lamaDiklat,
      'is_exist': isExist,
      'check_kesehatan': checkKesehatan,
    };
  }
}