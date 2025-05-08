class VesselInfo {
  final String? namaKapal;
  final String? namaPemilik;
  final String? nomorIMO;
  final String? tandaPendaftaran;

  VesselInfo({
    this.namaKapal,
    this.namaPemilik,
    this.nomorIMO,
    this.tandaPendaftaran,
  });

  factory VesselInfo.fromJson(Map<String, dynamic> json) {
    return VesselInfo(
      namaKapal: json['NamaKapal'],
      namaPemilik: json['NamaPemilik'],
      nomorIMO: json['NomorIMO'],
      tandaPendaftaran: json['TandaPendaftaran'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NamaKapal': namaKapal,
      'NamaPemilik': namaPemilik,
      'NomorIMO': nomorIMO,
      'TandaPendaftaran': tandaPendaftaran,
    };
  }
}
