import 'package:get/get.dart';
import 'package:mytrb/app/modules/logbook/controllers/logbook_controller.dart';
import 'package:mytrb/app/modules/logbook_add/controllers/logbook_add_controller.dart';

class LogbookAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogbookAddController>(
        () => LogbookAddController(logBookRepository: Get.find()));
    Get.lazyPut<LogbookController>(
        () => LogbookController(logBookRepository: Get.find()));
  }
}
