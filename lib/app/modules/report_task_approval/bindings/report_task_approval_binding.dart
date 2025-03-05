import 'package:get/get.dart';
import 'package:mytrb/app/modules/report_task_add/controllers/report_task_add_controller.dart';
import 'package:mytrb/app/modules/report_task_approval/controllers/report_task_approval_controller.dart';

class ReportTaskApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportTaskApprovalController>(
        () => ReportTaskApprovalController(reportRepository: Get.find()));
    Get.lazyPut<ReportTaskAddController>(
        () => ReportTaskAddController(reportRepository: Get.find()));
  }
}
