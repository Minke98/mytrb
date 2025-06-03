import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/task_checklist/controllers/task_checklist_controller.dart';
import 'package:mytrb/app/modules/task_checklist/views/task_check_info_view.dart';
import 'package:mytrb/app/modules/task_checklist/views/task_check_item_view.dart';

class TaskChecklistView extends GetView<TaskChecklistController> {
  const TaskChecklistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.label.value.isNotEmpty
            ? controller.label.value
            : 'Default Title'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckListInfo(
                label: controller.label.value,
                total: controller.total.value,
                completed: controller.completed, // Kirim RxInt ke CheckListInfo
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Task List",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 400, // Atur tinggi agar pasti bisa di-scroll
                  child: RefreshIndicator(
                    onRefresh: () => controller.initTaskChecklist(),
                    child: ListView.builder(
                      controller: controller.scrollController,
                      itemCount: controller.taskList.length,
                      itemBuilder: (context, index) {
                        final item = controller.taskList[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0), // Jarak antar item
                          child: CheckItem(
                            key: ValueKey(item.uc),
                            item: item,
                            allowModify: controller.allowModify.value,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
