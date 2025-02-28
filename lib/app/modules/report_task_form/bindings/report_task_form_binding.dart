import 'package:get/get.dart';
import 'package:mytrb/app/modules/report_task_form/controllers/report_task_form_controller.dart';

class ReportTaskFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportTaskFormController>(
        () => ReportTaskFormController(reportRepository: Get.find()));
  }
}
