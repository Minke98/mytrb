class Instructor {
  String? uc;
  int? category;
  String? idNumber;
  String? fullName;

  Instructor({
    this.uc,
    this.category,
    this.idNumber,
    this.fullName,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      uc: json['uc'],
      category: json['category'],
      idNumber: json['idNumber'],
      fullName: json['fullName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uc': uc,
      'category': category,
      'idNumber': idNumber,
      'fullName': fullName,
    };
  }
}
