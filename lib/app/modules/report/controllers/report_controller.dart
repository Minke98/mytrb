import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mytrb/app/Repository/report_repository.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';

class ReportController extends GetxController {
  final ReportRepository reportRepository;

  ReportController({required this.reportRepository});

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
    initializeReport();

    // Ambil argument hanya jika ada
    if (Get.arguments != null) {
      setReportData(Get.arguments);
    }
  }

  void setReportData(Map<String, dynamic> args) {
    ucSign.value = args['uc_sign'] ?? '';
    monthNumber.value = args['month_number'] ?? 1;
    log("SET REPORT DATA: uc_sign=$ucSign, month_number=$monthNumber");
  }

  Future<void> initializeReport() async {
    isLoading.value = true;
    // Ambil user data & sign data
    Map user = await UserRepository.getLocalUserReport(useAlternate: true);
    final prefs = await SharedPreferences.getInstance();
    allowModify.value = prefs.getBool("modifyTask") ?? true;

    Map sign = await SignRepository.getData(
      localSignUc: user['data']['sign_uc_local'],
      allowModify: allowModify.value,
    );

    if (sign['status'] == true) {
      signData.value = sign['data'];

      DateTime startDate = DateTime.parse(user['data']["date_start"]);
      DateTime endDate = DateTime.parse(user['data']["date_finish"]);

      bulanCount.value = (endDate.year - startDate.year) * 12 +
          endDate.month -
          startDate.month;

      var format = DateFormat.yMMMMd();
      user['data']["date_start_formated"] = format.format(startDate);
      user['data']["date_finish_formated"] = format.format(endDate);

      userData.value = user['data'];

      List reportContent = await reportRepository.getMonthContent(
        ucSign: user['data']['sign_uc'],
      );
      activeReport.value = reportContent;
    } else {
      Get.snackbar("Error", "Gagal memuat data laporan");
    }

    isLoading.value = false;
  }
}
