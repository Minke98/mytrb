import 'package:get/get.dart';
import 'package:mytrb/app/modules/report_task/controllers/report_task_controller.dart';

class ReportTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportTaskController>(
        () => ReportTaskController(reportRepository: Get.find()));
  }
}
