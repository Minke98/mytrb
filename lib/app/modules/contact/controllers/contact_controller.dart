import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/Repository/contact_repository.dart';

class ContactController extends GetxController {
  final ContactRepository contactRepository;

  var isSent = false.obs;
  var errorMessage = ''.obs;
  var isSubmitting = false.obs;
  var isFormValid = false.obs;

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pesanController = TextEditingController();

  ContactController({required this.contactRepository});

  void initializeContact() {
    isSent.value = false;
    errorMessage.value = '';
  }

  Future<void> sendContact() async {
    if (!isFormValid.value) return;

    isSubmitting.value = true;
    Map res = await contactRepository.send(
      pesan: pesanController.text,
      email: emailController.text,
      subject: subjectController.text,
    );

    if (res['status'] == true) {
      isSent.value = true;
      Get.snackbar("Success", "Message Sent",
          snackPosition: SnackPosition.BOTTOM);
    } else {
      errorMessage.value = res.containsKey('message')
          ? res['message']
          : "Maaf, data tidak dapat terkirim";
    }

    isSubmitting.value = false;
  }

  void validateForm() {
    isFormValid.value = subjectController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        GetUtils.isEmail(emailController.text) &&
        pesanController.text.isNotEmpty;
  }
}
