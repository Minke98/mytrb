import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:mytrb/app/components/image_picker_widget.dart';
import 'package:mytrb/app/modules/report_task_approval/controllers/report_task_approval_controller.dart';

class ReportTaskApprovalView extends GetView<ReportTaskApprovalController> {
  const ReportTaskApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        controller.hcontroller.clearFocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Approval"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: controller.namaInstruktur,
                    decoration: InputDecoration(
                      labelText: "Instructor's Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) => value!.isEmpty
                        ? "Please fill in the Instructor's Name"
                        : null,
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Instructor's Comment",
                        style: TextStyle(fontSize: 14),
                      )),
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
                  const SizedBox(height: 10),
                  Obx(() {
                    return Row(
                      children: controller.selection.map((approval) {
                        return Expanded(
                          child: Row(
                            children: [
                              Radio<int>(
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
                  const SizedBox(height: 10),
                  ImagePickerWidget(
                    imageFile: controller.uploadFoto,
                    error: controller.uploadFotoError.value.isNotEmpty
                        ? controller.uploadFotoError
                        : ''.obs,
                    showCamera: true, // Menampilkan opsi kamera
                    showGallery: false, // Menyembunyikan opsi galeri
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<bool>(
                    future: controller
                        .isFormValid(), // Panggil fungsi validasi async
                    builder: (context, snapshot) {
                      bool isFormValid = snapshot.data ?? false;

                      return Obx(() => ElevatedButton(
                            onPressed:
                                isFormValid && !controller.isSubmitting.value
                                    ? () => controller.saveApproval()
                                    : null,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(55),
                              backgroundColor: isFormValid
                                  ? Colors.blue.shade900
                                  : Colors.grey,
                              splashFactory: controller.isSubmitting.value
                                  ? NoSplash.splashFactory
                                  : InkSplash.splashFactory,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: controller.isSubmitting.value
                                ? CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  )
                                : const Text(
                                    "Save",
                                    style: TextStyle(fontSize: 14),
                                  ),
                          ));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
