class Biodata {
  String? id;
  String? uc;
  String? accountId;
  String? nik;
  String? seafarersCode;
  String? namaLengkap;
  String? namaIbu;
  String? tempatLahir;
  String? jk;
  String? tanggalLahir;
  String? alamatRumah;
  String? noTelepon;
  String? email;
  String? namaInstansi;
  String? alamatInstansi;
  String? asalSekolah;
  String? jurusanSmaSmk;
  String? tahunLulus;
  String? isExist;
  String? password;
  String? photo;
  String? isActive;
  String? namaAyah;
  String? pekerjaanAyah;
  String? pekerjaanIbu;
  String? noHpOrtu;
  String? noKk;
  String? nisn;
  String? tinggiBadan;
  String? createTime;

  Biodata({
    this.id,
    this.uc,
    this.accountId,
    this.nik,
    this.seafarersCode,
    this.namaLengkap,
    this.namaIbu,
    this.tempatLahir,
    this.jk,
    this.tanggalLahir,
    this.alamatRumah,
    this.noTelepon,
    this.email,
    this.namaInstansi,
    this.alamatInstansi,
    this.asalSekolah,
    this.jurusanSmaSmk,
    this.tahunLulus,
    this.isExist,
    this.password,
    this.photo,
    this.isActive,
    this.namaAyah,
    this.pekerjaanAyah,
    this.pekerjaanIbu,
    this.noHpOrtu,
    this.noKk,
    this.nisn,
    this.tinggiBadan,
    this.createTime,
  });

  // Convert from JSON
  factory Biodata.fromJson(Map<String, dynamic> json) {
    return Biodata(
      id: json['id'],
      uc: json['uc'],
      accountId: json['account_id'],
      nik: json['nik'],
      seafarersCode: json['seafarers_code'],
      namaLengkap: json['nama_lengkap'],
      namaIbu: json['nama_ibu'],
      tempatLahir: json['tempat_lahir'],
      jk: json['jk'],
      tanggalLahir: json['tanggal_lahir'],
      alamatRumah: json['alamat_rumah'],
      noTelepon: json['no_telepon'],
      email: json['email'],
      namaInstansi: json['nama_instansi'],
      alamatInstansi: json['alamat_instansi'],
      asalSekolah: json['asal_sekolah'],
      jurusanSmaSmk: json['jurusan_sma_smk'],
      tahunLulus: json['tahun_lulus'],
      isExist: json['is_exist'],
      password: json['password'],
      photo: json['photo'],
      isActive: json['is_active'],
      namaAyah: json['nama_ayah'],
      pekerjaanAyah: json['pekerjaan_ayah'],
      pekerjaanIbu: json['pekerjaan_ibu'],
      noHpOrtu: json['no_hp_ortu'],
      noKk: json['no_kk'],
      nisn: json['nisn'],
      tinggiBadan: json['tinggi_badan'],
      createTime: json['create_time'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uc': uc,
      'account_id': accountId,
      'nik': nik,
      'seafarers_code': seafarersCode,
      'nama_lengkap': namaLengkap,
      'nama_ibu': namaIbu,
      'tempat_lahir': tempatLahir,
      'jk': jk,
      'tanggal_lahir': tanggalLahir,
      'alamat_rumah': alamatRumah,
      'no_telepon': noTelepon,
      'email': email,
      'nama_instansi': namaInstansi,
      'alamat_instansi': alamatInstansi,
      'asal_sekolah': asalSekolah,
      'jurusan_sma_smk': jurusanSmaSmk,
      'tahun_lulus': tahunLulus,
      'is_exist': isExist,
      'password': password,
      'photo': photo,
      'is_active': isActive,
      'nama_ayah': namaAyah,
      'pekerjaan_ayah': pekerjaanAyah,
      'pekerjaan_ibu': pekerjaanIbu,
      'no_hp_ortu': noHpOrtu,
      'no_kk': noKk,
      'nisn': nisn,
      'tinggi_badan': tinggiBadan,
      'create_time': createTime,
    };
  }
}