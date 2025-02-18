import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/profile/controllers/profile_controllers.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<IndexController>(() => IndexController());
  }
}
