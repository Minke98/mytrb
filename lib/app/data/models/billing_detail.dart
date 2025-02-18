class BillingDetail {
  String? ucPendaftaran;
  String? ucPendaftar;
  String? noRegis;
  String? tglDaftar;
  String? namaDiklat;
  String? periode;
  String? noBilling;
  String? flagBayar;
  String? statusBayar;
  String? totalBayar;
  String? tglBayar;
  String? linkCetakInvoice;
  String? linkCetakKartu;
  String? linkCaraPembayaran;

  BillingDetail({
    this.ucPendaftaran,
    this.ucPendaftar,
    this.noRegis,
    this.tglDaftar,
    this.namaDiklat,
    this.periode,
    this.noBilling,
    this.flagBayar,
    this.statusBayar,
    this.totalBayar,
    this.tglBayar,
    this.linkCetakInvoice,
    this.linkCetakKartu,
    this.linkCaraPembayaran,
  });

  // fromJson
  factory BillingDetail.fromJson(Map<String, dynamic> json) {
    return BillingDetail(
      ucPendaftaran: json['uc_pendattaran'],
      ucPendaftar: json['uc_pendaftar'],
      noRegis: json['no_regis'],
      tglDaftar: json['tgl_daftar'],
      namaDiklat: json['nama_diklat'],
      periode: json['periode'],
      noBilling: json['no_billing'],
      flagBayar: json['flag_bayar'],
      statusBayar: json['status_bayar'],
      totalBayar: json['total_bayar'],
      tglBayar: json['tgl_bayar'],
      linkCetakInvoice: json['link_cetak_invoice'],
      linkCetakKartu: json['link_cetak_kartu'],
      linkCaraPembayaran: json['link_cara pembayaran'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'uc_pendattaran': ucPendaftaran,
      'uc_pendaftar': ucPendaftar,
      'no_regis': noRegis,
      'tgl_dattar': tglDaftar,
      'nama_diklat': namaDiklat,
      'periode': periode,
      'no_billing': noBilling,
      'flag_bayar': flagBayar,
      'status_bayar': statusBayar,
      'total_bayar': totalBayar,
      'tg1_bayar': tglBayar,
      'link_cetak_invoice': linkCetakInvoice,
      'link_cetak_kartu': linkCetakKartu,
      'link_cara pembayaran': linkCaraPembayaran,
    };
  }
}
