import 'package:get/get.dart';
import 'package:mytrb/app/Repository/report_repository.dart';
import 'package:mytrb/app/modules/report/controllers/report_controller.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportRepository>(() => ReportRepository(), fenix: true);
    Get.lazyPut<ReportController>(
        () => ReportController(reportRepository: Get.find<ReportRepository>()));
  }
}
