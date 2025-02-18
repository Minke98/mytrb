class Persyaratan {
  String? id;
  String? uc;
  String? ucDiklat;
  String? ucPersyaratan;
  String? persyaratan;

  Persyaratan({
    this.id,
    this.uc,
    this.ucDiklat,
    this.ucPersyaratan,
    this.persyaratan,
  });

  // Factory method to create a `Persyaratan` instance from JSON
  factory Persyaratan.fromJson(Map<String, dynamic> json) {
    return Persyaratan(
      id: json['id'] as String?,
      uc: json['uc'] as String?,
      ucDiklat: json['uc_diklat'] as String?,
      ucPersyaratan: json['uc_persyaratan'] as String?,
      persyaratan: json['persyaratan'] as String?,
    );
  }

  // Method to convert a `Persyaratan` instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uc': uc,
      'uc_diklat': ucDiklat,
      'uc_persyaratan': ucPersyaratan,
      'persyaratan': persyaratan,
    };
  }
}
