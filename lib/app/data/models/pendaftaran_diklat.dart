class PendaftaranDiklat {
  String? id;
  String? uc;
  String? ucPendaftar;
  String? noPendaftaran;
  String? noCertCoc;
  String? tanggalDaftar;
  String? typePendaftaran;
  String? trxId;
  String? billingNumber;
  String? virtualAccount;
  String? trxAmount;
  String? paymentAmount;
  String? datetimePayment;
  String? datetimeExpired;
  String? statusBayar;
  String? isExist;
  String? dateDeleteData;
  String? dateInjectPayment;
  String? nik;
  String? accountId;
  String? namaLengkap;
  String? seafarersCode;
  String? noTelepon;
  String? namaInstansi;
  String? sisaKursi;
  String? ucDiklat;
  String? tempatLahir;
  String? tanggalLahir;
  String? alamatRumah;
  String? email;
  String? pelaksanaanMulai;
  String? pelaksanaanAkhir;
  String? alamatInstansi;
  String? isComfrim;
  String? statusSyarat;
  String? statusValidasi;
  String? ucJadwalDiklat;
  String? kodeDiklat;
  String? namaDiklat;
  String? biaya;
  String? lamaDiklat;
  String? tahun;
  String? periode;
  String? jenisDiklat;
  String? category;
  String? ucDiklatTahun;
  String? totalTarif;
  String? opLoket;
  String? opKesehatan;

  PendaftaranDiklat({
    this.id,
    this.uc,
    this.ucPendaftar,
    this.noPendaftaran,
    this.noCertCoc,
    this.tanggalDaftar,
    this.typePendaftaran,
    this.trxId,
    this.billingNumber,
    this.virtualAccount,
    this.trxAmount,
    this.paymentAmount,
    this.datetimePayment,
    this.datetimeExpired,
    this.statusBayar,
    this.isExist,
    this.dateDeleteData,
    this.dateInjectPayment,
    this.nik,
    this.accountId,
    this.namaLengkap,
    this.seafarersCode,
    this.noTelepon,
    this.namaInstansi,
    this.sisaKursi,
    this.ucDiklat,
    this.tempatLahir,
    this.tanggalLahir,
    this.alamatRumah,
    this.email,
    this.pelaksanaanMulai,
    this.pelaksanaanAkhir,
    this.alamatInstansi,
    this.isComfrim,
    this.statusSyarat,
    this.statusValidasi,
    this.ucJadwalDiklat,
    this.kodeDiklat,
    this.namaDiklat,
    this.biaya,
    this.lamaDiklat,
    this.tahun,
    this.periode,
    this.jenisDiklat,
    this.category,
    this.ucDiklatTahun,
    this.totalTarif,
    this.opLoket,
    this.opKesehatan,
  });

  factory PendaftaranDiklat.fromJson(Map<String, dynamic> json) {
    return PendaftaranDiklat(
      id: json['id'] as String?,
      uc: json['uc'] as String?,
      ucPendaftar: json['uc_pendaftar'] as String?,
      noPendaftaran: json['no_pendaftaran'] as String?,
      noCertCoc: json['no_cert_coc'] as String?,
      tanggalDaftar: json['tanggal_daftar'] as String?,
      typePendaftaran: json['type_pendaftaran'] as String?,
      trxId: json['trx_id'] as String?,
      billingNumber: json['billing_number'] as String?,
      virtualAccount: json['virtual_account'] as String?,
      trxAmount: json['trx_amount'] as String?,
      paymentAmount: json['payment_amount'] as String?,
      datetimePayment: json['datetime_payment'] as String?,
      datetimeExpired: json['datetime_expired'] as String?,
      statusBayar: json['status_bayar'] as String?,
      isExist: json['is_exist'] as String?,
      dateDeleteData: json['date_delete_data'] as String?,
      dateInjectPayment: json['date_inject_payment'] as String?,
      nik: json['nik'] as String?,
      accountId: json['account_id'] as String?,
      namaLengkap: json['nama_lengkap'] as String?,
      seafarersCode: json['seafarers_code'] as String?,
      noTelepon: json['no_telepon'] as String?,
      namaInstansi: json['nama_instansi'] as String?,
      sisaKursi: json['sisa_kursi'] as String?,
      ucDiklat: json['uc_diklat'] as String?,
      tempatLahir: json['tempat_lahir'] as String?,
      tanggalLahir: json['tanggal_lahir'] as String?,
      alamatRumah: json['alamat_rumah'] as String?,
      email: json['email'] as String?,
      pelaksanaanMulai: json['pelaksanaan_mulai'] as String?,
      pelaksanaanAkhir: json['pelaksanaan_akhir'] as String?,
      alamatInstansi: json['alamat_instansi'] as String?,
      isComfrim: json['is_comfrim'] as String?,
      statusSyarat: json['status_syarat'] as String?,
      statusValidasi: json['status_validasi'] as String?,
      ucJadwalDiklat: json['uc_jadwal_diklat'] as String?,
      kodeDiklat: json['kode_diklat'] as String?,
      namaDiklat: json['nama_diklat'] as String?,
      biaya: json['biaya'] as String?,
      lamaDiklat: json['lama_diklat'] as String?,
      tahun: json['tahun'] as String?,
      periode: json['periode'] as String?,
      jenisDiklat: json['jenis_diklat'] as String?,
      category: json['category'] as String?,
      ucDiklatTahun: json['uc_diklat_tahun'] as String?,
      totalTarif: json['total_tarif'] as String?,
      opLoket: json['op_loket'] as String?,
      opKesehatan: json['op_kesehatan'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uc': uc,
      'uc_pendaftar': ucPendaftar,
      'no_pendaftaran': noPendaftaran,
      'no_cert_coc': noCertCoc,
      'tanggal_daftar': tanggalDaftar,
      'type_pendaftaran': typePendaftaran,
      'trx_id': trxId,
      'billing_number': billingNumber,
      'virtual_account': virtualAccount,
      'trx_amount': trxAmount,
      'payment_amount': paymentAmount,
      'datetime_payment': datetimePayment,
      'datetime_expired': datetimeExpired,
      'status_bayar': statusBayar,
      'is_exist': isExist,
      'date_delete_data': dateDeleteData,
      'date_inject_payment': dateInjectPayment,
      'nik': nik,
      'account_id': accountId,
      'nama_lengkap': namaLengkap,
      'seafarers_code': seafarersCode,
      'no_telepon': noTelepon,
      'nama_instansi': namaInstansi,
      'sisa_kursi': sisaKursi,
      'uc_diklat': ucDiklat,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir,
      'alamat_rumah': alamatRumah,
      'email': email,
      'pelaksanaan_mulai': pelaksanaanMulai,
      'pelaksanaan_akhir': pelaksanaanAkhir,
      'alamat_instansi': alamatInstansi,
      'is_comfrim': isComfrim,
      'status_syarat': statusSyarat,
      'status_validasi': statusValidasi,
      'uc_jadwal_diklat': ucJadwalDiklat,
      'kode_diklat': kodeDiklat,
      'nama_diklat': namaDiklat,
      'biaya': biaya,
      'lama_diklat': lamaDiklat,
      'tahun': tahun,
      'periode': periode,
      'jenis_diklat': jenisDiklat,
      'category': category,
      'uc_diklat_tahun': ucDiklatTahun,
      'total_tarif': totalTarif,
      'op_loket': opLoket,
      'op_kesehatan': opKesehatan,
    };
  }
}
