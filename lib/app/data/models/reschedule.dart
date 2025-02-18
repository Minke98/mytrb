class Reschedule {
  String? ucPendaftaran;
  String? ucDiklatTahun;
  String? ucDiklatJadwal;
  String? ucPendaftar;
  String? noRegis;
  String? namaDiklat;
  String? periode;
  String? tanggalPendaftaran;
  String? statusBayar;
  String? statusValidasi;

  Reschedule({
    this.ucPendaftaran,
    this.ucDiklatTahun,
    this.ucDiklatJadwal,
    this.ucPendaftar,
    this.noRegis,
    this.namaDiklat,
    this.periode,
    this.tanggalPendaftaran,
    this.statusBayar,
    this.statusValidasi,
  });

  // From JSON
  factory Reschedule.fromJson(Map<String, dynamic> json) {
    return Reschedule(
      ucPendaftaran: json['uc_pendaftaran'],
      ucDiklatTahun: json['uc_diklat_tahun'],
      ucDiklatJadwal: json['uc_diklat_jadwal'],
      ucPendaftar: json['uc_pendaftar'],
      noRegis: json['no_reg'],
      namaDiklat: json['nama_diklat'],
      periode: json['periode'],
      tanggalPendaftaran: json['tgl_daftar'],
      statusBayar: json['status_bayar'],
      statusValidasi: json['status_validasi'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'uc_pendaftaran': ucPendaftaran,
      'uc_diklat_tahun': ucDiklatTahun,
      'uc_diklat_jadwal': ucDiklatJadwal,
      'uc_pendaftar': ucPendaftar,
      'no_reg': noRegis,
      'nama_diklat': namaDiklat,
      'periode': periode,
      'tgl_daftar': tanggalPendaftaran,
      'status_bayar': statusBayar,
      'status_validasi': statusValidasi,
    };
  }
}
