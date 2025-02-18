import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/questionnaire/controllers/questionnaire_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QuestionnaireView extends GetView<QuestionnaireController> {
  const QuestionnaireView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Kuesioner'),
        ),
        body: WebViewWidget(controller: controller.webViewController!));
  }
}
