import 'dart:developer';

import 'package:get/get.dart';
import 'package:mytrb/app/Repository/report_repository.dart';

class ReportTaskController extends GetxController {
  final ReportRepository reportRepository;
  ReportTaskController({required this.reportRepository});

  var reportList = [].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var ucSign = ''.obs;
  var monthNumber = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      ucSign.value = args['uc_sign'] ?? '';
      monthNumber.value = args['month_number'] ?? 1;
      print("REPORT_TASK: uc_sign=$ucSign, month_number=$monthNumber");
    } else {
      log("WARNING: Get.arguments is null!");
    }
    prepareReportTask();
  }

  void prepareReportTask() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      var response = await reportRepository.getReportList(month: monthNumber);
      if (response['status'] == true) {
        reportList.assignAll(response['data']);
      } else {
        errorMessage.value = response['message'];
      }
    } catch (e) {
      errorMessage.value = "Terjadi kesalahan, coba lagi nanti";
    } finally {
      isLoading.value = false;
    }
  }
}
