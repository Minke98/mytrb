import 'package:mytrb/app/data/models/news_certficate.dart';
import 'package:mytrb/app/modules/news_certificate/controllers/news_certificate_controller.dart';
import 'package:mytrb/utils/html_parser_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/routes/app_pages.dart';

class NewsCertficateView extends GetView<NewsCertificateController> {
  const NewsCertficateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sertifikat Terbit'),
      ),
      body: Obx(() {
        if (controller.newsCertificateList.isEmpty) {
          return const Center(
            child: Text('Tidak ada sertifikat terbit'),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20),
            child: ListView.builder(
              itemCount: controller.newsCertificateList.length,
              itemBuilder: (context, index) {
                NewsCertificate newsCertificate =
                    controller.newsCertificateList[index];
                return GestureDetector(
                  onTap: () {
                    // controller.markNewsAsRead(news.uc!);
                    Get.toNamed(Routes.NEWS_CERTIFICATE_DETAIL,
                        arguments: newsCertificate);
                  },
                  child: buildAnnouncementItem(
                    context,
                    newsCertificate.title ?? '',
                    HtmlParserUtil.parseHtmlString(newsCertificate.text ?? ''),
                    newsCertificate.createTime ?? '',
                    // news.isRead, // Tambahkan status isRead di sini
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }

  Widget buildAnnouncementItem(
      BuildContext context, String title, String text, String additionalText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        // isRead
        //     ? Colors.white
        //     : Colors.blue[50], // Warna biru untuk berita yang belum dibaca
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        // isRead
        //     ? Border.all(color: Colors.grey.shade300)
        //     : null, // Garis border untuk item yang sudah dibaca
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF002171),
              // isRead
              //     ? Color(0xFF002171)
              //     : Colors.blue, // Ubah warna teks untuk item yang belum dibaca
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              additionalText,
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
