import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.put<IndexController>(IndexController(), permanent: true);
  }
}
