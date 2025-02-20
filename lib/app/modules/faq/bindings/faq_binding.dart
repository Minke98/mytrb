import 'package:get/get.dart';
import 'package:mytrb/app/Repository/faq_repository.dart';
import 'package:mytrb/app/modules/faq/controllers/faq_controller.dart';

class FaqBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaqRepository>(() => FaqRepository(), fenix: true);

    Get.lazyPut(() => FaqController(
          faqRepository: Get.find<FaqRepository>(),
        ));
  }
}
