import 'package:get/get.dart';
import 'package:mytrb/app/Repository/logbook_repository.dart';
import 'package:mytrb/app/modules/logbook_approval/controllers/logbook_approval_controller.dart';

class LogbookApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogBookRepository>(() => LogBookRepository(), fenix: true);
    Get.lazyPut<LogbookApprovalController>(() => LogbookApprovalController(
          logBookRepository: Get.find<LogBookRepository>(),
        ));
  }
}
