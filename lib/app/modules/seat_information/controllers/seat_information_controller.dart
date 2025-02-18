import 'package:mytrb/app/data/models/info_kursi.dart';
import 'package:mytrb/app/data/models/info_kursi_detail.dart';
import 'package:mytrb/app/modules/training/controllers/training_controller.dart';
import 'package:mytrb/app/services/api_call_status.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeatInformationController extends GetxController {
  final TrainingController trainingController = Get.put(TrainingController());
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;
  var errorMessage = ''.obs;
  var currentPage = 1.obs;
  var totalPage = 1.obs;
  var infoKursiList = <InfoKursi>[].obs;
  var filteredInfoKursiList = <InfoKursi>[].obs;
  var infoKursiDetail = Rxn<InfoKursiDetail>();
  var jenisDiklatList = <String>[].obs;
  var diklatList = <String>[].obs;
  var selectedJenisDiklat = ''.obs;
  var selectedDiklat = ''.obs;
  var isDropdownOpened = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDataDiklat();
  }

  void fetchDataDiklat({int? page}) async {
    final Map<String, dynamic> queryParameters = {};
    if (page != null && page > 0) {
      queryParameters['page'] = page;
    }

    await BaseClient.safeApiCall(
      Environment.infoKursi,
      RequestType.get,
      queryParameters: queryParameters,
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
      },
      onSuccess: (response) async {
        var res = response.data;
        infoKursiDetail.value = InfoKursiDetail.fromJson(res);
        if (infoKursiDetail.value!.data != null &&
            infoKursiDetail.value!.data!.isNotEmpty) {
          infoKursiList.value = infoKursiDetail.value!.data!;
          filteredInfoKursiList.value = infoKursiList;
          totalPage.value = infoKursiDetail.value!.totalPage!;
          apiCallStatus = ApiCallStatus.success;
        } else {
          apiCallStatus = ApiCallStatus.error;
          if (kDebugMode) {
            print('Data kursi kosong');
          }
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('Terjadi kesalahan saat memuat data kursi: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
      },
    );
  }

  void nextPage() {
    if (currentPage.value < totalPage.value) {
      currentPage.value++;
      fetchDataDiklat(page: currentPage.value); // Menggunakan parameter page
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchDataDiklat(page: currentPage.value); // Menggunakan parameter page
    }
  }

  void fetchFilterInfoKursi(String ucJenisDiklat, String ucDiklat) async {
    final Map<String, dynamic> queryParameters = {
      'uc_jenis_diklat': ucJenisDiklat,
      'uc_diklat': ucDiklat,
    };

    await BaseClient.safeApiCall(
      Environment.infoKursi,
      RequestType.get,
      queryParameters: queryParameters,
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
      },
      onSuccess: (response) async {
        var res = response.data;
        infoKursiDetail.value = InfoKursiDetail.fromJson(res);
        if (infoKursiDetail.value!.data != null &&
            infoKursiDetail.value!.data!.isNotEmpty) {
          infoKursiList.value = infoKursiDetail.value!.data!;
          filteredInfoKursiList.value = infoKursiList;
          totalPage.value = infoKursiDetail.value!.totalPage!;
          apiCallStatus = ApiCallStatus.success;
        } else {
          apiCallStatus = ApiCallStatus.error;
          if (kDebugMode) {
            print('Data kursi kosong');
          }
        }
      },
      onError: (error) {
        String errorMessage = error.message;
        update();
        Get.snackbar(
          'Mohon maaf',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
      },
    );
  }

  void goToFirstPage() {
    currentPage.value = 1;
    fetchDataDiklat(page: currentPage.value);
  }

  void goToLastPage() {
    currentPage.value = totalPage.value;
    fetchDataDiklat(page: currentPage.value);
  }

  void goToPage(int page) {
    currentPage.value = page;
    fetchDataDiklat(page: currentPage.value);
  }

  void clearDropdowns() {
    // Reset semua pilihan dropdown
    trainingController.selectedKategori.value = '';
    trainingController.selectedDiklat.value = '';
    trainingController.diklatList.clear();
  }

  void clearController() {
    selectedJenisDiklat.value = '';
    selectedDiklat.value = '';
  }
}
