import 'package:get/get.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/modules/seafarer/controllers/seafarer_controller.dart';

class SeafererBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(() => UserRepository(), fenix: true);
    Get.lazyPut<SeafererController>(
        () => SeafererController(userRepository: Get.find<UserRepository>()));
  }
}
