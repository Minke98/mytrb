import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/task/controllers/task_controller.dart';

class TaskUserDetail extends GetView<TaskController> {
  const TaskUserDetail({super.key});

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
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      "Name",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Text(
                      ":",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Text(
                      controller.userData['full_name'] ?? "-",
                      style: const TextStyle(fontSize: 14),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      "Seafarer Code",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Text(
                      ":",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Text(
                      controller.userData['seafarer_code'] ?? "-",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      "Instructor",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Text(
                      ":",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Text(
                      controller.userData['pembimbing'] ?? "-",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      "IMO Number",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: Text(
                      ":",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Text(
                      controller.userData['imo_number'] ?? "-",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
