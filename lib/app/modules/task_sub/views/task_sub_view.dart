import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/task/views/task_detail_view.dart';
import 'package:mytrb/app/modules/task_sub/controllers/task_sub_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';

class TaskSubView extends GetView<TaskSubController> {
  const TaskSubView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sub Competency'),
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
                  "Sub Competency",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: controller.subCompetency.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (BuildContext context, int index) {
                    var item = controller.subCompetency[index];
                    return Card(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(Routes.TASK_CHECK, arguments: {
                            'label': item['sub_label'],
                            'uc_sub_competency': item['uc'],
                            'total': item['total_task']
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Sub Competency",
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                item['sub_label'],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.blue.shade900),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Checklist Sub Competency",
                                style: TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 5),
                              Text("${item['total_task']} Task")
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
