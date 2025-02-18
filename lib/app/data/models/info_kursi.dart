class InfoKursi {
  String? jenisDiklat;
  String? namaDiklat;
  String? periode;
  String? pelaksanaanAkhir;
  String? kuota;
  String? sisaKursi;
  String? status;
  int? flagStatus;

  InfoKursi({
    this.jenisDiklat,
    this.namaDiklat,
    this.periode,
    this.pelaksanaanAkhir,
    this.kuota,
    this.sisaKursi,
    this.status,
    this.flagStatus,
  });

  // fromJson
  factory InfoKursi.fromJson(Map<String, dynamic> json) {
    return InfoKursi(
      jenisDiklat: json['jenis_diklat'],
      namaDiklat: json['nama_diklat'],
      periode: json['periode'],
      pelaksanaanAkhir: json['pelaksanaan_akhir'],
      kuota: json['kuota'],
      sisaKursi: json['sisa_kursi'],
      status: json['status'],
      flagStatus: json['flag_status'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'jenis_diklat': jenisDiklat,
      'nama_diklat': namaDiklat,
      'periode': periode,
      'pelaksanaan_akhir': pelaksanaanAkhir,
      'kuota': kuota,
      'sisa_kursi': sisaKursi,
      'status': status,
      'flag_status': flagStatus,
    };
  }
}
