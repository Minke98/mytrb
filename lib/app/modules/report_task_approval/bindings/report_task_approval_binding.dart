import 'package:get/get.dart';
import 'package:mytrb/app/modules/report_task_approval/controllers/report_task_approval_controller.dart';

class ReportTaskApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportTaskApprovalController>(
        () => ReportTaskApprovalController(reportRepository: Get.find()));
  }
}
