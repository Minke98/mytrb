import 'package:get/get.dart';
import 'package:mytrb/app/Repository/report_repository.dart';
import 'package:mytrb/app/modules/report_task_form/controllers/report_task_form_controller.dart';

class ReportTaskFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportRepository(), fenix: true);
    Get.lazyPut(() => ReportTaskFormController(reportRepository: Get.find()));
  }
}
