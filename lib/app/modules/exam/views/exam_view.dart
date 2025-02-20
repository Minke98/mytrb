// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mytrb/app/components/main_layout.dart';
// import 'package:mytrb/app/modules/exam/controllers/exam_controller.dart';

// class ExamView extends GetView<ExamController> {
//   const ExamView({super.key});
// Get.put(ContactController(contactRepository: Get.find()));


//   @override
//   Widget build(BuildContext context) {
//     return MainLayout(
//       appbarTitle: "Subject",
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.only(left: 16.0, top: 16.0),
//             child: Text(
//               "Select Your Semester:",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Obx(() => ElevatedButton(
//                         onPressed: () => controller.setSelectedSemester("V"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               controller.selectedSemester.value == "V"
//                                   ? Colors.red
//                                   : Colors.white,
//                         ),
//                         child: Text(
//                           "Semester V",
//                           style: TextStyle(
//                             color: controller.selectedSemester.value == "V"
//                                 ? Colors.white
//                                 : Colors.black,
//                           ),
//                         ),
//                       )),
//                 ),
//                 const SizedBox(width: 8.0),
//                 Expanded(
//                   child: Obx(() => ElevatedButton(
//                         onPressed: () => controller.setSelectedSemester("VI"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               controller.selectedSemester.value == "VI"
//                                   ? Colors.red
//                                   : Colors.white,
//                         ),
//                         child: Text(
//                           "Semester VI",
//                           style: TextStyle(
//                             color: controller.selectedSemester.value == "VI"
//                                 ? Colors.white
//                                 : Colors.black,
//                           ),
//                         ),
//                       )),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               return ListView.builder(
//                 itemCount: controller.exams.length,
//                 itemBuilder: (context, index) {
//                   var exam = controller.exams[index];
//                   return Card(
//                     elevation: 4,
//                     margin: const EdgeInsets.all(8.0),
//                     child: ListTile(
//                       title: Text(exam['topic_name']),
//                       subtitle: Text(
//                           "Major: ${exam['majorLabel']} - Semester: ${exam['id_semester']}"),
//                       trailing: ElevatedButton.icon(
//                         onPressed: () => controller.attemptExam(exam),
//                         icon: const Icon(Icons.play_circle_filled,
//                             color: Colors.white),
//                         label: const Text("Attempt",
//                             style: TextStyle(color: Colors.white)),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 exam['canBeOpened'] ? Colors.red : Colors.grey),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
