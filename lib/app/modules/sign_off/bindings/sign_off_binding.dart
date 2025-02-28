import 'package:get/get.dart';
import 'package:mytrb/app/modules/sign_off/controllers/sign_off_controller.dart';

class SignoffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignoffController>(
        () => SignoffController(signRepository: Get.find()));
  }
}
