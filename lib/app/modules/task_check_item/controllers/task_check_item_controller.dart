import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytrb/app/Repository/task_repository.dart';

class TaskCheckItemController extends GetxController {
  final TaskRepository taskRepository;
  TaskCheckItemController({required this.taskRepository});

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var uploadFoto = Rxn<XFile>();
  var fileFoto = Rxn<File>();

  Future<void> toggleCheckItem(String ucTask) async {
    isLoading.value = true;
    var toggle = await taskRepository.toggle(taskUc: ucTask);
    isLoading.value = false;
    if (toggle['status'] == true) {
      update();
    } else {
      errorMessage.value = toggle['message'];
    }
  }

  Future<void> addNote(String ucTask, String note) async {
    isLoading.value = true;
    var res = await taskRepository.addNote(note: note, ucTask: ucTask);
    isLoading.value = false;
    if (res['status'] == true) {
      update();
    } else {
      errorMessage.value = res['message'];
    }
  }

  Future<void> saveLampiran(String ucTask, File foto) async {
    isLoading.value = true;
    var save = await taskRepository.saveLampiran(foto: foto, taskUc: ucTask);
    isLoading.value = false;
    if (save['status'] == true) {
      update();
    } else {
      errorMessage.value = "Terjadi kesalahan saat menyimpan.";
    }
  }

  Future<void> saveUrlVideo(String ucTask, String urlVideo) async {
    isLoading.value = true;
    var res = await taskRepository.urlVideo(urlVideo: urlVideo, ucTask: ucTask);
    isLoading.value = false;
    if (res['status'] == true) {
      update();
    } else {
      errorMessage.value = res['message'];
    }
  }
}
