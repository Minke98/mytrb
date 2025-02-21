import 'package:get/get.dart';
import 'package:mytrb/app/Repository/task_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskChecklistController extends GetxController {
  final TaskRepository taskRepository;

  TaskChecklistController({required this.taskRepository});

  var taskList = <Map>[].obs;
  var allowModify = true.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  void initTaskChecklist(String ucSubCompetency) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      List<Map> fetchedTaskList =
          await taskRepository.getTaskList(ucSubCompetency: ucSubCompetency);
      final prefs = await SharedPreferences.getInstance();
      allowModify.value = prefs.getBool("modifyTask") ?? true;

      if (fetchedTaskList.isEmpty) {
        errorMessage.value = "Empty Task";
      } else {
        taskList.assignAll(fetchedTaskList);
      }
    } catch (e) {
      errorMessage.value = "Failed to load tasks";
    } finally {
      isLoading.value = false;
    }
  }
}
