class JadwalPelaksanaanDetail {
  final String pendaftaranMulai;
  final String pendaftaranAkhir;
  final String? seleksiAdmin;
  final String? seleksiPsikotes;
  final String? seleksiKesehatan;
  final String? seleksiKesamaptaan;
  final String? seleksiAkademik;
  final String? seleksiWawancara;
  final String? seleksiPengumuman;
  final String? seleksiDaftarUlangMulai;
  final String? seleksiDaftarUlangAkhir;
  final String? seleksiMasukAsrama;
  final String? tingkatSeleksiMulai;
  final String? tingkatSeleksiAkhir;
  final String? tingkatTeoriMulai;
  final String? tingkatTeoriAkhir;
  final String? tingkatUtdMulai;
  final String? tingkatUtdAkhir;
  final String? tingkatPraktekMulai;
  final String? tingkatPraktekAkhir;
  final String? tingkatUdMulai;
  final String? tingkatUdAkhir;
  final String? tingkatUpMulai;
  final String? tingkatUpAkhir;
  final String? tingkatYudisium;
  final String? tingkatUkp1Mulai;
  final String? tingkatUkp1Akhir;
  final String? tingkatUkp2Mulai;
  final String? tingkatUkp2Akhir;
  final String? tingkatUkp3Mulai;
  final String? tingkatUkp3Akhir;
  final String? tingkatUkp4Mulai;
  final String? tingkatUkp4Akhir;
  final String? tingkatPelepasan;

  JadwalPelaksanaanDetail({
    required this.pendaftaranMulai,
    required this.pendaftaranAkhir,
    this.seleksiAdmin,
    this.seleksiPsikotes,
    this.seleksiKesehatan,
    this.seleksiKesamaptaan,
    this.seleksiAkademik,
    this.seleksiWawancara,
    this.seleksiPengumuman,
    this.seleksiDaftarUlangMulai,
    this.seleksiDaftarUlangAkhir,
    this.seleksiMasukAsrama,
    this.tingkatSeleksiMulai,
    this.tingkatSeleksiAkhir,
    this.tingkatTeoriMulai,
    this.tingkatTeoriAkhir,
    this.tingkatUtdMulai,
    this.tingkatUtdAkhir,
    this.tingkatPraktekMulai,
    this.tingkatPraktekAkhir,
    this.tingkatUdMulai,
    this.tingkatUdAkhir,
    this.tingkatUpMulai,
    this.tingkatUpAkhir,
    this.tingkatYudisium,
    this.tingkatUkp1Mulai,
    this.tingkatUkp1Akhir,
    this.tingkatUkp2Mulai,
    this.tingkatUkp2Akhir,
    this.tingkatUkp3Mulai,
    this.tingkatUkp3Akhir,
    this.tingkatUkp4Mulai,
    this.tingkatUkp4Akhir,
    this.tingkatPelepasan,
  });

  factory JadwalPelaksanaanDetail.fromJson(Map<String, dynamic> json) {
    return JadwalPelaksanaanDetail(
      pendaftaranMulai: json['pendaftaran_mulai'] as String,
      pendaftaranAkhir: json['pendaftaran_akhir'] as String,
      seleksiAdmin: json['seleksi_admin'] as String?,
      seleksiPsikotes: json['seleksi_psikotes'] as String?,
      seleksiKesehatan: json['seleksi_kesehatan'] as String?,
      seleksiKesamaptaan: json['seleksi_kesamaptaan'] as String?,
      seleksiAkademik: json['seleksi_akademik'] as String?,
      seleksiWawancara: json['seleksi_wawancara'] as String?,
      seleksiPengumuman: json['seleksi_pengumuman'] as String?,
      seleksiDaftarUlangMulai: json['seleksi_daftar_ulang_mulai'] as String?,
      seleksiDaftarUlangAkhir: json['seleksi_daftar_ulang_akhir'] as String?,
      seleksiMasukAsrama: json['seleksi_masuk_asrama'] as String?,
      tingkatSeleksiMulai: json['tingkat_seleksi_mulai'] as String?,
      tingkatSeleksiAkhir: json['tingkat_seleksi_akhir'] as String?,
      tingkatTeoriMulai: json['tingkat_teori_mulai'] as String?,
      tingkatTeoriAkhir: json['tingkat_teori_akhir'] as String?,
      tingkatUtdMulai: json['tingkat_utd_mulai'] as String?,
      tingkatUtdAkhir: json['tingkat_utd_akhir'] as String?,
      tingkatPraktekMulai: json['tingkat_praktek_mulai'] as String?,
      tingkatPraktekAkhir: json['tingkat_praktek_akhir'] as String?,
      tingkatUdMulai: json['tingkat_ud_mulai'] as String?,
      tingkatUdAkhir: json['tingkat_ud_akhir'] as String?,
      tingkatUpMulai: json['tingkat_up_mulai'] as String?,
      tingkatUpAkhir: json['tingkat_up_akhir'] as String?,
      tingkatYudisium: json['tingkat_yudisium'] as String?,
      tingkatUkp1Mulai: json['tingkat_ukp1_mulai'] as String?,
      tingkatUkp1Akhir: json['tingkat_ukp1_akhir'] as String?,
      tingkatUkp2Mulai: json['tingkat_ukp2_mulai'] as String?,
      tingkatUkp2Akhir: json['tingkat_ukp2_akhir'] as String?,
      tingkatUkp3Mulai: json['tingkat_ukp3_mulai'] as String?,
      tingkatUkp3Akhir: json['tingkat_ukp3_akhir'] as String?,
      tingkatUkp4Mulai: json['tingkat_ukp4_mulai'] as String?,
      tingkatUkp4Akhir: json['tingkat_ukp4_akhir'] as String?,
      tingkatPelepasan: json['tingkat_pelepasan'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pendaftaran_mulai': pendaftaranMulai,
      'pendaftaran_akhir': pendaftaranAkhir,
      'seleksi_admin': seleksiAdmin,
      'seleksi_psikotes': seleksiPsikotes,
      'seleksi_kesehatan': seleksiKesehatan,
      'seleksi_kesamaptaan': seleksiKesamaptaan,
      'seleksi_akademik': seleksiAkademik,
      'seleksi_wawancara': seleksiWawancara,
      'seleksi_pengumuman': seleksiPengumuman,
      'seleksi_daftar_ulang_mulai': seleksiDaftarUlangMulai,
      'seleksi_daftar_ulang_akhir': seleksiDaftarUlangAkhir,
      'seleksi_masuk_asrama': seleksiMasukAsrama,
      'tingkat_seleksi_mulai': tingkatSeleksiMulai,
      'tingkat_seleksi_akhir': tingkatSeleksiAkhir,
      'tingkat_teori_mulai': tingkatTeoriMulai,
      'tingkat_teori_akhir': tingkatTeoriAkhir,
      'tingkat_utd_mulai': tingkatUtdMulai,
      'tingkat_utd_akhir': tingkatUtdAkhir,
      'tingkat_praktek_mulai': tingkatPraktekMulai,
      'tingkat_praktek_akhir': tingkatPraktekAkhir,
      'tingkat_ud_mulai': tingkatUdMulai,
      'tingkat_ud_akhir': tingkatUdAkhir,
      'tingkat_up_mulai': tingkatUpMulai,
      'tingkat_up_akhir': tingkatUpAkhir,
      'tingkat_yudisium': tingkatYudisium,
      'tingkat_ukp1_mulai': tingkatUkp1Mulai,
      'tingkat_ukp1_akhir': tingkatUkp1Akhir,
      'tingkat_ukp2_mulai': tingkatUkp2Mulai,
      'tingkat_ukp2_akhir': tingkatUkp2Akhir,
      'tingkat_ukp3_mulai': tingkatUkp3Mulai,
      'tingkat_ukp3_akhir': tingkatUkp3Akhir,
      'tingkat_ukp4_mulai': tingkatUkp4Mulai,
      'tingkat_ukp4_akhir': tingkatUkp4Akhir,
      'tingkat_pelepasan': tingkatPelepasan,
    };
  }
}
