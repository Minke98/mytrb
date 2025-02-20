import 'package:get/get.dart';
import 'package:mytrb/app/Repository/app_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/modules/auth/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(() => UserRepository(), fenix: true);
    Get.lazyPut<AppRepository>(() => AppRepository(), fenix: true);

    Get.lazyPut<AuthController>(() => AuthController(
          userRepository: Get.find<UserRepository>(),
          appRepository: Get.find<AppRepository>(),
        ));
  }
}
