import 'package:mytrb/app/modules/billing/controllers/billing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InvoiceWebView extends GetView<BillingController> {
  const InvoiceWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Invoice'),
        ),
        body: WebViewWidget(controller: controller.webViewController!));
  }
}
