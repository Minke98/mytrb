import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import 'package:mytrb/app/modules/logbook_add/controllers/logbook_add_controller.dart';

class LogBookAddView extends GetView<LogbookAddController> {
  final _formKey = GlobalKey<FormState>();

  LogBookAddView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Log")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              DatePicker(controller: controller),
              const SizedBox(height: 10.0),
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
                  onChangeContent: (String? text) {
                    controller
                        .validateForm(); // Panggil validateForm() setiap ada perubahan teks
                  },
                  onFocus: () {
                    FocusScope.of(context)
                        .unfocus(); // Menghilangkan fokus dari TextFormField
                  },
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () {
                  return SizedBox(
                    width: double.infinity, // Mengisi lebar yang tersedia
                    child: ElevatedButton(
                      onPressed: controller.isFormValid.value &&
                              !controller.isSubmitting.value
                          ? () async {
                              await controller.submit();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(55),
                        backgroundColor: controller.isFormValid.value
                            ? Colors.blue.shade900
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: controller.isSubmitting.value
                          ? CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                            )
                          : Text(
                              controller.uc.value == null ? "Save" : "Update",
                              style: const TextStyle(fontSize: 14),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DatePicker extends StatelessWidget {
  final LogbookAddController controller;

  const DatePicker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return TextFormField(
        readOnly: true,
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: controller.dateObj.value ?? DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 100),
            lastDate: DateTime(DateTime.now().year + 100),
          );
          if (selectedDate != null) {
            controller.dateObj.value = selectedDate;
            controller.dateText.value =
                DateFormat.yMMMMd().format(selectedDate);
            controller.validateForm();
          }
        },
        controller: TextEditingController(text: controller.dateText.value),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please fill in the Log Book date";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Log Book date",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    });
  }
}
