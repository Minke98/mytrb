import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/exam/controllers/exam_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExamWebView extends GetView<ExamController> {
  const ExamWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Examination'),
        ),
        body: WebViewWidget(controller: controller.webViewController!));
  }
}
