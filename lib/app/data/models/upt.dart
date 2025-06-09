class Upt {
  String? id;
  String? uc;
  String? code;
  String? uptLabel;
  String? ucPukp;
  String? pukpLabel;

  Upt({
    this.id,
    this.uc,
    this.code,
    this.uptLabel,
    this.ucPukp,
    this.pukpLabel,
  });

  factory Upt.fromJson(Map<String, dynamic> json) {
    return Upt(
      id: json['id'],
      uc: json['uc'],
      code: json['code'] ?? '',
      uptLabel: json['upt_label'],
      ucPukp: json['uc_pukp'],
      pukpLabel: json['pukp_label'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uc': uc,
      'code': code,
      'upt_label': uptLabel,
      'uc_pukp': ucPukp,
      'pukp_label': pukpLabel,
    };
  }
}
