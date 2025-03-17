import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/logbook/controllers/logbook_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LogbookView extends GetView<LogbookController> {
  const LogbookView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log Book")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.logbookList.isEmpty) {
          return Center(
              child: Text("There is currently no data available",
                  style: Theme.of(context).textTheme.bodyLarge));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          itemCount: controller.logbookList.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.logbookList.length) {
              return const SizedBox(height: 56.0);
            }
            final item = controller.logbookList[index];
            return Column(
              children: [
                ListWidget(item: item, controller: controller),
                const SizedBox(height: 8.0)
              ],
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Get.toNamed(Routes.LOGBOOK_ADD, arguments: {"mode": "add"}),
        label: const Text('Add', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class ListWidget extends StatelessWidget {
  final Map item;
  final LogbookController controller;

  const ListWidget({super.key, required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: controller.approvalMode.value
          ? Theme.of(context).colorScheme.secondaryContainer
          : Colors.white,
      child: InkWell(
        onTap: controller.approvalMode.value
            ? () =>
                controller.toggleApprovalMode(!controller.approvalMode.value)
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(item['log_date_formated'],
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                const Text(" - Approval : "),
                Text(item['status_string'])
              ]),
              const Divider(),
              const SizedBox(height: 5),
              WebViewContainer(content: item['log_activity']),
              if (!controller.approvalMode.value)
                Row(
                  children: [
                    if (item['app_inst_status'] != 1)
                      ElevatedButton(
                        onPressed: () => Get.toNamed(Routes.LOGBOOK_APPROVAL,
                            arguments: {"mode": "add", "uc": item['local_uc']}),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.green, // Warna tombol Approval
                          foregroundColor: Colors.white, // Warna teks
                        ),
                        child: const Text("Approval"),
                      ),
                    const Spacer(),
                    if (item['app_inst_status'] != 1)
                      ElevatedButton(
                        onPressed: () => Get.toNamed(Routes.LOGBOOK_ADD,
                            arguments: {"mode": "add", "uc": item['local_uc']}),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue.shade900, // Warna tombol Edit
                          foregroundColor: Colors.white, // Warna teks
                        ),
                        child: const Text("Edit"),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class WebViewContainer extends StatefulWidget {
  final String content;

  const WebViewContainer({super.key, required this.content});

  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer>
    with AutomaticKeepAliveClientMixin {
  late WebViewController _webViewController;
  final RxDouble webContainerHeight = 0.0.obs;

  @override
  void initState() {
    super.initState();
    _webViewController = _initWebViewController();
  }

  WebViewController _initWebViewController() {
    final webViewCtrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel('docEl', onMessageReceived: (e) {
        if (webContainerHeight.value == 0) {
          webContainerHeight.value = double.parse(e.message) + 15;
        }
        log("JS list CHANNEL \${e.message}");
      });

    String html = """
      <!DOCTYPE html><html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
      <style>html, body { width:100%; height: 100%; margin: 0px; padding: 0px; }</style></head>
      <body>
        <div id=\"container\">${widget.content}</div>
      </body>
      <script>
        setTimeout(() => docEl.postMessage(Math.ceil(document.getElementById(\"container\").offsetHeight * 0.85)), 300);
      </script>
      </html>
    """;
    webViewCtrl.loadHtmlString(html);
    return webViewCtrl;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() => SizedBox(
          height: webContainerHeight.value,
          child: WebViewWidget(controller: _webViewController),
        ));
  }
}
