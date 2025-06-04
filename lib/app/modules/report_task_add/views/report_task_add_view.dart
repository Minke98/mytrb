import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/components/constant.dart';
import 'package:mytrb/app/components/picture_display.dart';
import 'package:mytrb/app/modules/report_task_add/controllers/report_task_add_controller.dart';
import 'package:mytrb/app/routes/app_pages.dart';
import 'package:responsive_framework/responsive_value.dart' as responsive;
import 'package:responsive_framework/responsive_framework.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:developer';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';

class ReportTaskAddView extends GetView<ReportTaskAddController> {
  const ReportTaskAddView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title.value),
      ),
      body: Obx(() {
        if (!controller.isReady.value) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Widget> columnChilds = [];

        String fsize = "${ResponsiveValue(context, defaultValue: 4, valueWhen: [
              const responsive.Condition.largerThan(name: MOBILE, value: 2),
              const responsive.Condition.largerThan(name: TABLET, value: 1)
            ]).value!.toString()}rem";

        log("Report items ${controller.reportItem} $fsize");

        if (controller.reportStatus.value != null &&
            controller.reportStatus.value!['app_inst_status'] != 0) {
          log("Report Set Height html wrote");
          controller.komentar.value = """
            <!DOCTYPE html>
            <html>
            <head>
              <title>Komentar</title>
            </head>
            <style type="text/css">
              html, body { background: transparent; margin: 0; padding: 0;}
              #container { font-size:$fsize; padding-left:20px; position: absolute; }
            </style>
            <body id="body">
              <div id="container">
            ${controller.reportStatus.value!['app_inst_komentar']}
              </div>
            </body>
            <script type='text/javascript'>
              const myTimeout = setTimeout(sendheight, 300);
              function sendheight(){
                var docHeightLoc = document.getElementById("container").offsetHeight;
                docEl.postMessage(Math.ceil(docHeightLoc/3));
              }
            </script>
            </html>
          """;
        } else {
          controller.komentar.value =
              "<html><body style='font-size:5vw'> - </body></html>";
        }
        controller.webViewController.loadHtmlString(controller.komentar.value);

        if (controller.reportItem.isNotEmpty) {
          for (var e in controller.reportItem) {
            columnChilds.add(InkWell(
              onTap: () async {
                Directory appDocDir = await getApplicationDocumentsDirectory();
                String appDocPath = appDocDir.path;
                String image =
                    Path.join(appDocPath, REPORT_FOTO_FOLDER, e['local_file']);
                Get.toNamed(Routes.REPORT_TASK_RESULT,
                    arguments: {"image": image, "caption": e['caption']});
              },
              child: PictureDisplay(
                picAlign: Alignment.topCenter,
                folder: REPORT_FOTO_FOLDER,
                local: e['local_file'],
                remote: e['file'],
              ),
            ));
          }
        }

        int approveIndex =
            controller.reportStatus.value?['app_inst_status'] ?? 0;
        int lectApproveIndex =
            controller.reportStatus.value?['app_lect_status'] ?? 0;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: ResponsiveValue(context,
                                defaultValue: 8,
                                valueWhen: [
                                  const responsive.Condition.largerThan(
                                      name: MOBILE, value: 10)
                                ]).value!.toInt(),
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Lecturer Approval : ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    REPORTLOGLECTAPPROVAL[lectApproveIndex]
                                        .text,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Instructor Approval : ',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    REPORTLOGINSAPPROVAL[approveIndex].text,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                if (controller.reportStatus.value != null &&
                                    controller.reportStatus
                                            .value!['app_inst_status'] !=
                                        0)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Instructor Name :',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          controller.reportStatus
                                                  .value?['app_inst_name'] ??
                                              '-',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 5),
                                if (controller.reportStatus.value != null &&
                                    controller.reportStatus
                                            .value!['app_inst_status'] !=
                                        0)
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Comment :',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                const SizedBox(height: 5),
                                if (controller.reportStatus.value != null &&
                                    controller.reportStatus
                                            .value!['app_inst_status'] !=
                                        0)
                                  SizedBox(
                                      height: controller.webContainerHeight,
                                      child: WebViewWidget(
                                        controller:
                                            controller.webViewController,
                                        gestureRecognizers:
                                            controller.gestureRecognizers,
                                      ))
                              ],
                            ),
                          ),
                          Expanded(
                            flex: ResponsiveValue(context,
                                defaultValue: 4,
                                valueWhen: [
                                  const responsive.Condition.largerThan(
                                      name: MOBILE, value: 2)
                                ]).value!.toInt(),
                            child: (controller.reportStatus
                                        .value?['app_inst_local_foto'] !=
                                    null)
                                ? SizedBox(
                                    height: 150,
                                    child: PictureDisplay(
                                      fit: BoxFit.fitHeight,
                                      folder: APPROVAL_FOTO_FOLDER,
                                      local: controller.reportStatus
                                          .value!['app_inst_local_foto'],
                                      remote: controller
                                          .reportStatus.value!['app_inst_foto'],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      // const Divider()
                    ],
                  ),
                ]),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 8.0), // Kurangi padding atas
                sliver: SliverGrid.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 10.0,
                  children: columnChilds.map((widget) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(child: widget),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: Obx(() {
        if (!controller.allowModify.value) return const SizedBox.shrink();
        return Stack(
          children: [
            if (controller.reportStatus.value == null ||
                (controller.reportStatus.value != null &&
                    controller.reportStatus.value!['app_inst_status'] != 1))
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.blue.shade900,
                  heroTag: 'menuButton',
                  onPressed: controller.toggleMenuVisibility,
                  label: const Text(
                    'Menu',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  icon: const Icon(Icons.menu, color: Colors.white),
                ),
              ),
            if (controller.reportStatus.value != null &&
                controller.reportStatus.value!['app_inst_status'] != 1)
              Align(
                alignment: Alignment.bottomRight,
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 100),
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Visibility(
                    visible: controller.menuVisible.value,
                    child: FloatingActionButton.extended(
                      backgroundColor: Colors.blue.shade900,
                      heroTag: 'approvalButton',
                      onPressed: () {
                        Get.toNamed(Routes.REPORT_TASK_APPROVAL, arguments: {
                          "month": controller.monthNumber.value,
                          "ucReportList": controller.ucReport.value,
                          'ucSign': controller.ucSign.value
                        });
                      },
                      label: const Text(
                        'Approval',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      icon: const Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ),
              ),
            if (controller.reportStatus.value == null ||
                (controller.reportStatus.value != null &&
                    controller.reportStatus.value!['app_inst_status'] != 1))
              Align(
                alignment: Alignment.bottomRight,
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 100),
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Visibility(
                    visible: controller.menuVisible.value,
                    child: FloatingActionButton.extended(
                      backgroundColor: Colors.blue.shade900,
                      heroTag: 'addButton',
                      onPressed: () {
                        Get.toNamed(Routes.REPORT_TASK_ADD_FORM, arguments: {
                          "title": controller.title.value,
                          "uc_sign": controller.ucSign.value,
                          "uc_report": controller.ucReport.value,
                          "month_number": controller.monthNumber.value
                        });
                      },
                      label: const Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}
