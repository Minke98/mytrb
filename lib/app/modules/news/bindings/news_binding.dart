import 'package:get/get.dart';
import 'package:mytrb/app/Repository/news_repository.dart';
import 'package:mytrb/app/modules/news/controllers/news_controller.dart';

class NewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsRepository>(() => NewsRepository(), fenix: true);
    Get.lazyPut<NewsController>(() => NewsController(
          newsRepository: Get.find<NewsRepository>(),
        ));
  }
}
