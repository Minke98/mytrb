import 'dart:developer';

import 'package:get/get.dart';
import 'package:mytrb/app/Repository/news_repository.dart';

class NewsController extends GetxController {
  final NewsRepository newsRepository;

  var newsList = <Map>[].obs;
  var status = NewsReadyStatus.ready.obs;
  var page = 1.obs;
  var isFetching = false.obs;

  NewsController({required this.newsRepository});

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  Future<void> fetchNewsData() async {
    if (isFetching.value) return;

    try {
      isFetching.value = true;
      await NewsRepository.getNewNews();
      await fetchNews();
    } catch (e) {
      log("Error fetching news: $e");
    } finally {
      isFetching.value = false;
    }
  }

  Future<void> fetchNews() async {
    status.value = NewsReadyStatus.loading;
    List<Map> news =
        await NewsRepository.getNews(itemCount: 10, page: 1, characterMax: 150);
    newsList.assignAll(news);
    status.value = NewsReadyStatus.ready;
    page.value = 1;
  }

  Future<void> loadMoreNews() async {
    status.value = NewsReadyStatus.getmore;
    await Future.delayed(const Duration(milliseconds: 300));
    List<Map> news = await NewsRepository.getNews(
        itemCount: 10, page: page.value + 1, characterMax: 150);
    if (news.isNotEmpty) {
      newsList.addAll(news);
      page.value++;
    }
    status.value = NewsReadyStatus.success;
  }

  Future<void> setRead(String newsUc) async {
    Map save = await newsRepository.setRead(newsUc);
    if (save['status'] == true) {
      // Handle jika ada perubahan status baca
    }
  }

  void markAsRead(String uc) {
    int index = newsList.indexWhere((news) => news['uc'] == uc);
    if (index != -1) {
      newsList[index]['isRead'] = 1;
      newsList.refresh(); // Memicu update UI
    }
  }
}

enum NewsReadyStatus { ready, loading, getmore, success }
