import 'package:mytrb/app/modules/billing/controllers/billing_controller.dart';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/app/modules/news_certificate/controllers/news_certificate_controller.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/news/controllers/news_controller.dart';

class IndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<IndexController>(IndexController(), permanent: true);
    Get.lazyPut<NewsController>(() => NewsController());
    Get.lazyPut<NewsCertificateController>(() => NewsCertificateController());
    Get.lazyPut<BillingController>(() => BillingController());
  }
}
