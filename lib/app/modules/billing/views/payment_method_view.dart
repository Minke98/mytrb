import 'package:mytrb/app/modules/billing/controllers/billing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentMethodWebView extends GetView<BillingController> {
  const PaymentMethodWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cara Pembayaran'),
        ),
        body: WebViewWidget(controller: controller.webViewController!));
  }
}
