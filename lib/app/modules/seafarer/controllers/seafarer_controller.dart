import 'package:get/get.dart';
import 'package:mytrb/app/Repository/user_repository.dart';

class SeafererController extends GetxController {
  final UserRepository userRepository;
  SeafererController({required this.userRepository});

  var isChecking = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;
  var nama = ''.obs;
  var nik = ''.obs;
  var ucParticipant = ''.obs;

  Future<void> checkSeaferer(String seafarer) async {
    isChecking.value = true;
    isError.value = false;
    try {
      var res = await userRepository.checkSeafarer(seafarer: seafarer);
      if (res['status'] == false) {
        isError.value = true;
        errorMessage.value = res['message'];
      } else {
        var participant = res['data'];
        nama.value = participant["full_name"];
        nik.value = participant["nik"];
        ucParticipant.value = participant['uc_participant'];
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isChecking.value = false;
    }
  }
}
