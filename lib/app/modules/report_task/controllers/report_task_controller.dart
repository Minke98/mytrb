import 'package:get/get.dart';
import 'package:mytrb/app/Repository/report_repository.dart';

class ReportTaskController extends GetxController {
  final ReportRepository reportRepository;
  ReportTaskController({required this.reportRepository});

  var reportList = [].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  void prepareReportTask(String month) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      var response = await reportRepository.getReportList(month: month);
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
