import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/report/controllers/report_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_value.dart' as responsive;

class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.initializeReport();
        return true; // Mengizinkan pengguna untuk kembali
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Report")),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                signData(),
                const SizedBox(height: 10),
                reportGrid(controller, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget signData() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.signData.isEmpty) {
        return const Center(child: Text("Unable To Load Data"));
      }
      return Card(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              color: Colors.blue.shade900,
              child: Text(
                "Sign Data",
                style: Get.textTheme.titleMedium!.copyWith(
                  color: Get.theme.colorScheme.onPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(0.3),
                  2: FlexColumnWidth(7.7),
                },
                children: [
                  _buildTableRow(
                      "Sign On Date",
                      controller.signData["sign_on_date_formated"] ??
                          "The data is not available"),
                  _buildTableRow(
                      "Vessel Name", controller.signData["vessel_name"] ?? "-"),
                  _buildTableRow("Company Name",
                      controller.signData["company_name"] ?? "-"),
                  _buildTableRow(
                      "IMO Number", controller.signData["imo_number"] ?? "-"),
                  _buildTableRow(
                      "MMSI Number", controller.signData["mmsi_number"] ?? "-"),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  TableRow _buildTableRow(String title, String value) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(title),
      ),
      const Text(":"),
      Text(value),
    ]);
  }

  Widget reportGrid(ReportController controller, BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.bulanCount.value == 0) {
        return const Center(child: Text("No Data Available"));
      }
      List<Widget> gridChildren = [];
      for (int i = 1; i <= controller.bulanCount.value; i++) {
        gridChildren.add(
          Card(
            child: InkWell(
              onTap: () {
                log("NAVIGATE with ${controller.userData['sign_uc']} month: $i");
                Get.toNamed(Routes.REPORT_ADD, arguments: {
                  "uc_sign": controller.userData['sign_uc'] ?? '',
                  "month_number": i
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_copy,
                    color: controller.activeReport.contains(i)
                        ? Colors.amber[200]
                        : Colors.grey,
                    size: 45,
                  ),
                  const SizedBox(height: 10),
                  Text("Month $i"),
                ],
              ),
            ),
          ),
        );
      }
      return Expanded(
        child: GridView.count(
          crossAxisCount: responsive.ResponsiveValue(context,
              defaultValue: 2.0,
              valueWhen: [
                const responsive.Condition.largerThan(name: MOBILE, value: 3.0),
                const responsive.Condition.largerThan(name: TABLET, value: 4.0),
                const responsive.Condition.largerThan(name: DESKTOP, value: 6.0)
              ]).value!.toInt(),
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: gridChildren,
        ),
      );
    });
  }
}
