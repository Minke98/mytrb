class DetailJadwalDiklat {
  String? ucDiklatJadwal;
  String? ucDiklat;
  String? ucDiklatTahun;
  String? periode;
  String? namaDiklat;
  String? status;
  int? flagStatus;
  String? kuota;
  String? sisaKursi;
  String? biayaDiklat;
  String? pendaftaranAkhir;
  String? pelaksanaanMulai;
  String? pelaksanaanAkhir;

  DetailJadwalDiklat({
    this.ucDiklatJadwal,
    this.ucDiklat,
    this.ucDiklatTahun,
    this.periode,
    this.namaDiklat,
    this.status,
    this.flagStatus,
    this.kuota,
    this.sisaKursi,
    this.biayaDiklat,
    this.pendaftaranAkhir,
    this.pelaksanaanMulai,
    this.pelaksanaanAkhir,
  });

  // Factory method to create an instance of JadwalDiklat from JSON
  factory DetailJadwalDiklat.fromJson(Map<String, dynamic> json) {
    return DetailJadwalDiklat(
      ucDiklatJadwal: json['uc_diklat_jadwal'],
      ucDiklat: json['uc_diklat'],
      ucDiklatTahun: json['uc_diklat_tahun'],
      periode: json['periode'],
      namaDiklat: json['nama_diklat'],
      status: json['status'],
      flagStatus: json['flag_status'],
      kuota: json['kuota'],
      sisaKursi: json['sisa_kursi'],
      biayaDiklat: json['biaya_diklat'],
      pendaftaranAkhir: json['pendaftaran_akhir'],
      pelaksanaanMulai: json['pelaksanaan_mulai'],
      pelaksanaanAkhir: json['pelaksanaan_akhir'],
    );
  }

  // Method to convert JadwalDiklat instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'uc_diklat_jadwal': ucDiklatJadwal,
      'uc_diklat': ucDiklat,
      'uc_diklat_tahun': ucDiklatTahun,
      'periode': periode,
      'nama_diklat': namaDiklat,
      'status': status,
      'flag_status': flagStatus,
      'kuota': kuota,
      'sisa_kursi': sisaKursi,
      'biaya_diklat': biayaDiklat,
      'pendaftaran_akhir': pendaftaranAkhir,
      'pelaksanaan_mulai': pelaksanaanMulai,
      'pelaksanaan_akhir': pelaksanaanAkhir,
    };
  }
}
