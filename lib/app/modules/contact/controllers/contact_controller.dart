import 'package:get/get.dart';
import 'package:mytrb/app/Repository/contact_repository.dart';

class ContactController extends GetxController {
  final ContactRepository contactRepository;

  var isLoading = false.obs;
  var isSent = false.obs;
  var errorMessage = ''.obs;

  ContactController({required this.contactRepository});

  void initializeContact() {
    isSent.value = false;
    errorMessage.value = '';
  }

  Future<void> sendContact({
    required String subject,
    required String email,
    required String pesan,
  }) async {
    isLoading.value = true;

    Map res = await contactRepository.send(
        pesan: pesan, email: email, subject: subject);

    if (res['status'] == true) {
      isSent.value = true;
    } else {
      errorMessage.value = res.containsKey('message')
          ? res['message']
          : "Maaf, data tidak dapat terkirim";
    }

    isLoading.value = false;
  }
}
