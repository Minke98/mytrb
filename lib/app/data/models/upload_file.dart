import 'package:mytrb/app/data/models/data_pendaftaran_file.dart';
import 'package:mytrb/app/data/models/data_persyaratan_file.dart';

class UploadFile {
  final int status;
  final String message;
  final int statusFile;
  final DataPendaftaranFile? dataPendaftaranFile;
  final DataPersyaratanFile? dataPersyaratanFile;

  UploadFile({
    required this.status,
    required this.message,
    required this.statusFile,
    this.dataPendaftaranFile,
    this.dataPersyaratanFile,
  });

  factory UploadFile.fromJson(Map<String, dynamic> json) {
    return UploadFile(
      status: json['status'],
      message: json['message'],
      statusFile: json['status_file'],
      dataPendaftaranFile: json['data_pendaftaran'] != null
          ? DataPendaftaranFile.fromJson(json['data_pendaftaran'])
          : null,
      dataPersyaratanFile: json['data_persyaratan'] != null &&
              json['data_persyaratan'] is Map<String, dynamic>
          ? DataPersyaratanFile.fromJson(json['data_persyaratan'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'status_file': statusFile,
      'data_pendaftaran': dataPendaftaranFile?.toJson(),
      'data_persyaratan': dataPersyaratanFile?.toJson() ?? '',
    };
  }
}
