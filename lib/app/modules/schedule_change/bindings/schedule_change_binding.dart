import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/modules/schedule_change/controllers/schedule_change_controller.dart';
import 'package:get/get.dart';

class ScheduleChangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleChangeController>(() => ScheduleChangeController());
    Get.lazyPut<IndexController>(() => IndexController());
  }
}
