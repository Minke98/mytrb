import 'package:get/get.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';

class IndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignRepository>(() => SignRepository(), fenix: true);

    Get.lazyPut(() => IndexController(
          signRepository: Get.find<SignRepository>(),
        ));
  }
}
