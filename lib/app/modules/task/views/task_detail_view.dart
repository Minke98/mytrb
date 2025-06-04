import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/task/controllers/task_controller.dart';

class TaskUserDetail extends GetView<TaskController> {
  const TaskUserDetail({super.key});

  TableRow _buildTableRow(String title, String value) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
      ),
      const Text(
        ":",
        style: TextStyle(fontSize: 14),
      ),
      Text(
        value,
        style: const TextStyle(fontSize: 14),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Card(
          color: Colors.white,
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
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(4),
              1: FlexColumnWidth(0.3),
              2: FlexColumnWidth(7.7),
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
