import 'package:mytrb/app/data/models/data_pendaftaran.dart';
import 'package:mytrb/app/data/models/data_pendaftaran_diklat.dart';

class Registration {
  String? status;
  String? message;
  DataPendaftaran? dataPendaftaran;
  DataPendaftaranDiklat? dataPendaftaranDiklat;

  Registration({
    this.status,
    this.message,
    this.dataPendaftaran,
    this.dataPendaftaranDiklat,
  });

  factory Registration.fromJson(Map<String, dynamic> json) {
    return Registration(
      status: json['status']?.toString(),
      message: json['message'] as String?,
      dataPendaftaran: json['data_pendaftaran'] != null
          ? DataPendaftaran.fromJson(json['data_pendaftaran'])
          : null,
      dataPendaftaranDiklat: json['data_pendaftaran_diklat'] != null
          ? DataPendaftaranDiklat.fromJson(json['data_pendaftaran_diklat'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data_pendaftaran': dataPendaftaran?.toJson(),
      'data_pendaftaran_diklat': dataPendaftaranDiklat?.toJson(),
    };
  }
}
