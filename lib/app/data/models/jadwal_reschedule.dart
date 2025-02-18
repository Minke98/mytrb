class JadwalReschedule {
  String? ucPendaftaran;
  String? ucDiklatJadwalLast;
  String? ucDiklatJadwal;
  String? periode;

  JadwalReschedule({
    this.ucPendaftaran,
    this.ucDiklatJadwalLast,
    this.ucDiklatJadwal,
    this.periode,
  });

  // From JSON
  factory JadwalReschedule.fromJson(Map<String, dynamic> json) {
    return JadwalReschedule(
      ucPendaftaran: json['uc_pendaftaran'],
      ucDiklatJadwalLast: json['uc_diklat_jadwal_last'],
      ucDiklatJadwal: json['uc_diklat_jadwal'],
      periode: json['periode'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'uc_pendaftaran': ucPendaftaran,
      'uc_diklat_jadwal_last': ucDiklatJadwalLast,
      'uc_diklat_jadwal': ucDiklatJadwal,
      'periode': periode,
    };
  }
}
