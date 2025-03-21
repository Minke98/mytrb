import 'package:get/get.dart';
import 'package:mytrb/app/modules/news/controllers/news_controller.dart';

class NewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsController>(
        () => NewsController(newsRepository: Get.find()));
  }
}
