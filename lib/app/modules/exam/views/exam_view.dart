import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/exam/controllers/exam_controller.dart';

class ExamView extends GetView<ExamController> {
  const ExamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Examination")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              "Select Your Semester :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => ElevatedButton(
                        onPressed: () => controller.setSelectedSemester("V"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              controller.selectedSemester.value == "V"
                                  ? Colors.red
                                  : Colors.white,
                        ),
                        child: Text(
                          "Semester V",
                          style: TextStyle(
                            color: controller.selectedSemester.value == "V"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      )),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Obx(() => ElevatedButton(
                        onPressed: () => controller.setSelectedSemester("VI"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              controller.selectedSemester.value == "VI"
                                  ? Colors.red
                                  : Colors.white,
                        ),
                        child: Text(
                          "Semester VI",
                          style: TextStyle(
                            color: controller.selectedSemester.value == "VI"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              List<Widget> children = [];
              for (var exam in controller.exams) {
                if (controller.selectedSemester.isNotEmpty &&
                    exam['id_semester'] != controller.selectedSemester.value) {
                  continue;
                }

                String majorLabel = exam['major'] == "T"
                    ? "Teknika"
                    : (exam['major'] == "N" ? "Nautika" : "-");

                Widget temp = Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded Card
                  ),
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: InkWell(
                    onTap: () {}, // Bisa dipakai untuk fitur tambahan
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // **Judul Ujian**
                                Text(
                                  exam['topic_name'] ?? "Unknown Topic",
                                  maxLines: 42,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.school,
                                        size: 18, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      majorLabel,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 18, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Semester: ${exam['id_semester'] ?? "N/A"}",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              final bool canBeOpened =
                                  exam['canBeOpened'] == true;
                              if (canBeOpened) {
                                controller.getUrlExam(uc: exam['uc']);
                              } else {
                                String message;
                                final DateTime currentTime = DateTime.now();
                                final DateTime openTime =
                                    exam['open_time'] != null
                                        ? DateTime.parse(exam['open_time'])
                                        : DateTime.now();
                                final DateTime closeTime =
                                    exam['close_time'] != null
                                        ? DateTime.parse(exam['close_time'])
                                        : DateTime.now()
                                            .add(const Duration(days: 365));

                                if (currentTime.isBefore(openTime)) {
                                  message =
                                      "Sorry, the exam has not started yet.";
                                } else if (currentTime.isAfter(closeTime)) {
                                  message =
                                      "We apologize, the exam time has expired.";
                                } else {
                                  message = "The exam is accessible now.";
                                }

                                if (message != "The exam is accessible now.") {
                                  Get.defaultDialog(
                                    backgroundColor: Colors.white,
                                    title: '',
                                    titlePadding: EdgeInsets.zero,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.info_outline,
                                                color: Colors.blue.shade900,
                                                size: 26),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Exam Information",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue.shade900,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          message,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(height: 20),
                                        TextButton(
                                          onPressed: () => Get.back(),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.red,
                                            textStyle:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          child: const Text("Tutup"),
                                        ),
                                      ],
                                    ),
                                    radius: 12,
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.play_circle_filled,
                                color: Colors.white),
                            label: const Text(
                              "Attempt",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: exam['canBeOpened'] == true
                                  ? Colors.green
                                  : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                children.add(temp);
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
