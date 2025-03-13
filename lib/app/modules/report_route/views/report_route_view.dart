import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytrb/app/modules/report_route/controllers/report_route_controller.dart';

class ReportRouteView extends GetView<ReportRouteController> {
  const ReportRouteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Route for Month ${controller.monthNumber}"),
      ),
      floatingActionButton: Obx(() {
        if (controller.allowModify.isFalse) return const SizedBox.shrink();

        return FloatingActionButton.extended(
          backgroundColor: Colors.blue.shade900,
          onPressed: () async {
            Map? dialog = await addRouteDialog(context);
            log("reportRoute: SAVE $dialog");
            if (dialog != null && dialog['status'] == true) {
              if (context.mounted) {
                log("reportRoute: SAVE TRIGGER BLOC");
                controller.saveRoute();

                log("reportRoute: SAVE TRIGGER BLOC AFTER");
                // timer.cancel();
              }
              // });
              // });
            }
          },
          label: const Text("Add"),
          icon: const Icon(Icons.add),
        );
      }),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.routes.isEmpty) {
          return const Center(child: Text("Tidak ada rute tersedia."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: controller.routes.length,
          itemBuilder: (context, index) {
            final item = controller.routes[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                height: 50,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16), // Padding agar lebih rapi
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.center, // Pastikan sejajar tengah
                      children: [
                        Text(
                          "${index + 1}.",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(
                            width: 16), // Jarak antara nomor dan teks
                        Text(
                          item['item'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Future addRouteDialog(BuildContext context, {String error = ""}) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return await showGeneralDialog(
      barrierDismissible: false,
      barrierLabel: "Add Route Dialog",
      useRootNavigator: false,
      context: context,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: const Offset(0, 0))
              .animate(animation),
          child: Dialog(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: controller.locationController,
                        decoration:
                            const InputDecoration(labelText: "Location Name"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please fill in the location name.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                controller.locationController.text = "";
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  Navigator.of(context).pop({
                                    "status": true,
                                    "location_name":
                                        controller.locationController.text,
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade900,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Save",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
    );
  }
}
