import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/report_task/controllers/report_task_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
// import 'package:mytrb/utils/translator.dart';

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
                  ...controller.reportList.map((item) => Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10), // Jarak antar item
                        child:
                            // Card(
                            //   child: InkWell(
                            //     onTap: () {
                            //       Get.toNamed(Routes.REPORT_TASK_ADD, arguments: {
                            //         "month_number": controller.monthNumber.value,
                            //         "uc_sign": controller.ucSign.value,
                            //         "title": item['title'],
                            //         "uc_report": item['uc'],
                            //       });
                            //     },
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: FutureBuilder(
                            //         future: Future.wait([
                            //           translateToEnglish(item['title']),
                            //           translateToEnglish(
                            //               item['description'] ?? '-'),
                            //         ]),
                            //         builder: (context, snapshot) {
                            //           if (snapshot.connectionState ==
                            //               ConnectionState.waiting) {
                            //             return const ListTile(
                            //               title: Text('Loading...'),
                            //               subtitle: Text('Please wait...'),
                            //             );
                            //           }

                            //           if (snapshot.hasError) {
                            //             return ListTile(
                            //               title: Text(item['title']),
                            //               subtitle:
                            //                   Text(item['description'] ?? '-'),
                            //             );
                            //           }

                            //           final translatedTitle =
                            //               snapshot.data?[0] ?? item['title'];
                            //           final translatedDescription =
                            //               snapshot.data?[1] ?? item['description'];

                            //           return ListTile(
                            //             title: Text(translatedTitle),
                            //             subtitle:
                            //                 Text(translatedDescription ?? '-'),
                            //           );
                            //         },
                            //       ),
                            //     ),
                            //   ),
                            // ),

                            Card(
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.REPORT_TASK_ADD, arguments: {
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
