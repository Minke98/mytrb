import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:mytrb/app/components/image_picker_widget.dart';
import 'package:mytrb/app/modules/logbook_approval/controllers/logbook_approval_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LogbookApprovalView extends GetView<LogbookApprovalController> {
  LogbookApprovalView({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Logbook Approval")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoRow("Date", controller.logData['date_formated'] ?? "-"),
              _buildInfoRow(
                  "Approval", controller.logData['status_formated'] ?? "-"),
              _buildInfoRow("Activities", ""),
              const SizedBox(
                height: 4.0,
              ),
              WebViewContainer(
                  content: controller.logData['log_activity'] ?? ""),
              const Divider(),
              _buildForm(controller, controller.uc.value!, context),
              const SizedBox(height: 24.0),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(
                label,
                style: const TextStyle(fontSize: 14),
              )),
          const Expanded(
              flex: 1,
              child: Text(
                ":",
                style: TextStyle(fontSize: 14),
              )),
          Expanded(
              flex: 8,
              child: Text(
                value,
                style: const TextStyle(fontSize: 14),
              )),
        ],
      ),
    );
  }

  Widget _buildForm(
      LogbookApprovalController controller, String uc, BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            style: const TextStyle(color: Colors.black),
            controller: controller.namaInstruktur,
            decoration: InputDecoration(
              labelText: "Instructor's Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide:
                    BorderSide(color: Colors.black), // Ganti warna fokus
              ),
            ),
            validator: (value) =>
                value!.isEmpty ? "Please fill in the Instructor's Name" : null,
          ),
          const SizedBox(height: 8.0),
          Obx(() {
            return Row(
              children: controller.selection.map((approval) {
                return Expanded(
                  child: Row(
                    children: [
                      Radio<int>(
                        activeColor: Colors.black,
                        value: approval.value,
                        groupValue: controller.selectedApproval.value,
                        onChanged: (int? value) {
                          controller.selectedApproval.value = value!;
                        },
                      ),
                      Expanded(
                          child: Text(
                        approval.text,
                        style: const TextStyle(fontSize: 14),
                      )), // Agar teks tidak terpotong
                    ],
                  ),
                );
              }).toList(),
            );
          }),
          ImagePickerWidget(
            imageFile: controller.uploadFoto,
            error: controller.uploadFotoError.value.isNotEmpty
                ? controller.uploadFotoError
                : ''.obs,
            showCamera: true, // Menampilkan opsi kamera
            showGallery: false, // Menyembunyikan opsi galeri
          ),
          const SizedBox(height: 8.0),
          HtmlEditor(
            controller: controller.hcontroller,
            htmlEditorOptions: HtmlEditorOptions(
              initialText: controller.initText.value,
              hint: "Comment",
            ),
            htmlToolbarOptions: const HtmlToolbarOptions(
              defaultToolbarButtons: [
                ParagraphButtons(
                  caseConverter: false,
                  decreaseIndent: false,
                  increaseIndent: false,
                  lineHeight: false,
                  textDirection: false,
                ),
                FontButtons(
                    clearAll: false,
                    subscript: false,
                    superscript: false,
                    strikethrough: false),
                ListButtons(listStyles: false),
              ],
              toolbarType: ToolbarType.nativeGrid,
            ),
            otherOptions: OtherOptions(
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            callbacks: Callbacks(
              onFocus: () {
                FocusScope.of(context)
                    .unfocus(); // Menghilangkan fokus dari TextFormField
              },
            ),
          ),
          FutureBuilder<bool>(
            future: controller.isFormValid(), // Panggil fungsi validasi async
            builder: (context, snapshot) {
              bool isFormValid = snapshot.data ?? false;

              return Obx(
                () => ElevatedButton(
                  onPressed: isFormValid && !controller.isSubmitting.value
                      ? () => controller.save()
                      : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(55),
                    backgroundColor:
                        isFormValid ? Colors.blue.shade900 : Colors.grey,
                    splashFactory: controller.isSubmitting.value
                        ? NoSplash.splashFactory
                        : InkSplash.splashFactory,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: controller.isSubmitting.value
                      ? CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : const Text(
                          "Save",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                ),
              );
            },
          ),
        ],
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
