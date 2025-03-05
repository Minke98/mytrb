import 'package:get/get.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/modules/sign_on/controllers/sign_on_controller.dart';

class SignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignController>(
        () => SignController(signRepository: Get.find()));
    Get.lazyPut<IndexController>(() => IndexController(
        signRepository: Get.find(), syncRepository: Get.find()));
  }
}
