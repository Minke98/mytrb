import 'package:get/get.dart';
import 'package:mytrb/app/modules/credential/controllers/credential_controller.dart';

class CredentialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CredentialController>(() => CredentialController());
  }
}
