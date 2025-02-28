import 'package:get/get.dart';
import 'package:mytrb/app/modules/logbook/controllers/logbook_controller.dart';

class LogbookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogbookController>(
        () => LogbookController(logBookRepository: Get.find()));
  }
}
