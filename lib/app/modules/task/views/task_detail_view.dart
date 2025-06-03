import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/task/controllers/task_controller.dart';

class TaskUserDetail extends GetView<TaskController> {
  const TaskUserDetail({super.key});

  TableRow _buildTableRow(String title, String value) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0, right: 4),
        child: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(right: 4),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            ":",
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 50),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }

      log("state ${controller.userData}");

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(8),
            },
            children: [
              _buildTableRow(
                "Name",
                controller.userData['full_name'] ?? "-",
              ),
              _buildTableRow(
                "Seafarer Code",
                controller.userData['seafarer_code'] ?? "-",
              ),
              _buildTableRow(
                "Instructor",
                controller.userData['pembimbing'] ?? "-",
              ),
              _buildTableRow(
                "IMO Number",
                controller.userData['imo_number'] ?? "-",
              ),
            ],
          ),
        ),
      );
    });
  }
}
