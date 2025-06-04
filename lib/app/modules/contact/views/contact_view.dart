import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/components/constant.dart';
import 'package:mytrb/app/modules/contact/controllers/contact_controller.dart';

class ContactView extends GetView<ContactController> {
  ContactView({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 8),
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  controller: controller.subjectController,
                  decoration: InputDecoration(
                    labelText: "Subject",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.black), // Ganti warna fokus
                    ),
                  ),
                  onChanged: (value) => controller.validateForm(),
                  validator: (value) =>
                      value!.isEmpty ? "Please input the Subject" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.black), // Ganti warna fokus
                    ),
                  ),
                  onChanged: (value) => controller.validateForm(),
                  validator: (input) =>
                      input!.isValidEmail() ? null : "Email Invalid",
                ),
                const SizedBox(height: 12),
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  controller: controller.pesanController,
                  maxLines: null,
                  minLines: 5,
                  decoration: InputDecoration(
                    labelText: "Message",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.black), // Ganti warna fokus
                    ),
                  ),
                  onChanged: (value) => controller.validateForm(),
                  validator: (value) =>
                      value!.isEmpty ? "Please Input the Message" : null,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      return Expanded(
                        // Gantilah SizedBox dengan Expanded
                        child: ElevatedButton(
                          onPressed: controller.isFormValid.value &&
                                  !controller.isSubmitting.value
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    controller.sendContact();
                                  }
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
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                )
                              : const Text(
                                  "Save",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
