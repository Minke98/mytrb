class DiklatPengaduan {
  String? ucPendaftaran;
  String? diklat;

  DiklatPengaduan({
    this.ucPendaftaran,
    this.diklat,
  });

  factory DiklatPengaduan.fromJson(Map<String, dynamic> json) {
    return DiklatPengaduan(
      ucPendaftaran: json['uc_pendaftaran'],
      diklat: json['diklat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uc_pendaftaran': ucPendaftaran,
      'diklat': diklat,
    };
  }
}
