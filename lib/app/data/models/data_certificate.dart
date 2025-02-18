class DataCertificate {
  String? namaSertifikat;

  DataCertificate({this.namaSertifikat});

  // Mengubah dari JSON ke model Sertifikat
  factory DataCertificate.fromJson(Map<String, dynamic> json) {
    return DataCertificate(
      namaSertifikat: json['nama_sertifikat'],
    );
  }

  // Mengubah dari model Sertifikat ke JSON
  Map<String, dynamic> toJson() {
    return {
      'nama_sertifikat': namaSertifikat,
    };
  }
}
