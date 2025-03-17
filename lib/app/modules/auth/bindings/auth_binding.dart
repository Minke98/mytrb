import 'package:get/get.dart';
import 'package:mytrb/app/modules/auth/controllers/auth_controller.dart';
import 'package:mytrb/app/modules/news/controllers/news_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(
      AuthController(
        userRepository: Get.find(),
        appRepository: Get.find(),
      ),
      permanent: true,
    );
    Get.lazyPut<NewsController>(
        () => NewsController(newsRepository: Get.find()));
  }
}
