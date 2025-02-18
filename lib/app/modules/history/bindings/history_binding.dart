import 'package:mytrb/app/modules/history/controllers/history_controller.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:get/get.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<IndexController>(() => IndexController());
  }
}
