import 'package:mytrb/app/modules/certificate_delivery/controllers/certificate_delivery_controller.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:get/get.dart';

class CertificateDeliveryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CertificateDeliveryController>(
        () => CertificateDeliveryController());
    Get.lazyPut<IndexController>(() => IndexController());
  }
}
