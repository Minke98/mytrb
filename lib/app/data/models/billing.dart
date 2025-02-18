class Billing {
  String? ucPendaftaran;
  String? ucPendaftar;
  String? noRegis;
  String? tglDaftar;
  String? namaDiklat;
  String? periode;
  String? noBilling;
  String? flagBayar;
  String? statusBayar;

  Billing({
    this.ucPendaftaran,
    this.ucPendaftar,
    this.noRegis,
    this.tglDaftar,
    this.namaDiklat,
    this.periode,
    this.noBilling,
    this.flagBayar,
    this.statusBayar,
  });

  factory Billing.fromJson(Map<String, dynamic> json) {
    return Billing(
      ucPendaftaran: json['uc_pendaftaran'],
      ucPendaftar: json['uc_pendaftar'],
      noRegis: json['no_regis'],
      tglDaftar: json['tgl_daftar'],
      namaDiklat: json['nama_diklat'],
      periode: json['periode'],
      noBilling: json['no_billing'],
      flagBayar: json['flag_bayar'],
      statusBayar: json['status_bayar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uc_pendaftaran': ucPendaftaran,
      'uc_pendaftar': ucPendaftar,
      'no_regis': noRegis,
      'tgl_daftar': tglDaftar,
      'nama_diklat': namaDiklat,
      'periode': periode,
      'no_billing': noBilling,
      'flag_bayar': flagBayar,
      'status_bayar': statusBayar,
    };
  }
}
