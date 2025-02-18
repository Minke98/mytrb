import 'dart:convert';

import 'package:mytrb/app/data/models/jadwal_reschedule.dart';
import 'package:mytrb/app/data/models/reschedule.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/services/api_call_status.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:mytrb/config/storage/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleChangeController extends GetxController {
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;
  final IndexController indexController = Get.put(IndexController());
  var isDropdownOpened = false.obs;
  var diklatList = <Reschedule>[].obs;
  var rescheduleList = <JadwalReschedule>[].obs;
  var reschedule = Rxn<Reschedule>();
  var selectedReschedule = ''.obs;

  // Dropdown selected value
  var selectedGelombang = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDataDiklat(); // Load data on initialization
  }

  void fetchDataDiklat() async {
    await BaseClient.safeApiCall(
      Environment.dataDiklat,
      RequestType.get,
      queryParameters: {
        'uc_pendaftar': indexController.currentUser.value!.usrUc!
      },
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        var res = response.data;
        var data = res['data'] as List<dynamic>;

        // Update diklatList dengan data yang di-mapping
        diklatList.value = data.map((item) {
          return Reschedule.fromJson(item as Map<String, dynamic>);
        }).toList();

        // Simpan diklatList ke SharedPreferences
        final storage = await SharedPreferences.getInstance();
        if (diklatList.isNotEmpty) {
          String rescheduleJson =
              jsonEncode(diklatList.map((item) => item.toJson()).toList());
          await storage.setString(StorageConfig.reschedule, rescheduleJson);
          if (kDebugMode) {
            print("Saved reschedule data: $rescheduleJson");
          }
        } else {
          if (kDebugMode) {
            print("No data to save");
          }
        }

        apiCallStatus = ApiCallStatus.success;
        update();
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

  Future<void> fetchGetForm(String? ucPendaftaran, String? ucJadwalDiklat,
      String? ucDiklatTahun) async {
    await BaseClient.safeApiCall(
      Environment.getForm,
      RequestType.get,
      queryParameters: {
        'uc_pendaftaran': ucPendaftaran,
        'uc_diklat_jadwal': ucJadwalDiklat,
        'uc_diklat_tahun': ucDiklatTahun
      },
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        var res = response.data;
        var data = res['data'] as List<dynamic>;
        rescheduleList.value = data.map((item) {
          return JadwalReschedule.fromJson(item as Map<String, dynamic>);
        }).toList();
        apiCallStatus = ApiCallStatus.success;
        update();
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

  void saveReschedule() async {
    if (selectedReschedule.isEmpty) {
      Get.snackbar('Error', 'Pilih gelombang/periode terlebih dahulu.');
      return;
    }
    final selectedRescheduleItem = rescheduleList.firstWhere(
      (item) => item.ucDiklatJadwal == selectedReschedule.value,
      orElse: () => JadwalReschedule(), // default value jika tidak ditemukan
    );

    if (selectedRescheduleItem.ucDiklatJadwal == null) {
      Get.snackbar('Error', 'Data reschedule tidak valid.');
      return;
    }

    await BaseClient.safeApiCall(
      Environment.saveReschedule, // endpoint untuk menyimpan reschedule
      RequestType.post, // gunakan POST karena akan menyimpan data
      data: {
        'uc_diklat_jadwal_last': selectedRescheduleItem.ucDiklatJadwalLast,
        'uc_diklat_jadwal_new': selectedRescheduleItem.ucDiklatJadwal,
        'uc_pendaftaran': selectedRescheduleItem.ucPendaftaran,
      },
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) {
        apiCallStatus = ApiCallStatus.success;
        var res = response.data;
        String message = res['message'] ?? 'Success';
        selectedReschedule.value = '';
        Get.close(1);
        Get.snackbar(
          'Update Berhasil', // Title
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
        fetchDataDiklat();
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        if (kDebugMode) {
          print('Error occurred while saving reschedule: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  void updateGelombang(String value) {
    selectedGelombang(value);
  }
}
