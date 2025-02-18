class TypePengaduan {
  String? id;
  String? typePengaduan;

  TypePengaduan({
    this.id,
    this.typePengaduan,
  });

  factory TypePengaduan.fromJson(Map<String, dynamic> json) {
    return TypePengaduan(
      id: json['id'],
      typePengaduan: json['type_pengaduan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type_pengaduan': typePengaduan,
    };
  }
}
