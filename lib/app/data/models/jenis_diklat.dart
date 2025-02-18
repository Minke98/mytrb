class JenisDiklat {
  String? id;
  String? uc;
  String? jenisDiklat;
  String? jenisBayar;
  String? category;
  String? isExist;

  JenisDiklat({
    this.id,
    this.uc,
    this.jenisDiklat,
    this.jenisBayar,
    this.category,
    this.isExist,
  });

  factory JenisDiklat.fromJson(Map<String, dynamic> json) {
    return JenisDiklat(
      id: json['id'] as String,
      uc: json['uc'] as String,
      jenisDiklat: json['jenis_diklat'] as String,
      jenisBayar: json['jenis_bayar'] as String,
      category: json['category'] as String,
      isExist: json['is_exist'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uc': uc,
      'jenis_diklat': jenisDiklat,
      'jenis_bayar': jenisBayar,
      'category': category,
      'is_exist': isExist,
    };
  }
}
