import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mytrb/app/data/models/pukp.dart';
import 'package:mytrb/app/data/models/upt.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/environment/environment.dart';

class CredentialController extends GetxController {
  final storage = GetStorage();

  var isPukpDropdownOpened = false.obs;
  var isUptDropdownOpened = false.obs;

  var pukpList = <Pukp>[].obs;
  var uptList = <Upt>[].obs;

  final selectedPukp = Rxn<Pukp>();
  final selectedUpt = Rxn<Upt>();

  final isLoadingPukp = false.obs;
  final isLoadingUpt = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPukpList();
  }

  Future<void> fetchPukpList() async {
    isLoadingPukp.value = true;

    await BaseClient.safeApiCall(
      Environment.baseUrlPUKP,
      RequestType.get,
      onSuccess: (response) {
        if (response.data['status'] == 200) {
          pukpList.value = (response.data['data'] as List)
              .map((e) => Pukp.fromJson(e))
              .toList();
        } else {
          pukpList.clear();
          Get.snackbar(
              'Gagal', response.data['message'] ?? 'Gagal mengambil data PUKP');
        }
      },
      onError: (error) {
        pukpList.clear();
        Get.snackbar('Error', error.message);
      },
    );

    isLoadingPukp.value = false;
  }

  Future<void> loadUptByPukp(String? ucPukp) async {
    if (ucPukp == null || ucPukp.isEmpty) return;

    isLoadingUpt.value = true;
    selectedUpt.value = null; // Perbaikan: set ke null, jangan string kosong
    uptList.clear();

    await BaseClient.safeApiCall(
      Environment.baseUrlUPT,
      RequestType.get,
      queryParameters: {'uc_pukp': ucPukp},
      onSuccess: (response) {
        if (response.data['status'] == 200) {
          uptList.value = (response.data['data'] as List)
              .map((e) => Upt.fromJson(e))
              .toList();
        } else {
          uptList.clear();
          Get.snackbar(
              'Gagal', response.data['message'] ?? 'Gagal mengambil data UPT');
        }
      },
      onError: (error) {
        uptList.clear();
        Get.snackbar('Error', error.message);
      },
    );

    isLoadingUpt.value = false;
  }

  Future<void> submitConfiguration() async {
    final pukpUc = selectedPukp.value?.uc;
    final uptUc = selectedUpt.value?.uc; // Ambil uc dari Upt

    if (pukpUc == null || pukpUc.isEmpty || uptUc == null || uptUc.isEmpty) {
      Get.snackbar('Error', 'Silakan pilih PUKP dan UPT');
      return;
    }

    EasyLoading.show(status: 'Menyimpan...');

    await BaseClient.safeApiCall(
      Environment.baseUrl,
      RequestType.post,
      data: {
        'uc_pukp': pukpUc,
        'uc_upt': uptUc,
      },
      onSuccess: (response) {
        EasyLoading.dismiss();
        if (response.data['status'] == 200) {
          final urlApi = response.data['url_api'];
          storage.write('base_url_api', urlApi);
          Get.offAllNamed('/login');
        } else {
          Get.snackbar(
              'Gagal', response.data['message'] ?? 'Gagal setup sekolah');
        }
      },
      onError: (error) {
        EasyLoading.dismiss();
        Get.snackbar('Error', error.message);
      },
    );
  }
}
