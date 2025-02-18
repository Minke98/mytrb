class DataPersyaratan {
  String? id;
  String? uc;
  String? ucDiklat;
  String? ucPersyaratan;
  String? file;
  String? catatan;
  String? validasi;
  String? persyaratan;
  String? statusFile;
  String? ucDoc;
  String? status;
  String? statusSyarat;
  String? statusValidasi;
  String? billingNumber;
  String? statusBayar;
  String? statusSyaratBelumLengkap;
  String? jenisPersyaratan;

  DataPersyaratan({
    this.id,
    this.uc,
    this.ucDiklat,
    this.ucPersyaratan,
    this.file,
    this.catatan,
    this.validasi,
    this.persyaratan,
    this.statusFile,
    this.ucDoc,
    this.status,
    this.statusSyarat,
    this.statusValidasi,
    this.billingNumber,
    this.statusBayar,
    this.statusSyaratBelumLengkap,
    this.jenisPersyaratan,
  });

  factory DataPersyaratan.fromJson(Map<String, dynamic> json) {
    return DataPersyaratan(
      id: json['id'] as String?,
      uc: json['uc'] as String?,
      ucDiklat: json['uc_diklat'] as String?,
      ucPersyaratan: json['uc_persyaratan'] as String?,
      file: json['file'] as String?,
      catatan: json['catatan'] as String?,
      validasi: json['validasi'] as String?,
      persyaratan: json['persyaratan'] as String?,
      statusFile: json['status_file'] as String?,
      ucDoc: json['uc_doc'] as String?,
      status: json['status'] as String?,
      statusSyarat: json['status_syarat'] as String?,
      statusValidasi: json['status_validasi'] as String?,
      billingNumber: json['billing_number'] as String?,
      statusBayar: json['status_bayar'] as String?,
      statusSyaratBelumLengkap: json['status_syarat_belum_lengkap'] as String?,
      jenisPersyaratan: json['jenis_persyaratan'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uc': uc,
      'uc_diklat': ucDiklat,
      'uc_persyaratan': ucPersyaratan,
      'file': file,
      'catatan': catatan,
      'validasi': validasi,
      'persyaratan': persyaratan,
      'status_file': statusFile,
      'uc_doc': ucDoc,
      'status': status,
      'status_syarat': statusSyarat,
      'status_validasi': statusValidasi,
      'billing_number': billingNumber,
      'status_bayar': statusBayar,
      'status_syarat_belum_lengkap': statusSyaratBelumLengkap,
      'jenis_persyaratan': jenisPersyaratan,
    };
  }
}
