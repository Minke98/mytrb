import 'package:get/get.dart';
import 'package:mytrb/app/modules/report_task_add/controllers/report_task_add_controller.dart';
import 'package:mytrb/app/modules/report_task_form/controllers/report_task_form_controller.dart';

class ReportTaskAddFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportTaskAddFormController>(
        () => ReportTaskAddFormController(reportRepository: Get.find()));
    Get.lazyPut<ReportTaskAddController>(
        () => ReportTaskAddController(reportRepository: Get.find()));
  }
}
