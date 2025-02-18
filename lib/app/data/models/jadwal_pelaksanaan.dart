import 'package:mytrb/app/data/models/jadwal_pelaksanaan_detail.dart';

class JadwalPelaksanaan {
  final int? status;
  final String? message;
  final String? category;
  final JadwalPelaksanaanDetail? jadwalPelaksanaanDetail;

  JadwalPelaksanaan({
    this.status,
    this.message,
    this.category,
    this.jadwalPelaksanaanDetail,
  });

  factory JadwalPelaksanaan.fromJson(Map<String, dynamic> json) {
    return JadwalPelaksanaan(
      status: json['status'] as int?,
      message: json['message'] as String?,
      category: json['category'] as String?,
      jadwalPelaksanaanDetail: json['data'] != null
          ? JadwalPelaksanaanDetail.fromJson(
              json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'category': category,
      'jadwal_pelaksanaan': jadwalPelaksanaanDetail?.toJson(),
    };
  }
}
