import 'package:get/get.dart';
import 'package:mytrb/app/Repository/sign_repository.dart';
import 'package:mytrb/app/Repository/task_repository.dart';
import 'package:mytrb/app/Repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskController extends GetxController {
  final TaskRepository taskRepository;

  TaskController({required this.taskRepository});

  var competency = <Map>[].obs;
  var isLoading = true.obs;
  var userData = {}.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await initTask();
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

  Future<void> initTask() async {
    isLoading(true);
    try {
      List<Map>? resCompetency = await taskRepository.getListCompetency();
      competency.assignAll(resCompetency ?? []);
    } finally {
      isLoading(false);
    }
  }
}
