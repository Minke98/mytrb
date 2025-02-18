import 'package:mytrb/app/data/models/biodata.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/services/api_call_status.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BiodataController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;
  final IndexController indexController = Get.put(IndexController());
  final TextEditingController seafarerCodeController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tglLahirController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noTeleponController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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
  Rx<String?> selectedJenisKelamin = Rx<String?>(null);
  Rx<DateTime?> selectedTglLahir = Rx<DateTime?>(null);
  Map<String, dynamic> payload = {};
  var isDropdownOpened = false.obs;
  var isFormChanged = false.obs;
  var biodata = Rxn<Biodata>();
  var initialBiodata = Biodata();
  var formType = 'biodata'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBiodata();
  }

  void onFieldChanged() {
    isFormChanged.value = true;
  }

  // void updateJenisKelamin(String? newValue) {
  //   if (newValue == 'Laki-laki') {
  //     payload['jenis_kelamin'] = 0; // 0 untuk laki-laki
  //   } else if (newValue == 'Perempuan') {
  //     payload['jenis_kelamin'] = 1; // 1 untuk perempuan
  //   }
  // }

  Future<void> pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      selectedTglLahir.value = pickedDate;
    }
  }

  String getFormattedDate() {
    return selectedTglLahir.value != null
        ? DateFormat('dd MMM yyyy').format(selectedTglLahir.value!)
        : 'Tgl Lahir';
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
        seafarerCodeController.text = biodata.value?.seafarersCode ?? '-';
        nikController.text = biodata.value?.nik ?? '-';
        namaLengkapController.text = biodata.value?.namaLengkap ?? '-';
        tempatLahirController.text = biodata.value?.tempatLahir ?? '-';
        tglLahirController.text = biodata.value?.tanggalLahir ?? '-';
        alamatController.text = biodata.value?.alamatRumah ?? '-';
        noTeleponController.text = biodata.value?.noTelepon ?? '-';
        emailController.text = biodata.value?.email ?? '-';
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
        selectedJenisKelamin.value =
            biodata.value?.jk == "0" ? "Laki-laki" : "Perempuan";
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

  void checkAndAddToPayload({
    required String currentValue,
    required String? initialValue,
    required String key,
    required Map<String, dynamic> payload,
  }) {
    if (currentValue != initialValue &&
        currentValue.isNotEmpty &&
        currentValue != '-') {
      payload[key] = currentValue;
    }
  }

  void simpanForm() async {
    if (!isFormChanged.value) {
      Get.snackbar(
        'Info',
        'Tidak ada perubahan yang dilakukan!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Map<String, dynamic> payload = {
      'type_form': formType.value,
      'uc_pendaftar': indexController.currentUser.value!.usrUc!,
    };

    // Menggunakan helper function untuk cek perubahan dan tambahkan ke payload
    checkAndAddToPayload(
      currentValue: seafarerCodeController.text,
      initialValue: initialBiodata.seafarersCode,
      key: 'seafarers_code',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: nikController.text,
      initialValue: initialBiodata.nik,
      key: 'nik',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: namaLengkapController.text,
      initialValue: initialBiodata.namaLengkap,
      key: 'nama_lengkap',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: tempatLahirController.text,
      initialValue: initialBiodata.tempatLahir,
      key: 'tempat_lahir',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: tglLahirController.text,
      initialValue: initialBiodata.tanggalLahir,
      key: 'tanggal_lahir',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: alamatController.text,
      initialValue: initialBiodata.alamatRumah,
      key: 'alamat_rumah',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: noTeleponController.text,
      initialValue: initialBiodata.noTelepon,
      key: 'no_telepon',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: emailController.text,
      initialValue: initialBiodata.email,
      key: 'email',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: nisnController.text,
      initialValue: initialBiodata.nisn,
      key: 'nisn',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: jurusanAsalController.text,
      initialValue: initialBiodata.jurusanSmaSmk,
      key: 'jurusan_sma_smk',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: sekolahAsalController.text,
      initialValue: initialBiodata.asalSekolah,
      key: 'asal_sekolah',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: tahunLulusController.text,
      initialValue: initialBiodata.tahunLulus,
      key: 'tahun_lulus',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: tinggiBadanController.text,
      initialValue: initialBiodata.tinggiBadan?.toString(),
      key: 'tinggi_badan',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: noKKController.text,
      initialValue: initialBiodata.noKk,
      key: 'no_kk',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: namaAyahController.text,
      initialValue: initialBiodata.namaAyah,
      key: 'nama_ayah',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: pekerjaanAyahController.text,
      initialValue: initialBiodata.pekerjaanAyah,
      key: 'pekerjaan_ayah',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: namaIbuController.text,
      initialValue: initialBiodata.namaIbu,
      key: 'nama_ibu',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: pekerjaanIbuController.text,
      initialValue: initialBiodata.pekerjaanIbu,
      key: 'pekerjaan_ibu',
      payload: payload,
    );

    checkAndAddToPayload(
      currentValue: noTeleponOrangTuaController.text,
      initialValue: initialBiodata.noHpOrtu,
      key: 'no_hp_ortu',
      payload: payload,
    );

    // Cek jenis kelamin
    if (selectedJenisKelamin.value != initialBiodata.jk) {
      payload['jk'] = selectedJenisKelamin.value == 'Laki-laki' ? 0 : 1;
    }

    // Simpan ke API jika ada perubahan nyata
    if (payload.length > 2) {
      await updateBiodata(payload);
      isFormChanged.value = false; // Reset status perubahan setelah simpan
    } else {
      Get.snackbar('Info', 'Tidak ada perubahan yang disimpan.');
    }
  }

  Future<void> updateBiodata(Map<String, dynamic> payload) async {
    EasyLoading.show(status: 'Please wait...');
    await BaseClient.safeApiCall(
      Environment.updateBiodata,
      RequestType.post,
      data: payload,
      isJson: false,
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        EasyLoading.dismiss();
        var res = response.data;
        String message = res['message'] ?? 'Success';
        Get.snackbar(
          'Selamat', // Title
          message, // Body
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        fetchBiodata();
        isFormChanged.value = false;
      },
      onError: (error) {
        EasyLoading.dismiss();
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  // Fungsi untuk menyimpan data for

  @override
  void onClose() {
    // Dispose of controllers when they are no longer needed
    noKKController.dispose();
    namaAyahController.dispose();
    pekerjaanAyahController.dispose();
    namaIbuController.dispose();
    pekerjaanIbuController.dispose();
    noTeleponOrangTuaController.dispose();
    super.onClose();
  }
}
