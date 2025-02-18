class Pengirim {
  String? namaPengirim;
  String? alamatRumah;
  String? noTlpn;

  Pengirim({this.namaPengirim, this.alamatRumah, this.noTlpn});

  // fromJson method
  factory Pengirim.fromJson(Map<String, dynamic> json) {
    return Pengirim(
      namaPengirim: json['nama_pengirim'],
      alamatRumah: json['alamat_rumah'],
      noTlpn: json['no_tlpn'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'nama_pengirim': namaPengirim,
      'alamat_rumah': alamatRumah,
      'no_tlpn': noTlpn,
    };
  }
}
