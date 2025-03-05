import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mytrb/app/modules/report_task_add/controllers/report_task_result_controller.dart';

class ReportTaskResultView extends GetView<ReportTaskResultController> {
  const ReportTaskResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan"),
      ),
      body: Obx(
        () {
          log("Image Path: ${controller.localImage.value}");
          File imageFile = File(controller.localImage.value);
          log("File Exists: ${imageFile.existsSync()}");

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (controller.localImage.value.isNotEmpty &&
                      imageFile.existsSync())
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 300,
                        child: Image.file(imageFile, fit: BoxFit.contain),
                      ),
                    )
                  else
                    const Text("Gambar tidak ditemukan",
                        style: TextStyle(color: Colors.red)),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Html(
                      data: controller.caption.value, // Menampilkan HTML
                      style: {
                        "body": Style(
                          fontSize: FontSize(
                              16.0), // Atur ukuran font sesuai keinginan
                        ),
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
