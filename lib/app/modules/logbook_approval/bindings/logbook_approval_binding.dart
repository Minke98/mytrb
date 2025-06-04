import 'package:get/get.dart';
import 'package:mytrb/app/modules/logbook/controllers/logbook_controller.dart';
import 'package:mytrb/app/modules/logbook_approval/controllers/logbook_approval_controller.dart';

class LogbookApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogbookApprovalController>(
        () => LogbookApprovalController(logBookRepository: Get.find()));
    Get.lazyPut<LogbookController>(
        () => LogbookController(logBookRepository: Get.find()));
  }
}
