class Pukp {
  String? id;
  String? uc;
  String? pukpLabel;
  String? noPukp;
  String? namaPejabat;
  String? nipPejabat;

  Pukp({
    this.id,
    this.uc,
    this.pukpLabel,
    this.noPukp,
    this.namaPejabat,
    this.nipPejabat,
  });

  factory Pukp.fromJson(Map<String, dynamic> json) {
    return Pukp(
      id: json['id']?.toString(),
      uc: json['uc'],
      pukpLabel: json['pukp_label'],
      noPukp: json['no_pukp'],
      namaPejabat: json['nama_pejabat'],
      nipPejabat: json['nip_pejabat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uc': uc,
      'pukp_label': pukpLabel,
      'no_pukp': noPukp,
      'nama_pejabat': namaPejabat,
      'nip_pejabat': nipPejabat,
    };
  }
}
