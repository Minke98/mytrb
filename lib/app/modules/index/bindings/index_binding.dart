import 'package:get/get.dart';
import 'package:mytrb/app/modules/auth/controllers/auth_controller.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/modules/sync/controllers/sync_controller.dart';

class IndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IndexController>(
        () => IndexController(signRepository: Get.find()));

    Get.lazyPut<AuthController>(() =>
        AuthController(userRepository: Get.find(), appRepository: Get.find()));
    Get.lazyPut<SyncController>(
        () => SyncController(syncRepository: Get.find()));
  }
}
