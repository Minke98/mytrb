import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
    Get.put<IndexController>(IndexController(), permanent: true);
  }
}
