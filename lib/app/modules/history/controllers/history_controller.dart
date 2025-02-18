import 'package:mytrb/app/data/models/history.dart';
import 'package:mytrb/app/data/models/history_detail.dart';
import 'package:mytrb/app/data/models/reschedule.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/services/api_call_status.dart';
import 'package:mytrb/app/services/base_client.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final IndexController indexController = Get.put(IndexController());
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;
  var currentPage = 1.obs;
  var totalPage = 1.obs;
  var historyList = <History>[].obs;
  var filteredHistoryList = <History>[].obs;
  var historyDetail = Rxn<HistoryDetail>();
  var diklatList = <Reschedule>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  void goToFirstPage() {
    currentPage.value = 1;
    fetchHistory(page: currentPage.value);
  }

  void goToLastPage() {
    currentPage.value = totalPage.value;
    fetchHistory(page: currentPage.value);
  }

  void goToPage(int page) {
    currentPage.value = page;
    fetchHistory(page: currentPage.value);
  }

  void nextPage() {
    if (currentPage.value < totalPage.value) {
      currentPage.value++;
      fetchHistory(page: currentPage.value); // Menggunakan parameter page
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchHistory(page: currentPage.value); // Menggunakan parameter page
    }
  }

  void fetchHistory({int? page}) async {
    EasyLoading.show(status: 'Please wait...');
    final Map<String, dynamic> queryParameters = {
      'uc_pendaftar': indexController.currentUser.value!.usrUc!,
    };
    if (page != null && page > 0) {
      queryParameters['page'] = page;
    }

    await BaseClient.safeApiCall(
      Environment.history,
      RequestType.get,
      queryParameters: queryParameters,
      onLoading: () {
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        EasyLoading.dismiss();
        var res = response.data;
        historyDetail.value = HistoryDetail.fromJson(res);
        if (historyDetail.value!.data != null &&
            historyDetail.value!.data!.isNotEmpty) {
          historyList.value = historyDetail.value!.data!;
          filteredHistoryList.value = historyList;
          totalPage.value = historyDetail.value!.totalPage!;
          apiCallStatus = ApiCallStatus.success;
        } else {
          apiCallStatus = ApiCallStatus.error;
          if (kDebugMode) {
            print('Data kursi kosong');
          }
        }
      },
      onError: (error) {
        EasyLoading.dismiss();
        if (kDebugMode) {
          print('Error occurred while fetching kategori list: $error');
        }
        BaseClient.handleApiError(error);
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  void loadDiklat() {
    // Dummy data untuk contoh
    var list = [
      Reschedule(
        noRegis: '33482918',
        namaDiklat: 'RENEWAL BRM',
        periode: '43',
        tanggalPendaftaran: '13 May 2024',
        statusBayar: 'Belum Lengkap',
        statusValidasi: 'Belum Diverifikasi',
      ),
      Reschedule(
        noRegis: '33482918',
        namaDiklat: 'AFF',
        periode: '43',
        tanggalPendaftaran: '13 May 2024',
        statusBayar: 'Belum Lengkap',
        statusValidasi: 'Belum Diverifikasi',
      ),
      Reschedule(
        noRegis: '33482918',
        namaDiklat: 'BST',
        periode: '43',
        tanggalPendaftaran: '13 May 2024',
        statusBayar: 'Sudah Lengkap',
        statusValidasi: 'Sudah Diverifikasi',
      ),
    ];

    diklatList.assignAll(list);
  }
}
