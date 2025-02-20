import 'package:get/get.dart';
import 'package:mytrb/app/Repository/contact_repository.dart';
import 'package:mytrb/app/modules/contact/controllers/contact_controller.dart';

class ContactBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactRepository>(() => ContactRepository(), fenix: true);

    Get.lazyPut<ContactController>(() =>
        ContactController(contactRepository: Get.find<ContactRepository>()));
  }
}
