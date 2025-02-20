import 'package:get/get.dart';
import 'package:mytrb/app/Repository/task_repository.dart';

class TaskController extends GetxController {
  final TaskRepository taskRepository;

  TaskController({required this.taskRepository});

  var competency = <Map>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    initTask();
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
