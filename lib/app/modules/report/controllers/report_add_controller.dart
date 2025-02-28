import 'dart:developer';

import 'package:get/get.dart';
import 'package:mytrb/app/Repository/report_repository.dart';

class ReportAddController extends GetxController {
  final ReportRepository reportRepository;

  ReportAddController({required this.reportRepository});

  var isLoading = false.obs;
  var userData = {}.obs;
  var signData = {}.obs;
  var allowModify = true.obs;
  var bulanCount = 0.obs;
  var activeReport = [].obs;
  var ucSign = ''.obs;
  var monthNumber = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      setReportData(Get.arguments);
    }
  }

  void setReportData(Map<String, dynamic> args) {
    ucSign.value = args['uc_sign'] ?? '';
    monthNumber.value = args['month_number'] ?? 1;
    log("SET REPORT DATA: uc_sign=$ucSign, month_number=$monthNumber");
  }
}
