import 'package:get/get.dart';
import 'package:mytrb/app/modules/contact/controllers/contact_controller.dart';

class ContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactController>(
        () => ContactController(contactRepository: Get.find()));
  }
}
