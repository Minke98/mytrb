class InfoDiklat {
  String? ucPendaftaran;
  String? ucPendaftar;
  String? noPendaftaran;
  String? tanggalDaftar;
  String? statusValidasi;
  String? periode;
  String? pendaftaranAkhir;
  String? ucDiklat;
  String? namaDiklat;
  String? ucJadwalDiklat; // Properti baru

  InfoDiklat({
    this.ucPendaftaran,
    this.ucPendaftar,
    this.noPendaftaran,
    this.tanggalDaftar,
    this.statusValidasi,
    this.periode,
    this.pendaftaranAkhir,
    this.ucDiklat,
    this.namaDiklat,
    this.ucJadwalDiklat, // Tambahkan properti baru di konstruktor
  });

  // fromJson method
  factory InfoDiklat.fromJson(Map<String, dynamic> json) {
    return InfoDiklat(
      ucPendaftaran: json['uc_pendaftaran'] as String?,
      ucPendaftar: json['uc_pendaftar'] as String?,
      noPendaftaran: json['no_pendaftaran'] as String?,
      tanggalDaftar: json['tanggal_daftar'] as String?,
      statusValidasi: json['status_validasi'] as String?,
      periode: json['periode'] as String?,
      pendaftaranAkhir: json['pendaftaran_akhir'] as String?,
      ucDiklat: json['uc_diklat'] as String?,
      namaDiklat: json['nama_diklat'] as String?,
      ucJadwalDiklat: json['uc_jadwal_diklat'] as String?, // Tambahkan parsing properti baru
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'uc_pendaftaran': ucPendaftaran,
      'uc_pendaftar': ucPendaftar,
      'no_pendaftaran': noPendaftaran,
      'tanggal_daftar': tanggalDaftar,
      'status_validasi': statusValidasi,
      'periode': periode,
      'pendaftaran_akhir': pendaftaranAkhir,
      'uc_diklat': ucDiklat,
      'nama_diklat': namaDiklat,
      'uc_jadwal_diklat': ucJadwalDiklat, // Tambahkan properti baru di konversi ke JSON
    };
  }
}