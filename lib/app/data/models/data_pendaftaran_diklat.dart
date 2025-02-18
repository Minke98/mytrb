class DataPendaftaranDiklat {
  String? uc;
  String? ucPendaftaran;
  String? ucJadwalDiklat;

  DataPendaftaranDiklat({
    this.uc,
    this.ucPendaftaran,
    this.ucJadwalDiklat,
  });

  factory DataPendaftaranDiklat.fromJson(Map<String, dynamic> json) {
    return DataPendaftaranDiklat(
      uc: json['uc'] as String?,
      ucPendaftaran: json['uc_pendaftaran'] as String?,
      ucJadwalDiklat: json['uc_jadwal_diklat'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uc': uc,
      'uc_pendaftaran': ucPendaftaran,
      'uc_jadwal_diklat': ucJadwalDiklat,
    };
  }
}