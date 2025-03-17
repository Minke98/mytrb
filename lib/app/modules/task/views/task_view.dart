import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/task/controllers/task_controller.dart';
import 'package:mytrb/app/modules/task/views/task_detail_view.dart';
import 'package:mytrb/app/routes/app_pages.dart';

class TaskView extends GetView<TaskController> {
  const TaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TaskUserDetail(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Function",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: controller.competency.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (BuildContext context, int index) {
                    var item = controller.competency[index];
                    return Card(
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(Routes.TASK_SUB, arguments: {
                            "uc_competency": item['uc'],
                            'label': item['label']
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Competency",
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                item['label'],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.blue.shade900),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Checklist Sub Competency",
                                style: TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 5),
                              Text("${item['subtotal_competency']} Item")
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
