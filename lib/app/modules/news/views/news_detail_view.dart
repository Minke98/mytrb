import 'package:mytrb/utils/device_max_width_util.dart';
import 'package:mytrb/utils/html_parser_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/news/controllers/news_controller.dart';
import 'package:pdfx/pdfx.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailView extends GetView<NewsController> {
  NewsDetailView({
    Key? key,
  }) : super(key: key);

  final news = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewsController>(
      init: NewsController(),
      builder: (c) {
        c.loadPdfFromUrl(news.file);
        return _buildWidget(context);
      },
    );
  }

  Widget _buildWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.clearDialog();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail Pengumuman'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news.title ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002171),
                ),
              ),
              const SizedBox(height: 16),
              // Kotak teks dengan batasan tinggi tertentu
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: _buildClickableText(
                      HtmlParserUtil.parseHtmlString(news.text ?? '')),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                return Stack(
                  children: [
                    FutureBuilder<PdfDocument>(
                      future: controller.isLoading.value
                          ? null
                          : controller.pdfPath.value != null
                              ? Future.value(controller.pdfPath.value)
                              : null,
                      builder: (context, snapshot) {
                        if (controller.isLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              'Terjadi kesalahan saat memuat PDF',
                              style: TextStyle(fontSize: 16, color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else if (!snapshot.hasData) {
                          return const Center(
                            child: Text(
                              'File PDF tidak ditemukan.',
                              style: TextStyle(fontSize: 16, color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else {
                          return Stack(
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  double maxWidth =
                                      DeviceUtils.getDeviceMaxWidth(context);
                                  double pdfHeight = maxWidth <= 384
                                      ? 350
                                      : maxWidth >= 736
                                          ? 350
                                          : 350;

                                  return SizedBox(
                                    height: pdfHeight,
                                    child: PdfView(
                                      scrollDirection: Axis.vertical,
                                      controller: controller.pdfController,
                                      onPageChanged: (page) {
                                        controller.onPageChanged(page);
                                      },
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                bottom: 5.0, // Menempatkan di bawah
                                left: 0,
                                right: 0,
                                child: Obx(() {
                                  return Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Text(
                                        controller.pageFractionText.value,
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membuat teks dengan hyperlink
  Widget _buildClickableText(String text) {
    final RegExp urlRegex = RegExp(
      r'((http|https):\/\/[^\s]+)',
      caseSensitive: false,
    );

    final List<TextSpan> spans = [];
    final matches = urlRegex.allMatches(text);

    int lastIndex = 0;
    for (final match in matches) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }

      final String url = match.group(0) ?? '';
      spans.add(
        TextSpan(
          text: url,
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final Uri parsedUrl = Uri.parse(url); // Parse the URL
              if (await canLaunchUrl(parsedUrl)) {
                await launchUrl(parsedUrl);
              }
            },
        ),
      );
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    // Menggunakan `Align` untuk membuat teks justified.
    return Align(
      alignment: Alignment.topLeft,
      child: RichText(
        textAlign: TextAlign.justify, // Justify the text
        text: TextSpan(
          style: const TextStyle(fontSize: 16, color: Colors.black),
          children: spans,
        ),
      ),
    );
  }
}
