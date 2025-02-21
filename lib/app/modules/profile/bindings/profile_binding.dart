import 'package:get/get.dart';
import 'package:mytrb/app/Repository/profile_repository.dart';
import 'package:mytrb/app/modules/profile/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRepository>(() => ProfileRepository(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(
          profileRepository: Get.find<ProfileRepository>(),
        ));
  }
}
