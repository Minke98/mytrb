import 'package:mytrb/app/modules/billing/controllers/billing_controller.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:get/get.dart';

class BillingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BillingController>(() => BillingController());
    Get.lazyPut<IndexController>(() => IndexController());
  }
}
