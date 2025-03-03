import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/report_task/controllers/report_task_controller.dart';

class ReportTaskView extends GetView<ReportTaskController> {
  const ReportTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assignment for Month ${controller.monthNumber.value}"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(child: Text(controller.errorMessage.value));
              }

              return Column(
                children: [
                  const SizedBox(height: 10),
                  ...controller.reportList.map((item) => Card(
                        child: InkWell(
                          onTap: () {
                            Get.toNamed("/reporttaskadd", arguments: {
                              "month_number": controller.monthNumber.value,
                              "uc_sign": controller.ucSign.value,
                              "title": item['title'],
                              "uc_report": item['uc'],
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(item['title']),
                              subtitle: Text(item['description'] ?? '-'),
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(height: 10),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
