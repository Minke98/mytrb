class CertificateType {
  String? ucPendaftaran;
  String? sertifikat;

  CertificateType({
    this.ucPendaftaran,
    this.sertifikat,
  });

  // fromJson method
  factory CertificateType.fromJson(Map<String, dynamic> json) {
    return CertificateType(
      ucPendaftaran: json['uc_pendaftaran'],
      sertifikat: json['sertifikat'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'ucPendaftaran': ucPendaftaran,
      'sertifikat': sertifikat,
    };
  }
}
