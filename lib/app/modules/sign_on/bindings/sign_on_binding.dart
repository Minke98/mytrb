import 'package:get/get.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/modules/sign_on/controllers/sign_on_controller.dart';

class SignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignRepository>(() => SignRepository(), fenix: true);
    Get.lazyPut<SignController>(
        () => SignController(signRepository: Get.find<SignRepository>()));
  }
}
