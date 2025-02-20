class TypeVessel {
  String? uc;
  String? typeVessel;

  TypeVessel({
    this.uc,
    this.typeVessel,
  });

  factory TypeVessel.fromJson(Map<String, dynamic> json) {
    return TypeVessel(
      uc: json['uc'],
      typeVessel: json['typeVessel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uc': uc,
      'typeVessel': typeVessel,
    };
  }
}
