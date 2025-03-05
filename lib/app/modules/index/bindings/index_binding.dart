import 'package:get/get.dart';
import 'package:mytrb/app/modules/auth/controllers/auth_controller.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';

class IndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IndexController>(() => IndexController(
        signRepository: Get.find(), syncRepository: Get.find()));

    Get.lazyPut<AuthController>(() =>
        AuthController(userRepository: Get.find(), appRepository: Get.find()));
  }
}
