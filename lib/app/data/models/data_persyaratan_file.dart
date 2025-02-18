class DataPersyaratanFile {
  final String? id;
  final String? uc;
  final String? ucPendaftar;
  final String? ucPersyaratan;
  final String? file;

  DataPersyaratanFile({
    this.id,
    this.uc,
    this.ucPendaftar,
    this.ucPersyaratan,
    this.file,
  });

  factory DataPersyaratanFile.fromJson(Map<String, dynamic> json) {
    return DataPersyaratanFile(
      id: json['id'],
      uc: json['uc'],
      ucPendaftar: json['uc_pendaftar'],
      ucPersyaratan: json['uc_persyaratan'],
      file: json['file'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uc': uc,
      'uc_pendaftar': ucPendaftar,
      'uc_persyaratan': ucPersyaratan,
      'file': file,
    };
  }
}