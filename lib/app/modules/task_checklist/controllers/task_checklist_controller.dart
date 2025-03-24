import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytrb/app/Repository/task_repository.dart';
import 'package:mytrb/app/data/models/task_item.dart';
import 'package:mytrb/utils/auth_biometric.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskChecklistController extends GetxController {
  final TaskRepository taskRepository;

  TaskChecklistController({required this.taskRepository});

  // var taskList = <Map>[].obs;
  var allowModify = true.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var completed = 0.obs;
  Rx<File?> uploadFoto = Rx<File?>(null);
  var fileFoto = Rxn<File>();
  var ucSubCompetency = ''.obs;
  var label = ''.obs;
  var total = 0.obs;
  var checked = false.obs;
  var isApproved = 0.obs;
  var isLectApproved = 0.obs;
  var initNote = "".obs;
  var isAttachmentSaved = false.obs;
  var instTime = "".obs;
  var initFoto = "".obs;
  var initUrl = "".obs;
  var taskList = <TaskItem>[].obs;
  var videoUrl = ''.obs;
  final ImagePicker picker = ImagePicker();
  TextEditingController notes = TextEditingController();
  var isFirstAttachmentAdded = false.obs;
  final ScrollController scrollController = ScrollController();
  // String? urlVideo;
  var lastScrollPosition = 0.0.obs;
  Timer? _scrollDebounce;

  @override
  Future<void> onInit() async {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      label.value = args["label"];
      ucSubCompetency.value = args["uc_sub_competency"];
      total.value = args["total"] ?? 0;
    } else {
      log("WARNING: Get.arguments is null!");
    }
    scrollController.addListener(() {
      if (scrollController.hasClients) {
        _scrollDebounce?.cancel(); // Hapus timer sebelumnya
        _scrollDebounce = Timer(const Duration(milliseconds: 300), () {
          saveScrollPosition(scrollController.position.pixels);
        });
      }
    });
    initTaskChecklist();
  }

  void initTaskChecklist() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      // Fetch the task list from the repository
      List<dynamic> fetchedTaskList = await taskRepository.getTaskList(
          ucSubCompetency: ucSubCompetency.value);

      // Convert each map in the list to Map<String, dynamic>
      List<Map<String, dynamic>> typedTaskList = fetchedTaskList.map((item) {
        if (item is Map<dynamic, dynamic>) {
          return Map<String, dynamic>.from(item);
        } else {
          throw Exception("Invalid data type in task list");
        }
      }).toList();

      final prefs = await SharedPreferences.getInstance();
      allowModify.value = prefs.getBool("modifyTask") ?? true;

      if (typedTaskList.isEmpty) {
        errorMessage.value = "Empty Task";
      } else {
        taskList
            .assignAll(typedTaskList.map((e) => TaskItem.fromMap(e)).toList());
      }
    } catch (e) {
      errorMessage.value = "Failed to load tasks: $e";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSingleTask(String ucTask) async {
    try {
      var updatedTask = await taskRepository.getSingleTask(ucTask: ucTask);
      if (updatedTask != null) {
        int index = taskList.indexWhere((task) => task.uc == ucTask);
        if (index != -1) {
          // ✅ Ambil posisi scroll yang tersimpan sebelumnya
          await loadScrollPosition();
          final double currentScrollPosition = lastScrollPosition.value;

          // Update data tanpa refresh seluruh list
          taskList.replaceRange(index, index + 1, [updatedTask]);

          // Hitung ulang completed
          completed.value = taskList.where((task) => task.checked.value).length;

          // ✅ Tunggu ListView selesai di-render sebelum scroll
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(const Duration(milliseconds: 100), () {
              if (scrollController.hasClients) {
                scrollController.jumpTo(currentScrollPosition);
                debugPrint("✅ Scroll kembali ke: $currentScrollPosition");
              } else {
                debugPrint(
                    "⚠️ ScrollController belum siap, tidak bisa scroll.");
              }
            });
          });
        }
      }
    } catch (e) {
      debugPrint("⚠️ Error updating task: $e");
    }
  }

  Future<void> toggleCheckItem(String ucTask) async {
    try {
      EasyLoading.show(status: 'Loading...'); // Tampilkan loading indicator
      isLoading.value = true;

      var toggle = await taskRepository.toggle(taskUc: ucTask);

      if (toggle['status'] == true) {
      } else {
        errorMessage.value = toggle['message'];
        EasyLoading.showError(toggle['message']); // Tampilkan error jika gagal
      }
    } catch (e) {
      EasyLoading.showError('Terjadi kesalahan');
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss(); // Sembunyikan loading indicator
    }
  }

  Future<void> saveLampiran(String ucTask, File foto) async {
    bool isAuthenticated = await BiometricAuth.authenticateUser(
        'Use biometric authentication to login');
    if (!isAuthenticated) {
      EasyLoading.showError('Autentikasi biometrik gagal');
      return;
    }
    isLoading.value = true;
    EasyLoading.show(status: 'Menyimpan...');

    try {
      var save = await taskRepository.saveLampiran(foto: foto, taskUc: ucTask);
      if (save['status'] == true) {
        await updateSingleTask(ucTask);
        Get.close(1);
      } else {
        errorMessage.value = "Terjadi kesalahan saat menyimpan.";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> saveUrlVideo(
    String ucTask,
  ) async {
    try {
      bool isAuthenticated = await BiometricAuth.authenticateUser(
          'Use biometric authentication to login');
      if (!isAuthenticated) {
        EasyLoading.showError('Autentikasi biometrik gagal');
        return;
      }
      EasyLoading.show(status: 'Saving...'); // Tampilkan loading indicator
      isLoading.value = true;

      var res = await taskRepository.urlVideo(
          urlVideo: videoUrl.value, ucTask: ucTask);

      if (res['status'] == true) {
        updateSingleTask(ucTask);
        Get.close(1);
      } else {
        errorMessage.value = res['message'];
        Get.snackbar("Error", res['message'] ?? "Failed to save Video URL",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss(); // Sembunyikan loading indicator
    }
  }

  Future<void> saveScrollPosition(double position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('lastScrollPosition', position);
    debugPrint("✅ Scroll Position Saved: $position");
  }

  // ✅ Ambil posisi scroll dari SharedPreferences
  Future<void> loadScrollPosition() async {
    final prefs = await SharedPreferences.getInstance();
    lastScrollPosition.value = prefs.getDouble('lastScrollPosition') ?? 0.0;
    debugPrint("📌 Loaded Scroll Position: ${lastScrollPosition.value}");
  }
}
