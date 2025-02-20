import 'package:get/get.dart';
import 'package:mytrb/app/Repository/logbook_repository.dart';
import 'package:mytrb/app/modules/logbook_add/controllers/logbook_add_controller.dart';

class LogbookAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogBookRepository>(() => LogBookRepository(), fenix: true);
    Get.lazyPut<LogbookAddController>(() => LogbookAddController(
          logBookRepository: Get.find<LogBookRepository>(),
        ));
  }
}
