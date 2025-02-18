import 'package:mytrb/app/modules/news_certificate/controllers/news_certificate_controller.dart';
import 'package:get/get.dart';

class NewsCertificateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsCertificateController>(() => NewsCertificateController());
  }
}
