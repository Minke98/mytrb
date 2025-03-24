import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/report/controllers/report_add_controller.dart';
import 'package:mytrb/app/modules/report/controllers/report_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';

class ReportAddView extends GetView<ReportAddController> {
  final ReportController reportController = Get.find<ReportController>();
  ReportAddView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Report for Month ${controller.monthNumber}"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                locationButton(context, controller.monthNumber.value,
                    controller.ucSign.value),
                const SizedBox(height: 10),
                tugasButton(context, controller.monthNumber.value,
                    controller.ucSign.value)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget locationButton(BuildContext context, int monthNumber, String ucSign) {
    return Card(
      child: InkWell(
        onTap: () {
          log("NAVIGATE to REPORT_ROUTE: uc_sign=$ucSign, month_number=$monthNumber");
          Get.toNamed(Routes.REPORT_ROUTE,
              arguments: {"month_number": monthNumber, "uc_sign": ucSign});
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            leading: SizedBox(
                height: double.infinity,
                child: Icon(
                  Icons.route_outlined,
                  color: Colors.green[400],
                  size: 45,
                )),
            title: const Text("Shipping Route"),
            subtitle: const Text("The shipping route data for the last month."),
          ),
        ),
      ),
    );
  }

  Widget tugasButton(BuildContext context, int monthNumber, String ucSign) {
    return Card(
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.REPORT_TASK,
              arguments: {"month_number": monthNumber, "uc_sign": ucSign});
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: SizedBox(
                height: double.infinity,
                child: Icon(
                  Icons.task_outlined,
                  color: Colors.orange[400],
                  size: 45,
                )),
            title: const Text("Assignment Report"),
            subtitle: const Text(
                "Introduction to ship areas, safety equipment familiarization, introduction to equipment on the forecastle,.."),
          ),
        ),
      ),
    );
  }
}
