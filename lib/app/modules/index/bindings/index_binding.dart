import 'package:get/get.dart';
import 'package:mytrb/app/Repository/app_repository.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/Repository/sync_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/modules/auth/controllers/auth_controller.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/modules/sync/controllers/sync_controller.dart';

class IndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SyncRepository>(() => SyncRepository(), fenix: true);
    Get.lazyPut<UserRepository>(() => UserRepository(), fenix: true);
    Get.lazyPut<AppRepository>(() => AppRepository(), fenix: true);
    Get.lazyPut<SignRepository>(() => SignRepository(), fenix: true);
    Get.lazyPut<IndexController>(() => IndexController(
          signRepository: Get.find<SignRepository>(),
        ));

    Get.lazyPut<AuthController>(() => AuthController(
          userRepository: Get.find<UserRepository>(),
          appRepository: Get.find<AppRepository>(),
        ));
    Get.lazyPut<SyncController>(() => SyncController(
          syncRepository: Get.find<SyncRepository>(),
        ));
  }
}
