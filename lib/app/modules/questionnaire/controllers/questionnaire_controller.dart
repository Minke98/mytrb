import 'dart:ui';
import 'package:mytrb/app/modules/index/controllers/index_controller.dart';
import 'package:mytrb/config/environment/environment.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QuestionnaireController extends GetxController {
  WebViewController? webViewController;
  final IndexController indexController = Get.put(IndexController());

  @override
  void onInit() {
    final url =
        Environment.kuesioner + indexController.currentUser.value!.usrNik!;
    if (kDebugMode) {
      print('Loading URL: $url');
    }

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    super.onInit();
  }
}
