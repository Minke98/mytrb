import 'package:get/get.dart';
import 'package:mytrb/app/Repository/task_repository.dart';

class TaskSubController extends GetxController {
  final TaskRepository taskRepository;
  TaskSubController({required this.taskRepository});

  var subCompetency = <Map>[].obs;
  var isLoading = false.obs;

  void initSubTask(String ucCompetency) async {
    isLoading.value = true;
    List<Map>? resSubCompetency =
        await taskRepository.getSubListCompetency(ucCompetency: ucCompetency);
    subCompetency.value = resSubCompetency ?? [];
    isLoading.value = false;
  }
}
