import 'package:get/get.dart';
import 'package:mytrb/app/Repository/app_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(() => UserRepository());
    Get.lazyPut<AppRepository>(() => AppRepository());
    Get.lazyPut<SplashController>(() => SplashController(
          userRepository: Get.find(),
          appRepository: Get.find(),
        ));
  }
}
