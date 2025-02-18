class CertificateDetail {
  String? ucPengajuan;
  String? noTiket;
  String? isPass;
  String? tglPengajuan;
  String? namaPengirim;
  String? alamatRumah;
  String? noTelepon;

  CertificateDetail({
    this.ucPengajuan,
    this.noTiket,
    this.isPass,
    this.tglPengajuan,
    this.namaPengirim,
    this.alamatRumah,
    this.noTelepon,
  });

  // Mengubah dari JSON ke model CertificateDetail
  factory CertificateDetail.fromJson(Map<String, dynamic> json) {
    return CertificateDetail(
      ucPengajuan: json['uc_pengajuan'],
      noTiket: json['no_tiket'],
      isPass: json['is_pass'],
      tglPengajuan: json['tgl_pengajuan'],
      namaPengirim: json['nama_pengirim'],
      alamatRumah: json['alamat_rumah'],
      noTelepon: json['no_tlpn'],
    );
  }

  // Mengubah dari model CertificateDetail ke JSON
  Map<String, dynamic> toJson() {
    return {
      'uc_pengajuan': ucPengajuan,
      'no_tiket': noTiket,
      'is_pass': isPass,
      'tgl_pengajuan': tglPengajuan,
      'nama_pengirim': namaPengirim,
      'alamat_rumah': alamatRumah,
      'no_tlpn': noTelepon,
    };
  }
}
