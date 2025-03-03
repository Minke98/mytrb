import 'package:get/get.dart';
import 'package:mytrb/app/modules/auth/controllers/auth_controller.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/modules/sync/controllers/sync_controller.dart';

class IndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<IndexController>(
      IndexController(
        signRepository: Get.find(),
      ),
      permanent: true,
    );
    Get.put<SyncController>(
      SyncController(
        syncRepository: Get.find(),
      ),
      permanent: true,
    );
    Get.lazyPut<AuthController>(() =>
        AuthController(userRepository: Get.find(), appRepository: Get.find()));
  }
}
