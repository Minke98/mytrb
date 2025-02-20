import 'package:get/get.dart';
import 'package:mytrb/app/Repository/report_repository.dart';
import 'package:mytrb/app/modules/report_task_approval/controllers/report_task_approval_controller.dart';

class ReportTaskApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportRepository>(() => ReportRepository(), fenix: true);
    Get.lazyPut<ReportTaskApprovalController>(
        () => ReportTaskApprovalController(reportRepository: Get.find()));
  }
}
