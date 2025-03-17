import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/news/controllers/news_controller.dart';

class NewsDetailView extends GetView<NewsController> {
  const NewsDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map args = Get.arguments;
    final String uc = args['uc'];
    final String title = args['title'] ?? "";
    final String desc = args['description'] ?? "";
    final String create = args['created_at'] ?? "";

    // Tandai berita sebagai telah dibaca
    controller.setRead(uc);

    return WillPopScope(
      onWillPop: () async {
        Get.back(result: 1);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("News Detail")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(create, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontSize: 13.0,
                  ),
                  children: [
                    const TextSpan(
                      text: "MyTRB News - ",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: desc),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
