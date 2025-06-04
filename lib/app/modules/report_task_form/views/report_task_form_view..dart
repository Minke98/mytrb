import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:mytrb/app/components/image_picker_widget.dart';
import 'package:mytrb/app/modules/report_task_form/controllers/report_task_form_controller.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class ReportTaskAddFormView extends GetView<ReportTaskAddFormController> {
  const ReportTaskAddFormView({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.sch.value == 0) {
      controller.sch.value =
          (ResponsiveWrapper.of(context).orientation == Orientation.portrait)
              ? ResponsiveWrapper.of(context).screenHeight
              : ResponsiveWrapper.of(context).screenWidth;
    }

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(controller.title.value),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  Center(
                    child: Obx(() {
                      return ImagePickerWidget(
                        imageFile: controller
                            .uploadFoto, // Tetap gunakan ini karena Rx<XFile?>
                        error: controller.uploadFotoError.value.isNotEmpty
                            ? controller.uploadFotoError
                            : ''.obs, // Pastikan ini juga observable
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  HtmlEditor(
                    controller: controller.hcontroller,
                    htmlEditorOptions: HtmlEditorOptions(
                      initialText: controller.initText.value,
                      hint: "Fill in the Description",
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
                    otherOptions:
                        OtherOptions(height: 0.5 * controller.sch.value),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: ElevatedButton(
                        onPressed: () async {
                          String data = await controller.hcontroller.getText();
                          controller.quilError.value = data.isEmpty;
                          controller.uploadFotoError.value =
                              controller.uploadFotoError.value =
                                  controller.uploadFoto.value == null
                                      ? "Harap Unggah Foto"
                                      : "";

                          if (controller.uploadFotoError.value.isEmpty &&
                              !controller.quilError.value) {
                            controller.saveReportTaskForm(
                              caption: data,
                              foto: File(controller.uploadFoto.value!.path),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.blue.shade900,
                            minimumSize: const Size.fromHeight(50)),
                        child: const Text(
                          "Save",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
