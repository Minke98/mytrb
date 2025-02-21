import 'package:get/get.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskDetailController extends GetxController {
  var userData = {}.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTaskDetail();
  }

  Future<void> fetchTaskDetail() async {
    isLoading.value = true;
    Map user = await UserRepository.getLocalUser(useAlternate: true);

    if (user['status'] == true) {
      final prefs = await SharedPreferences.getInstance();
      bool allowModify = prefs.getBool("modifyTask") ?? true;
      var udata = user['data'];

      Map signData = await SignRepository.getData(
        localSignUc: udata['sign_uc_local'],
        allowModify: allowModify,
      );

      udata['imo_number'] =
          signData['status'] == true ? signData['data']['imo_number'] : "-";
      udata['pembimbing'] =
          signData['status'] == true && signData['data']['pembimbing'] != null
              ? signData['data']['pembimbing']
              : "-";

      userData.value = udata;
    } else {
      userData.value = {
        'full_name': "-",
        'seafarer_code': "-",
        'imo_number': "-",
        'pembimbing': "-",
      };
    }

    isLoading.value = false;
  }
}
