import 'package:mytrb/app/modules/billing/controllers/billing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CardWebView extends GetView<BillingController> {
  const CardWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cetak Kartu'),
        ),
        body: WebViewWidget(controller: controller.webViewController!));
  }
}
