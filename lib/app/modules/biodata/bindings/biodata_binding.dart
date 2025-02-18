import 'package:mytrb/app/modules/biodata/controllers/biodata_controller.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:get/get.dart';

class BiodataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IndexController>(() => IndexController());
    Get.lazyPut<BiodataController>(() => BiodataController());
  }
}
