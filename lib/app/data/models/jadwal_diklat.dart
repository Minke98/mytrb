class JadwalDiklat {
  String? ucDiklatJadwal;
  String? periode;
  String? ucDiklat;
  String? ucDiklatTahun;

  JadwalDiklat({
    this.ucDiklatJadwal,
    this.periode,
    this.ucDiklat,
    this.ucDiklatTahun,
  });

  // Factory method to create an instance of JadwalDiklat from JSON
  factory JadwalDiklat.fromJson(Map<String, dynamic> json) {
    return JadwalDiklat(
      ucDiklatJadwal: json['uc_diklat_jadwal'],
      periode: json['periode'],
      ucDiklat: json['uc_diklat'],
      ucDiklatTahun: json['uc_diklat_tahun'],
    );
  }

  // Method to convert JadwalDiklat instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'uc_diklat_jadwal': ucDiklatJadwal,
      'periode': periode,
      'uc_diklat': ucDiklat,
      'uc_diklat_tahun': ucDiklatTahun,
    };
  }
}
