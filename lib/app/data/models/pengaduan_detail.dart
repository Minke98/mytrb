class PengaduanDetail {
  String? id;
  String? uc;
  String? noTiket;
  String? ucTypePengaduan;
  String? ucPendaftar;
  String? ucPendaftaran;
  String? aduan;
  String? file;
  String? tglAduan;
  String? status;
  String? jawaban;
  String? tglJawab;
  String? typePengaduan;
  String? namaDiklat;

  PengaduanDetail({
    this.id,
    this.uc,
    this.noTiket,
    this.ucTypePengaduan,
    this.ucPendaftar,
    this.ucPendaftaran,
    this.aduan,
    this.file,
    this.tglAduan,
    this.status,
    this.jawaban,
    this.tglJawab,
    this.typePengaduan,
    this.namaDiklat,
  });

  factory PengaduanDetail.fromJson(Map<String, dynamic> json) {
    return PengaduanDetail(
      id: json['id'],
      uc: json['uc'],
      noTiket: json['no_tiket'],
      ucTypePengaduan: json['uc_type_pengaduan'],
      ucPendaftar: json['uc_pendaftar'],
      ucPendaftaran: json['uc_pendaftaran'],
      aduan: json['aduan'],
      file: json['file'],
      tglAduan: json['tgl_aduan'],
      status: json['status'],
      jawaban: json['jawaban'],
      tglJawab: json['tgl_jawab'],
      typePengaduan: json['type_pengaduan'],
      namaDiklat: json['nama_diklat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uc': uc,
      'no_tiket': noTiket,
      'uc_type_pengaduan': ucTypePengaduan,
      'uc_pendaftar': ucPendaftar,
      'uc_pendaftaran': ucPendaftaran,
      'aduan': aduan,
      'file': file,
      'tgl_aduan': tglAduan,
      'status': status,
      'jawaban': jawaban,
      'tgl_jawab': tglJawab,
      'type_pengaduan': typePengaduan,
      'nama_diklat': namaDiklat,
    };
  }
}