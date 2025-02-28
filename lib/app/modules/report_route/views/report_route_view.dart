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
          onPressed: () => addRouteDialog(context),
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
            return Card(
              child: ListTile(
                title: Text(item['item']),
                leading: Text("${index + 1}"),
              ),
            );
          },
        );
      }),
    );
  }

  Future addRouteDialog(BuildContext context, {String error = ""}) async {
    final TextEditingController locationController = TextEditingController();
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
            backgroundColor: Theme.of(context).colorScheme.background,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: locationController,
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
                                locationController.text = "";
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                                minimumSize: const Size.fromHeight(50),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onError),
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
                                    "location_name": locationController.text,
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50)),
                              child: const Text("Save"),
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
