import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckListInfo extends StatelessWidget {
  final String label;
  final int total;
  final RxInt completed; // Ubah tipe data ke RxInt

  const CheckListInfo({
    super.key,
    required this.label,
    this.total = 0,
    required this.completed, // Terima RxInt sebagai parameter
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              color: Colors.blue.shade900,
              child: const Text(
                "Task Info",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sub Competency",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(label),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Checklist Total",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text("$total items"),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Completed",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Obx(() => Text(
                                "${completed.value} items")), // Gunakan Obx di sini
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
