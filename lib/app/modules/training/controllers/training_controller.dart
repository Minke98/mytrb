import 'package:mytrb/app/data/models/biodata.dart';
import 'package:mytrb/app/data/models/detail_jadwal_diklat.dart';
import 'package:mytrb/app/data/models/diklat.dart';
import 'package:mytrb/app/data/models/jadwal_diklat.dart';
import 'package:mytrb/app/data/models/jadwal_pelaksanaan.dart';
import 'package:mytrb/app/data/models/jenis_diklat.dart';
import 'package:mytrb/app/data/models/persyaratan.dart';
import 'package:mytrb/app/data/models/registration.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:mytrb/app/services/api_call_status.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:mytrb/utils/connection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class TrainingController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;
  final IndexController indexController = Get.put(IndexController());
  final TextEditingController nisnController = TextEditingController();
  final TextEditingController jurusanAsalController = TextEditingController();
  final TextEditingController sekolahAsalController = TextEditingController();
  final TextEditingController tahunLulusController = TextEditingController();
  final TextEditingController tinggiBadanController = TextEditingController();
  final TextEditingController noKKController = TextEditingController();
  final TextEditingController namaAyahController = TextEditingController();
  final TextEditingController pekerjaanAyahController = TextEditingController();
  final TextEditingController namaIbuController = TextEditingController();
  final TextEditingController pekerjaanIbuController = TextEditingController();
  final TextEditingController noTeleponOrangTuaController =
      TextEditingController();
  final TextEditingController nomorSertifikat = TextEditingController();
  var selectedKategori = ''.obs;
  var selectedDiklat = ''.obs;
  var selectedTanggal = ''.obs;
  var isDropdownOpened = false.obs;
  var diklatLabelText = 'Pilih Diklat'.obs;
  var tanggalLabelText = 'Pilih Periode/Tanggal Diklat'.obs;
  var persyaratanList = <Persyaratan>[].obs;
  var detailJadwalDiklatList = <DetailJadwalDiklat>[].obs;
  var kategoriList = <JenisDiklat>[].obs;
  var diklatList = <Diklat>[].obs;
  var tanggalList = <JadwalDiklat>[].obs;
  var jenisDiklat = ''.obs;
  Registration? registration;
  var diklatPembentukan = '18-01659-66'.obs;
  var diklatEndors = '99-58612-45'.obs;
  var biodata = Rxn<Biodata>();
  var jadwalPelaksanaan = Rxn<JadwalPelaksanaan>();
  var isChecked = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchKategoriList();
  }

  fetchBiodata() async {
    EasyLoading.show(status: 'Please wait...');
    await BaseClient.safeApiCall(
      Environment.biodata,
      RequestType.get,
      queryParameters: {
        'uc_pendaftar': indexController.currentUser.value!.usrUc!,
      },
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        var res = response.data;
        var bio = res['data'];
        biodata.value = Biodata.fromJson(bio);
        nisnController.text = biodata.value?.nisn ?? '-';
        jurusanAsalController.text = biodata.value?.jurusanSmaSmk ?? '-';
        sekolahAsalController.text = biodata.value?.asalSekolah ?? '-';
        tahunLulusController.text = biodata.value?.tahunLulus ?? '-';
        tinggiBadanController.text =
            biodata.value?.tinggiBadan?.toString() ?? '-';
        noKKController.text = biodata.value?.noKk ?? '-';
        namaAyahController.text = biodata.value?.namaAyah ?? '-';
        pekerjaanAyahController.text = biodata.value?.pekerjaanAyah ?? '-';
        namaIbuController.text = biodata.value?.namaIbu ?? '-';
        pekerjaanIbuController.text = biodata.value?.pekerjaanIbu ?? '-';
        noTeleponOrangTuaController.text = biodata.value?.noHpOrtu ?? '-';
        apiCallStatus = ApiCallStatus.success;
        EasyLoading.dismiss();
        update();
      },
      onError: (error) {
        EasyLoading.dismiss();
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  void fetchKategoriList() async {
    await BaseClient.safeApiCall(
      Environment.jenisDiklat,
      RequestType.get,
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        try {
          var res = response.data;
          var data = res['data'] as List<dynamic>;
          kategoriList.value = data.map((item) {
            return JenisDiklat.fromJson(item as Map<String, dynamic>);
          }).toList();
          apiCallStatus = ApiCallStatus.success;
          update();
        } catch (e) {
          if (kDebugMode) {
            print('Error occurred while parsing kategori list: $e');
          }
          apiCallStatus = ApiCallStatus.error;
          update();
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('Error occurred while fetching kategori list: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  void fetchDiklatList(JenisDiklat jenisDiklat) async {
    diklatList.clear(); // Clear previous diklat list
    selectedDiklat.value = ''; // Reset the selected diklat

    await BaseClient.safeApiCall(
      Environment.diklat,
      RequestType.get,
      queryParameters: {'uc_jenis_diklat': jenisDiklat.uc},
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        var res = response.data;
        var data = res['data'] as List<dynamic>;
        diklatList.value = data.map((item) {
          return Diklat.fromJson(item as Map<String, dynamic>);
        }).toList();
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
        Get.snackbar('Error', 'Gagal mengambil data diklat');
      },
    );
  }

  Future<void> fetchTanggalList(Diklat diklat) async {
    tanggalList.clear(); // Clear previous tanggal list
    selectedTanggal.value = ''; // Reset the selected tanggal

    await BaseClient.safeApiCall(
      Environment.jadwalDiklat,
      RequestType.get,
      queryParameters: {'uc_diklat': diklat.uc},
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        try {
          var res = response.data;
          var data = res['data'] as List<dynamic>;
          tanggalList.value = data.map((item) {
            return JadwalDiklat.fromJson(item as Map<String, dynamic>);
          }).toList();
          apiCallStatus = ApiCallStatus.success;
          update();
        } catch (e) {
          if (kDebugMode) {
            print('Error processing data: $e');
          }
          apiCallStatus = ApiCallStatus.error;
          Get.snackbar('Error', 'Gagal memproses data tanggal diklat');
        } finally {
          update();
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('Error occurred while fetching tanggal list: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
        Get.snackbar('Error', 'Gagal mengambil data tanggal diklat');
      },
    );
  }

  void fetchPersyaratan(Diklat diklat) async {
    await BaseClient.safeApiCall(
      Environment.persyaratanDiklat,
      RequestType.get,
      queryParameters: {'uc_diklat': diklat.uc},
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        try {
          var res = response.data;
          var data = res['data'] as List<dynamic>;
          persyaratanList.value = data.map((item) {
            return Persyaratan.fromJson(item as Map<String, dynamic>);
          }).toList();
          apiCallStatus = ApiCallStatus.success;
          update();
        } catch (e) {
          if (kDebugMode) {
            print('Error processing data: $e');
          }
          apiCallStatus = ApiCallStatus.error;
          Get.snackbar('Error', 'Gagal memproses data tanggal diklat');
        } finally {
          update();
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('Error occurred while fetching tanggal list: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
        Get.snackbar('Error', 'Gagal mengambil data tanggal diklat');
      },
    );
  }

  void fetchJadwalPelaksanaan(JadwalDiklat jadwalDiklat) async {
    await BaseClient.safeApiCall(
      Environment.jadwalPelaksanaan,
      RequestType.get,
      queryParameters: {'uc_diklat_jadwal': jadwalDiklat.ucDiklatJadwal},
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        try {
          var res = response.data;
          jadwalPelaksanaan.value = JadwalPelaksanaan.fromJson(res);
          apiCallStatus = ApiCallStatus.success;
          update();
        } catch (e) {
          if (kDebugMode) {
            print('Error processing data: $e');
          }
          apiCallStatus = ApiCallStatus.error;
          Get.snackbar('Error', 'Gagal memproses data jadwal diklat');
        } finally {
          update();
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('Error occurred while fetching jadwal diklat: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
        Get.snackbar('Error', 'Gagal mengambil data jadwal diklat');
      },
    );
  }

  void fetchDetailInfoJadwal(JadwalDiklat jadwalDiklat) async {
    await BaseClient.safeApiCall(
      Environment.detailInfoJadwalDiklat,
      RequestType.get,
      queryParameters: {'uc_diklat_jadwal': jadwalDiklat.ucDiklatJadwal},
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        try {
          var res = response.data;
          var data = res['data'];

          if (data is List<dynamic>) {
            // If data is a list, process it (backward compatibility)
            detailJadwalDiklatList.value = data.map((item) {
              return DetailJadwalDiklat.fromJson(item as Map<String, dynamic>);
            }).toList();
          } else if (data is Map<String, dynamic>) {
            DetailJadwalDiklat detail = DetailJadwalDiklat.fromJson(data);
            detailJadwalDiklatList.value = [detail]; // Wrap in a list if needed
          } else {
            // Handle unexpected data types
            if (kDebugMode) {
              print('Unexpected data type: ${data.runtimeType}');
            }
            Get.snackbar('Error', 'Data tidak valid.');
            return;
          }

          apiCallStatus = ApiCallStatus.success;
          update();
        } catch (e) {
          if (kDebugMode) {
            print('Error processing data: $e');
          }
          apiCallStatus = ApiCallStatus.error;
          Get.snackbar('Error', 'Gagal memproses data tanggal diklat');
        } finally {
          update();
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('Error occurred while fetching tanggal list: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
        Get.snackbar('Error', 'Gagal mengambil data tanggal diklat');
      },
    );
  }

  void updateDiklatAndTanggal(JenisDiklat jenisDiklat) {
    this.jenisDiklat.value = jenisDiklat.jenisDiklat ?? '';
    selectedDiklat.value = '';
    selectedTanggal.value = '';
    diklatList.clear();
    tanggalList.clear();

    if (jenisDiklat.jenisDiklat ==
            'SIPENCATAR DIKLAT PELAUT - PEMBENTUKAN III' ||
        jenisDiklat.jenisDiklat == 'DIKLAT PENINGKATAN') {
      diklatLabelText.value = 'Pilih Program Diklat';
      tanggalLabelText.value = 'Pilih Gelombang';
    } else {
      diklatLabelText.value = 'Pilih Diklat';
      tanggalLabelText.value = 'Pilih Periode/Tanggal Diklat';
    }
    fetchDiklatList(jenisDiklat);
  }

  void updateTanggalList(Diklat diklat) {
    selectedTanggal.value = '';
    tanggalList.clear();
    fetchTanggalList(diklat);
    fetchPersyaratan(diklat);
  }

  Future<void> registDiklat() async {
    bool isConnected = await ConnectionUtils.checkInternetConnection();
    if (!isConnected) {
      ConnectionUtils.showNoInternetDialog(
        "Apologies, the registration process requires an internet connection.",
      );
      return;
    }

    EasyLoading.show(status: 'Please wait...');
    bool isFastConnection = await ConnectionUtils.isConnectionFast();
    if (!isFastConnection) {
      ConnectionUtils.showNoInternetDialog(
        "Apologies, the registration process requires a stable internet connection.",
        isSlowConnection: true,
      );
      return;
    }
    final data = <String, dynamic>{};
    String environmentUrl;
    if (selectedKategori.value == diklatPembentukan.value) {
      environmentUrl = Environment.registDiklatIII;
      data.addAll({
        'uc_jenis_diklat': selectedKategori.value,
        'uc_diklat': selectedDiklat.value,
        'uc_diklat_jadwal': selectedTanggal.value,
        'uc_pendaftar': indexController.currentUser.value!.usrUc!,
        'nik': indexController.currentUser.value!.usrNik!,
        'nisn': nisnController.text.trim(),
        'jurusan_asal': jurusanAsalController.text,
        'sekolah_asal': sekolahAsalController.text,
        'tahun_lulus': tahunLulusController.text,
        'tinggi_badan': tinggiBadanController.text.trim(),
        'kartu_keluarga': noKKController.text.trim(),
        'nama_ayah': namaAyahController.text,
        'pekerjaan_ayah': pekerjaanAyahController.text,
        'nama_ibu': namaIbuController.text,
        'pekerjaan_ibu': pekerjaanIbuController.text,
        'no_telepon_orang_tua': noTeleponOrangTuaController.text.trim(),
      });
    } else if (selectedKategori.value == diklatEndors.value) {
      environmentUrl = Environment.registDiklatEndors;
      data.addAll({
        'NIK': indexController.currentUser.value!.usrNik!,
        'uc_jenis_diklat': selectedKategori.value,
        'uc_diklat': selectedDiklat.value,
        'uc_diklat_jadwal': selectedTanggal.value,
        'uc_pendaftar': indexController.currentUser.value!.usrUc!,
        'no_cert_coc': nomorSertifikat.text.trim(),
      });
    } else {
      environmentUrl = Environment.registDiklat; // URL default environment
      data.addAll({
        'nik': indexController.currentUser.value!.usrNik!,
        'uc_jenis_diklat': selectedKategori.value,
        'uc_diklat': selectedDiklat.value,
        'uc_diklat_jadwal': selectedTanggal.value,
        'uc_pendaftar': indexController.currentUser.value!.usrUc!,
      });
    }
    await BaseClient.safeApiCall(
      environmentUrl,
      RequestType.post,
      data: data,
      onSuccess: (response) async {
        EasyLoading.dismiss();
        var res = response.data;
        registration = Registration.fromJson(res);
        if (kDebugMode) {
          print('UC Pendaftaran: ${registration?.dataPendaftaran?.uc}');
        }
        if (kDebugMode) {
          print(
              'UC Jadwal Diklat: ${registration?.dataPendaftaranDiklat?.ucJadwalDiklat}');
        }
        Get.toNamed(Routes.DIKLAT_REGISTRATION_SUCCESS);
      },
      onError: (error) {
        EasyLoading.dismiss();
        String errorMessage = error.message;
        Get.toNamed(Routes.DIKLAT_REGISTRATION_FAILED);
        showErrorSnackbarRegist(errorMessage);
        update();
      },
    );
  }

  void showErrorSnackbarRegist(value) {
    Get.snackbar(
      "Mohon maaf",
      "$value",
      icon: const Icon(
        Icons.close,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent[400],
      borderRadius: 20,
      margin: const EdgeInsets.all(15),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
