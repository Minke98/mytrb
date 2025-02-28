import 'package:get/get.dart';
import 'package:mytrb/app/modules/logbook_approval/controllers/logbook_approval_controller.dart';

class LogbookApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogbookApprovalController>(
        () => LogbookApprovalController(logBookRepository: Get.find()));
  }
}
