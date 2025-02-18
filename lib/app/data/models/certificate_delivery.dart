class CertificateDelivery {
  String? ucPengajuan;
  String? noTiket;
  String? isPass;
  String? jmlSertifikat;
  String? tglPengajuan;

  CertificateDelivery({
    this.ucPengajuan,
    this.noTiket,
    this.isPass,
    this.jmlSertifikat,
    this.tglPengajuan,
  });

  // Convert JSON to CertificateDelivery
  factory CertificateDelivery.fromJson(Map<String, dynamic> json) {
    return CertificateDelivery(
      ucPengajuan: json['uc_pengajuan'],
      noTiket: json['no_tiket'],
      isPass: json['is_pass'],
      jmlSertifikat: json['jml_sertifikat'],
      tglPengajuan: json['tgl_pengajuan'],
    );
  }

  // Convert CertificateDelivery to JSON
  Map<String, dynamic> toJson() {
    return {
      'uc_pengajuan': ucPengajuan,
      'no_tiket': noTiket,
      'is_pass': isPass,
      'jml_sertifikat': jmlSertifikat,
      'tgl_pengajuan': tglPengajuan,
    };
  }
}
