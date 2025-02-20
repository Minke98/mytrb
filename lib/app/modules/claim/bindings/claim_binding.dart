import 'package:get/get.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:mytrb/app/modules/claim/controllers/claim_controller.dart';

class ClaimBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(() => UserRepository(), fenix: true);

    Get.lazyPut<ClaimController>(
        () => ClaimController(userRepository: Get.find<UserRepository>()));
  }
}
