import 'package:get/get.dart';
import 'package:mytrb/app/Repository/logbook_repository.dart';
import 'package:mytrb/app/modules/logbook/controllers/logbook_controller.dart';

class LogbookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogBookRepository>(() => LogBookRepository(), fenix: true);
    Get.lazyPut<LogbookController>(() => LogbookController(
          logBookRepository: Get.find<LogBookRepository>(),
        ));
  }
}
