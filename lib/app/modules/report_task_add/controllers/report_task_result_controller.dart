import 'dart:developer';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_value.dart' as responsive;

class ReportTaskResultController extends GetxController {
  var sch = 0.0.obs;
  var localImage = ''.obs;
  var caption = ''.obs;
  final HtmlEditorController hcontroller = HtmlEditorController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      localImage.value = args['image'] ?? '';
      caption.value =
          "<html><body style='font-size:${_getFontSize()}rem'>${args['caption']}</body></html>";
      log("REPORT_TASK_RESULT: caption=${caption.value}, image=${localImage.value}");
    } else {
      log("WARNING: Get.arguments is null!");
    }
  }

  String _getFontSize() {
    return ResponsiveValue(Get.context!, defaultValue: 5, valueWhen: [
      const responsive.Condition.largerThan(name: MOBILE, value: 1.5),
      const responsive.Condition.largerThan(name: TABLET, value: 1)
    ]).value!.toString();
  }
}
