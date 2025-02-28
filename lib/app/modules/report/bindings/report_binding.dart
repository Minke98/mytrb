import 'package:get/get.dart';
import 'package:mytrb/app/modules/report/controllers/report_add_controller.dart';
import 'package:mytrb/app/modules/report/controllers/report_controller.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportController>(
        () => ReportController(reportRepository: Get.find()));
    Get.lazyPut<ReportAddController>(
        () => ReportAddController(reportRepository: Get.find()));
  }
}
