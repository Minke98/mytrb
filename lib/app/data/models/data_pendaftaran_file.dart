class DataPendaftaranFile {
  final String? ucDiklat;
  final String? ucDiklatJadwal;
  final String? ucPendaftaran;
  final String? ucPersyaratan;
  final String? ucDiklatPersyaratan;

  DataPendaftaranFile({
    this.ucDiklat,
    this.ucDiklatJadwal,
    this.ucPendaftaran,
    this.ucPersyaratan,
    this.ucDiklatPersyaratan,
  });

  factory DataPendaftaranFile.fromJson(Map<String, dynamic> json) {
    return DataPendaftaranFile(
      ucDiklat: json['uc_diklat'],
      ucDiklatJadwal: json['uc_diklat_jadwal'],
      ucPendaftaran: json['uc_pendaftaran'],
      ucPersyaratan: json['uc_persyaratan'],
      ucDiklatPersyaratan: json['uc_diklat_persyaratan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uc_diklat': ucDiklat,
      'uc_diklat_jadwal': ucDiklatJadwal,
      'uc_pendaftaran': ucPendaftaran,
      'uc_persyaratan': ucPersyaratan,
      'uc_diklat_persyaratan': ucDiklatPersyaratan,
    };
  }
}
