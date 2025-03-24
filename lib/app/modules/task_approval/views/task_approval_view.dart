import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:mytrb/app/components/image_picker_widget.dart';
import 'package:mytrb/app/modules/task_approval/controllers/task_approval_controller.dart';

class TaskApprovalView extends GetView<TaskApprovalController> {
  TaskApprovalView({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Approval")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Approval : ",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  controller.taskName.value ?? "",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                const Text("Instructor's Comment"),
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
                ),
                Obx(() {
                  return controller.quilError.value
                      ? const Text("Please fill in the comment.",
                          style: TextStyle(color: Colors.red))
                      : const SizedBox.shrink();
                }),
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
                Obx(() {
                  return ImagePickerWidget(
                    imageFile: controller.uploadFoto,
                    error: controller.uploadFotoError.value.isNotEmpty
                        ? controller.uploadFotoError
                        : ''.obs,
                    showCamera: true, // Menampilkan opsi kamera
                    showGallery: false, // Menyembunyikan opsi galeri
                  );
                }),
                const SizedBox(height: 10),
                FutureBuilder<bool>(
                  future:
                      controller.isFormValid(), // Panggil fungsi validasi async
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
    );
  }
}
