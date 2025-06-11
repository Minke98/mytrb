import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/news/controllers/news_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsView extends GetView<NewsController> {
  const NewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RefreshController refreshController = RefreshController();
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(title: const Text("News")),
      body: Obx(() {
        if (controller.status.value == NewsReadyStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.newsList.isEmpty) {
          return const Center(
            child: Text(
              "There is currently no recent news available",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
          );
        }

        return SmartRefresher(
          controller: refreshController,
          enablePullDown: false,
          enablePullUp: true,
          onLoading: () async {
            await controller.loadMoreNews();
            refreshController.loadComplete();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            controller: scrollController,
            itemCount: controller.newsList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: NewsPreview(item: controller.newsList[index]),
              );
            },
          ),
        );
      }),
    );
  }
}

class NewsPreview extends StatelessWidget {
  final Map item;
  const NewsPreview({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NewsController controller = Get.find<NewsController>();

    return Obx(() {
      // Ambil data terbaru dari controller
      int isRead = controller.newsList.firstWhereOrNull(
              (news) => news['uc'] == item['uc'])?['isRead'] ??
          0;

      return Card(
        color: isRead == 0 ? Colors.blue.shade200 : Colors.white,
        child: InkWell(
          onTap: () async {
            var status = await Get.toNamed(Routes.NEWS_DETAIL, arguments: {
              "uc": item['uc'],
              "title": item['title'],
              "created_at": item['created_at_formated'],
              "description": item['descriptionfull'],
            });

            if (status is int && status == 1) {
              controller.markAsRead(item['uc']);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                item['title'] ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w500),
              ),
              subtitle: Column(
                children: [
                  const Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item['created_at_formated'],
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          const TextSpan(
                            text: "TRSea News - ",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 12),
                          ),
                          TextSpan(
                            text: item['description'] ?? '-',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                        text: "Selengkapnya >",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontSize: 14),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
