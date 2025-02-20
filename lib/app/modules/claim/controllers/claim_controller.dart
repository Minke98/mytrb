import 'package:get/get.dart';
import 'package:mytrb/app/Repository/user_repository.dart';

class ClaimController extends GetxController {
  final UserRepository userRepository;

  var isLoading = false.obs;
  var isSuccess = false.obs;
  var errorMessage = ''.obs;

  ClaimController({required this.userRepository});

  Future<void> claim({
    required String deviceId,
    required String email,
    required String fullName,
    required String password,
    required String ucParticipant,
    required String username,
  }) async {
    isLoading.value = true;
    var res = await userRepository.claim(
        device_id: deviceId,
        email: email,
        full_name: fullName,
        password: password,
        uc_participant: ucParticipant,
        username: username);

    if (res['status'] == true) {
      isSuccess.value = true;
    } else {
      errorMessage.value = res['message'];
    }
    isLoading.value = false;
  }

  void resetClaim() {
    isSuccess.value = false;
    errorMessage.value = '';
  }
}
