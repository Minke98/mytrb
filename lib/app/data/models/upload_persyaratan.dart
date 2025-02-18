import 'package:mytrb/app/data/models/data_persyaratan_diklat.dart';
import 'package:mytrb/app/data/models/pendaftaran_diklat.dart';

class UploadPersyaratan {
  String? status;
  String? message;
  PendaftaranDiklat? pendaftaranDiklat;
  DataPersyaratan? dataPersyaratan;

  UploadPersyaratan({
    this.status,
    this.message,
    this.pendaftaranDiklat,
    this.dataPersyaratan,
  });

  factory UploadPersyaratan.fromJson(Map<String, dynamic> json) {
    return UploadPersyaratan(
      status: json['status']?.toString(),
      message: json['message'] as String?,
      pendaftaranDiklat: json['info_diklat'] != null
          ? PendaftaranDiklat.fromJson(json['info_diklat'])
          : null,
      dataPersyaratan: json['data_persyaratan'] != null
          ? DataPersyaratan.fromJson(json['data_persyaratan'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'info_diklat': pendaftaranDiklat?.toJson(),
      'data_persyaratan': dataPersyaratan?.toJson(),
    };
  }
}
