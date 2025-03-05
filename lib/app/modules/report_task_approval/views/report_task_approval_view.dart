import 'package:dropdown_button2/dropdown_button2.dart';
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
                    return DropdownButtonHideUnderline(
                      child: DropdownButton2<int>(
                        isExpanded: true,
                        hint: const Text(
                          "Select Approval",
                          style: TextStyle(color: Colors.grey),
                        ),
                        value: controller.selectedApproval.value,
                        items: controller.selection.map((approval) {
                          return DropdownMenuItem<int>(
                            value: approval.value,
                            child: Text(approval.text),
                          );
                        }).toList(),
                        onChanged: (int? value) {
                          controller.selectedApproval.value = value;
                        },
                        buttonStyleData: ButtonStyleData(
                          height: 56,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black38),
                          ),
                          elevation: 0,
                        ),
                        iconStyleData: IconStyleData(
                          icon: Obx(() => Icon(
                                controller.isDropdownOpened.value
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                              )),
                          iconSize: 24,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black26),
                            color: Colors.white,
                          ),
                          offset: const Offset(0, 5),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all<double>(6),
                            thumbVisibility:
                                MaterialStateProperty.all<bool>(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        onMenuStateChange: (isOpen) {
                          controller.isDropdownOpened.value = isOpen;
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                  ImagePickerWidget(
                    imageFile: controller.uploadFoto,
                    error: controller.uploadFotoError.value.isNotEmpty
                        ? controller.uploadFotoError
                        : ''.obs,
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
