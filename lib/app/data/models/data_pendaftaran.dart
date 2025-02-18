class DataPendaftaran {
  String? uc;
  String? ucPendaftar;
  String? noPendaftaran;
  String? tanggalDaftar;
  String? typePendaftaran;
  String? trxId;
  String? trxAmount;
  String? billingNumber;
  String? virtualAccount;
  String? noCertCoc;

  DataPendaftaran({
    this.uc,
    this.ucPendaftar,
    this.noPendaftaran,
    this.tanggalDaftar,
    this.typePendaftaran,
    this.trxId,
    this.trxAmount,
    this.billingNumber,
    this.virtualAccount,
    this.noCertCoc,
  });

  factory DataPendaftaran.fromJson(Map<String, dynamic> json) {
    return DataPendaftaran(
      uc: json['uc'] as String?,
      ucPendaftar: json['uc_pendaftar'] as String?,
      noPendaftaran: json['no_pendaftaran'] as String?,
      tanggalDaftar: json['tanggal_daftar'] as String?,
      typePendaftaran: json['type_pendaftaran']?.toString(),
      trxId: json['trx_id']?.toString(),
      trxAmount: json['trx_amount']?.toString(),
      billingNumber: json['billing_number']?.toString(),
      virtualAccount: json['virtual_account']?.toString(),
      noCertCoc: json['no_cert_coc'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uc': uc,
      'uc_pendaftar': ucPendaftar,
      'no_pendaftaran': noPendaftaran,
      'tanggal_daftar': tanggalDaftar,
      'type_pendaftaran': typePendaftaran,
      'trx_id': trxId,
      'trx_amount': trxAmount,
      'billing_number': billingNumber,
      'virtual_account': virtualAccount,
      'no_cert_coc': noCertCoc,
    };
  }
}