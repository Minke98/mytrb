import 'package:get/get.dart';
import 'package:mytrb/app/Repository/report_repository.dart';
import 'package:mytrb/app/modules/report_task_add/controllers/report_task_add_controller.dart';

class ReportTaskAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportRepository>(() => ReportRepository(), fenix: true);
    Get.lazyPut<ReportTaskAddController>(
        () => ReportTaskAddController(reportRepository: Get.find()));
  }
}
