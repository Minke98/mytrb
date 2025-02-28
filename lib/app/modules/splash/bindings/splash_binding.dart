import 'package:get/get.dart';
import 'package:mytrb/app/modules/auth/controllers/auth_controller.dart';
import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
    Get.lazyPut<AuthController>(() =>
        AuthController(userRepository: Get.find(), appRepository: Get.find()));
  }
}
